//
//  FeedController.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 2/4/24.
//

import UIKit

class FeedController: UIViewController{
    
    //MARK: - Propiedades
    
    
    //MARK: -Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        //Lo primero que vamos a hacer es llamar a un metodo que configure la UI
        configureUI()
    }

    //MARK: - Funciones de ayuda
    
    func configureUI(){
        
        view.backgroundColor = .white //Fondito blanco
        
        //Lo primero que vamos a hacer es poner el loguito de twitter arriba
        //Esto lo vamos a hacer instanciando un IMAGEVIEW con un UIIMAGE dentro, que son cosas distintas
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        
        imageView.contentMode = .scaleAspectFit //ajusta la imagen al imageview pero manteniendo el aspect ratio
        
        navigationItem.titleView = imageView //La propiedad titleView añade al centro de la barrita de navegacion una vista que hayamos creado, en este caso nuestra imagen

    }
}
