//
//  TabBarController.swift
//  Navigation
//
//  Created by Алексей Голованов on 05.06.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    var feedNavigationController : UINavigationController!
    var profileNavigationController : UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        let logInViewController = LogInViewController()
        logInViewController.loginDelegate = MyLoginFactory().makeLoginInspector()
        profileNavigationController = UINavigationController.init(rootViewController: logInViewController)
        feedNavigationController = UINavigationController.init(rootViewController: FeedViewController(viewModel: FeedViewModel()))
        
        self.viewControllers = [
            feedNavigationController,
            profileNavigationController
        ]
        
        feedNavigationController.tabBarItem = UITabBarItem(
            title: "Лента",
            image: UIImage(systemName: "newspaper"),
            tag: 0)
        profileNavigationController.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person"),
            tag: 1)
    }
    
}
