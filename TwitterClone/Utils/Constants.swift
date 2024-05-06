//
//  Constants.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 5/4/24.
//

import UIKit
import Firebase
import FirebaseStorage

// Nuestra clase de constantes
// Recuerda que las constantes siempre en mayúsculas y palabras separadas por "_"
let DB_REF = Database.database().reference()// con nuestra referencia a la base de datos

let DB_USERS = DB_REF.child("users") // Y nuestra referencia directa a la parte de usuarios

let DB_TWEETS = DB_REF.child("tweets") // Y nuestra referencia directa a la parte de usuarios

let DB_USER_TWEETS = DB_REF.child("user-tweets") // Referencia directa a los tweets del usuario

let DB_USER_LIKES = DB_REF.child("user-likes") // Referencia directa a los likes del usuario

let DB_USER_NAMES = DB_REF.child("user-usernames") // Referencia directa a los usernames

let DB_USER_REPLIES = DB_REF.child("user-replies") // Referencia directa a los likes del usuario

let DB_TWEET_LIKES = DB_REF.child("tweet-likes") // Referencia directa a los likes del tweet

let DB_TWEET_REPLIES = DB_REF.child("tweet-replies") // Referencia directa a las respuestas a los tweet

let DB_NOTIFICATIONS = DB_REF.child("notifications") // Referencia directa a las notificaciones

let STORAGE_REF = Storage.storage().reference() // Referencia directa a storage

let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images") // Referencia directa a las images de usuario

let DB_USER_FOLLOWERS = DB_REF.child("user-followers") // Referencia directa a user followers

let DB_USER_FOLLOWING = DB_REF.child("user-following") // referencia directa a user following
