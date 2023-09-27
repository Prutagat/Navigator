//
//  SceneDelegate.swift
//  Navigation
//
//  Created by Алексей Голованов on 03.05.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var coordinator: AppCoordinator?
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
//        let appConfiguration: AppConfiguration = AppConfiguration.people(URL(string: "https://swapi.dev/api/people/5")!)
//        let appConfiguration: AppConfiguration = AppConfiguration.starships(URL(string: "https://swapi.dev/api/starships/3"
        let appConfiguration: AppConfiguration = AppConfiguration.films(URL(string: "https://swapi.dev/api/films/1")!)
        NetworkService(appConfiguration: appConfiguration)
        
        let navigationController = UINavigationController()
        let tabBarController = UITabBarController()
        coordinator = AppCoordinator(navigationController: navigationController, tabBarController: tabBarController)
        coordinator?.start()
        
        let window = UIWindow(windowScene: scene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}
