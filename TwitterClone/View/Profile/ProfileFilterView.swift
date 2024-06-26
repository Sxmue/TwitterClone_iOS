//
//  ProfileFilterView.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 12/4/24.
//

import UIKit

// Delegado para que cuando se seleccione una celda se haga algo concreto exteriormente, en este caso la animacion del cambio de barrita
protocol ProfileFilterViewDelegate: AnyObject {

    func optionSelected(option: ProfileFilterOptions,didSelect indexpath: IndexPath)
}

/**
 UIView que va a albergar nuestro collection view, para tener los tres botones de filtrado en el perfil del usuario
 */
class ProfileFilterView: UIView {

    // MARK: - Properties
    lazy var  collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

        cv.delegate = self
        cv.dataSource = self

        return cv
    }()

    weak var delegate: ProfileFilterViewDelegate? // Delegado para la funcionalidad de animacion del seleccionado
    
    lazy var barSelection: UIView = {
        let view = UIView()

        view.backgroundColor = .twitterBlue

        view.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 1)

        return view
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: "FilterCell")
        addSubview(collectionView)

        collectionView.addConstraintsToFillView(self) // Importante que existe esto, para que te añada automaticamente las constraints para que la vista ocupe todo el disponible

        // Ahora queremos que se seleccione siempre por defecto la primera opcion, eso se hace de esta manera
        // Tienen esta pripiedad los collection view para dejar seleccionado el que quieras
        collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
        
        

    }
    /**
     Esta funcion se encarga de colocar las subviews de esta vista una vez se haya inicializado el frame
     */
    override func layoutSubviews() {
        
        // Barrita para el filtro seleccionado
        addSubview(barSelection)
        
        //Como necesitamos el "frame.width" necesitamos anclarla en este metodo, porque si lo hacemos arriba el frame no estara inicializado
        barSelection.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width/3, height: 1)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Selectors

    // MARK: - Helpers

}

// MARK: - UICollectionViewFlowDelegate

extension ProfileFilterView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileFilterOptions.allCases.count // De cada caso del enum creara una celda
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! ProfileFilterCell

        // Usamos nuestro enum creado en el ProfileHeaderViewModel
        // Como hemos usado el parametro integer y la interfaz CaseIterable en el enum, a traves del index path itera los posibles casos
        let option = ProfileFilterOptions(rawValue: indexPath.row) // Instancia del enum con el indexpath 0,1,2

        // Si accedemos a la variable description de cada enum, segun lo seleccionado devolvera el titulo que queramos
        // Esto permitira que si añadimos en el futuro nuevas pestañas al filtro sera muy facil mapearlas

        cell.labelCell.text = option?.description

        return cell
    }

}

// MARK: - UICollectionViewDelegate

extension ProfileFilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    
        // De esta manera sacamos la celda en un metodo dentro del mismo collection view, la instanciamos
        let cell = collectionView.cellForItem(at: indexPath)
        let position = cell?.frame.origin.x ?? 0
        //Pasamos la animacion de la barra de filtro a esta vista
        UIView.animate(withDuration: 0.3) {
            self.barSelection.frame.origin.x = position
        }

        guard let option = ProfileFilterOptions(rawValue: indexPath.row) else {return }
        delegate?.optionSelected(option: option, didSelect: indexPath)
    }

}

// MARK: - UICollectionViewFlowDelegate

extension ProfileFilterView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Vamos a dividir el ancho de las celdas entre el ancho de las posibilidades que tengamos
        return CGSize(width: frame.width/CGFloat(ProfileFilterOptions.allCases.count), height: frame.height)
    }

    // Las celdas tienen un espacio por defecto en los collection view, de esta manera lo eliminamos
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
