//
//  FeedController.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 2/4/24.
//

import UIKit
import SDWebImage

class FeedController: UIViewController{
    
    //MARK: - Propiedades
    
    var user:  User?{
        didSet {
            print("DEBUG: Usuario asignado en FeedController")
            //Cuando se haya asignado correctamente, podemos llamar al metodo que pone la imagen de la izquierda
            configureLeftProfileImage()
        }
        
    }
    
    
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
    
    /**
     Metodo que se encarga de configurar la imagen de arriba a la izquierda
     */
    func configureLeftProfileImage(){
        
        guard let user = user else {return } //Comprobamos que el usuario ha sido traido primero
        
        //Configuramos la imagen
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32) //Con esta linea se le da a los image view un tamaño concreto
        profileImageView.layer.cornerRadius = 32/2
        profileImageView.layer.masksToBounds = true //Indicamos que la imagen se quede de la forma del imageview
        //Ahora con la libreria que hemos añadido SDWEBIMAGE podemos asignar la imagen y hacer el fetch en el momento
        profileImageView.sd_setImage(with: URL(string: user.profileImage), completed: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)

    }
}
