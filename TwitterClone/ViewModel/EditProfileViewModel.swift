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
    
    let option: EditProfileOptions
    
    let user: User
    
    var shouldHideInfoTextView: Bool{
        return option == .bio
    }
    
    var titleText: String {
        return option.description
    }
    
    var textFieldData: String? {
        switch option {
        case .fullname:
            return user.fullname
        case .username:
            return user.username
        case .bio:
            return user.bio
        }
    }
    
    var shouldHideBioTextView: Bool{
        return option != .bio 
    }
    
    init(option: EditProfileOptions, user: User) {
        self.option = option
        self.user = user
    }
   

}
