//
//  Records.swift
//  CalorieSnap
//
//  Created by Yuk Yeung Ho on 5/12/2024.
//

import Foundation
import FirebaseFirestore

struct Record: Codable, Identifiable {
    @DocumentID var id: String?
    var userId: String
    var name: String
    var calorie: Int
    var details: String
    var photoURL: String?
    var timestamp: Timestamp         
    
    init(id: String? = nil, userId: String, name: String, calorie: Int, details: String, photoURL: String? = nil, timestamp: Timestamp = Timestamp()) {
        self.id = id
        self.userId = userId
        self.name = name
        self.calorie = calorie
        self.details = details
        self.photoURL = photoURL
        self.timestamp = timestamp
    }
}

extension Record {
    var dictionary: [String: Any] {
        return [
            "userId": userId,
            "name": name,
            "calorie": calorie,
            "details": details,
            "photoURL": photoURL ?? "",
            "timestamp": timestamp
        ]
    }
}
