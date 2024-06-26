//
//  Post.swift
//  Navigation
//
//  Created by Алексей Голованов on 28.05.2023.
//

import UIKit

public struct OldPostModel {
    public var favorite: Bool
    public var author: String
    public var description: String
    public var image: String
    public var likes: Int
    public var views: Int
}

extension OldPostModel {
    
    public static func makeDataSource() -> [OldPostModel] {
        [
            OldPostModel(
                favorite: false,
                author: "Дональд Дак",
                description: "Дядя Билли, Вилли и Дилли. Отдал детей на воспитание скруджу, так как сам занят и не может с ними сидеть.",
                image: "Donald",
                likes: 537,
                views: 4021),
            OldPostModel(
                favorite: false,
                author: "Билли. Храбрее утки пожалуй не найти.",
                description: "Лидер трио, и самый смелый из трех братьев. Обычно он делает так, что планы Вилли в очереди, и Дилли не попадает в беду. Носит красную одежду.",
                image: "Huey",
                likes: 133,
                views: 829),
            OldPostModel(
                favorite: false,
                author: "Вилли. Умнейший из троих.",
                description: "Умный брат, и он также очень хорошо организован. Обычно он придумывает планы. Носит синюю одежду.",
                image: "Dewey",
                likes: 154,
                views: 1013),
            OldPostModel(
                favorite: false,
                author: "Дилли. Добрая душа.",
                description: "Самый добрый из группы, и очень непринужденный, беззаботный и нежный. Он также очень креативен. Носит зеленую одежду.",
                image: "Louie",
                likes: 75,
                views: 1213),
        ]
    }
}
