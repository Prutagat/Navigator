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
    func getUser(login: String) -> User?
}

class CurrentUserService: UserService {
    let user = User(
        login: "Duck",
        name: "Скрудж Макдак",
        avatar: UIImage(named: "Profile_picture") ?? nil,
        status: "Безумно можно быть уткой"
    )
    func getUser(login: String) -> User? {
        var currentUser: User?
        if login == "Duck" {
            currentUser = user
        }
        return currentUser
    }
}

class TestUserService: UserService {
    let user = User(
        login: "admin",
        name: "Админ",
        avatar: UIImage(named: "logo") ?? nil,
        status: "Тестовый профиль"
    )
    func getUser(login: String) -> User? {
        var testUser: User?
        if login == "admin" {
            testUser = user
        }
        return testUser
    }
}
