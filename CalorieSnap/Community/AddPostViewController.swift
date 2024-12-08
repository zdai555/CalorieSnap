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
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let uploadButton = UIButton()
    let imageView = UIImageView()
    let captionField = UITextField()
    let labelTitle = UILabel()
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
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        labelTitle.text = "Share your recipe or favorite food!"
        labelTitle.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelTitle)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "camera")
        imageView.tintColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        
        uploadButton.setTitle("Upload Picture", for: .normal)
        uploadButton.setTitleColor(.systemBlue, for: .normal)
        uploadButton.addTarget(self, action: #selector(uploadPictureTapped), for: .touchUpInside)
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(uploadButton)
        
        captionField.placeholder = "Add a caption..."
        captionField.borderStyle = .roundedRect
        captionField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(captionField)
        
        shareButton.setTitle("Share", for: .normal)
        shareButton.setTitleColor(.white, for: .normal)
        shareButton.backgroundColor = .systemBlue
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(shareButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            labelTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            labelTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            
            imageView.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            
            uploadButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            uploadButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            captionField.topAnchor.constraint(equalTo: uploadButton.bottomAnchor, constant: 20),
            captionField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            captionField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            captionField.heightAnchor.constraint(equalToConstant: 44),
            
            shareButton.topAnchor.constraint(equalTo: captionField.bottomAnchor, constant: 20),
            shareButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor), 
            shareButton.widthAnchor.constraint(equalToConstant: 200),
            shareButton.heightAnchor.constraint(equalToConstant: 44),
            shareButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    @objc func uploadPictureTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    @objc func shareTapped() {
        guard let image = imageView.image, let caption = captionField.text, !caption.isEmpty else {
            self.showAlert(message: "Please enter all fields.")
            return
        }
        
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
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("Error: User not logged in.")
            shareButton.isEnabled = true
            return
        }
        
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

            let username = profileData["name"] as? String ?? "Unknown User"

            let postData: [String: Any] = [
                "imageUrl": imageUrl,
                "caption": caption,
                "likes": 0,
                "likedBy": [],
                "comments": [],
                "timestamp": FieldValue.serverTimestamp(),
                "username": username
            ]

            self.db.collection("posts").addDocument(data: postData) { error in
                if let error = error {
                    print("Error saving post: \(error)")
                    self.shareButton.isEnabled = true
                    return
                }

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
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Invalid Input", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
