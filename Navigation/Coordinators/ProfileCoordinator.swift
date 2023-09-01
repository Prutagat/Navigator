//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Алексей Голованов on 30.08.2023.
//

import UIKit

final class ProfileCoordinator: Coordinatable {
    
    var navigationController: UINavigationController
    private(set) var childCoordinators: [Coordinatable] = []
    private let parentCoordinator: Coordinatable
    private let user: User
    
    init(navigationController: UINavigationController, parentCoordinator: Coordinatable, user: User) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.user = user
        parentCoordinator.addChildCoordinator(self)
    }
    
    func start() {
        let viewController = ProfileViewController(user: user)
        navigationController.setViewControllers([viewController], animated: true)
        navigationController.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person"),
            tag: 1)
    }
}
