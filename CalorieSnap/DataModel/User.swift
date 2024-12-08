//
//  User.swift
//  CalorieSnap
//
//  Created by Steph on 13/11/2024.
//

import Foundation
import FirebaseFirestore

struct User: Codable, Hashable {
    @DocumentID var id: String?
    var name: String
    var email: String
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
           hasher.combine(name)
           hasher.combine(email)
    }
       
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.email == rhs.email
    }
}
