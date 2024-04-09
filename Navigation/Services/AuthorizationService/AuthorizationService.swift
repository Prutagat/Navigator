//
//  AuthorizationService.swift
//  Navigation
//
//  Created by Алексей Голованов on 26.03.2024.
//

import Foundation

protocol AuthorizationHelper: AnyObject {
    func showController(user: UserOld)
    func showAlert(isError: Bool,title: String, message: String)
    func startChoosePassword()
    func stopChoosePassword(correctPassword: String)
}

class AuthorizationService {
    
    weak var authorizationHelper: AuthorizationHelper?
    var loginDelegate: LoginViewControllerDelegate?
    var workItem: DispatchWorkItem?
    
    func logIn(login: String, password: String) {
        
        loginDelegate?.checkCredentials(email: login, password: password) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                guard let profileUser = CurrentUserService().getUser() else { return }
                profileUser.name = user.name.isEmpty ? profileUser.name : user.name
                profileUser.status = user.email
                self.authorizationHelper?.showController(user: profileUser)
            case .failure(let failure):
                let textError: String
                switch failure {
                case let .custom(text):
                    textError = text
                case .notAuthorized:
                    textError = "the user is not logged in"
                }
                self.authorizationHelper?.showAlert(isError: true, title: "Error", message: textError)
            }
        }
    }
    
    func signUp(login: String, password: String) {
        
        loginDelegate?.signUp(email: login, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                guard let profileUser = CurrentUserService().getUser() else { return }
                profileUser.name = user.name.isEmpty ? profileUser.name : user.name
                profileUser.status = user.email
                self.authorizationHelper?.showController(user: profileUser)
                self.authorizationHelper?.showAlert(isError: false, title: "Successfully", message: "You are registered")
            case .failure(let failure):
                let textError: String
                switch failure {
                case let .custom(text):
                    textError = text
                case .notAuthorized:
                    textError = "The user is not logged in"
                }
                self.authorizationHelper?.showAlert(isError: true, title: "Error", message: textError)
            }
        }
    }
    
    func choosePassword(password: String = "") {
        workItem?.cancel()
        self.authorizationHelper?.startChoosePassword()
        let passwordToUnlock = password.isEmpty ? getRandomPassword() : password
        let choosePassword = DispatchWorkItem {
            let correctPassword = ChoosePasswordService.shared.bruteForce(passwordToUnlock: passwordToUnlock)
        DispatchQueue.main.async { [weak self] in
            self?.authorizationHelper?.stopChoosePassword(correctPassword: correctPassword) }
                }
        workItem = choosePassword
        DispatchQueue.global().async(execute: choosePassword)
    }

    func getRandomPassword() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<4).map { _ in letters.randomElement()! })
    }
}
