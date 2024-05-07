//
//  SideMenu.swift
//  TwitterClone
//
//  Created by Samuel Leiva Alvarez on 6/5/24.
//

import UIKit


protocol SideMenuDelegate: AnyObject{
    
    func didSelectProfileOption(_ sideMenu: SideMenu)
    
    func didSelectLogout(_ sideMenu: SideMenu)

}

class SideMenu: UIView{
    
    //MARK: - Properties
    
    var user: User?{
        didSet{
            configure()
        }
    }
        
    
    var tableView = UITableView()
    
    weak var delegate: SideMenuDelegate?
    
    
    private lazy var profileImageView: UIImageView = {
        let imv = UIImageView()
        imv.contentMode = .scaleToFill
        imv.clipsToBounds = true
        imv.setDimensions(width: 64, height: 64)
        imv.layer.cornerRadius = 64/2
        imv.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toProfileView))

        imv.addGestureRecognizer(tap)

        imv.isUserInteractionEnabled = true 

        return imv
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    let statsLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    let profileButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(named: "ic_person_outline_white_2x"), for: .normal)
        
        button.setDimensions(width: 60, height: 60)
        
        return button
    }()
    
    
    
    //MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.register(SideMenuCell.self, forCellReuseIdentifier: "SideMenuCell")

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.backgroundColor = .twitterBlue
        tableView.separatorStyle = .none
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Selectors
    
    
    
    
    
    //MARK: - Helpers

    func configure(){
        
        backgroundColor = .twitterBlue

        tintColor = .white
        
        guard let user = user else {return }
        
        let viewModel = SideMenuViewModel(user: user)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: safeAreaLayoutGuide.topAnchor,left: leftAnchor,paddingTop: 0,paddingLeft: 12)
        profileImageView.sd_setImage(with: user.profileImageURL)
        
        
        let stack = UIStackView(arrangedSubviews: [fullnameLabel,usernameLabel])
        stack.axis = .vertical
        stack.spacing = 8
        addSubview(stack)
        stack.anchor(top: profileImageView.bottomAnchor,left: leftAnchor,paddingTop: 8,paddingLeft: 12)
        
        addSubview(statsLabel)
        statsLabel.anchor(top: stack.bottomAnchor,left: leftAnchor,paddingTop: 10,paddingLeft: 12)
        
        statsLabel.attributedText = viewModel.statsString
        
        fullnameLabel.text = viewModel.fullnameText
        
        usernameLabel.text = viewModel.usernameText
        

        addSubview(tableView)
        
        tableView.frame = frame

        tableView.anchor(top: statsLabel.bottomAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop: 30,paddingLeft: 12)
        
        
    }
    
    
    @objc func toProfileView() {
        
        print("DEBUG: A la vista de perfil del usuario")
    }
    
}

extension SideMenu: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SideMenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell 
        
        cell.selectionStyle = .none
        cell.option = SideMenuOptions(rawValue: indexPath.row)
        
        return cell
    }
    
    
}

extension SideMenu: UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let option = SideMenuOptions(rawValue: indexPath.row) else {return }
        
        switch option {
        case .profile:
            
            delegate?.didSelectProfileOption(self)
            
        case .list: break
            
        case .logout:
            
            delegate?.didSelectLogout(self)

        }
        
    }
    
}
