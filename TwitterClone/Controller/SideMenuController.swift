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
    
    init( user: User) {
        self.user = user
        self.sideMenu.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        
        view.addSubview(blackView)
        blackView.frame = view.frame
        
        
        
        view.addSubview(sideMenu)
        sideMenu.setDimensions(width: 300, height: view.frame.height)
        sideMenu.anchor(top: view.topAnchor,left: view.leftAnchor,bottom: view.bottomAnchor)
        
        
        UIView.animate(withDuration: 0.5) {

            self.blackView.alpha = 1

        }
        
    }
    
    
    
    //MARK: - Helpers
    
    func configure(){
        
        
    }
    
    
    @objc func handleDismiss(){
        
        navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: - API
    
    


    
}
