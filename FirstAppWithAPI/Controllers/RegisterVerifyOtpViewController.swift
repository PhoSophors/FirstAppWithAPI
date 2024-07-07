import UIKit
import SnapKit

class RegisterVerifyOtpViewController: UIViewController, UITextFieldDelegate {

    private var otpTextFields = [UITextField]()
    private let numberOfFields = 4
    private var userEmail: String // Property to store user's email

    init(userEmail: String) {
        self.userEmail = userEmail
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let otpMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Verify your email"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor.systemBlue
        label.textAlignment = .center
        return label
    }()

    let codeHereLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter code here"
        label.textColor = UIColor.systemBlue
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupViews()
    }

    private func setupViews() {
        view.addSubview(otpMessageLabel)
        otpMessageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }

        view.addSubview(codeHereLabel)
        codeHereLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(otpMessageLabel.snp.bottom).offset(10)
        }

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10.0
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(codeHereLabel.snp.bottom).offset(20)
            make.width.equalTo(250)
            make.height.equalTo(50)
        }

        for index in 0..<numberOfFields {
            let textField = createOTPTextField(tag: index)
            otpTextFields.append(textField)
            stackView.addArrangedSubview(textField)
        }

        // Focus the first OTP text field initially
        otpTextFields.first?.becomeFirstResponder()
    }

    private func createOTPTextField(tag: Int) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 24)
        textField.keyboardType = .numberPad
        textField.delegate = self
        textField.tag = tag // Set tag for navigation
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true

        // Add target to handle text change
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        return textField
    }

    // MARK: - UITextFieldDelegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Allow only numeric input and limit to 1 character
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)

        // Check if deleting
        if string.isEmpty {
            return true // allow deletion
        }

        return allowedCharacters.isSuperset(of: characterSet) && textField.text!.count < 1
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }

        // Move to the next text field if the current one is filled
        if text.count >= 1 {
            if let nextTextField = otpTextFields.first(where: { $0.tag == textField.tag + 1 }) {
                nextTextField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
                verifyOTP()
            }
        } else {
            // Handle auto-delete when navigating backwards
            if let previousTextField = otpTextFields.first(where: { $0.tag == textField.tag - 1 }) {
                previousTextField.becomeFirstResponder()
            }
        }

        // Clear text if it exceeds one character (to handle pasting)
        if text.count > 1 {
            textField.text = String(text.prefix(1))
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss keyboard on return key press
        textField.resignFirstResponder()
        return true
    }

    // MARK: - OTP Verification

    private func verifyOTP() {
        guard let otpCode = getOTPFromFields() else {
            displayErrorMessage("Please enter the OTP code.")
            return
        }

        AuthService.shared.verifyOTP(email: userEmail, otpCode: otpCode) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    print("OTP verification success: \(message)")
                    // Handle successful OTP verification, navigate to main screen or perform necessary actions
                    self?.navigateToMainScreen()

                case .failure(let error):
                    print("OTP verification failed: \(error.localizedDescription)")
                    self?.handleOTPVerificationFailure(error)
                }
            }
        }
    }

    
    private func handleOTPVerificationFailure(_ error: Error) {
        var errorMessage = "OTP verification failed. Please try again later."

        if let apiError = error as? APIError {
            switch apiError {
            case .invalidOTP:
                errorMessage = "Invalid OTP code. Please check your code and try again."
            case .networkError:
                errorMessage = "Network error. Please check your internet connection and try again."
            }
        }

        displayErrorMessage(errorMessage)
    }

    private func displayErrorMessage(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    

    private func getOTPFromFields() -> String? {
        var otpCode = ""
        for textField in otpTextFields {
            guard let text = textField.text, !text.isEmpty else {
                return nil // If any field is empty, return nil
            }
            otpCode += text
        }
        return otpCode
    }

    // Navigate to Main Screen on successful login
    private func navigateToMainScreen() {
        let mainViewController = MainViewController()
        navigationController?.setViewControllers([mainViewController], animated: true)
    }

}
