import UIKit
import SnapKit

class RegisterViewController: UIViewController {
    private let registerView = RegisterView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(registerView)
        setupConstraints()

        registerView.registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        registerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc private func registerButtonTapped() {
        guard
            let fullname = registerView.fullnameTextField.text, !fullname.isEmpty,
            let email = registerView.emailTextField.text, !email.isEmpty,
            let password = registerView.passwordTextField.text, !password.isEmpty,
            let confirmPassword = registerView.confirmPasswordTextField.text, !confirmPassword.isEmpty
        else {
            showErrorMessage(message: "Please enter fullname, email, password, and confirm password.")
            return
        }

        AuthManager.shared.register(full_name: fullname, email: email, password: password, password_confirmation: confirmPassword) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    print("Registration success: \(message)")
                    self?.navigateToRegisterVerifyOtp(with: email)
                case .failure(let error):
                    if let error = error as? NSError {
                        if error.domain == "", error.code == 422 {
                            self?.handleValidationErrors(from: error)
                        } else {
                            self?.showErrorMessage(message: "Registration failed: \(error.localizedDescription)")
                        }
                    } else {
                        self?.showErrorMessage(message: "Registration failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    private func handleValidationErrors(from error: NSError) {
        guard let data = error.userInfo[NSLocalizedDescriptionKey] as? Data else {
            showErrorMessage(message: "Validation error occurred, but details not available.")
            return
        }

        do {
            let decoder = JSONDecoder()
            let registerResponse = try decoder.decode(RegisterResponse.self, from: data)

            if let passwordErrors = registerResponse.data?.password {
                let errorMessage = passwordErrors.joined(separator: "\n")
                showErrorMessage(message: errorMessage)
            } else {
                showErrorMessage(message: "Validation error occurred, but details not available.")
            }
        } catch {
            showErrorMessage(message: "Failed to parse validation error details: \(error.localizedDescription)")
        }
    }

    private func showErrorMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    private func navigateToRegisterVerifyOtp(with email: String) {
        let registerVerifyOtpViewController = RegisterVerifyOtpViewController(userEmail: email)
        navigationController?.pushViewController(registerVerifyOtpViewController, animated: true)
    }
}
