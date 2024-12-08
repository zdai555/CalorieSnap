//
//  CommunityMainScreen.swift
//  CalorieSnap
//
//  Created by Steph on 6/12/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class CommunityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var posts: [Post] = []
    let tableView = UITableView()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Community"
        view.backgroundColor = .white
        
        // Add Button for creating a new post
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPostTapped))
        
        setupTableView()
        fetchPosts()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
    
    func fetchPosts() {
        db.collection("posts").order(by: "timestamp", descending: true).addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching posts: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            self?.posts = documents.map { Post(id: $0.documentID, data: $0.data()) }
            self?.tableView.reloadData()
        }
    }
    
    @objc func addPostTapped() {
        let addPostVC = AddPostViewController()
        navigationController?.pushViewController(addPostVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        let post = posts[indexPath.row]
        cell.configure(with: post)
        cell.likeButtonAction = { [weak self] in
            self?.updateLikes(for: post)
        }
        cell.commentButtonAction = { [weak self] in
            self?.navigateToPostDetails(for: post)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedPost = posts[indexPath.row]
        navigateToPostDetails(for: selectedPost)
    }
    
    
    func navigateToPostDetails(for post: Post) {
        let postDetailsVC = PostDetailsViewController()
        postDetailsVC.post = post
        navigationController?.pushViewController(postDetailsVC, animated: true)
    }
    
    
    func updateLikes(for post: Post) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("Error: User not logged in.")
            return
        }

        let postRef = db.collection("posts").document(post.id)

        postRef.getDocument { [weak self] document, error in
            if let error = error {
                print("Error fetching post: \(error)")
                return
            }

            guard let data = document?.data(),
                  let likedBy = data["likedBy"] as? [String] else {
                print("Error: Missing likedBy field.")
                return
            }

            if likedBy.contains(currentUserId) {
                print("User has already liked this post.")
                return
            }

            let updatedLikes = (data["likes"] as? Int ?? 0) + 1
            postRef.updateData([
                "likes": updatedLikes,
                "likedBy": FieldValue.arrayUnion([currentUserId])
            ]) { error in
                if let error = error {
                    print("Error updating likes: \(error)")
                    return
                }

                print("Likes updated successfully.")
                if let index = self?.posts.firstIndex(where: { $0.id == post.id }) {
                    self?.posts[index].likes = updatedLikes
                    DispatchQueue.main.async {
                        self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                    }
                }
            }
        }
    }}
