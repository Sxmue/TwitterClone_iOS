//
//  TweetService.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 10/4/24.
//

import UIKit
import Firebase

/**
 Servicio de la API que se va a encargar de gestionar los tweets
 */
struct TweetService {
    
    static let shared = TweetService()
    
    /**
     Metodo para guardar un tweet en la bbdd
     */
    func uploadTweet(caption: String, completion: @escaping(Error?,DatabaseReference)-> Void){
        //Nuestros tweet van a tener el uid de quien lo ha escrito, un timestamp, el caption, likes y retweets
        
        
        //Sacamos el uid del usuario que ha escrito el twit
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        //Creamos un diccionario con los valores que vamos a guardar
        //De esta manera se hace un timeStamp
        let values = ["uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweets": 0,
                      "caption": caption] as [String : Any]
        
        //De esta manera guardamos en la database con un ID automatico
        //Esto significa guardame con un id automatico, y ponle esos valores
        DB_TWEETS.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
        
    }
    
    
}
