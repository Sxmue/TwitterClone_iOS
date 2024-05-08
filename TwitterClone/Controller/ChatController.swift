//
//  ChatController.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 8/5/24.
//

import UIKit

class ChatController: UITableViewController{
    
    let user: User
    
    let messages = [Message]()
    
    
    init(user: User) {
        
        self.user = user
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        tableView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        
        tableView.rowHeight = 100
        

    }
    
    
    
    //MARK: - TableView Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
        
        
        return cell
    }
    
    
}
