//
//  ChatController.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 8/5/24.
//

import UIKit

class ChatController: UIViewController{
    
    
    //MARK: - Properties
    
    let user: User
    
    let footer = ChatFooterView()
    
    var messages = [Message](){
        didSet{
            updateChatLastMessage()
        }
    }
    
    var viewModel: ChatViewModel?
    
    let chat = UITableView()
    
    init(user: User) {
        
        self.user = user
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        footer.delegate = self
        view.addSubview(chat)
        
        view.addSubview(footer)
        
        //TODO: - arreglar las constraints del footer y el problema de las celdas
        footer.setDimensions(width: view.frame.width, height: 60)
        footer.anchor(top:chat.bottomAnchor,left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor,paddingLeft: 20,paddingBottom: 25,paddingRight: 20)
        chat.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,bottom: footer.topAnchor,right: view.rightAnchor)
        
        configureTableView()
        
        fetchMessages()
        
        
    }
    
    //MARK: - Helpers
    
    func configureTableView(){
        
        chat.delegate = self
        chat.dataSource = self
        chat.backgroundColor = .white
        chat.register(MessageSendCell.self, forCellReuseIdentifier: "MessageSendCell")
        chat.register(MessageReciveCell.self, forCellReuseIdentifier: "MessageReciveCell")
        
        chat.separatorStyle = .none
        
        
    }
    
    
    //MARK: - API
    
    func fetchMessages(){
        
        MessageService.shared.fetchMessages(withUser: user.uid) { messages in
            self.messages = messages
            UIView.animate(withDuration: 0.5) {
                self.chat.reloadData()
                
            }
        }
    }
    
    
    func sendMessage(message: String){
        
        MessageService.shared.saveMessage(content: footer.textView.text, toUser: user.uid) { error, ref, messageID in
            UIView.animate(withDuration: 0.5) {
                //                self.chat.reloadData()
                
                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                
                if indexPath.row > 1 {
                    self.chat.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
                
            }
            
            self.saveChat(messageID)
            
        }
        
        
    }
    
    func saveChat(_ messageID: String) {
        ChatService.shared.userHasChat(withUser: self.user.uid) { response in
            if !response {
                ChatService.shared.saveChat(toUser: self.user.uid, messageUid: messageID) { error, ref in
                    
                }
                
            }
        }
    }
    
    func updateChatLastMessage(){
        
//        guard let message = messages.last else {return }
       
        //TODO: - Actualizar el ultimo mensaje de la conversacion al chat
        
    }
    
}

//MARK: - TableViewDelegate

extension ChatController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    
}

//MARK: - TableView Datasource

extension ChatController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        let cellSend = tableView.dequeueReusableCell(withIdentifier: "MessageSendCell") as! MessageSendCell
        
        
        let cellRecive = tableView.dequeueReusableCell(withIdentifier: "MessageReciveCell") as! MessageReciveCell
        
        
        
        if message.isSended {
            
            cellSend.mode = .send
            
            cellSend.message = message
            cellSend.selectionStyle = .none
            
            return cellSend
            
        }else {
            
            cellRecive.mode = .recive
            
            cellRecive.message = message
            
            cellRecive.selectionStyle = .none
            
            return cellRecive
        }
        
    }
    
    
}

extension ChatController: ChatFooterDelegate {
    
    func didTappedSend(_ footer: ChatFooterView, content: String) {
        
        print("DEBUG: se ha pulsado enviar, el mensaje es \(content)")
        
        sendMessage(message: content)
        
        
    }
    
    
    
    
}

