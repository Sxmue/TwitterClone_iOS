//
//  EditProfileController.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 29/4/24.
//

import UIKit


class EditProfileController: UITableViewController {
    
    
    //MARK: - Properties
    
    let user: User
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    //MARK: - Lifecycle

    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureNavigsationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - API

    
    
    //MARK: - Selectors
    
    
    @objc func handleCancel(){
        navigationController?.dismiss(animated: true)
    }
    
    @objc func handleDone(){
        
    }
    //MARK: - Helpers

    func configureNavigsationBar(){
        
        navigationController?.navigationBar.backgroundColor = .twitterBlue
        
        navigationController?.navigationBar.barTintColor = .twitterBlue
        
        navigationController?.navigationBar.backgroundColor = .twitterBlue
        
        navigationController?.navigationBar.tintColor = .white

        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.title = "Editar Perfil"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))

    }
    
    
    
}


