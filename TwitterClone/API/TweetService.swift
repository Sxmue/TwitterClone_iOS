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
    func uploadTweet(caption: String, type: UploadTweetConfiguration, completion: @escaping(Error?, DatabaseReference) -> Void) {
        // Nuestros tweet van a tener el uid de quien lo ha escrito, un timestamp, el caption, likes y retweets
        
        // Sacamos el uid del usuario que ha escrito el twit
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // Creamos un diccionario con los valores que vamos a guardar
        // De esta manera se hace un timeStamp
        //Es var porque en el caso de que sea reply añadiremos un campo nuevo
        var values = ["uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweets": 0,
                      "caption": caption] as [String: Any]
        
        // Segun el tipo que sea, si una reply o un tweet nuevo, guardamos en tweets o en replies
        switch type {
            
        case .tweet:
            
            // De esta manera guardamos en la database con un ID automatico
            // Esto significa guardame con un id automatico, y ponle esos valores
            // Vamos a sacar el idAutomatico a una variable para usarlo dentro, pero esta llamada normalmente se encadenaria
            let tweetID = DB_TWEETS.childByAutoId() // asi tenemos el id que le ha puesto la bbdd automaticamente
            tweetID.updateChildValues(values) { _, ref in
                
                // Ahora queremos que cuando el tweet se suba, se guarde tambien en la parte de tweets del usuario, asi que en lugar de usar el completion aqui, vamos a encadenarlo con el siguiente metodo
                
                // Nos vamos a la referencia de user-tweets, creamos un nuevo child con el uid del USER y le añadimos el uid del tweet que acabamos de escribir, que lo tenemos en ref
                
                guard let tweetID =  ref.key else {return } // guard let al id del twit para guardarlo
                
                // Asi siempre tendremos en user tweets, el uid del user con los uid de sus tweets dentro guardados
                // El 1 es simplemente porque hay que poner un valor, lo que importa es el tweet id
                
                DB_USER_TWEETS.child(uid).updateChildValues([tweetID: 1], withCompletionBlock: completion)
            }
            
        case .reply(let tweet):
            
            //Le añadimos al tweet el username de la persona a la que responde, y asi lo tenemos almacenado
            values["replyingTo"] = tweet.user.username
            
            // Igual que arriba pero en otra ruta, ese tweet existira solo en la seccion de replies
            DB_TWEET_REPLIES.child(tweet.tweetID).childByAutoId().updateChildValues(values) { error, ref in
                //al ser una reply, pues sacamos el id que le ha puesto automaticamente firebase
                guard let replyId = ref.key else {return }
                //y la guardamos tambien en user-replies, la key del tweet al que responde, y la key de la respuesta
                DB_USER_REPLIES.child(uid).updateChildValues([tweet.tweetID: replyId]) { error, ref in
                    completion(error,ref)
                }
                
            }
            
        }
        
    }
    
    /**
     Metodo que se encarga de traer los tweets de la bbdd
     
     Vamos a traer los tweets de los usuarios a los que sigamos y los nuestros, asi que por eso el completion devuelve un array de tweets, y por eso esta en el completion para devolverlos una vez los haya traido
     */
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return }
        
        var tweets = [Tweet]() // declaramos nuestro array de tweets para devolverlo
        
        //sacamos los id de la gente que seguimos
        DB_USER_FOLLOWING.child(uid).observe(.childAdded) { snapshot in
            
            let userUid = snapshot.key
            
            //para cada id con el listener buscamos en los tweets de cada usuario
            DB_USER_TWEETS.child(userUid).observe(.childAdded) { snapshot in
                
                //traemos cada tweet a traves de los id que tenemos
                self.fetchTweet(withTweetID: snapshot.key) { tweet in
                    
                    //Los traemos ya sabiendo si el usuario logueado les ha dado like o no
                    isTweetLiked(tweet: tweet) { bool in
                        var tweet = tweet
                        tweet.didLike = bool
                        tweets.append(tweet)
                        completion(tweets)
                    }
                    
                }
            }
        }
        
        //Repetimos proceso pero exclusivamente con los tweets propios
        DB_USER_TWEETS.child(uid).observe(.childAdded) { snapshot in
            
            fetchTweet(withTweetID: snapshot.key) { tweet in
                isTweetLiked(tweet: tweet) { bool in
                    var tweet = tweet
                    tweet.didLike = bool
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
    }
    
    /**
     Funcion que se va a encargar de traer todos los tweets de un usuario en concreto
     */
    func fetchUserTweets(forUser user: User, completion: @escaping ([Tweet]) -> Void) {
        
        var tweets = [Tweet]()
        
        // Vamos a la referencia de user tweets del usuario logueado con su uid
        // Añadimos un listener
        DB_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in
            
            // Ahora aqui en snapshot tenemos todas las claves de los tweets
            // Para cada uno vamos y traemos su info
            
            let tweetID = snapshot.key // en key lo tenemos
            
            // De esta manera, con el sigle event y el evento .value, se hace fetch al tweet una vez y cada vez que cambie lo actualiza solo
            DB_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
                
                guard let dictionary = snapshot.value as? [String: Any] else {return }
                
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                
                tweets.append(tweet)
                
                completion(tweets)
            }
            
        }
        
    }
    
    func fetchLikes(forUser user: User, completion: @escaping(([Tweet]) -> Void)){
        var tweets = [Tweet]()
        
        DB_USER_LIKES.child(user.uid).observe(.childAdded) { snapshot in
            
            fetchTweet(withTweetID: snapshot.key) { tweet in
                var modifiedTweet = tweet
                modifiedTweet.didLike = true
                tweets.append(modifiedTweet)
                
                completion(tweets)
            }
            
        }
        
    }
    
    func fetchReplies(forUser user: User, completion: @escaping(([Tweet]) -> Void) ){
        var replies = [Tweet]()
        
        //Primero entramos en user replies con el uid del usuaerio
        DB_USER_REPLIES.child(user.uid).observe(.childAdded) { snapshot in
            
            let tweetID = snapshot.key
            guard let replyId = snapshot.value as? String else {return }
            
            //Ahora que tenemos la key del tweet al que pertecene la reply, y la key de la reply
            //Nos vamos al servicio de replies, con la id de ese tweet, buscamos el id de la reply y traemos todo
            DB_TWEET_REPLIES.child(tweetID).child(replyId).observeSingleEvent(of: .value) { snapshot in
                
                //Cogemos toda esa reply
                guard let dictionary = snapshot.value as? [String: Any] else {return }
                guard let userID = dictionary["uid"] as? String else {return }
                
                //Le asignamos su usuario
                UserService.shared.fetchUser(uid: userID) { user in
                    
                    let tweet = Tweet(user: user, tweetID: replyId, dictionary: dictionary)
                    
                    // la añadimos a la devolucion
                    replies.append(tweet)
                    completion(replies)
                }
                
            }
            
        }
        
    }
    
    
    func fetchReplies(forTweet tweet: Tweet, completion: @escaping ([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        DB_TWEET_REPLIES.child(tweet.tweetID).observe(.childAdded) { snapshot in
            
            guard let dictionary = snapshot.value as? [String: Any] else {return }
            
            // sacamos el uid del user que viene en el tweet
            guard let uid = dictionary["uid"] as? String else {return }
            
            let tweetID = snapshot.key
            
            // consumimos el servicio de usuarios para traer al usuario a traves de su uid, ya que en local si pero en nuestra base de datos los tweets no tienen al usuario completo
            UserService.shared.fetchUser(uid: uid) { user in
                
                // Una vez lo tenemos pues creamos un tweet y lo guardamos
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                
                completion(tweets)
            }
            
        }
        
    }
    
    /**
     Funcion encargada de gestionar los likes de la aplicacion
     */
    func likeTweet(tweet: Tweet, completion: @escaping (Error?, DatabaseReference) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return }
        
        // Primero vamos a actualizar el numero de likes de nuestro tweet, para eso usamos nuestro boolean
        // Si el metodo entra aqui, y el boolean era POSITIVO significa que ya estaba dado like, asi que vamos a quitarle uno
        // Si no pues se lo sumamos
        let likes = tweet.didLike ? tweet.likes-1 : tweet.likes+1
        
        // Actualizamos el numero de likes en la bbdd para ese tweet en concreto
        
        if likes >= 0 {
            DB_TWEETS.child(tweet.tweetID).child("likes").setValue(likes)
        } else {
            DB_TWEETS.child(tweet.tweetID).child("likes").setValue(0)
        }
        
        // Ahora como vamos a reutilizar el mismo metodo para dar like como para quitarlo, vamos a hacer la distincion
        // Si el didLike es positivo, ya estaba dado like asi que dentro lo eliminaremos
        if tweet.didLike {
            
            // Quitar like
            DB_USER_LIKES.child(uid).child(tweet.tweetID).removeValue { _, _ in
                
                DB_TWEET_LIKES.child(tweet.tweetID).child(uid).removeValue(completionBlock: completion)
            }
            
        } else {
            // Poner like
            // Añadimos a la bbdd con este metodo, para añadir el id del tweet con valor
            DB_USER_LIKES.child(uid).updateChildValues([tweet.tweetID: 1]) { _, _ in
                
                // Una vez este añadido a los likes del usuario lo añadimos a los likes del tweet
                DB_TWEET_LIKES.child(tweet.tweetID).updateChildValues([uid: 1], withCompletionBlock: completion)
                
            }
        }
        
    }
    
    func isTweetLiked(tweet: Tweet, completion: @escaping (Bool) -> Void ) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        DB_USER_LIKES.child(uid).child(tweet.tweetID).observeSingleEvent(of: .value) { snapshot in
            
            completion(snapshot.exists())
        }
    }
    
    func fetchTweet(withTweetID tweetID: String, completion: @escaping(Tweet) -> Void) {
        
        DB_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
            
            guard let dictionary = snapshot.value as? [String: Any] else {return }
            guard let userID = dictionary["uid"] as? String else {return }
            
            UserService.shared.fetchUser(uid: userID) { user in
                
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                
                completion(tweet)
            }
            
        }
        
    }
    
}
