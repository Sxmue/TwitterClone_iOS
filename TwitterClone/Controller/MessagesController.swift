//
//  MessagesController.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 2/4/24.
//


import UIKit

protocol MessagesControllerDelegate: AnyObject {
    func didSelectChat(_ controller: MessagesController)
    func shouldShowActionButton(_ controller: MessagesController)
}

class MessagesController: UITableViewController{
    
    //MARK: - Propiedades
    
    var chats = [Chat]()
    
    weak var delegate: MessagesControllerDelegate?
    
    //MARK: -Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        configureUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        fetchChats()
        delegate?.shouldShowActionButton(self)
        
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
            
            for (index, currentChat) in self.chats.enumerated(){
                ChatService.shared.putChatlisteners(chatKey: currentChat.uid, toUser: currentChat.user.uid) { chat in
                    self.chats[index] = chat
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    
    //MARK: - TableViewDatasource
    
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
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chat = chats[indexPath.row]
        let controller = ChatController(user: chat.user)
        controller.previousChat = chat
        controller.delegate = self
        delegate?.didSelectChat(self)
        self.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
        self.hidesBottomBarWhenPushed = false
        
    }
    
}


//MARK: - ChatController Delegate
extension MessagesController: ChatControllerDelegate{
    func didChatMessageChange(_ controller: ChatController, _ previousChatID: String, _ content: String) {
        for (index, chat) in chats.enumerated(){
            
            if chat.uid == previousChatID {
                
                
                chats[index].message.content = content
                
                tableView.reloadData()
                
            }
        }
    }
    
}


