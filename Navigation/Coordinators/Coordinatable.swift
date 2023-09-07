//
//  Coordinatable.swift
//  Navigation
//
//  Created by Алексей Голованов on 25.08.2023.
//

import UIKit

protocol Coordinatable: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinatable] { get }
    func addChildCoordinator(_ coordinator: Coordinatable)
    func removeChildCoordinator(_ coordinator: Coordinatable)
    func start()
}

extension Coordinatable {
    func addChildCoordinator(_ coordinator: Coordinatable) {}
    func removeChildCoordinator(_ coordinator: Coordinatable) {}
}
