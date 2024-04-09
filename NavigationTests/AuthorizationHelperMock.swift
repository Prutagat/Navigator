//
//  AuthorizationHelperMock.swift
//  NavigationTests
//
//  Created by Алексей Голованов on 27.03.2024.
//

@testable import Navigation

class AuthorizationHelperMock: AuthorizationHelper {
    
    var resultAutorization: ((String) -> ())?
    var resultChoosePassword: ((String) -> ())?
    
    func showController(user: Navigation.UserOld) {
        resultAutorization?("correct")
    }
    
    func showAlert(isError: Bool, title: String, message: String) {
        resultAutorization?(message)
    }
    
    func startChoosePassword() {
        print("start choose password")
    }
    
    func stopChoosePassword(correctPassword: String) {
        print("stop choose password")
        resultChoosePassword?(correctPassword)
    }
}
