import UIKit
import SnapKit

protocol ProfileViewDelegate: AnyObject {
    func profileViewDidTapLogout()
}

class ProfileView: UIView {
    
    weak var delegate: ProfileViewDelegate?
    
    // UI elements
    let formBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.shared.IVORY()
        view.layer.cornerRadius = 30
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 5
        return view
    }()
    
    let personIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .black // Customize as needed
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black // Customize as needed
        return label
    }()
    
    lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue // Customize as needed
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 17)
        ]
        let attributedTitle = NSAttributedString(string: "Sign Out", attributes: attributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
        
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
        addSubview(formBackgroundView)
        formBackgroundView.addSubview(personIconImageView)
        formBackgroundView.addSubview(emailLabel)
        formBackgroundView.addSubview(logoutButton)
        
        // Setup constraints for formBackgroundView using SnapKit
        formBackgroundView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Setup constraints for personIconImageView
        personIconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        // Setup constraints for emailLabel
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(personIconImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualTo(formBackgroundView).offset(20)
            make.trailing.lessThanOrEqualTo(formBackgroundView).offset(-20)
        }
        
        // Setup constraints for logoutButton
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(40)
            make.bottom.equalTo(formBackgroundView).offset(-20)
        }
    }

    // Logout button action
    @objc private func logoutButtonTapped() {
        delegate?.profileViewDidTapLogout()
    }
}
