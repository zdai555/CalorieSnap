//
//  PostTableViewCell.swift
//  CalorieSnap
//
//  Created by Zewei Dai on 12/6/24.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    let postImageView = UIImageView()
    let captionLabel = UILabel()
    let likeButton = UIButton()
    let commentButton = UIButton()
    
    var likeButtonAction: (() -> Void)?
    var commentButtonAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        postImageView.layer.cornerRadius = 8
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(postImageView)
        
        captionLabel.numberOfLines = 0
        captionLabel.font = UIFont.systemFont(ofSize: 16)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(captionLabel)
        
        likeButton.setTitleColor(.systemBlue, for: .normal)
        likeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(likeButton)
        
        commentButton.setTitleColor(.systemGreen, for: .normal)
        commentButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        commentButton.addTarget(self, action: #selector(commentTapped), for: .touchUpInside)
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(commentButton)
        
        NSLayoutConstraint.activate([
            postImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            postImageView.heightAnchor.constraint(equalToConstant: 200),
            
            captionLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 8),
            captionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            captionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            likeButton.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 8),
            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            commentButton.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 8),
            commentButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            commentButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with post: Post) {
        if let url = URL(string: post.imageUrl) {
            postImageView.image = nil // Clear previous image
            loadImage(from: url)
        } else {
            postImageView.image = UIImage(named: "placeholder") // Fallback placeholder
        }
        
        captionLabel.text = post.caption
        
        likeButton.setTitle("❤️ \(post.likes)", for: .normal)
        commentButton.setTitle("💬 Comment", for: .normal)
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.postImageView.image = UIImage(named: "placeholder")
                }
                return
            }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.postImageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.postImageView.image = UIImage(named: "placeholder")
                }
            }
        }.resume()
    }
    
    @objc func likeTapped() {
        likeButtonAction?()
    }
    
    @objc func commentTapped() {
        commentButtonAction?()
    }
}
