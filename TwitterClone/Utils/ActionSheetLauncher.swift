//
//  ActionSheetLauncher.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 19/4/24.
//

import UIKit

/**
   Protocolo para el delegado de la clase
 */

protocol ActionSheetLauncherDelegate: AnyObject {
    
    func didSelect(option: ActionSheetOptions)
    
}

/**
 Clase que gestiona la action sheet que hay en DetailsViewController
 */
class ActionSheetLauncher: NSObject {
    
    let ROW_HEIGHT = 60
    
    
    //MARK: - Properties
    var user: User
    
    lazy var viewModel = ActionSheetViewModel(user: user)
    
    let tableView = UITableView()
    
    weak var delegate: ActionSheetLauncherDelegate? //variable del delegado
    
    
    
    //Este black view va a ser el efecto de oscurecerse detras de la ventana modal
    lazy var blackView: UIView = {
        let view = UIView()
        
        
        //Va a ser una view con este constructor, es decir con el white a 0 y el alpha (opacidad= a la mitad
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.alpha = 0
        
        
        //Le añadimos un gesture tap para nada mas que se pulse en lo negro se vuelva a la pantalla anterior
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        
        //Y aqui lo añadimos al image view
        view.addGestureRecognizer(tap) //listo
        
        view.isUserInteractionEnabled = true //importante para que funcione nuestro reconocimiento de gestos
        
        
        return view
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGroupedBackground //Esto le da el grisecillo al boton ese tan caracteristico
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 50/2
        button.addTarget(self, action: #selector(handleDismiss) , for: .touchUpInside)
        return button
    }()
    
    lazy var  footerView: UIView = {
        let view = UIView()
        //Footer view solo con el boton
        view.addSubview(cancelButton)
        cancelButton.anchor(left: view.leftAnchor,right: view.rightAnchor,paddingLeft: 12,paddingRight: 12)
        cancelButton.centerY(inView: view)
        
        return view
    }()
    
    private var window: UIWindow?
    
    init(user: User) {
        self.user = user
        super.init()
    }
    
    
    
    //MARK: - Lifecycle


    func show(){
                
        //Sacamos una instancia de la pantalla completa
        let scenes = UIApplication.shared.connectedScenes
        
        let windowScene = scenes.first as? UIWindowScene
                
        guard let window = windowScene?.windows.first(where: {$0.isKeyWindow}) else {return }
        
        self.window = window
        
        configureTableView() //importante llamamos al metodo de configurar el tableview
        
        //le añadimos la black view
        window.addSubview(blackView)
        //y le decimos que su frame es el de window, eso hara que ocupe toooda la ventana entera, oscurecera todo
        blackView.frame = window.frame
        

        window.addSubview(tableView)
        //Le damos este frame, un frame es un trocito en la pantalla
        
        //Ya sabes que el inicio de cordenadas en iphone es arriba a la izquierda, si le damos de eje "Y" el alto de la pantalla. bajara a abajo del todo, si le damos de alto 300 subira 300 px de abajo hacia arriba que es como queremos mostrar la view
        //Queremos tantas celdas como opciones haya de 60 px cada una, asi que el tamaño 3 * 60
        let height = (viewModel.options.count * 60) + 100
        tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: CGFloat(height))
        
        //Los 300 de altura en el eje y se lo damos en la animacion, esto hace que DESDE ABAJO (window.frame.heigh) suba 300 px
        UIView.animate(withDuration: 0.5) {
            
            self.blackView.alpha = 1
            self.tableView.frame.origin.y -= CGFloat(height)
            
        }
        
        
    }
    
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        //Configuracion visual
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false //quitamos el scroll
                
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: "ActionSheetCell")
        
    }
    
    //MARK: - Selectors
    
    @objc func handleDismiss(){
        
        //Con animacion tambien para quitarla
        UIView.animate(withDuration: 0.5) {
            
            //Le quitamos la opacidad completamente
            self.blackView.alpha = 0
            //Movemos el table view a fuera de la pantalla sumandole los 300 px de vuelta
            self.tableView.frame.origin.y += 300
        }
        
    }
    
 
}

//MARK: - TableViewDataSourceDelegate

extension ActionSheetLauncher: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ActionSheetCell", for: indexPath) as! ActionSheetCell
        
        cell.option = viewModel.options[indexPath.row]
        
        return cell
    }
    
    
}


//MARK: - TableViewDelegate

extension ActionSheetLauncher: UITableViewDelegate {
    
    //Llamamos a los metodos del footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        CGFloat(ROW_HEIGHT)
    }
    
    //Llamamos al didselect
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //El viewModel tiene el array con las opciones que tenemos, asi que a traves de el sacamos la opcion seleccionada
        
        let option = viewModel.options[indexPath.row] //ya sabemos que opcion ha sido
        
        delegate?.didSelect(option: option) //llamada al delegado con la opcion seleccionada
        
        handleDismiss()
        
    }
    
    
}



