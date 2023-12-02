//
//  PostModel.swift
//  Navigation
//
//  Created by Алексей Голованов on 16.11.2023.
//

import Foundation

struct PostModel {
    let postId: String
    var favorite: Bool
    var author: String
    var postDescription: String
    var nameImage: String
    var likes: Int64
    var views: Int64
    
    init(postId: String, favorite: Bool, author: String, postDescription: String, nameImage: String, likes: Int64, views: Int64) {
        self.postId = postId
        self.favorite = favorite
        self.author = author
        self.postDescription = postDescription
        self.nameImage = nameImage
        self.likes = likes
        self.views = views
    }
    
    init(postModelCoreData: PostModelCoreData) {
        self.postId = postModelCoreData.postId ?? ""
        self.favorite = postModelCoreData.favorite
        self.author = postModelCoreData.author ?? ""
        self.postDescription = postModelCoreData.postDescription ?? ""
        self.nameImage = postModelCoreData.nameImage ?? ""
        self.likes = postModelCoreData.likes
        self.views = postModelCoreData.views
    }
}

extension PostModel {
    public static func makePosts() -> [PostModel] {
        let coreDataService = CoreDataService.shared
        
        let posts = [
            PostModel(
                postId: "1",
                favorite: false,
                author: "Дональд Дак",
                postDescription: "Дядя Билли, Вилли и Дилли. Отдал детей на воспитание скруджу, так как сам занят и не может с ними сидеть.",
                nameImage: "Donald",
                likes: 537,
                views: 4021
            ),
            PostModel(
                postId: "2",
                favorite: false,
                author: "Билли. Храбрее утки пожалуй не найти.",
                postDescription: "Лидер трио, и самый смелый из трех братьев. Обычно он делает так, что планы Вилли в очереди, и Дилли не попадает в беду. Носит красную одежду.",
                nameImage: "Huey",
                likes: 133,
                views: 829
            ),
            PostModel(
                postId: "3",
                favorite: false,
                author: "Вилли. Умнейший из троих.",
                postDescription: "Умный брат, и он также очень хорошо организован. Обычно он придумывает планы. Носит синюю одежду.",
                nameImage: "Dewey",
                likes: 154,
                views: 1013
            ),
            PostModel(
                postId: "4",
                favorite: false,
                author: "Дилли. Добрая душа.",
                postDescription: "Самый добрый из группы, и очень непринужденный, беззаботный и нежный. Он также очень креативен. Носит зеленую одежду.",
                nameImage: "Louie",
                likes: 75,
                views: 1213
            )
        ]
        
        posts.forEach {
            coreDataService.backgroundSavePost(post: $0) { result in print(result)}
        }
        
        return posts
    }
}
