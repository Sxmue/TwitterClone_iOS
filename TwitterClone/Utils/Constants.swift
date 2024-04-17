//
//  Constants.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 5/4/24.
//

import UIKit
import Firebase
import FirebaseStorage

//Nuestra clase de constantes
//Recuerda que las constantes siempre en mayúsculas y palabras separadas por "_"
let DB_REF = Database.database().reference()//con nuestra referencia a la base de datos

let DB_USERS = DB_REF.child("users") //Y nuestra referencia directa a la parte de usuarios

let DB_TWEETS = DB_REF.child("tweets") //Y nuestra referencia directa a la parte de usuarios

let DB_USER_TWEETS = DB_REF.child("user-tweets") //Referencia directa a los tweets del usuario

let STORAGE_REF = Storage.storage().reference() //Referencia directa a storage

let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images") //Referencia directa a las images de usuario

let DB_USER_FOLLOWERS = DB_REF.child("user-followers") //Referencia directa a user followers

let DB_USER_FOLLOWING = DB_REF.child("user-following") //referencia directa a user following


