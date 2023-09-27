//
//  UserService.swift
//  Navigation
//
//  Created by Алексей Голованов on 03.07.2023.
//

import UIKit

class User {
    var login: String
    var password: String
    var name: String
    var avatar: UIImage?
    var status: String
    
    init(login: String, password: String, name: String, avatar: UIImage?, status: String) {
        self.login = login
        self.password = password
        self.name = name
        self.avatar = avatar
        self.status = status
    }
}

protocol UserService {
    var user: User { get }
    func getUser(login: String, password: String) -> User?
}

extension UserService {
    func getUser(login: String, password: String) -> User? {
        return login == user.login && password == user.password ? user : nil
    }
}

class CurrentUserService: UserService {
    let user = User(
        login: "Duck",
        password: "",
        name: "Скрудж Макдак",
        avatar: UIImage(named: "Profile_picture") ?? nil,
        status: "Безумно можно быть уткой"
    )
}

class TestUserService: UserService {
    let user = User(
        login: "admin",
        password: "",
        name: "Админ",
        avatar: UIImage(named: "logo") ?? nil,
        status: "Тестовый профиль"
    )
}
