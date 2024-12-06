//
//  MainTabBarController.swift
//  CalorieSnap
//
//  Created by Steph on 6/12/2024.
//
import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVC = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)

        let profileDetailsVC = ProfileDetailsViewController()
        let profileNav = UINavigationController(rootViewController: profileDetailsVC)
        profileNav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 1)

        let chatVC = UIViewController()
        chatVC.view.backgroundColor = .white
        let chatNav = UINavigationController(rootViewController: chatVC)
        chatNav.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "message"), tag: 2)

        self.viewControllers = [homeNav, profileNav, chatNav]

        self.tabBar.tintColor = .systemBlue
        self.tabBar.unselectedItemTintColor = .gray
        self.tabBar.backgroundColor = .white
    }
}
