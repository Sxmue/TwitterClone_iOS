//
//  SideMenuViewModel.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 6/5/24.
//

import UIKit


struct SideMenuViewModel {
    let user: User
    
    init(user: User) {
        self.user = user
    }
    
    var fullnameText: String{
        return user.fullname
    }
    
    var usernameText: String{
        return "@\(user.username)"
    }
    
}
