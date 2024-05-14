//
//  MessageCellViewModel.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 9/5/24.
//

import UIKit

enum MessageCellMode {
    
    case send
    case recive
    
}


class MessageCellViewModel {
    
    let message: Message
    
    let mode: MessageCellMode
    

    
    init(message: Message, mode: MessageCellMode) {
        self.message = message
        self.mode = mode
    }
    
    
    func size(forWidth width: CGFloat) -> CGSize {
        let view = MessageView()
        view.content.text = message.content
        view.content.numberOfLines = 0
        view.content.lineBreakMode = .byWordWrapping
        view.content.translatesAutoresizingMaskIntoConstraints = false
        view.content.widthAnchor.constraint(equalToConstant: width).isActive = true
        return view.content.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    func maxSize(forWidth width: CGFloat) -> CGFloat{
        return width * 0.40
    }
    
    func anchor(view: UIView) -> NSLayoutXAxisAnchor {
        switch mode {
        case .send:
            return view.rightAnchor
        case .recive:
            return view.leftAnchor
        }
    }
    
    

}
