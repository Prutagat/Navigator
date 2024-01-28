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
    private let user: UserOld
    
    init(navigationController: UINavigationController, parentCoordinator: Coordinatable, user: UserOld) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.user = user
        parentCoordinator.addChildCoordinator(self)
    }
    
    func start() {
        let viewController = ProfileViewController(coordinator: self, user: user)
        navigationController.setViewControllers([viewController], animated: true)
        navigationController.tabBarItem = UITabBarItem(
            title: "Profile".localized,
            image: UIImage(systemName: "person"),
            tag: 1)
    }
    
    func pushPhotos() {
        let nextViewController = PhotosViewController()
        navigationController.navigationBar.isHidden = false
        navigationController.pushViewController(
            nextViewController,
            animated: true
        )
    }
}
