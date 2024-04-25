//
//  CaptionTextView.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 10/4/24.
//

import UIKit

/**
 Vista que va a representar nuestro TextView personalizado
 
 En la vista de enviar tweet necesitamos un campo de text con placeholder, en iOS los textView no tienen placeholder asi que necesitamos personalizarlo
 */
class CaptionTextView: UITextView {

    // Para personalizar nuestro text view, creamos esta clase y a continuacion los componentes necesario

    // MARK: - Properties
    let placeholder: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "¿Qué esta pasando?"
        return label
    }()

    // MARK: - Lifecyrcle

    /**
     En los text view necesitamos implementar este inicializador
     */
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)

        // Propiedades de la clase propia
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false // deshabilitas el scroll en el textField
        heightAnchor.constraint(equalToConstant: 300).isActive = true

        // Placeholder
        addSubview(placeholder)
        // En este caso, al ajustar un elemento a dentro del textview no se usa view. sino directamente topAnchor
        placeholder.anchor(top: topAnchor,
                           left: leftAnchor,
                           paddingTop: 8,
                           paddingLeft: 4)

        // Ahora vamos a hacer que cuando escribas se quite el placeholcer y viceversa
        // Esto lo hacemos añadiendo un listener, un observador como en javaFX al notificationCenter
        NotificationCenter.default.addObserver(self, selector: #selector(handleInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Selectors
    /**
     Recomendable añadir este dealloc cuando haya un observer, limpiara la vista de observer
     */
    deinit {
        NotificationCenter.default.removeObserver(UITextView.textDidChangeNotification)
    }
    @objc func handleInputChange() {
        // Como la vista es un textField, podemos acceder a la propiedad texto de los textFields
        // Si igualamos el hidden del placeholder de esta manera, siempre estara al contrario de si hay texto o no
        // Y gracias al listener se comprobara caracter a caracter
        placeholder.isHidden = !text.isEmpty

    }

}
