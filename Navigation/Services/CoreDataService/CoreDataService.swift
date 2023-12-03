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

protocol BackgroundCoreDataServiceProtocol {
    func backgroundSavePost(post: PostModel, completion: @escaping (Bool) -> Void)
    func backgroundFetchPosts(format: String, value: CVarArg, completion: @escaping ([PostModel]) -> Void)
    func backgroundRemovePost(post: PostModel, completion: @escaping (Bool) -> Void)
    func backgroundUpdatePost(post: PostModel, completion: @escaping (Bool) -> Void)
}

final class CoreDataService {
    static let shared = CoreDataService()
    
    private lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context.persistentStoreCoordinator = appDelegate.persistentContainer.persistentStoreCoordinator
        return context
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
            _ = removePost(post: post)
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
    
extension CoreDataService: BackgroundCoreDataServiceProtocol {
    
    func backgroundSavePost(post: PostModel, completion: @escaping (Bool) -> Void) {
        backgroundContext.perform { [weak self] in
            guard let self else {
                completion(false)
                return
            }
            
            self.backgroundFetchPosts(format: "postId == %@", value: post.postId) { result in
                if result.isEmpty {
                    let model = PostModelCoreData(context: self.backgroundContext)
                    model.postId = post.postId
                    model.favorite = !post.favorite
                    model.author = post.author
                    model.nameImage = post.nameImage
                    model.postDescription = post.postDescription
                    model.likes = post.likes
                    model.views = post.views
                    
                    do {
                        try self.backgroundContext.save()
                        self.context.perform {
                            completion(true)
                        }
                    } catch {
                        print(error.localizedDescription)
                        self.context.perform {
                            completion(false)
                        }
                    }
                    
                    guard self.backgroundContext.hasChanges else {
                        self.context.perform {
                            completion(false)
                        }
                        return
                    }
                } else {
                    self.backgroundUpdatePost(post: post) { result in
                        self.context.perform {
                            completion(result)
                        }
                    }
                }
            }
        }
    }
    
    func backgroundFetchPosts(format: String = "", value: CVarArg = false, completion: @escaping ([PostModel]) -> Void) {
        backgroundContext.perform { [weak self] in
            guard let self else {
                completion([])
                return
            }
            
            let fetchRequest: NSFetchRequest<PostModelCoreData> = PostModelCoreData.fetchRequest()
            
            if !format.isEmpty {
                fetchRequest.predicate = NSPredicate(format: format, value)
            }
            
            do {
                var postsModels: [PostModel] = []
                let postsModelCoreData: [PostModelCoreData] = try self.backgroundContext.fetch(fetchRequest)
                postsModelCoreData.forEach({postsModels.append(PostModel(postModelCoreData: $0)) })
                self.context.perform {
                    completion(postsModels)
                }
            } catch {
                print(error.localizedDescription)
                self.context.perform {
                    completion([])
                }
            }
        }
    }
    
    func backgroundRemovePost(post: PostModel, completion: @escaping (Bool) -> Void) {
        backgroundContext.perform { [weak self] in
            guard let self else {
                completion(false)
                return
            }
            
            let fetchRequest: NSFetchRequest<PostModelCoreData> = PostModelCoreData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "postId == %@", post.postId)
            
            do {
                let postsModelCoreData: [PostModelCoreData] = try self.backgroundContext.fetch(fetchRequest)
                postsModelCoreData.forEach({self.backgroundContext.delete($0)})
                try self.backgroundContext.save()
                self.context.perform {
                    completion(true)
                }
            } catch {
                print(error.localizedDescription)
                self.context.perform {
                    completion(false)
                }
            }
        }
    }
    
    func backgroundUpdatePost(post: PostModel, completion: @escaping (Bool) -> Void) {
        backgroundContext.perform { [weak self] in
            guard let self else {
                completion(false)
                return
            }
            
            let fetchRequest: NSFetchRequest<PostModelCoreData> = PostModelCoreData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "postId == %@", post.postId)
            
            do {
                let postsModelCoreData: [PostModelCoreData] = try self.backgroundContext.fetch(fetchRequest)
                postsModelCoreData.forEach({
                    $0.favorite = !post.favorite
                    $0.author = post.author
                    $0.postDescription = post.postDescription
                    $0.nameImage = post.nameImage
                    $0.likes = post.likes
                    $0.views = post.views
                })
                try self.backgroundContext.save()
                self.context.perform {
                    completion(true)
                }
            } catch {
                print(error.localizedDescription)
                self.context.perform {
                    completion(false)
                }
            }
        }
    }
}
