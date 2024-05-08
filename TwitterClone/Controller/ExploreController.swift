//
//  ExploreController.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 2/4/24.
//

import UIKit

enum ExploreConfiguration{
    case messages
    case userSearch
}

class ExploreController: UITableViewController {

    // MARK: - Propiedades

    private var users = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var config: ExploreConfiguration

    // Array suplementario para almacenar el filtro de los usuarios
    private var filteredUsers = [User]() {
        didSet {
            tableView.reloadData()
        }
    }

    // Con eso sabremos si la barra esta activada y si NO tiene texto, la usaremos abajo
    var inSearchMode: Bool {
        return searchController.isActive && ((searchController.searchBar.text?.isEmpty) != nil)
    }

    // Esto es nuevo completamente, vamos a necesitar buscar entre los usuarios que nos traigamos, asi que vamos a usar el componente SearchController
    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Lifecycle
    
    
    init(config: ExploreConfiguration){
        self.config = config

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserCell") // registramos la celda

        tableView.separatorStyle = .none // quitamos las lineas separadoras

        tableView.rowHeight = 60 // le damos un poco mas de alto a las celdas

        configureUI()

        fetchUsers()

        configureSearchController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        navigationController?.navigationBar.isHidden = false
        navigationController?.isNavigationBarHidden = false

    }

    // MARK: - Funciones de ayuda

    func configureUI() {

        view.backgroundColor = .white // Fondito blanco

        navigationItem.title = config == .messages ? "New Message" : "Explore"

        if config == .messages {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target:self, action: #selector(handleCancel))
        }
    }

    /**
     Metodo que se encarga de configurar la barra de navegacion
     */
    func configureSearchController() {

        // Con esto le decimos en que clase debemos aplicar el update de lo que se busque,
        // hay que adoptar su protocolo para que lo identifique
        searchController.searchResultsUpdater = self

        // Esta propiedad evita que se oscurezca la vista cuando el usuario clicke en la barrita de busqueda
        searchController.obscuresBackgroundDuringPresentation = false

        // Le decimos que NO quite la navigationbar cuando pulsemos en ella
        searchController.hidesNavigationBarDuringPresentation = false

        // Le ponemos un placeholder
        searchController.searchBar.placeholder = "Busca un usuario"

        // Con esta propiedad cambiamos el color del cancel de al lado, que salia blanco
        searchController.searchBar.tintColor = .systemBlue

        // Y los navigation Item tienen una propiedad llamada searchBar para añadirla a la barra de navegacion

        navigationItem.searchController = searchController

        definesPresentationContext = false // Preguntar a fernando
    }

    // MARK: - API

    func fetchUsers() {

        UserService.shared.fetchUsers { users in
            self.users = users

        }

    }
    
    // MARK: - Selectors
    
    @objc func handleCancel(){
    
        dismiss(animated: true)
    }



}

// MARK: - TableView Datasource

extension ExploreController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Aqui basicamente, con nuestro boolean de ayuda, si es true devolvemos la lista filtrada y sino devolvemos la de usuarios original
        // Asi cuando cliques en la barrita desaparecera lo que haya abajo y hace ese efecto tan chulo ademas de simplificar el filtrado
        return inSearchMode ? filteredUsers.count : users.count

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        cell.awakeFromNib()

        // Aqui igual, si estamos en search mode coge los datos de un array o de otro, con el operador elvis es muy facil hacer esto
        cell.user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row] // asignamos la propiedad usuario a la celda

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Tenemos el usuario en la row del index path asi que copiamos la linea de arriba
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        var controller: UIViewController
        
        switch config{
            
        case .messages:
            
            controller = ChatController(user: user)
            
        case .userSearch:
            
            controller = UserProfileController(user: user)
            
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - SearchBarUpdating

/**
 Este protocolo te permite adoptar el metodo necesario para trabajar con la search bar
 */
extension ExploreController: UISearchResultsUpdating {

    /**
     Y este metodo del protocolo aplica el resultado de la busqueda, te da el texto de la barra de busqueda en tiempo real
     */
    func updateSearchResults(for searchController: UISearchController) {
        // obviamente desde search controller sacamos el texto y lo aplicamos
        tableView.reloadData()

        guard let searchText = searchController.searchBar.text?.lowercased() else {return }

        // tenemos este metodo en los array para filtrar facilmente
        // De esta manera cuando coincida alguno en la busqueda en el filter array habra datos, sino no los habra
        filteredUsers = users.filter({ user in

            user.username.lowercased().contains(searchText)
        })

    }

}
