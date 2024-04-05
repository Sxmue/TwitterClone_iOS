//
//  Constants.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 5/4/24.
//

import UIKit
import FirebaseDatabase

//Nuestra clase de constantes
//Recuerda que las constantes siempre en mayúsculas y palabras separadas por "_"
let DB_REF = Database.database().reference()//con nuestra referencia a la base de datos

let DB_USERS = DB_REF.child("users") //Y nuestra referencia directa a la parte de usuarios
