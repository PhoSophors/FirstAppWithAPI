import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupTabBar()
    }

    private func setupTabBar() {
        // Create tab bar controller
        let tabBarController = UITabBarController()
        tabBarController.tabBar.barTintColor = .white
        tabBarController.tabBar.tintColor = .white
        tabBarController.tabBar.backgroundColor = ColorManager.shared.IVORY()
        
        // Create HomeViewController (embedded in a navigation controller)
        let homeVC = HomeViewController()
//        homeVC.title = "Home"
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), selectedImage: nil) // Adjust image as needed
        let homeNavVC = UINavigationController(rootViewController: homeVC)
        
        // Create ProfileViewController (embedded in a navigation controller)
        let profileVC = ProfileViewController()
//        profileVC.title = "Profile"
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle.fill"), selectedImage: nil) // Adjust image as needed
        let profileNavVC = UINavigationController(rootViewController: profileVC)
        
        // Assign view controllers to the tab bar controller
        tabBarController.viewControllers = [homeNavVC, profileNavVC]
        
        // Set tab bar controller as the child of MainViewController
        addChild(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.didMove(toParent: self)
        
        // Adjust tab bar frame to fit within view
        tabBarController.view.frame = view.bounds
    }

    // Add more functionality as needed
}

