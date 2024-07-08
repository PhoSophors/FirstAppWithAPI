import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    private lazy var profileView: ProfileView = {
        let view = ProfileView()
        view.backgroundColor = .systemGray6
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        setupProfileView()
        fetchUserInfo()
    }
    
    private func setupProfileView() {
        view.addSubview(profileView)
        
        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func fetchUserInfo() {
        // Fetch user info from your data source
        AuthService.shared.fetchUserInfo { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self?.profileView.update(with: user)
                }
            case .failure(let error):
                print("Failed to fetch user info: \(error)")
                // Handle error display or retry logic if needed
            }
        }
    }
    
    private func handleLogout() {
        let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
            // Clear login state and Core Data
            AuthManager.shared.logout()
            
            // Dismiss current view controller
            self.dismiss(animated: true, completion: nil)
            
            // Present the login screen again
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.showLoginScreen()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension ProfileViewController: ProfileViewDelegate {
    func profileViewDidTapEdit() {
        // Handle edit button tap, possibly presenting an edit profile screen
    }
    
    func profileViewDidTapLogout() {
        handleLogout()
    }
}
