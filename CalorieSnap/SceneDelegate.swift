//
//  SceneDelegate.swift
//  CalorieSnap
//
//  Created by Zewei Dai on 12/3/24.
//
//
import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let initialViewController: UIViewController
        
        if Auth.auth().currentUser != nil {
            initialViewController = HomeViewController()
        } else {
            initialViewController = LoginViewController()
        }
        
        let navigationController = UINavigationController(rootViewController: initialViewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Handle scene disconnection
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Handle scene becoming active
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Handle scene going inactive
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Handle scene transitioning to the foreground
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Handle scene transitioning to the background
    }
}
