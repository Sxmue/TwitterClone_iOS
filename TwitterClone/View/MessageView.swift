//
//  MessageView.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 8/5/24.
//

import UIKit

class MessageView: UIView{
    
    
    let text: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.text = "Texto de prueba por defecto hola hola hola"
        label.numberOfLines = 10
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(text)
        text.centerY(inView: self)
        text.anchor(paddingLeft: 4,paddingRight: 4)
        backgroundColor = .systemBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
