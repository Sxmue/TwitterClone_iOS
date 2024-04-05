//
//  Constants.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 5/4/24.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

//Nuestra clase de constantes
//Recuerda que las constantes siempre en mayúsculas y palabras separadas por "_"
let DB_REF = Database.database().reference()//con nuestra referencia a la base de datos

let DB_USERS = DB_REF.child("users") //Y nuestra referencia directa a la parte de usuarios

let STORAGE_REF = Storage.storage().reference() //Referencia directa a storage

let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images") //Referencia directa a las images de usuario

