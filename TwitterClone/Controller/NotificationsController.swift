//
//  NotificationsController.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 2/4/24.
//


import UIKit

class NotificationsController: UIViewController{
    
    //MARK: - Propiedades
    
    
    //MARK: -Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()

    }

    //MARK: - Funciones de ayuda
    func configureUI(){
        
        view.backgroundColor = .white //Fondito blanco
        
        navigationItem.title = "Notifications"


    }
    
    
}
