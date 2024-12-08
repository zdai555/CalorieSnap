//
//  EditProfileViewController.swift
//  CalorieSnap
//
//  Created by Steph on 6/12/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import PhotosUI

class EditProfileViewController: UIViewController {
    var onProfileUpdated: ((UserProfile) -> Void)?
    private let editProfileView = CreateProfileView()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private var currentUserId: String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    private var selectedImage: UIImage?
    private var userProfile: UserProfile?

    override func loadView() {
        self.view = editProfileView
    }

    init(userProfile: UserProfile) {
        self.userProfile = userProfile
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Profile"
        setupNavigationBar()
        setupPhotoPicker()
        prefillProfileData()
    }

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
    }

    private func prefillProfileData() {
        guard let profile = userProfile else { return }
        editProfileView.textFieldName.text = profile.name
        editProfileView.textFieldAge.text = "\(profile.age)"
        editProfileView.textFieldGender.text = profile.gender
        editProfileView.textFieldPronouns.text = profile.pronouns
        editProfileView.textFieldCalorieTarget.text = "\(profile.targetedCalorieIntake)"
        editProfileView.textFieldFavoriteFood.text = profile.favoriteFood

        if let photoURLString = profile.photoURL, let photoURL = URL(string: photoURLString) {
            loadProfileImage(from: photoURL)
        } else {
            editProfileView.buttonTakePhoto.setImage(UIImage(systemName: "person.crop.circle"), for: .normal)
        }
    }

    private func loadProfileImage(from url: URL) {
        let storageRef = storage.reference(forURL: url.absoluteString)

        storageRef.getData(maxSize: 5 * 1024 * 1024) { [weak self] data, error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to load image: \(error)")
                DispatchQueue.main.async {
                    self.editProfileView.buttonTakePhoto.setImage(UIImage(systemName: "person.crop.circle"), for: .normal)
                }
                return
            }

            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.editProfileView.buttonTakePhoto.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
                    self.selectedImage = image
                }
            }
        }
    }

    @objc private func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func saveButtonTapped() {
        guard let name = editProfileView.textFieldName.text, !name.isEmpty,
              let ageText = editProfileView.textFieldAge.text, let age = Int(ageText),
              let gender = editProfileView.textFieldGender.text, !gender.isEmpty,
              let pronouns = editProfileView.textFieldPronouns.text, !pronouns.isEmpty,
              let calorieTargetText = editProfileView.textFieldCalorieTarget.text, let targetedCalorieIntake = Int(calorieTargetText),
              let favoriteFood = editProfileView.textFieldFavoriteFood.text, !favoriteFood.isEmpty else {
            self.showAlert(message: "Please enter all fields.")
            return
        }

        if let image = selectedImage {
            uploadPhoto(image: image) { [weak self] photoURL in
                guard let self = self else { return }
                self.updateProfile(name: name, age: age, gender: gender, pronouns: pronouns, targetedCalorieIntake: targetedCalorieIntake, favoriteFood: favoriteFood, photoURL: photoURL)
            }
        } else {
            updateProfile(name: name, age: age, gender: gender, pronouns: pronouns, targetedCalorieIntake: targetedCalorieIntake, favoriteFood: favoriteFood, photoURL: userProfile?.photoURL)
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Invalid Input", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    private func uploadPhoto(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to compress image")
            completion(nil)
            return
        }

        let fileName = "\(currentUserId)_profile.jpg"
        let storageRef = storage.reference().child("profiles/\(fileName)")
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Failed to upload image: \(error)")
                completion(nil)
                return
            }
            storageRef.downloadURL { url, _ in
                completion(url?.absoluteString)
            }
        }
    }

    private func updateProfile(name: String, age: Int, gender: String, pronouns: String, targetedCalorieIntake: Int, favoriteFood: String, photoURL: String?) {
        let updatedProfile = UserProfile(
            userId: currentUserId,
            name: name,
            age: age,
            gender: gender,
            pronouns: pronouns,
            targetedCalorieIntake: targetedCalorieIntake,
            favoriteFood: favoriteFood,
            photoURL: photoURL
        )

        db.collection("users").document(currentUserId).setData(["profile": updatedProfile.dictionary], merge: true) { [weak self] error in
            if let error = error {
                print("Failed to update profile: \(error)")
            } else {
                print("Profile updated successfully")
                self?.onProfileUpdated?(updatedProfile)
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }

    private func setupPhotoPicker() {
        editProfileView.buttonTakePhoto.showsMenuAsPrimaryAction = true
        editProfileView.buttonTakePhoto.menu = getMenuImagePicker()
    }

    private func getMenuImagePicker() -> UIMenu {
        return UIMenu(title: "Select Source", children: [
            UIAction(title: "Camera", handler: { _ in self.pickUsingCamera() }),
            UIAction(title: "Gallery", handler: { _ in self.pickPhotoFromGallery() })
        ])
    }

    private func pickUsingCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera not available")
            return
        }
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.allowsEditing = true
        cameraController.delegate = self
        present(cameraController, animated: true)
    }

    private func pickPhotoFromGallery() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1

        let photoPicker = PHPickerViewController(configuration: configuration)
        photoPicker.delegate = self
        present(photoPicker, animated: true)
    }
}

extension EditProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first else { return }

        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                        self?.editProfileView.buttonTakePhoto.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
                        self?.selectedImage = image
                    }
                }
            }
        }
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        if let image = info[.editedImage] as? UIImage {
            editProfileView.buttonTakePhoto.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
            selectedImage = image
        }
    }
}
