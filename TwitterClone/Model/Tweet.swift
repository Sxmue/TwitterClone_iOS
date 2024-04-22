//
//  Tweet.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 10/4/24.
//

import UIKit

/**
 Estructura que representa un tweet
 */
struct Tweet {
    
    let caption: String
    var likes: Int
    let tweetID: String //id propio del tweet
    let retweets: Int
    let uid: String
    var timestamp: Date! //hay que inicializarlo asi sino dara ruido al ser campo calculado
    var user: User
    var didLike: Bool = false //aqui almacenaremos si el usuario le ha dado like al tweet o no 
    
    init(user: User,tweetID: String, dictionary: [String: Any]){
        
        self.tweetID = tweetID //necesitamos el id por separado
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.retweets = dictionary["retweets"] as? Int ?? 0
        self.likes = dictionary["likes"] as? Int ?? 0
        
        //De esta manera transformamos un timestamp a un tipo Date
        if let timestamp = dictionary["timestamp"] as? Double {
            //Como ves muy facilito
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        self.user = user
        
    }
}
    
