//
//  User.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 9/4/24.
//

import UIKit
import Firebase

struct User {
    let fullname: String
    let username: String
    let email: String
    let profileImage: String
    var profileImageURL: URL?
    let uid: String
    var isFollowed = false
    var stats: userFollowFollowingStats?
    var isCurrentUser: Bool {
        return uid == Auth.auth().currentUser?.uid
    }

    init (uid: String, dictionary: [String: Any]) {

        self.uid = uid// Esto hay que hacerlo asi manualmente

        self.fullname = dictionary["fullname"] as? String ?? ""

        self.email = dictionary["email"] as? String ?? ""

        self.username = dictionary["username"] as? String ?? ""

        self.profileImage = dictionary["profileImage"] as? String ?? ""

        if let stringURL = dictionary["profileImage"] as? String {
            self.profileImageURL = URL(string: stringURL)
        }

    }

}

/**
 Estructura para almacenar el numero de seguidores y seguidos
 */
struct userFollowFollowingStats {
    let followers: Int
    let following: Int
}
