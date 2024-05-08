//
//  MessageCell.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 8/5/24.
//

import UIKit

class MessageCell: UITableViewCell {
    
    let message = MessageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        
        message.setDimensions(width: 150, height: 40)
        message.layer.cornerRadius = 40/2
        addSubview(message)
        message.centerY(inView: self)
        message.anchor(right: rightAnchor,paddingRight: 4)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
}
