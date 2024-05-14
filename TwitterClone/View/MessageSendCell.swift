//
//  MessageSendCell.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 14/5/24.
//


import UIKit

class MessageSendCell: UITableViewCell {
    
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
        
        messageView.anchor(top: topAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop:4,paddingBottom: 4,paddingRight: 4)
        
        messageView.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: screenPercent).isActive = true
        
    }
}
