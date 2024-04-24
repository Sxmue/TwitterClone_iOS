//
//  Notification.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 23/4/24.
//

import UIKit

/**
 Enum para diferenciar que tipo de notificacion vamos a enviar
 */

enum NotificationType: Int {
    //Al ponerle ese int, cada caso tiene un identificador numerico
    case follow
    case like
    case retweet
    case reply
    case mentions
    
}

/**
 Estructura de datos para la gestion de notificaciones del usuario
 */
struct Notification {
    
    var timestamp: Date! //Timestamp para calcular el tiempo de la notificacion
    
    var tweetID: String? //El id del tweet dependiendo de si es una notificacion sobre un tweet o no, asi que es Optional
    
    var user: User //El usuario al que pertenece la notificacion
    
    var tweet: Tweet? //Igual, optional porque si es un follow seguramente no este
    
    var type: NotificationType! //El tipo de nuestra notificacion, que sera de nuestro enumerado, importante el force unwrapp
    
    init(user: User, tweet: Tweet?, dictionary: [String: Any]) {
    
        
        if let tweetId = dictionary["TweetID"] as? String{
            self.tweetID = tweetId
        }
        
        self.tweet = tweet
        
        self.user = user
        
        if let timestamp = dictionary["timestamp"] as? Double{
             self.timestamp = Date(timeIntervalSince1970: timestamp)
         }
        
        if let type = dictionary["type"] as? Int{
            self.type = NotificationType(rawValue: type)
        }
    }
    
}
