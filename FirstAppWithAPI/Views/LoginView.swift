import UIKit

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
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter email"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter password"
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
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 5
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
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(forgetPasswordLabel)
        contentView.addSubview(loginButton)
        contentView.addSubview(registerLabel)
        
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
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        forgetPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(forgetPasswordLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        registerLabel.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
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
}

// Notification Names
extension Notification.Name {
    static let forgetPasswordLabelTapped = Notification.Name("forgetPasswordLabelTapped")
    static let registerLabelTapped = Notification.Name("registerLabelTapped")
}
