
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
   
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let initialViewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: initialViewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }


    func showLoginScreen() {
       guard let window = self.window else { return }
    
       let loginViewController = LoginViewController()
       let navigationController = UINavigationController(rootViewController: loginViewController)
       
       window.rootViewController = navigationController
   }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
      
    }

    func sceneWillResignActive(_ scene: UIScene) {
     
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
       
    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }


}

