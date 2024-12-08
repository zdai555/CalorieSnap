//
//  Post.swift
//  CalorieSnap
//
//  Created by Zewei Dai on 12/6/24.
//

import UIKit

struct Post {
    var id: String
    var imageUrl: String
    var caption: String
    var likes: Int
    var likedBy: [String]
    var comments: [[String: String]]
    var username: String
        
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.imageUrl = data["imageUrl"] as? String ?? ""
        self.caption = data["caption"] as? String ?? ""
        self.likes = data["likes"] as? Int ?? 0
        self.comments = data["comments"] as? [[String: String]] ?? []
        self.username = data["username"] as? String ?? "Unknown"
        self.likedBy = data["likedBy"] as? [String] ?? [] 
    }
}

