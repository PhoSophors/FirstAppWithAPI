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

        AuthManager.shared.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.navigateToMainScreen()
                case .failure(let error):
                    self.showErrorMessage(message: "Login failed: \(error.localizedDescription)")
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
}
