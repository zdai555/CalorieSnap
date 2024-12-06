//
//  ProfileDetailsViewController.swift
//  CalorieSnap
//
//  Created by Steph on 6/12/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class ProfileDetailsViewController: UIViewController {
    private var currentUserProfile: UserProfile?
    private let profileDetailsView = ProfileDetailsView()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private var currentUserId: String {
        return Auth.auth().currentUser?.uid ?? ""
    }

    override func loadView() {
        view = profileDetailsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile Details"
        setupNavigationBar()
        loadProfileData()
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped))
    }

    @objc private func editButtonTapped() {
        guard let profile = currentUserProfile else {
            print("Profile data not available")
            return
        }

        let editProfileVC = EditProfileViewController(userProfile: profile) 
        editProfileVC.onProfileUpdated = { [weak self] updatedProfile in
            self?.displayProfile(updatedProfile)
        }
        navigationController?.pushViewController(editProfileVC, animated: true)
    }

    private func loadProfileData() {
        db.collection("users").document(currentUserId).getDocument { [weak self] document, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching profile: \(error)")
                return
            }

            guard let data = document?.data(),
                  let profileData = data["profile"] as? [String: Any] else {
                print("No profile data found")
                return
            }

            let userProfile = UserProfile(
                userId: self.currentUserId,
                name: profileData["name"] as? String ?? "",
                age: profileData["age"] as? Int ?? 0,
                gender: profileData["gender"] as? String ?? "",
                pronouns: profileData["pronouns"] as? String ?? "",
                targetedCalorieIntake: profileData["targetedCalorieIntake"] as? Int ?? 0,
                favoriteFood: profileData["favoriteFood"] as? String ?? "",
                photoURL: profileData["photoURL"] as? String
            )

            self.currentUserProfile = userProfile
            self.displayProfile(userProfile)
        }
    }

    
    private func displayProfile(_ profile: UserProfile) {
        profileDetailsView.labelName.text = "Name: \(profile.name)"
        profileDetailsView.labelAge.text = "Age: \(profile.age)"
        profileDetailsView.labelGender.text = "Gender: \(profile.gender)"
        profileDetailsView.labelPronouns.text = "Pronouns: \(profile.pronouns)"
        profileDetailsView.labelCalorieTarget.text = "Calorie Target: \(profile.targetedCalorieIntake) cal"
        profileDetailsView.labelFavoriteFood.text = "Favorite Food: \(profile.favoriteFood)"

        if let photoURLString = profile.photoURL, let photoURL = URL(string: photoURLString) {
            loadProfileImage(from: photoURL)
        } else {
            profileDetailsView.imageView.image = UIImage(systemName: "person.crop.circle")
        }
    }

    private func loadProfileImage(from url: URL) {
        let storageRef = storage.reference(forURL: url.absoluteString)
        
        storageRef.getData(maxSize: 5 * 1024 * 1024) { [weak self] data, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Failed to load image: \(error)")
                return
            }

            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileDetailsView.imageView.image = image
                }
            }
        }
    }
}
