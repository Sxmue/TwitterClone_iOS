//
//  TweetViewModel.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 11/4/24.
//

import UIKit

// Esta es nuestra primera clase ViewModel, clase la cual va a actuar igual que una capa de servicios, cada minima LOGICA que necesitemos realizar fuera de los componentes de la UI que no sea simplemente asignar algo, debe ir en su ViewModel correspondiente, ayuda al mantenimiento del codigo y a separar la arquitectura de capas
// Ya sea desde calcular un timestamp o hacer un attributed string DEBE ir aqui, en su viewModel
class TweetViewModel {

    var tweet: Tweet

    lazy var profileImageURL: URL? = {
        return  URL(string: self.tweet.user.profileImage)
    }()

     var usernameText: String {
        return "@\(tweet.user.username)"
    }

    var timestamp: String {
        // Para trabajar con timestamps hay que crear un Formatter
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekday] // Esto indica en que va a devolver nuestro formatter la fecha

        formatter.maximumUnitCount = 1 // Asi le dices que unidades de las que acabamos de poner arriba quieres de vuelva, por orden, asi que 1 es segundos

        formatter.unitsStyle = .abbreviated // estilo abreviado

        return formatter.string(from: tweet.timestamp, to: Date()) ?? "0s" // Este metodo devuelve la diferencia entre dos fechas
    }

    var detailsHeaderTimestamp: String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.timeZone = .current
        // Esto es nuevo, y de esta manera le podemos dar formato
        formatter.dateFormat = "h:mm﹒dd/MM/yyyy"

        return formatter.string(from: tweet.timestamp)
    }

    var retweetAttributedString: NSAttributedString? {
        return attributedText(withValue: tweet.retweets, text: " Retweets")

    }

    var likesAttributedString: NSAttributedString? {

        return attributedText(withValue: tweet.likes, text: " Likes")

    }

    lazy var userInfoText: NSAttributedString = {
        let title = NSMutableAttributedString(string: "\(self.tweet.user.fullname)",
                                              attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " @\(tweet.user.username)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))

        title.append(NSAttributedString(string: " ﹒ \(timestamp)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return title
    }()

    // Propiedad que nos devolvera el color dependeiendo de su esta lickeado el tweet o no
    var likeTintColor: UIColor {
        return tweet.didLike ? .red : .darkGray
    }

    // Propiedad que cambia la imagen del boton de like dependiendo de si esta dado mg o no
    var likeButtonImage: UIImage {
        let name = tweet.didLike ? "like_filled" : "like"
        return UIImage(named: name)!
    }

    init(tweet: Tweet) {
        self.tweet = tweet
    }

    /**
     Funcion que nos va a crear un attributedText con el valor que pongamos y el texto que queramos
     
     Sera de uso interno ya que con esta funcion setearemos las dos propiedades mas arriba
     */
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {

        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])

        attributedTitle.append(NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                                               .foregroundColor: UIColor.lightGray]))

        return attributedTitle
    }

    /**
     Funcion que se va a encargar de asignar el alto a la celda del tweet dependiendo de cuandos caracteres tenga
     */
    func size(forWidth width: CGFloat) -> CGSize {
        // Creamos un label de pruebas en el que vamos a calcular ls cosas, primero seteamos varias propiedades
        let testLabel = UILabel()
        testLabel.text = tweet.caption // le ponemo la caption del tweet
        testLabel.numberOfLines = 0
        testLabel.lineBreakMode = .byWordWrapping // Le decimos que corte por palabras cuando haya un salto de linea no por letras

        testLabel.translatesAutoresizingMaskIntoConstraints = false // Hay que quitar las constranits para que la siguiente linea de bien el valor
        testLabel.widthAnchor.constraint(equalToConstant: width).isActive = true

        // El metodo systemLayoytSizeFitting se encarga de devolver el valor optimo de tamaño que deberia de tener la vista
        // Y el argumento es, es valor minimo para que vista? Pues para un UIView con esa llamada, que se encarga de decir que sea para que ocupe lo minimo posible
        // Asi el sistema te da el valor optimo para ocupar el minimo posible
        // La verdad, es complicado hablarlo con fernando
        return testLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
