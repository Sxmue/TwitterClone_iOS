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
    
    var messages = [Message]()
       
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
        footer.setDimensions(width: view.frame.width, height: 60)
        footer.anchor(left: view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,paddingLeft: 20,paddingBottom: 25,paddingRight: 20)
        chat.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,bottom: footer.topAnchor,right: view.rightAnchor,paddingBottom: 4)
        
        configureTableView()
        
        fetchMessages()
        

    }
    
    //MARK: - Helpers

    func configureTableView(){
        
        chat.delegate = self
        chat.dataSource = self
        chat.backgroundColor = .white
        chat.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        
        chat.separatorStyle = .none
        
        chat.rowHeight = 100
                
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
        MessageService.shared.saveMessage(content: footer.textView.text, toUser: user.uid) { error, ref in
            UIView.animate(withDuration: 0.5) {
                self.chat.reloadData()

            }
        }
        
    }

    
}

//MARK: - TableViewDelegate

extension ChatController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    
    
}

//MARK: - TableView Datasource

extension ChatController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
        
        let message = messages[indexPath.row]
        
        cell.selectionStyle = .none
        
        cell.message = message
        
        
        return cell
    }
    

}

extension ChatController: ChatFooterDelegate {
    
    func didTappedSend(_ footer: ChatFooterView, content: String) {
        
        print("DEBUG: se ha pulsado enviar, el mensaje es \(content)")
        
        sendMessage(message: content)
        
    }
    
    
    
    
}

