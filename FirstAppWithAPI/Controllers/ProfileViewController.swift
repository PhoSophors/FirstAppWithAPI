import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    private lazy var profileView: ProfileView = {
        let view = ProfileView()
        view.backgroundColor = .white
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Profile"
        
        setupProfileView()
    }
    
    private func setupProfileView() {
        view.addSubview(profileView)
        
        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // Handle logout action
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
    func profileViewDidTapLogout() {
        handleLogout()
    }
}
