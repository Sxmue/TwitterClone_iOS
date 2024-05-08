//
//  ChatController.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 8/5/24.
//

import UIKit

class ChatController: UITableViewController{
    
    let user: User
    
    init(user: User) {
        
        self.user = user
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .systemPink

    }
    
    
    
}
