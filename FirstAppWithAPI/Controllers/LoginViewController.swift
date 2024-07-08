import UIKit

class LoginViewController: UIViewController {

    private let loginView = LoginView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(loginView)
        setupConstraints()

        // Check if user is already logged in
        if AuthManager.shared.isLoggedIn {
            navigateToMainScreen()
        }

        // Add targets for buttons and labels
        loginView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)

        // Observe label tap notifications
        NotificationCenter.default.addObserver(self, selector: #selector(handleForgetPasswordLabelTap), name: .forgetPasswordLabelTapped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRegisterLabelTap), name: .registerLabelTapped, object: nil)

        // Observe keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        // Remove observers
        NotificationCenter.default.removeObserver(self)
    }

    private func setupConstraints() {
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // Login Button Action
    @objc private func loginButtonTapped() {
        guard let email = loginView.emailTextField.text, !email.isEmpty,
              let password = loginView.passwordTextField.text, !password.isEmpty else {
            // Show error message for empty fields
            showErrorMessage(message: "Please enter both email and password.")
            return
        }

        AuthManager.shared.login(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.navigateToMainScreen()
                case .failure(let error):
                    var errorMessage = "Login failed: "
                    switch error {
                    case LoginError.emailNotFound:
                        errorMessage += "Email not found. Please check your email."
                    case LoginError.incorrectPassword:
                        errorMessage += "Incorrect password. Please try again."
                    case let LoginError.invalidCredentials(message):
                        errorMessage += message
                    default:
                        errorMessage += "An unexpected error occurred. Please try again later."
                    }
                    self.showErrorMessage(message: errorMessage)
                }
            }
        }
    }



    // Navigate to Main Screen on successful login
    private func navigateToMainScreen() {
        let mainViewController = MainViewController()
        navigationController?.setViewControllers([mainViewController], animated: true)
    }

    // Show error message function
    private func showErrorMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    // Handle Forget Password Label Tap
    @objc private func handleForgetPasswordLabelTap() {
        let forgetPasswordVC = ForgetPasswordViewController()
        navigationController?.pushViewController(forgetPasswordVC, animated: true)
    }

    // Handle Register Label Tap
    @objc private func handleRegisterLabelTap() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }

    // Keyboard notification handlers
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            loginView.scrollView.contentInset.bottom = keyboardHeight
            loginView.scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        loginView.scrollView.contentInset.bottom = 0
        loginView.scrollView.verticalScrollIndicatorInsets.bottom = 0
    }

}
