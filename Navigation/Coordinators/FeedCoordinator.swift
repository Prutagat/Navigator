//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Алексей Голованов on 25.08.2023.
//

import UIKit

final class FeedCoordinator: Coordinatable {
    
    enum Presentation {
        case post
        case info
        case audio
        case video
        case voiceRecorder
        case autorized
        case error(ApiError)
        case attention(String)
    }
    
    var navigationController: UINavigationController
    private(set) var childCoordinators: [Coordinatable] = []
    private let parentCoordinator: Coordinatable
    
    init(navigationController: UINavigationController, parentCoordinator: Coordinatable) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        parentCoordinator.addChildCoordinator(self)
    }
    
    func start() {
        let viewController = FeedViewController(viewModel: FeedViewModel(), coordinator: self)
        navigationController.setViewControllers([viewController], animated: true)
        navigationController.tabBarItem = UITabBarItem(
            title: "Лента",
            image: UIImage(systemName: "newspaper"),
            tag: 0)
    }
    
    func present(_ presentation: Presentation) {
            switch presentation {
            case .post:
                let postViewController = PostViewController(coordinator: self)
                postViewController.post = Post(title: "Переопределенный")
                navigationController.pushViewController(postViewController, animated: true)
            case .info:
                let infoViewController = InfoViewController(coordinator: self)
                navigationController.present(infoViewController, animated: true, completion: nil)
            case .audio:
                let audioViewController = AudioViewController(coordinator: self)
                navigationController.pushViewController(audioViewController, animated: true)
            case .video:
                let videoViewController = VideoViewController(coordinator: self)
                navigationController.pushViewController(videoViewController, animated: true)
            case .voiceRecorder:
                let voiceRecorderViewController = VoiceRecorderViewController(coordinator: self)
                navigationController.pushViewController(voiceRecorderViewController, animated: true)
            case .autorized:
                let alertController = UIAlertController(title: "Внимание", message: "Пароль верный", preferredStyle: .alert)
                let okBtn = UIAlertAction(title: "ОК", style: .default)
                let cancelBtn = UIAlertAction(title: "Отмена", style: .cancel)
                alertController.addAction(okBtn)
                alertController.addAction(cancelBtn)
                navigationController.present(alertController, animated: true)
            case .error(let apiError):
                var message = ""
                switch apiError {
                case .isEmpty:
                    message = "Пустое поле, заполните!"
                case .unauthorized:
                    message = "Вы не угадали!"
                case .notFound:
                    message = "Не найден"
                }
                let alertController = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
                let okBtn = UIAlertAction(title: "ОК", style: .default)
                let cancelBtn = UIAlertAction(title: "Отмена", style: .cancel)
                alertController.addAction(okBtn)
                alertController.addAction(cancelBtn)
                navigationController.present(alertController, animated: true)
            case .attention(let message):
                let alertController = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
                let okBtn = UIAlertAction(title: "ОК", style: .default)
                let cancelBtn = UIAlertAction(title: "Отмена", style: .cancel)
                alertController.addAction(okBtn)
                alertController.addAction(cancelBtn)
                navigationController.present(alertController, animated: true)
            }
        }
}
