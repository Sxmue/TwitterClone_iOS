//
//  MessageViewViewModel.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 10/5/24.
//

import UIKit


class MessageViewViewModel {
    
    
    var mode: MessageCellMode
    
    init(mode: MessageCellMode) {
        self.mode = mode
    }
    
    
    var font: UIFont {
        return mode == .send ? UIFont.systemFont(ofSize: 16) : UIFont.boldSystemFont(ofSize: 16)
    }
    
    var backgroundColor: UIColor {
        return mode == .send ? UIColor.systemBlue : UIColor.placeholderText
    }
    
    var fontColor: UIColor {
        return mode == .send ? UIColor.white : UIColor.black
    }
    
}
