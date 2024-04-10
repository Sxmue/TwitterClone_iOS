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
    
    /**
     Metodo que se encarga de traer los tweets de la bbdd
     
     Vamos a traer todos los tweets, asi que por eso el completion devuelve un array de tweets, y por eso esta en el completion para devolverlos una vez los haya traido
     */
    func fetchTweets(completion: @escaping([Tweet]) -> Void){
        
        var tweets = [Tweet]() //declaramos nuestro array de tweets para devolverlo
        
        //De esta manera te traes los datos con un observe, este metodo trae los datos una vez y automaticamente los vuelve a traer cuando haya un cambio, se ejecuta en la db ref directamente
        //El observe monitoriza una ref de la base de datos, y .childaded es un Data event el cual le indica al observe que mire cuando se añada a esa referencia
        DB_TWEETS.observe(.childAdded) { snapshot in
          
            //En snapshot.key obtenemos el id unico del objeto que nos hayamos traido, en este caso el id que la bbdd ha puesto automaticamente a nuestro tweet
            
            //Si en snapshot.key tenemos la key de los tweets, lo logico habria sido pensar que para cada key habria que recorrerlas con un for each y dentro crear cada tweet y añadirlo, pero NO, se hace automaticamente
                
                //Casteamos el array de valores de vuelta a diccionario
                guard let dictionary = snapshot.value as? [String: Any] else {return }
                
                let tweet = Tweet(tweetID: snapshot.key, dictionary: dictionary) //con la key y con el diccionario inicializamos
                
                tweets.append(tweet) //añadimos a nuestro array
            
            completion(tweets) //llamamos al completion
            
        }
    }
    
    
}
