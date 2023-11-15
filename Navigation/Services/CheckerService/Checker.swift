//
//  Checker.swift
//  Navigation
//
//  Created by Алексей Голованов on 13.07.2023.
//

import UIKit

final class Checker {
    
    static let shared = Checker()
    
    #if DEBUG
        private let login = "Duck"
    #else
        private let login = "admin"
    #endif
    private let password = ""
    
    private init() {}
    
    func check(login: String, password: String) -> Bool {
        if login == self.login && password == self.password {
            return true
        } else {
            return false
        }
    }
    
}

extension Checker: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
