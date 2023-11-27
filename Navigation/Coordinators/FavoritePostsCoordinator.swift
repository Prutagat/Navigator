//
//  FavoritePostsCoordinator.swift
//  Navigation
//
//  Created by Алексей Голованов on 15.11.2023.
//

import UIKit

final class FavoritePostsCoordinator: Coordinatable {
    
    var navigationController: UINavigationController
    private(set) var childCoordinators: [Coordinatable] = []
    private let parentCoordinator: Coordinatable
    
    init(navigationController: UINavigationController, parentCoordinator: Coordinatable) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        parentCoordinator.addChildCoordinator(self)
    }
    
    func start() {
        let viewController = FavoritePostsViewController(coordinator: self)
        navigationController.setViewControllers([viewController], animated: true)
        navigationController.tabBarItem = UITabBarItem(
            title: "Понравившиеся посты",
            image: UIImage(systemName: "star"),
            tag: 1)
    }
}
