//
//  SideMenuViewModel.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 6/5/24.
//

import UIKit

enum SideMenuOptions: Int,CaseIterable {
    case profile
    case list
    case logout
    
    var title: String {
        switch self {
        case .profile:
            return "Profile"
        case .list:
            return "List"
        case .logout:
            return "Logout"
        }
    }
    
    var imgName: String{
        switch self {
        case .profile:
            return "ic_person_outline_white_2x"
        case .list:
            return "ic_menu_white_3x"
        case .logout:
            return "baseline_arrow_back_white_24dp"
        }
    }
    
}





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
    
    var followingText: NSMutableAttributedString {
        guard let stats = user.stats else { return NSMutableAttributedString()}
        let attributed = NSMutableAttributedString(string: "\(stats.following)", attributes: [.font: UIFont.boldSystemFont(ofSize: 16),.foregroundColor: UIColor.white])
        
        let append = NSMutableAttributedString(string: " following", attributes: [.font: UIFont.systemFont(ofSize: 14),.foregroundColor: UIColor.white])
        attributed.append(append)
        
        return attributed
    }
    
    var followersText: NSMutableAttributedString {
        guard let stats = user.stats else { return NSMutableAttributedString()}
        let attributed = NSMutableAttributedString(string: "\(stats.followers)", attributes: [.font: UIFont.boldSystemFont(ofSize: 16),.foregroundColor: UIColor.white])
        
        let append = NSMutableAttributedString(string: " followers", attributes: [.font: UIFont.systemFont(ofSize: 14),.foregroundColor: UIColor.white])
        attributed.append(append)
        
        return attributed
    }
    
    var statsString: NSMutableAttributedString {
        
        guard let stats = user.stats else { return NSMutableAttributedString()}
        
        let attributed = NSMutableAttributedString(string: "\(stats.following)", attributes: [.font: UIFont.boldSystemFont(ofSize: 16),.foregroundColor: UIColor.white])
        
        let append = NSMutableAttributedString(string: " following", attributes: [.font: UIFont.systemFont(ofSize: 14),.foregroundColor: UIColor.white])
        attributed.append(append)
        
        
        
        let attributedFollowers = NSMutableAttributedString(string: "   \(stats.followers)", attributes: [.font: UIFont.boldSystemFont(ofSize: 16),.foregroundColor: UIColor.white])
        
        attributed.append(attributedFollowers)
        let appendFollwers = NSMutableAttributedString(string: " followers", attributes: [.font: UIFont.systemFont(ofSize: 14),.foregroundColor: UIColor.white])
        
        attributed.append(appendFollwers)

        
        return  attributed
    }
}
