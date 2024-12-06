//
//  CommunityMainScreen.swift
//  CalorieSnap
//
//  Created by Steph on 6/12/2024.
//

import UIKit
import FirebaseFirestore

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
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell") // Ensure PostTableViewCell is correctly defined
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
        postDetailsVC.post = post // Pass the selected post to the PostDetailsViewController
        navigationController?.pushViewController(postDetailsVC, animated: true)
    }
    
    
    func updateLikes(for post: Post) {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }
        posts[index].likes += 1 // Update local data
        db.collection("posts").document(post.id).updateData(["likes": post.likes]) { error in
            if let error = error {
                print("Error updating likes: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                }
            }
        }
    }
}
