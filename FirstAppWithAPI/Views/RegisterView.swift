import UIKit

class RegisterView: UIView {
    
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
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Account"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }()
    
    let fullnameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Fullname"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Email"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    
    let forgetPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Forget password"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Signup", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 5
        return button
    }()
    
    let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Have an account? Login"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }()
    
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
    
    private func setupView() {
        backgroundColor = .white
        
        // Add subviews
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(welcomeLabel)
        contentView.addSubview(fullnameTextField)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(confirmPasswordTextField)
        contentView.addSubview(forgetPasswordLabel)
        contentView.addSubview(registerButton)
        contentView.addSubview(loginLabel)
        
        // Setup constraints using SnapKit
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview() // Match content width to scroll view width
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
        }
        
        fullnameTextField.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(fullnameTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        forgetPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(forgetPasswordLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func setupGestureRecognizers() {
        let forgetPasswordTapGesture = UITapGestureRecognizer(target: self, action: #selector(forgetPasswordLabelTapped))
        forgetPasswordLabel.addGestureRecognizer(forgetPasswordTapGesture)
        
        let registerTapGesture = UITapGestureRecognizer(target: self, action: #selector(loginLabelTapped))
//        loginLabel.addGestureRecognizer(loginTapGesbture)
        
        // Enable user interaction for labels
        forgetPasswordLabel.isUserInteractionEnabled = true
        loginLabel.isUserInteractionEnabled = true
    }
    
    @objc private func forgetPasswordLabelTapped() {
        // Navigate to ForgetPasswordViewController
        NotificationCenter.default.post(name: .forgetPasswordLabelTapped, object: nil)
    }
    
    @objc private func loginLabelTapped() {
        // Navigate to LoginViewController
        NotificationCenter.default.post(name: .loginLabelTapped, object: nil)
    }
}

// Notification Names
extension Notification.Name {
//    static let forgetPasswordLabelTapped = Notification.Name("forgetPasswordLabelTapped")
    static let loginLabelTapped = Notification.Name("loginLabelTapped")
}
