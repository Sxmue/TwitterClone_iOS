//
//  MessagesController.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 2/4/24.
//


import UIKit

class MessagesController: UITableViewController{
    
    //MARK: - Propiedades
    
    var chats = [Chat]()
    
    //MARK: -Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        configureUI()
        fetchChats()
    }

    //MARK: - Funciones de ayuda
    func configureUI(){
        
        view.backgroundColor = .white //Fondito blanco
        
        navigationItem.title = "Messages"
        
        tableView.register(ChatCell.self, forCellReuseIdentifier: "ChatCell")

        tableView.rowHeight = 70
    }
    
    //MARK: - API
    
    func fetchChats(){
        ChatService.shared.fetchChats { chats in
            print("DEBUG: Hemos traido \(chats.count) chats")
            self.chats = chats
            self.tableView.reloadData()
        }
        
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell

        let chat = chats[indexPath.row]
        let viewModel = ChatCellViewModel(chat: chat)

        cell.viewModel = viewModel

        return cell
    }
    
}
