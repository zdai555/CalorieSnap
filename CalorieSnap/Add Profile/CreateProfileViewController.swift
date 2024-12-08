//
//  CreateProfileViewController.swift
//  CalorieSnap
//
//  Created by Steph on 6/12/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import PhotosUI

class CreateProfileViewController: UIViewController {
    private let createProfileView = CreateProfileView()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private var selectedImage: UIImage?
    private var currentUserId: String {
        return Auth.auth().currentUser?.uid ?? ""
    }

    override func loadView() {
        view = createProfileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveProfile))
        createProfileView.buttonTakePhoto.menu = getMenuImagePicker()
        createProfileView.buttonTakePhoto.showsMenuAsPrimaryAction = true
        createProfileView.buttonTakePhoto.setImage(UIImage(systemName: "photo"), for: .normal)
    }

    private func navigateToHome() {
        let homeVC = HomeViewController()
        navigationController?.setViewControllers([homeVC], animated: true)
    }

    func getMenuImagePicker() -> UIMenu {
        let menuItems = [
            UIAction(title: "Camera", handler: { _ in
                self.pickUsingCamera()
            }),
            UIAction(title: "Gallery", handler: { _ in
                self.pickPhotoFromGallery()
            })
        ]

        return UIMenu(title: "Select source", children: menuItems)
    }

    func pickUsingCamera() {
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

    func pickPhotoFromGallery() {
        var configuration = PHPickerConfiguration()
        configuration.filter = PHPickerFilter.images
        configuration.selectionLimit = 1

        let photoPicker = PHPickerViewController(configuration: configuration)
        photoPicker.delegate = self
        present(photoPicker, animated: true)
    }

    private func uploadPhoto(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to compress image")
            completion(nil)
            return
        }

        let fileName = UUID().uuidString
        let storageRef = storage.reference().child("profiles/\(fileName).jpg")

        print("Starting upload for file: \(fileName)")

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Failed to upload image: \(error)")
                completion(nil)
                return
            }

            print("Image uploaded successfully. Metadata: \(String(describing: metadata))")

            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Failed to retrieve download URL: \(error)")
                    completion(nil)
                    return
                }

                print("Download URL retrieved: \(String(describing: url))")
                completion(url)
            }
        }
    }

    @objc private func saveProfile() {
        guard let name = createProfileView.textFieldName.text, !name.isEmpty,
              let ageString = createProfileView.textFieldAge.text, !ageString.isEmpty,
              let age = Int(ageString),
              let calorieString = createProfileView.textFieldCalorieTarget.text, !calorieString.isEmpty,
              let calorie = Int(calorieString),
              let favoriteFood = createProfileView.textFieldFavoriteFood.text, !favoriteFood.isEmpty,
              let gender = createProfileView.textFieldGender.text, !gender.isEmpty,
              let pronouns = createProfileView.textFieldPronouns.text, !pronouns.isEmpty else {
            self.showAlert(message: "Please enter all fields.")
            return
        }

        if let image = selectedImage {
            uploadPhoto(image: image) { [weak self] photoURL in
                guard let self = self else { return }
                self.saveProfileToFirestore(name: name, age: age, gender: gender, pronouns: pronouns, calorie: calorie, favoriteFood: favoriteFood, photoURL: photoURL)
            }
        } else {
            saveProfileToFirestore(name: name, age: age, gender: gender, pronouns: pronouns, calorie: calorie, favoriteFood: favoriteFood, photoURL: nil)
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Invalid Input", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    private func saveProfileToFirestore(name: String, age: Int, gender: String, pronouns: String, calorie: Int, favoriteFood: String, photoURL: URL?) {
        let profile = UserProfile(
            userId: currentUserId,
            name: name,
            age: age,
            gender: gender,
            pronouns: pronouns,
            targetedCalorieIntake: calorie,
            favoriteFood: favoriteFood,
            photoURL: photoURL?.absoluteString
        )

        db.collection("users").document(currentUserId).setData(["profile": profile.dictionary], merge: true) { error in
            if let error = error {
                print("Error saving profile: \(error)")
            } else {
                print("Profile saved successfully")
                self.navigateToHome()
            }
        }
    }
}

extension CreateProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)

        let itemProviders = results.map(\.itemProvider)
        for item in itemProviders {
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            self?.createProfileView.buttonTakePhoto.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
                            self?.selectedImage = image
                        }
                    }
                }
            }
        }
    }
}

extension CreateProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        if let image = info[.editedImage] as? UIImage {
            createProfileView.buttonTakePhoto.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
            selectedImage = image
        }
    }
}
