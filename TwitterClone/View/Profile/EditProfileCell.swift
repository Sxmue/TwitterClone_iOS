//
//  EditProfileCell.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 30/4/24.
//

import UIKit

protocol EditProfileCellDelegate: AnyObject{
    func didUserInfoChange(_ cell: EditProfileCell)
    
}

class EditProfileCell: UITableViewCell{
    
    var vm: EditProfileViewModel?{
        didSet{
            configure()
        }
    }
    
    weak var delegate: EditProfileCellDelegate?
    
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
        tf.delegate = self
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
        
        //Para que no se seleccione la celda visulmente cuando pulsemos
        selectionStyle = .none
        
//        infoTextField.addTarget(self, action: #selector(handleUpdateUserInfo), for: .touchUpInside)

        contentView.isUserInteractionEnabled = true
       
        addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.anchor(top: topAnchor,left: leftAnchor,paddingTop: 12,paddingLeft: 16)
        
        addSubview(infoTextField)
        infoTextField.anchor(top: topAnchor,left: titleLabel.rightAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop: 4,paddingLeft: 16,paddingRight: 8)
        
        addSubview(bioTextView)
        bioTextView.anchor(top: topAnchor,left: titleLabel.rightAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop: 4,paddingLeft: 12,paddingRight: 8)
        
        
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        guard let vm = vm else {return  }
       
        infoTextField.isHidden = vm.shouldHideInfoTextView
        bioTextView.isHidden = vm.shouldHideBioTextView
        
        titleLabel.text = vm.titleText
        
        infoTextField.text = vm.textFieldData
        
        bioTextView.text = vm.textFieldData
        
        bioTextView.placeholder.isHidden = vm.shouldHideBioPlaceholder

        
        bioTextView.delegate = self
        
    }
    
}

//MARK: - TextFieldDelegate

extension EditProfileCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        delegate?.didUserInfoChange(self)
        
    }
}

//MARK: - TextViewDelegate

extension EditProfileCell: UITextViewDelegate{
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        delegate?.didUserInfoChange(self)

    }
    
}
