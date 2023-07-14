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
        return login == self.login && password == self.password
    }
    
}

extension Checker: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
