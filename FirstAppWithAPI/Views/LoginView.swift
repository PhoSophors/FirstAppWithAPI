import UIKit
import SnapKit

class LoginView: UIView {
    
    // UI components
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let loginImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "login")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .systemBlue
        label.textAlignment = .left
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter email"
        textField.borderStyle = .none
        textField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        textField.textColor = .black
        textField.layer.cornerRadius = 15
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.shadowRadius = 5
        textField.keyboardType = .emailAddress
        
        // Capture self weakly to avoid retain cycle
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        
        let placeholderView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = placeholderView
        textField.leftViewMode = .always
        return textField
    }()

    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Password"
        textField.borderStyle = .none
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        textField.textColor = .black
        textField.layer.cornerRadius = 15
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.layer.shadowRadius = 5
        
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        
        let placeholderView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = placeholderView
        textField.leftViewMode = .always
        
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        eyeButton.setImage(UIImage(systemName: "eye"), for: .selected)
        eyeButton.tintColor = .lightGray
        eyeButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        eyeButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        textField.rightView = eyeButton
        textField.rightViewMode = .always
        
        return textField
    }()
    
    let forgetPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Forget password"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .systemBlue
        label.textAlignment = .left
        return label
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 15
        return button
    }()
    
    let registerLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account? Register"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }()
    
    // Constraint references
    var profileImageViewHeightConstraint: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupGestureRecognizers()
    }
    
    // MARK: - Private Functions
    
    private func setupView() {
        backgroundColor = .white
        
        // Add subviews
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(loginImageView)
        contentView.addSubview(welcomeLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(forgetPasswordLabel)
        contentView.addSubview(loginButton)
        contentView.addSubview(registerLabel)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        loginImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(200)
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(loginImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        forgetPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(forgetPasswordLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        registerLabel.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func setupGestureRecognizers() {
        let forgetPasswordTapGesture = UITapGestureRecognizer(target: self, action: #selector(forgetPasswordLabelTapped))
        forgetPasswordLabel.addGestureRecognizer(forgetPasswordTapGesture)
        
        let registerTapGesture = UITapGestureRecognizer(target: self, action: #selector(registerLabelTapped))
        registerLabel.addGestureRecognizer(registerTapGesture)
        
        // Enable user interaction for labels
        forgetPasswordLabel.isUserInteractionEnabled = true
        registerLabel.isUserInteractionEnabled = true
    }
    
    @objc private func forgetPasswordLabelTapped() {
        // Navigate to ForgetPasswordViewController
        NotificationCenter.default.post(name: .forgetPasswordLabelTapped, object: nil)
    }
    
    @objc private func registerLabelTapped() {
        // Navigate to RegisterViewController
        NotificationCenter.default.post(name: .registerLabelTapped, object: nil)
    }
    
    @objc private func togglePasswordVisibility(sender: UIButton) {
        sender.isSelected.toggle() // Toggle button state
        passwordTextField.isSecureTextEntry.toggle() // Toggle password visibility
    }
    
    @objc private func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    @objc private func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    // Method to show the profileImageView
    func showProfileImageView() {
        profileImageViewHeightConstraint?.update(offset: 150) // Set the desired height
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}

// Notification Names
extension Notification.Name {
    static let forgetPasswordLabelTapped = Notification.Name("forgetPasswordLabelTapped")
    static let registerLabelTapped = Notification.Name("registerLabelTapped")
}
