//
//  UploadTwitController.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 9/4/24.
//

import UIKit

class UploadTwitController: UIViewController {
    
    //MARK: - Properties
    
    /**
     Boton de tweet de la barra de navegacion
     */
    private lazy var tweetButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue //color de fondo
        button.setTitle("Tweet", for: .normal) //asi se pone el texto
        button.titleLabel?.textAlignment = .center //asi se centra el texto programaticamente
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16) //cambio del tamaño del texto
        button.setTitleColor(.white, for: .normal) //cambio de color del texto
        button.setDimensions(width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        button.addTarget(self, action: #selector(handleTweet), for: .touchUpInside)
        return button
    }()
    
    
    
    //MARK: - Lifecyrcle

    override func viewDidLoad() {
        super.viewDidLoad()
      configureUI()
    }
    
    //MARK: - Selectors

    @objc func handleCancel(){
        
        self.dismiss(animated: true)

    }
    
    @objc func handleTweet(){
        print("DEBUG: tweet button action...")
    }
    
    //MARK: - Functions
    
    /**
     Metodo que se encarga de configurar la vista
     */
    func configureUI(){
        
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: tweetButton)
        
    }
    
}
