//
//  PostDetailsViewController.swift
//  CalorieSnap
//
//  Created by Zewei Dai on 12/6/24.
//

import UIKit
import FirebaseFirestore

class PostDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var post: Post?
    var comments: [String] = []
    let db = Firestore.firestore()
    
    let postImageView = UIImageView()
    let captionLabel = UILabel()
    let likesLabel = UILabel()
    let tableView = UITableView()
    let commentField = UITextField()
    let sendButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Post Details"
        view.backgroundColor = .white
        
        setupViews()
        loadComments()
    }
    
    func setupViews() {
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(postImageView)
        
        captionLabel.numberOfLines = 0
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(captionLabel)
        
        likesLabel.textColor = .gray
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(likesLabel)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CommentCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        commentField.placeholder = "Add a comment..."
        commentField.borderStyle = .roundedRect
        commentField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(commentField)
        
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.backgroundColor = .systemBlue
        sendButton.addTarget(self, action: #selector(sendCommentTapped), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            postImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            postImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            postImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            postImageView.heightAnchor.constraint(equalToConstant: 200),
            
            captionLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 8),
            captionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            captionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            likesLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 8),
            likesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            tableView.topAnchor.constraint(equalTo: likesLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: commentField.topAnchor, constant: -8),
            
            commentField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            commentField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            commentField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            commentField.heightAnchor.constraint(equalToConstant: 44),
            
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            sendButton.widthAnchor.constraint(equalToConstant: 80),
            sendButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        if let post = post {
            loadImage(from: post.imageUrl)
            captionLabel.text = post.caption
            likesLabel.text = "❤️ \(post.likes) likes"
        }
    }
    
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error loading image: \(error)")
                return
            }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.postImageView.image = image
                }
            }
        }.resume()
    }
    
    func loadComments() {
        guard let post = post else { return }
        
        db.collection("posts").document(post.id).getDocument { [weak self] document, error in
            if let error = error {
                print("Error fetching comments: \(error)")
                return
            }
            
            guard let data = document?.data() else { return }
            self?.comments = data["comments"] as? [String] ?? []
            self?.tableView.reloadData()
        }
    }
    
    @objc func sendCommentTapped() {
        guard let post = post, let commentText = commentField.text, !commentText.isEmpty else { return }
        
        db.collection("posts").document(post.id).updateData([
            "comments": FieldValue.arrayUnion([commentText])
        ]) { [weak self] error in
            if let error = error {
                print("Error adding comment: \(error)")
                return
            }
            
            self?.comments.append(commentText)
            self?.tableView.reloadData()
            self?.commentField.text = ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
        cell.textLabel?.text = comments[indexPath.row]
        return cell
    }
}
