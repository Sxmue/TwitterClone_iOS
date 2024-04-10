//
//  Utilities.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 3/4/24.
//

import UIKit

class Utilities {
    
    func createTwitterTextInput(img: String, tf: UITextField) -> UIView{
        
        let view = UIView()
        
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true //Muy importante porque si no le decimos el alto no se vera
        
        let imageView = UIImageView(image: UIImage(named: img))
        imageView.setDimensions(width: 24, height: 24)
        
        view.addSubview(imageView)
        view.addSubview(tf)
        imageView.anchor(left: view.leftAnchor,bottom: view.bottomAnchor,paddingLeft: 8,paddingBottom: 8)
        tf.anchor(left: imageView.rightAnchor, bottom:view.bottomAnchor,right: view.rightAnchor,paddingLeft: 8,paddingBottom: 8)
        
        //Despues de colocar imagen y textfield, vamos a crear una view sin nada, con un alto super pequeñito para que solo se vea una linea y colocarlo debajo del textField
        
        let divider = UIView()
        
        divider.backgroundColor = .white
        
        view.addSubview(divider)
        
        divider.anchor(left: view.leftAnchor,bottom: view.bottomAnchor,right: view.rightAnchor,paddingLeft: 8,height: 0.75)
        return view
    }
    
    func createTextField(withPlaceholder placeholder: String) -> UITextField{
        let tf = UITextField()
        tf.textColor = .white
        
        //De esta manera vamos a crear un placeHolder con atributos, propiedad que tienen los textFields y he visto por primera vez
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor : UIColor.white])
        
        
        return tf
    }
    
    func twitterButton(withText text: String) -> UIButton{
        
        //Nuestro boton de login va a ir en un stack view, asi que solo hay que configurar colores, el redondeo, y el alto del boton ya que el stack view se encarga de las constraints
        let button = UIButton(type: .system)
        
        //Propiedades de nuestro generador de botones
        button.backgroundColor = .white
        button.tintColor = .twitterBlue
        button.setTitle(text, for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        
        //Solo hay que ponerle alto al boton, porque ancho va a ocupar lo que ocupe el stack view
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return button
        
    }
    
    //Este generador de botones se va a encargar de generar los botones de abajo de "Tienes una cuenta?"
    func attributedButton(_ first: String,_ second: String) -> UIButton {
        
        //Para ello vamos a crear un boton, para que en cualquier parte se pulse sea en un texto o en otro
        //Este boton tiene dos textos: el "Tienes una cuenta?" que es la primera parte y el Sing in
        let btn = UIButton(type: .system)
        
        //Asi que creamos un atributed Title del boton, con las dos partes
        let attributedTitle = NSMutableAttributedString(string: first, attributes: [.font: UIFont.systemFont(ofSize: 16),.foregroundColor:  UIColor.white])
        
        //Y le hacemos el append de la segunda
        attributedTitle.append(NSAttributedString(string: second, attributes: [.font: UIFont.boldSystemFont(ofSize: 16),.foregroundColor:  UIColor.white] ))
    
        btn.setAttributedTitle(attributedTitle, for: .normal)
        
        return btn
    }
    
    func createCellImageButton(imgName: String) -> UIButton{
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: imgName), for: .normal)
        btn.tintColor = .darkGray
        btn.setDimensions(width: 20, height: 20)
        return btn
    }
    
    
}
