//
//  Profile.swift
//  CalorieSnap
//
//  Created by Steph on 6/12/2024.
//
import FirebaseFirestore

struct UserProfile: Codable {
    var userId: String
    var name: String
    var age: Int
    var gender: String
    var pronouns: String
    var targetedCalorieIntake: Int
    var favoriteFood: String
    var photoURL: String?

    init(
        userId: String,
        name: String,
        age: Int,
        gender: String,
        pronouns: String,
        targetedCalorieIntake: Int,
        favoriteFood: String,
        photoURL: String? = nil
    ) {
        self.userId = userId
        self.name = name
        self.age = age
        self.gender = gender
        self.pronouns = pronouns
        self.targetedCalorieIntake = targetedCalorieIntake
        self.favoriteFood = favoriteFood
        self.photoURL = photoURL
    }
}

extension UserProfile {
    var dictionary: [String: Any] {
        return [
            "userId": userId,
            "name": name,
            "age": age,
            "gender": gender,
            "pronouns": pronouns,
            "targetedCalorieIntake": targetedCalorieIntake,
            "favoriteFood": favoriteFood,
            "photoURL": photoURL ?? ""
        ]
    }
}
