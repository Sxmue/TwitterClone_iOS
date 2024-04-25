//
//  ActionSheetCell.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 19/4/24.
//

import UIKit

class ActionSheetCell: UITableViewCell {

    var option: ActionSheetOptions? {
        didSet {
            titleLabel.text = option?.description
        }
    }

    // MARK: - Properties
    private let optionImage: UIImageView = {

        let imv = UIImageView(image: UIImage(named: "twitter_logo_blue"))

        imv.contentMode = .scaleAspectFit

        imv.clipsToBounds = true

        imv.setDimensions(width: 36, height: 36)

        return imv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Text Option"

        return label
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(optionImage)
        optionImage.centerY(inView: self)
        optionImage.anchor(left: leftAnchor, paddingLeft: 12)
        addSubview(titleLabel)
        titleLabel.centerY(inView: self)
        titleLabel.anchor(left: optionImage.rightAnchor, paddingLeft: 12)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }

    // MARK: - Selectors

}
