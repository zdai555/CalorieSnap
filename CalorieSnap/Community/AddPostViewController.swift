//
//  AddPostViewController.swift
//  CalorieSnap
//
//  Created by Zewei Dai on 12/6/24.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class AddPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imageView = UIImageView()
    let captionField = UITextField()
    let shareButton = UIButton()
    let storage = Storage.storage()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Post"
        view.backgroundColor = .white
        setupViews()
    }
    
    func setupViews() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        let uploadButton = UIButton()
        uploadButton.setTitle("Upload Picture", for: .normal)
        uploadButton.setTitleColor(.systemBlue, for: .normal)
        uploadButton.addTarget(self, action: #selector(uploadPictureTapped), for: .touchUpInside)
        
        captionField.placeholder = "Add a caption..."
        captionField.borderStyle = .roundedRect
        
        shareButton.setTitle("Share", for: .normal)
        shareButton.setTitleColor(.white, for: .normal)
        shareButton.backgroundColor = .systemBlue
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [uploadButton, imageView, captionField, shareButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc func uploadPictureTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    @objc func shareTapped() {
        guard let image = imageView.image, let caption = captionField.text, !caption.isEmpty else { return }
            
        let imageData = image.jpegData(compressionQuality: 0.8)
        let imageRef = storage.reference().child("post_images/\(UUID().uuidString).jpg")
        
        imageRef.putData(imageData!, metadata: nil) { [weak self] metadata, error in
            if let error = error {
                print("Error uploading image: \(error)")
                return
            }
            
            imageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting image URL: \(error)")
                    return
                }
                
                guard let url = url else { return }
                self?.savePost(imageUrl: url.absoluteString, caption: caption)
            }
        }
    }
    
    func savePost(imageUrl: String, caption: String) {
        // Ensure the current user is logged in
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("Error: User not logged in.")
            shareButton.isEnabled = true
            return
        }
        
        // Fetch user profile from Firestore
        db.collection("users").document(currentUserId).getDocument { [weak self] document, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching profile: \(error)")
                self.shareButton.isEnabled = true
                return
            }

            guard let data = document?.data(),
                  let profileData = data["profile"] as? [String: Any] else {
                print("No profile data found")
                self.shareButton.isEnabled = true
                return
            }

            // Extract username from the profile
            let username = profileData["name"] as? String ?? "Unknown User"

            // Create the post data dictionary
            let postData: [String: Any] = [
                "imageUrl": imageUrl,
                "caption": caption,
                "likes": 0,
                "likedBy": [],
                "comments": [],
                "timestamp": FieldValue.serverTimestamp(),
                "username": username // Add the username from the profile
                
            ]

            // Save the post to Firestore
            self.db.collection("posts").addDocument(data: postData) { error in
                if let error = error {
                    print("Error saving post: \(error)")
                    self.shareButton.isEnabled = true
                    return
                }

                // Navigate back and re-enable the share button
                self.shareButton.isEnabled = true
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
        }
        picker.dismiss(animated: true)
    }
}
