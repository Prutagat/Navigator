//
//  UserService.swift
//  Navigation
//
//  Created by Алексей Голованов on 03.07.2023.
//

import UIKit

class UserOld {
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
    var user: UserOld { get }
    func getUser(login: String, password: String) -> UserOld?
}

extension UserService {
    func getUser(login: String, password: String) -> UserOld? {
        return login == user.login && password == user.password ? user : nil
    }
    func getUser() -> UserOld? {
        return user
    }
}

class CurrentUserService: UserService {
    let user = UserOld(
        login: "Duck",
        password: "",
        name: "Скрудж Макдак",
        avatar: UIImage(named: "Profile_picture") ?? nil,
        status: "Безумно можно быть уткой"
    )
}

class TestUserService: UserService {
    let user = UserOld(
        login: "admin",
        password: "",
        name: "Админ",
        avatar: UIImage(named: "logo") ?? nil,
        status: "Тестовый профиль"
    )
}
