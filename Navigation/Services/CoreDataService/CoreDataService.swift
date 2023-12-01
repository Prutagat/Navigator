//
//  CoreDataService.swift
//  Navigation
//
//  Created by Алексей Голованов on 15.11.2023.
//

import UIKit
import CoreData
import StorageService

protocol CoreDataServiceProtocol {
    func savePost(post: PostModel) -> Bool
    func fetchPosts(postId: String) -> [PostModel]
    func fetchPosts(favorite: Bool?) -> [PostModel]
    func removePost(post: PostModel) -> Bool
    func updatePost(post: PostModel) -> Bool
}

final class CoreDataService {
    static let shared = CoreDataService()
    
    private lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    private init() {}
    
}

extension CoreDataService: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}

extension CoreDataService: CoreDataServiceProtocol {
    
    func savePost(post: PostModel) -> Bool {
        if !fetchPosts(postId: post.postId).isEmpty {
            let result = removePost(post: post)
        }
        
        let model = PostModelCoreData(context: context)
        model.postId = post.postId
        model.favorite = !post.favorite
        model.author = post.author
        model.nameImage = post.nameImage
        model.postDescription = post.postDescription
        model.likes = post.likes
        model.views = post.views
        
        guard context.hasChanges else { return false }
        
        do {
            try context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func fetchPosts(postId: String) -> [PostModel] {
        let fetchRequest: NSFetchRequest<PostModelCoreData> = PostModelCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "postId == %@", postId)
        
        do {
            var postsModels: [PostModel] = []
            let postsModelCoreData: [PostModelCoreData] = try context.fetch(fetchRequest)
            postsModelCoreData.forEach({postsModels.append(PostModel(postModelCoreData: $0)) })
            return postsModels
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchPosts(favorite: Bool? = false) -> [PostModel] {
        let fetchRequest: NSFetchRequest<PostModelCoreData> = PostModelCoreData.fetchRequest()
        
        do {
            var postsModels: [PostModel] = []
            let postsModelCoreData: [PostModelCoreData] = try context.fetch(fetchRequest)
            postsModelCoreData.forEach {
                if let favoriteFilter = favorite {
                    if $0.favorite == favoriteFilter {
                        postsModels.append(PostModel(postModelCoreData: $0))
                    }
                } else {
                    postsModels.append(PostModel(postModelCoreData: $0))
                }
            }
            
            return postsModels
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func removePost(post: PostModel) -> Bool {
        let fetchRequest: NSFetchRequest<PostModelCoreData> = PostModelCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "postId == %@", post.postId)
        
        do {
            let postsModelCoreData: [PostModelCoreData] = try context.fetch(fetchRequest)
            postsModelCoreData.forEach({context.delete($0)})
            try context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func updatePost(post: PostModel) -> Bool {
        let fetchRequest: NSFetchRequest<PostModelCoreData> = PostModelCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "postId == %@", post.postId)
        
        do {
            let postsModelCoreData: [PostModelCoreData] = try context.fetch(fetchRequest)
            postsModelCoreData.forEach({
                $0.favorite = post.favorite
                $0.author = post.author
                $0.postDescription = post.postDescription
                $0.nameImage = post.nameImage
                $0.likes = post.likes
                $0.views = post.views
            })
            try context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
}
