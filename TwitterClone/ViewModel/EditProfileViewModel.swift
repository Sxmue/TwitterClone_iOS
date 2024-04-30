//
//  EditProfileViewModel.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 30/4/24.
//

import UIKit

/**
 Enum para hacer la misma celda cambiando los valores segun el tipo
 */
enum EditProfileOptions: Int,CaseIterable{
    
    case fullname
    case username
    case bio
    
    //Variable que para cada caso almacenara una descripcion diferente
    var description: String{
        //Nos recorremos a nosotros mismos
        switch self{
            
        case .fullname:
            return "Name"
        case .username:
            return "Username"
        case .bio:
            return "Bio"
        }
    }
}



struct EditProfileViewModel {
    
    
    
    
    
    
    
    
}
