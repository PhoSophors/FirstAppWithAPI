import UIKit
import SnapKit

protocol ProfileViewDelegate: AnyObject {
    func profileViewDidTapEdit()
    func profileViewDidTapLogout()
}

class ProfileView: UIView {
    
    weak var delegate: ProfileViewDelegate?
    
    // UI elements
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 30
        return view
    }()
    
    let profileImageView: UIImageView = {
          let imageView = UIImageView()
          imageView.image = UIImage(named: "profile")
          imageView.tintColor = .white
          imageView.contentMode = .scaleAspectFill
          imageView.layer.cornerRadius = 40
          imageView.clipsToBounds = true
          return imageView
      }()

    let fullnameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let badgesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 10
        stackView.clipsToBounds = true
        stackView.layer.borderWidth = 1.0
        stackView.layer.borderColor = UIColor.systemGray.cgColor
        stackView.layer.masksToBounds = false
        
        return stackView
    }()

    let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.contentHorizontalAlignment = .left
        button.layer.cornerRadius = 10
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        // Add icon to the left
        let leftIcon = UIImage(systemName: "pencil")
        button.setImage(leftIcon, for: .normal)
        button.tintColor = .systemGray
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        // Add arrow icon to the right
        let rightArrow = UIImage(systemName: "chevron.right")
        let arrowImageView = UIImageView(image: rightArrow)
        arrowImageView.tintColor = .black
        button.addSubview(arrowImageView)
        
        // Set constraints for the arrow icon using SnapKit
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(button)
            make.trailing.equalTo(button).offset(-10)
        }
        
        return button
    }()
    
    let profileSettingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Profile Settings", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.contentHorizontalAlignment = .left
        button.layer.cornerRadius = 10
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        // Add icon to the left
        let leftIcon = UIImage(systemName: "person.crop.circle.fill")
        button.setImage(leftIcon, for: .normal)
        button.tintColor = .systemGray
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        // Add arrow icon to the right
        let rightArrow = UIImage(systemName: "chevron.right")
        let arrowImageView = UIImageView(image: rightArrow)
        arrowImageView.tintColor = .black
        button.addSubview(arrowImageView)
        
        // Set constraints for the arrow icon using SnapKit
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(button)
            make.trailing.equalTo(button).offset(-10)
        }
        
        return button
    }()
    
    let changePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Password", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.contentHorizontalAlignment = .left
        button.layer.cornerRadius = 10
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        // Add icon to the left
        let leftIcon = UIImage(systemName: "lock.circle.fill")
        button.setImage(leftIcon, for: .normal)
        button.tintColor = .systemGray
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        // Add arrow icon to the right
        let rightArrow = UIImage(systemName: "chevron.right")
        let arrowImageView = UIImageView(image: rightArrow)
        arrowImageView.tintColor = .black
        button.addSubview(arrowImageView)
        
        // Set constraints for the arrow icon using SnapKit
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(button)
            make.trailing.equalTo(button).offset(-10)
        }
        
        return button
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .white
        button.contentHorizontalAlignment = .left
        button.layer.cornerRadius = 10
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        // Add icon to the left
        let leftIcon = UIImage(systemName: "iphone.and.arrow.forward")
        button.setImage(leftIcon, for: .normal)
        button.tintColor = .systemRed
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        // Add arrow icon to the right
        let rightArrow = UIImage(systemName: "chevron.right")
        let arrowImageView = UIImageView(image: rightArrow)
        arrowImageView.tintColor = .systemRed
        button.addSubview(arrowImageView)
        
        // Set constraints for the arrow icon using SnapKit
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(button)
            make.trailing.equalTo(button).offset(-10)
        }
        
        return button
    }()
  
    
    // Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Function to setup UI elements and their constraints
    private func setupUI() {
        addSubview(headerView)
        headerView.addSubview(profileImageView)
        headerView.addSubview(fullnameLabel)
        headerView.addSubview(emailLabel)
        headerView.addSubview(badgesStackView)
        addSubview(editProfileButton)
        addSubview(profileSettingsButton)
        addSubview(changePasswordButton)
        addSubview(logoutButton)
        
        // Setup constraints using SnapKit
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(240)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerView.snp.top).offset(64)
            make.width.height.equalTo(100)
        }
        
        fullnameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(fullnameLabel.snp.bottom).offset(5)
        }
        
        badgesStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        editProfileButton.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        profileSettingsButton.snp.makeConstraints { make in
            make.top.equalTo(editProfileButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        changePasswordButton.snp.makeConstraints { make in
            make.top.equalTo(profileSettingsButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(changePasswordButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    @objc private func editButtonTapped() {
        delegate?.profileViewDidTapEdit()
    }
    
    @objc private func logoutButtonTapped() {
        delegate?.profileViewDidTapLogout()
    }
    
    // Update method
    func update(with user: User) {
        fullnameLabel.text = user.full_name
        emailLabel.text = user.email
        
        // Update profile image if available
        if let profileImagePath = user.profile_image_path {
            // Load image using a method, assuming you have a way to load images from path
            loadImage(from: profileImagePath)
        } else {
            // Set default profile image or handle accordingly
            profileImageView.image = UIImage(named: "profile")
        }
    
    }

    private func loadImage(from path: String) {
    }
    
   
}
