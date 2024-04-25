//
//  NotificationService.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 23/4/24.
//

import UIKit
import Firebase

/**
 Servicio de la API encargado de gestionar las notificaciones
 */

struct NotificationService {

    static let shared = NotificationService() // patron singelton

    /**
     Funcion encargada de subir una notificacion
     */
    func uploadNotification(tweet: Tweet? = nil, // O le pasamos un tweet
                            user: User? = nil, // O le pasamos un usuario
                            type: NotificationType) {
        // El tweet puede que este o puede que no dependiendo de la notificacion, de ahi el nil default

        guard let uid = Auth.auth().currentUser?.uid else {return } // uid del current user

        // Seteamos el diccionario con los valores comunes a todas las notificaciones, el uid del usuario, el type y el timestamp
        var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
                                     "uid": uid,
                                     "type": type.rawValue]

        // Si tenemos un tweet
        if let tweet = tweet {

            // Le añadimos a los valores el id del tweet
            values["TweetID"] = tweet.tweetID
            // Le mandamos una notificacion al usuario del tweet
            DB_NOTIFICATIONS.child(tweet.user.uid).childByAutoId().updateChildValues(values)

        } else if let user = user {

            // En caso contrario tendremos un usuario y ejecutaremos los otros casos (follow y mencion)
            DB_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values)

        }

    }

    func fetchNotifications(completion: @escaping([Notification]) -> Void) {

        var notifications = [Notification]()

        guard let uid = Auth.auth().currentUser?.uid else {return }

        DB_NOTIFICATIONS.child(uid).observe(.childAdded) { snapshot, _ in

            guard let dictionary = snapshot.value as? [String: Any] else {return }
            guard let uid = dictionary["uid"] as? String else {return }

            UserService.shared.fetchUser(uid: uid) { user in

                let notification = Notification(user: user, tweet: nil, dictionary: dictionary)
                notifications.append(notification)
                completion(notifications)

            }

        }
    }

}
