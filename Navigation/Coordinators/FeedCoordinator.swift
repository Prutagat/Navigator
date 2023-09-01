//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Алексей Голованов on 25.08.2023.
//

import UIKit

final class FeedCoordinator: Coordinatable {
    
    var navigationController: UINavigationController
    private(set) var childCoordinators: [Coordinatable] = []
    private let parentCoordinator: Coordinatable
    
    init(navigationController: UINavigationController, parentCoordinator: Coordinatable) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        parentCoordinator.addChildCoordinator(self)
    }
    
    func start() {
        let viewController = FeedViewController(viewModel: FeedViewModel())
        navigationController.setViewControllers([viewController], animated: true)
        navigationController.tabBarItem = UITabBarItem(
            title: "Лента",
            image: UIImage(systemName: "newspaper"),
            tag: 0)
    }
}
