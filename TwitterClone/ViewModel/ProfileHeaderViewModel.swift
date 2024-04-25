//
//  ProfileHeaderViewModel.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 15/4/24.
//

import UIKit

/**
 Esta clase se encargara de implementar la logica necesaria en la profile header view
 */
enum ProfileFilterOptions: Int, CaseIterable {

    // Este enum se va a encargar del filtrado de los tweets en el perfil segun el boton que haya seleccionado
    // Tenemos estos 3 casos, que mapearemos como 0 , 1 y 2 dependiendo de que se haya seleccionado
    case tweets
    case replies
    case likes

    // Una variable calculada segun los casos de arriba, segun cada caso devuelve un string o otro
    // Esta manera de trabajar con el enum es muy facil de mantener e intuitiva
    var description: String {
        switch self {
        case .replies: return "Tweets & Replies"
        case .tweets: return "Tweets"
        case .likes: return "Likes"
        }

    }
}

struct ProfileHeaderViewModel {

    // Usuario del que vamos a coger los datos
    private let user: User

    var followingString: NSAttributedString? {

        return attributedText(withValue: user.stats?.following ?? 0, text: " following")
    }

    var followersString: NSAttributedString? {

        return attributedText(withValue: user.stats?.followers ?? 0, text: " followers")

    }

    var usernameText: String

    /**
     Cambiara dependiendo de si estamos viendo el perfil del usuario logueado o no
     */
     var buttonTittle: String {

         return user.isCurrentUser ? "Edit Profile" :  user.isFollowed ? "Following" : "Follow"

    }

    init(user: User) {
        self.user = user
        self.usernameText = "@\(user.username)"
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

}
