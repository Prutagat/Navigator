//
//  UserService.swift
//  Navigation
//
//  Created by Алексей Голованов on 03.07.2023.
//

import UIKit

class User {
    var login: String
    var name: String
    var avatar: UIImage?
    var status: String
    
    init(login: String, name: String, avatar: UIImage?, status: String) {
        self.login = login
        self.name = name
        self.avatar = avatar
        self.status = status
    }
}

protocol UserService {
    var user: User { get }
    func getUser(login: String) -> User?
}

extension UserService {
    func getUser(login: String) -> User? {
        return login == user.login ? user : nil
    }
}

class CurrentUserService: UserService {
    let user = User(
        login: "Duck",
        name: "Скрудж Макдак",
        avatar: UIImage(named: "Profile_picture") ?? nil,
        status: "Безумно можно быть уткой"
    )
}

class TestUserService: UserService {
    let user = User(
        login: "admin",
        name: "Админ",
        avatar: UIImage(named: "logo") ?? nil,
        status: "Тестовый профиль"
    )
}
