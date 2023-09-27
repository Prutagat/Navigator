//
//  TabBarCoordinator.swift
//  Navigation
//
//  Created by Алексей Голованов on 31.08.2023.
//

import UIKit

final class TabBarCoordinator: Coordinatable {
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
    
    func addChildCoordinator(_ coordinator: Coordinatable) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinatable) {
        childCoordinators = childCoordinators.filter { $0 === coordinator }
    }
    
    func start() {
        let tabBarController = UITabBarController()
        let feedCoordinator = FeedCoordinator(navigationController: UINavigationController(), parentCoordinator: self)
        feedCoordinator.start()
        let profileCoordinator = ProfileCoordinator(navigationController: UINavigationController(), parentCoordinator: self, user: user)
        profileCoordinator.start()
        tabBarController.viewControllers = [feedCoordinator.navigationController, profileCoordinator.navigationController]
        navigationController.pushViewController(tabBarController, animated: true)
    }
}
