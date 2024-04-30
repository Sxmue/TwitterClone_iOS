//
//  EditProfileCell.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 30/4/24.
//

import UIKit

class EditProfileCell: UITableViewCell{
    
    var option: EditProfileOptions?{
        didSet{
            configure()
        }
    }
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //Sera el textField de las opciones normales
    lazy var  infoTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textAlignment = .left
        tf.textColor = .twitterBlue
        tf.addTarget(self, action: #selector(handleUpdateUserInfo), for: .touchUpInside)
        return tf
    }()
    
    //Este sera el textView de la biografia, que es distinto
    //InputTextView es la clase que creamos al principio para disponer de TextViews con placeholder, ya que de base no tienen
    let bioTextView: InputTextView = {
        let textView = InputTextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .twitterBlue
        textView.placeholder.text = "Bio"
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        
        
        //Para que no se seleccione la celda visulmente cuando pulsemos
        selectionStyle = .none
        guard let option = option else {return }
        titleLabel.text = option.description
        
       
        addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.anchor(top: topAnchor,left: leftAnchor,paddingTop: 8,paddingLeft: 10)
        
        
    }
    
    
    @objc func handleUpdateUserInfo(){
        
        
        
    }
}
