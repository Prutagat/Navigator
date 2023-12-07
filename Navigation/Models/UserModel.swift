//
//  UserModel.swift
//  Navigation
//
//  Created by Алексей Голованов on 02.10.2023.
//

import Firebase

final class UserModel {
    let email: String
    let name: String
    
    init(user: User) {
        self.email = user.email ?? ""
        self.name = user.displayName ?? ""
    }
}
