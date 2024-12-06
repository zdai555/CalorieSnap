//
//  EditRecordViewController.swift
//  CalorieSnap
//
//  Created by Yuk Yeung Ho on 6/12/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import PhotosUI

class EditRecordViewController: UIViewController {
    var onRecordUpdated: ((Record) -> Void)?
    private let editRecordView = AddRecordScreenView()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private var record: Record
    private var currentUserId: String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    private var selectedImage: UIImage?

    init(record: Record) {
        self.record = record
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = editRecordView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Record"
        setupNavigationBar()
        prefillRecordData()
        editRecordView.buttonTakePhoto.menu = getMenuImagePicker()
        editRecordView.buttonTakePhoto.showsMenuAsPrimaryAction = true
    }

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
    }

    private func prefillRecordData() {
        editRecordView.textFieldName.text = record.name
        editRecordView.textFieldCalorie.text = "\(record.calorie)"
        editRecordView.textFieldDetails.text = record.details

        if let photoURLString = record.photoURL, let photoURL = URL(string: photoURLString) {
            print("Loading image from URL: \(photoURL)")
            loadRecordImage(from: photoURL)
        } else {
            print("Invalid photo URL")
            editRecordView.buttonTakePhoto.setImage(UIImage(systemName: "photo"), for: .normal)
        }

    }
    private func loadRecordImage(from url: URL) {
        let storageRef = storage.reference(forURL: url.absoluteString)

        storageRef.getData(maxSize: 5 * 1024 * 1024) { [weak self] data, error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to load image: \(error)")
                DispatchQueue.main.async {
                    self.editRecordView.buttonTakePhoto.setImage(UIImage(systemName: "photo"), for: .normal)
                }
                return
            }

            if let data = data, let image = UIImage(data: data) {
                print("Image loaded successfully")
                DispatchQueue.main.async {
                    self.editRecordView.buttonTakePhoto.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
                    self.selectedImage = image
                }
            }
        }
    }

    @objc private func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func saveButtonTapped() {
        guard let name = editRecordView.textFieldName.text, !name.isEmpty,
              let calorieString = editRecordView.textFieldCalorie.text, let calorie = Int(calorieString),
              let details = editRecordView.textFieldDetails.text else {
            print("All fields are required")
            return
        }

        if let image = selectedImage {
            uploadPhoto(image: image) { [weak self] photoURL in
                guard let self = self else { return }
                self.updateRecordInFirestore(name: name, calorie: calorie, details: details, photoURL: photoURL)

                DispatchQueue.main.async {
                    if let updatedImage = self.selectedImage {
                        self.editRecordView.buttonTakePhoto.setImage(updatedImage.withRenderingMode(.alwaysOriginal), for: .normal)
                    }
                }
            }
        } else {
            updateRecordInFirestore(name: name, calorie: calorie, details: details, photoURL: record.photoURL)
        }
    }

    private func uploadPhoto(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to compress image")
            completion(nil)
            return
        }

        let storageRef = storage.reference().child("records/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { [weak self] _, error in
            guard let self = self else { return }
            if let error = error {
                print("Failed to upload image: \(error)")
                completion(nil)
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Failed to retrieve download URL: \(error)")
                    completion(nil)
                    return
                }

                print("Image uploaded successfully. URL: \(url?.absoluteString ?? "No URL")")
                self.selectedImage = image
                completion(url?.absoluteString)
            }
        }
    }


    
    private func updateRecordInFirestore(name: String, calorie: Int, details: String, photoURL: String?) {
        let updatedRecord = Record(
            id: record.id,
            userId: currentUserId,
            name: name,
            calorie: calorie,
            details: details,
            photoURL: photoURL,
            timestamp: record.timestamp
        )

        guard let recordId = record.id else {
            print("Error: Record ID not found")
            return
        }

        db.collection("users")
            .document(currentUserId)
            .collection("records")
            .document(recordId)
            .setData(updatedRecord.dictionary) { error in
                if let error = error {
                    print("Failed to update record: \(error)")
                } else {
                    print("Record updated successfully")
                    self.onRecordUpdated?(updatedRecord)
                    self.navigationController?.popViewController(animated: true)
                }
            }
    }

    private func getMenuImagePicker() -> UIMenu {
        let menuItems = [
            UIAction(title: "Camera", handler: { _ in
                self.pickUsingCamera()
            }),
            UIAction(title: "Gallery", handler: { _ in
                self.pickPhotoFromGallery()
            })
        ]
        return UIMenu(title: "Select Source", children: menuItems)
    }

    private func pickUsingCamera() {
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

extension EditRecordViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        if let image = info[.editedImage] as? UIImage {
            selectedImage = image
        } else if let image = info[.originalImage] as? UIImage {
            selectedImage = image
        }

        if let image = selectedImage {
            DispatchQueue.main.async {
                self.editRecordView.buttonTakePhoto.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
                self.editRecordView.buttonTakePhoto.setNeedsDisplay()
            }
        } else {
            DispatchQueue.main.async {
                self.editRecordView.buttonTakePhoto.setImage(UIImage(systemName: "photo"), for: .normal)
            }
            print("Error: No image selected or image data is invalid.")
        }
    }
}

extension EditRecordViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let result = results.first else { return }

        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                guard let self = self, let image = image as? UIImage else { return }
                DispatchQueue.main.async {
                    self.selectedImage = image
                    self.editRecordView.buttonTakePhoto.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
                    self.editRecordView.buttonTakePhoto.setNeedsDisplay() 
                }
            }
        }
    }
}


