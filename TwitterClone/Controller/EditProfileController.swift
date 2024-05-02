//
//  EditProfileController.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 29/4/24.
//

import UIKit

/**
 Vista encargada de editar el perfil de usuario
 */
class EditProfileController: UITableViewController{
    
    
    //MARK: - Properties
    
    //usuario del perfil
    var user: User
    
    let picker = UIImagePickerController()

        
    
    //Importante el lazy aqui, porque asi nos aseguraremos de que el user este inicializado antes que esta vista
    private lazy var headerView = EditProfileHeader(user: user)
    
    //Override para cambiar el color de la status a blanco
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
        configureTableView()
        configureImagePicker()
        
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

    /**
     Metodo encargado de cambiar nuestra navigation bar
     */
    func configureNavigsationBar(){
        
        //Cambiamos los fondos a azul, tambien he tenido que hacerlo en el scene delegate
        navigationController?.navigationBar.backgroundColor = .twitterBlue
        
        navigationController?.navigationBar.barTintColor = .twitterBlue
        
        //Tint color para que los botones sean blancos
        navigationController?.navigationBar.tintColor = .white

        //Quitamos que sea traslucida
        navigationController?.navigationBar.isTranslucent = false
        
        //Ponemos su titulo
        navigationItem.title = "Editar Perfil"
        
        //De esta manera ponemos el titulo del navigation en blanco
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        //Le añadimos las opciones al menu
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        
        navigationItem.rightBarButtonItem?.isEnabled = false

    }
    
    /**
     Configurcion de nuestro tableView
     */
    func configureTableView(){
        
        //Le indicamos que el header va a ser nuestra vista
        tableView.tableHeaderView = headerView
        
        headerView.delegate = self
        //Posicion 0,0 que es donde va el header, el ancho de la vista, y 180 de alto
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        
//        tableView.tableFooterView = UIView()
        
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: "EditProfileCell")
        
    }
    
    func configureImagePicker(){
        picker.delegate = self
        picker.allowsEditing = true

    }
    
    
    
}

//MARK: - EditProfileHeaderDelegate
/**
 Delegado del edit Profile Header
 */
extension EditProfileController: EditProfileHeaderDelegate{
    func didChangeImage(_ header: EditProfileHeader) {
        
        present(picker,animated: true)
    }
    
}

//MARK: - Datasource
extension EditProfileController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOptions.allCases.count //De esta manera creamos una celda por cada caso del array
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileCell", for: indexPath) as! EditProfileCell
        
        guard let option = EditProfileOptions(rawValue: indexPath.row) else {return UITableViewCell()}
        
        let vm = EditProfileViewModel(option: option, user: user)
        
        cell.vm = vm
        cell.delegate = self
                
        return cell
    }
    
}

extension EditProfileController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //Vamos a cambiar el alto de la celda dependiendo de que opcion esta seleccionada
        guard let option = EditProfileOptions(rawValue: indexPath.row) else {return  0}
        
        //La razon por la que se hace esto es para darle mas alto a la celda de la biografica concretamente
        //Si es bio la celda medira 100, sino 48
        return option == .bio ? 100 : 48
    }
}

//MARK: - EditProfileCellDelegate

extension EditProfileController: EditProfileCellDelegate{
    
    func didUserInfoChange(_ cell: EditProfileCell) {
        
        guard let vm = cell.vm else {return }
        
        switch vm.option {
            
        case .fullname:
            
            print("DEBUG: update user fullname")
            
            guard let fullname = cell.infoTextField.text else {return }
            
            user.fullname = fullname
        case .username:
            
            print("DEBUG: update user username")
            
            guard let username = cell.infoTextField.text else {return }

             
             user.username = username
            
        case .bio:
            
            print("DEBUG: update bio")
            
        }
        
        print("DEBUG: el full name es \(user.fullname)")
        print("DEBUG: el username es \(user.username)")

        
    }
    
    
}



//MARK: - ImagePickerDelegate

extension EditProfileController: UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let img = info[.editedImage] as? UIImage else {return }
        
        headerView.profileImageView.image = img
        
        dismiss(animated: true)
    }
    
    
    
}


