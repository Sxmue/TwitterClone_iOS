//
//  MessageView.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 8/5/24.
//

import UIKit

class MessageView: UIView{
    
    
    var content: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.text = "Texto de prueba por defecto hola hola hola"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(content)
        content.center(inView: self)
        content.anchor(top: topAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop: 4,paddingLeft: 12,paddingBottom: 4,paddingRight: 4)
        backgroundColor = .systemBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
