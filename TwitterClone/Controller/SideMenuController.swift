//
//  SideMenuController.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 6/5/24.
//

import UIKit

class SideMenuController: UIViewController{
    
    //MARK: - Properties
    
    var sideMenu = SideMenu()
    
    private var window: UIWindow?

    
    var user: User{
        didSet{
            configure()
        }
    }
    
    lazy var blackView: UIView = {
        let view = UIView()

        // Va a ser una view con este constructor, es decir con el white a 0 y el alpha (opacidad= a la mitad
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.alpha = 0

        // Le añadimos un gesture tap para nada mas que se pulse en lo negro se vuelva a la pantalla anterior
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))

        // Y aqui lo añadimos al image view
        view.addGestureRecognizer(tap) // listo

        view.isUserInteractionEnabled = true // importante para que funcione nuestro reconocimiento de gestos

        return view
    }()
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        
    
        
    }
    
    
    
    //MARK: - Helpers
    
    func configure(){
        
        
    }
    
    
    @objc func handleDismiss(){
        
        // Con animacion tambien para quitarla
        UIView.animate(withDuration: 0.5) {
            
            // Le quitamos la opacidad completamente
            self.blackView.alpha = 0
            
            self.sideMenu.frame.origin.x -= 500

            
        }
        
    }
    
    //MARK: - API
    
    


    
}
