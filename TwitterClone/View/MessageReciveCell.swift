//
//  MessageCell.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 8/5/24.
//

import UIKit

class MessageReciveCell: UITableViewCell {
    
    let messageView = MessageView()
    
    var mode: MessageCellMode?
    
    var message: Message?{
        didSet{
            configure()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        
        guard let message = message else {return }
        
        guard let mode = mode else {return }
        
        messageView.viewModel = MessageViewViewModel(mode: mode)
        
        let viewModel = MessageCellViewModel(message: message,mode: mode)
        
        messageView.content.text = viewModel.message.content
        messageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(messageView)
        messageView.centerY(inView: self)
        messageView.layer.cornerRadius = 8
        
        let screenPercent = viewModel.maxSize(forWidth: frame.width)
        
        messageView.anchor(top: topAnchor,left: leftAnchor,bottom: bottomAnchor,paddingTop: 4,paddingLeft: 4,paddingBottom: 4)
        
        messageView.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: screenPercent).isActive = true
        
    }
}


