//
//  LocalAuthorizationService.swift
//  Navigation
//
//  Created by Алексей Голованов on 06.04.2024.
//

import UIKit
import LocalAuthentication

enum BiometricType {
    case none
    case touch
    case face
    case opticID
}

final class LocalAuthorizationService {
    
    static let shared = LocalAuthorizationService()
    let context = LAContext()
    var error: NSError?
    var policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics
    
    func type() -> BiometricType {
        let _ = context.canEvaluatePolicy(policy, error: nil)
                switch(context.biometryType) {
                case .none:
                    return .none
                case .touchID:
                    return .touch
                case .faceID:
                    return .face
                case .opticID:
                    return .opticID
                @unknown default:
                    return .none
                }
    }
    
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool) -> Void) {
        var isBiometryEvaluated = context.canEvaluatePolicy(policy, error: &error)
        if let error {
            print (error.localizedDescription)
            authorizationFinished(isBiometryEvaluated)
        }
        
        context.evaluatePolicy(policy, localizedReason: "Проверка биометрии") { isSuccess, error in
            if let error {
                    print("Выдайте разрешение на проверку беометрии, \(error.localizedDescription)")
                    return
            }
            
            DispatchQueue.main.async {
                authorizationFinished(isSuccess)
            }
        }
    }
    
    func authorizeIfPossible(_ authorizationFinished: @escaping (Result<Bool, NSError>) -> Void) {
        var isBiometryEvaluated = context.canEvaluatePolicy(policy, error: &error)
        if let error {
            print (error.localizedDescription)
            authorizationFinished(.failure(error))
        }
        
        context.evaluatePolicy(policy, localizedReason: "Проверка биометрии") { isSuccess, error in
            if let error {
                print("Выдайте разрешение на проверку беометрии, \(error.localizedDescription)")
                authorizationFinished(.failure(error as NSError))
            }
            
            DispatchQueue.main.async {
                authorizationFinished(.success(isSuccess))
            }
        }
    }
}

extension LocalAuthorizationService: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
