//
//  AppCoordinator.swift
//  Navigation
//
//  Created by Алексей Голованов on 25.08.2023.
//

import UIKit

final class AppCoordinator: Coordinatable {
    var navigationController: UINavigationController
    var tabBarController: UITabBarController
    private(set) var childCoordinators: [Coordinatable] = []

    init(navigationController: UINavigationController, tabBarController: UITabBarController) {
        self.navigationController = navigationController
        self.tabBarController = tabBarController
    }
    
    func addChildCoordinator(_ coordinator: Coordinatable) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinatable) {
        childCoordinators = childCoordinators.filter { $0 === coordinator }
    }
    
    func start() {
        
        let isAuth = false
        
        if !isAuth {
            showLoginFlow()
        } else {
//            showMainFlow()
        }
    }
    
    private func showLoginFlow() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController, parentCoordinator: self)
        loginCoordinator.start()
    }
    
    private func showMainFlow() {
    }
}
