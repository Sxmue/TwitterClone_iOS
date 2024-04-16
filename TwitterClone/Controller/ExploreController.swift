//
//  ExploreController.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 2/4/24.
//

import UIKit

class ExploreController: UITableViewController{
    
    //MARK: - Propiedades
    
    private var users = [User](){
        didSet{
            tableView.reloadData()
        }
    }
    
    //Esto es nuevo completamente, vamos a necesitar buscar entre los usuarios que nos traigamos, asi que vamos a usar el componente SearchController
    private let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: -Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserCell") //registramos la celda
        
        tableView.separatorStyle = .none //quitamos las lineas separadoras
        
        tableView.rowHeight = 60 //le damos un poco mas de alto a las celdas

        configureUI()
        
        fetchUsers()
        
        configureSearchController()
    }

    //MARK: - Funciones de ayuda
    
    func configureUI(){
        
        view.backgroundColor = .white //Fondito blanco
        
        navigationItem.title = "Explore"


    }
    
    /**
     Metodo que se encarga de configurar la barra de navegacion
     */
    func configureSearchController(){
        //Esta propiedad evita que se oscurezca la vista cuando el usuario clicke en la barrita de busqueda
        searchController.obscuresBackgroundDuringPresentation = false
        
        //Le decimos que NO quite la navigationbar cuando pulsemos en ella
        searchController.hidesNavigationBarDuringPresentation = false
        
        
        //Le ponemos un placeholder
        searchController.searchBar.placeholder = "Busca un usuario"
        
        //Con esta propiedad cambiamos el color del cancel de al lado, que salia blanco
        searchController.searchBar.tintColor = .systemBlue
        
        //Y los navigation Item tienen una propiedad llamada searchBar para añadirla a la barra de navegacion
        
        navigationItem.searchController = searchController
        
        definesPresentationContext = false //Preguntar a fernando
    }
    
    //MARK: - API

    func fetchUsers(){
        
        UserService.shared.fetchUsers { users in
            self.users = users
            
        }
        
    }

    
}

//MARK: - TableView Datasource

extension ExploreController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        cell.awakeFromNib()
        
        cell.user = users[indexPath.row] //asignamos la propiedad usuario a la celda
        
        return cell
    }
}




