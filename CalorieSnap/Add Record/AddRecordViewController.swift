//
//  AddRecordViewController.swift
//  CalorieSnap
//
//  Created by Yuk Yeung Ho on 5/12/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import PhotosUI

class AddRecordViewController: UIViewController {
    var onRecordAdded: ((Record) -> Void)?
    private let addRecordView = AddRecordScreenView()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private var selectedImage: UIImage?
    private var currentUserId: String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view = addRecordView
        setupNavigationBar()
        addRecordView.buttonTakePhoto.menu = getMenuImagePicker()
        addRecordView.buttonTakePhoto.showsMenuAsPrimaryAction = true
        addRecordView.buttonTakePhoto.setImage(UIImage(systemName: "photo"), for: .normal)
    
    }

    private func setupNavigationBar() {
        title = "Add Record"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveRecordTapped))
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func saveRecordTapped() {
        guard let name = addRecordView.textFieldName.text, !name.isEmpty,
              let calorieString = addRecordView.textFieldCalorie.text, let calorie = Int(calorieString),
              let date = addRecordView.textFieldDate.text,
              let details = addRecordView.textFieldDetails.text else {
            self.showAlert(message: "Please enter all fields.")
            return
        }

        if let image = selectedImage {
            uploadPhoto(image: image) { [weak self] photoURL in
                guard let self = self else { return }
                self.saveRecordToFirestore(name: name, calorie: calorie, date: date, details: details, photoURL: photoURL)
            }
        } else {
            saveRecordToFirestore(name: name, calorie: calorie, date: date, details: details, photoURL: nil)
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Invalid Input", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    func getMenuImagePicker() -> UIMenu{
        let menuItems = [
            UIAction(title: "Camera",handler: {(_) in
                self.pickUsingCamera()
            }),
            UIAction(title: "Gallery",handler: {(_) in
                self.pickPhotoFromGallery()
            })
        ]
        
        return UIMenu(title: "Select source", children: menuItems)
    }


    func pickUsingCamera(){
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.allowsEditing = true
        cameraController.delegate = self
        present(cameraController, animated: true)
    }
    
    func pickPhotoFromGallery(){
        var configuration = PHPickerConfiguration()
        configuration.filter = PHPickerFilter.any(of: [.images])
        configuration.selectionLimit = 1
        
        let photoPicker = PHPickerViewController(configuration: configuration)
        
        photoPicker.delegate = self
        present(photoPicker, animated: true, completion: nil)
    }

    private func uploadPhoto(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to compress image")
            completion(nil)
            return
        }

        let fileName = UUID().uuidString
        let storageRef = storage.reference().child("records/\(fileName).jpg")
        
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

    private func saveRecordToFirestore(name: String, calorie: Int, date: String, details: String, photoURL: URL?) {
        let newRecord = Record(
            userId: currentUserId,
            name: name,
            calorie: calorie,
            date: date,
            details: details,
            photoURL: photoURL?.absoluteString,
            timestamp: Timestamp()
        )

        do {
            let documentRef = try db.collection("users")
                .document(currentUserId)
                .collection("records")
                .addDocument(from: newRecord)

            var savedRecord = newRecord
            savedRecord.id = documentRef.documentID
            onRecordAdded?(savedRecord)
            navigationController?.popViewController(animated: true)
        } catch {
            print("Failed to save record: \(error)")
        }
    }


}

extension AddRecordViewController:PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        print(results)
        
        let itemprovider = results.map(\.itemProvider)
        
        for item in itemprovider{
            if item.canLoadObject(ofClass: UIImage.self){
                item.loadObject(
                    ofClass: UIImage.self,
                    completionHandler: { (image, error) in
                        DispatchQueue.main.async{
                            if let uwImage = image as? UIImage{
                                self.addRecordView.buttonTakePhoto.setImage(
                                    uwImage.withRenderingMode(.alwaysOriginal),
                                    for: .normal
                                )
                                self.selectedImage = uwImage
                            }
                        }
                    }
                )
            }
        }
    }
}

extension AddRecordViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage{
            self.addRecordView.buttonTakePhoto.setImage(
                image.withRenderingMode(.alwaysOriginal),
                for: .normal
            )
            self.selectedImage = image
        }else{
        }
    }
}
