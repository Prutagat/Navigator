//
//  LoginCoordinator.swift
//  Navigation
//
//  Created by Алексей Голованов on 30.08.2023.
//

import UIKit

final class LoginCoordinator: Coordinatable {
    var navigationController: UINavigationController
    private(set) var childCoordinators: [Coordinatable] = []
    private let parentCoordinator: Coordinatable
    
    init(navigationController: UINavigationController, parentCoordinator: Coordinatable) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        parentCoordinator.addChildCoordinator(self)
    }
    
    func addChildCoordinator(_ coordinator: Coordinatable) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinatable) {
        childCoordinators = childCoordinators.filter { $0 === coordinator }
    }
    
    func start() {
        let viewController = LoginViewCoordinator(coordinator: self)
        viewController.loginDelegate = MyLoginFactory().makeLoginInspector()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showTabBarController(user: User) {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController, parentCoordinator: self, user: user)
        tabBarCoordinator.start()
    }
}
