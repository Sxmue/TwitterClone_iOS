//
//  ActinSheetViewModel.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 19/4/24.
//

import UIKit

enum ActionSheetOptions{
    
    case follow(User)
    case unfollow(User)
    case report
    case delete
    
    var description: String {
        switch self {
            
        case .follow(let user):
            return "Follow @\(user.username)"
            
        case .unfollow(let user):
           return "Unfollow @\(user.username)"
            
        case .report:
            return "Report Tweet"
            
        case .delete:
            
            return "Delete Tweet"
        }
    }
}

struct ActionSheetViewModel {
    
    private let user: User
    
    lazy var  options: [ActionSheetOptions] = {
        var results = [ActionSheetOptions]()
        
        if user.isCurrentUser {
            results.append(.delete)
        }else {
            
            let option: ActionSheetOptions = user.isFollowed ? .unfollow(user) : .follow(user)
            
            results.append(option)
        }
        
        results.append(.report)
        
        return results
    }()
   
    init(user: User){
        self.user = user
    }
}
