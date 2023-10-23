//
//  CheckerService.swift
//  Navigation
//
//  Created by Алексей Голованов on 02.10.2023.
//

import Foundation
import Firebase

enum FireBaseError: Error {
    case notAuthorized
    case custom(String)
}

protocol CheckerServiceProtocol {
    func checkCredentials(email: String, password: String, complection: @escaping (Result<UserModel, FireBaseError>) -> Void)
    func signUp(email: String, password: String, complection: @escaping (Result<UserModel, FireBaseError>) -> Void)
}

extension CheckerServiceProtocol {
    func checkCredentials(email: String, password: String, complection: @escaping (Result<UserModel, FireBaseError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard let userFire = authResult?.user else {
                complection(.failure(.notAuthorized))
                return
            }
            
            let user = UserModel(user: userFire)
            complection(.success(user))
        }
    }
    func signUp(email: String, password: String, complection: @escaping (Result<UserModel, FireBaseError>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error {
                complection(.failure(.custom(error.localizedDescription)))
                return
            }
            
            guard let userFire = authResult?.user else {
                complection(.failure(.notAuthorized))
                return
            }
            
            let user = UserModel(user: userFire)
            complection(.success(user))
        }
    }
}

final class CheckerService: CheckerServiceProtocol {
    
}
