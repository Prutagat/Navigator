//
//  FavoritePostsViewController.swift
//  Navigation
//
//  Created by Алексей Голованов on 15.11.2023.
//

import UIKit
import SnapKit
import CoreData

final class FavoritePostsViewController: UIViewController {
    
    let coordinator: FavoritePostsCoordinator
    private var coreDataService = CoreDataService.shared
    private var fetchedResultsController: NSFetchedResultsController<PostModelCoreData>!
    
    
    // MARK: - Subviews
    
    private var postsTableView: UITableView =  {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(coordinator: FavoritePostsCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.title = "Понравившиеся посты"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTable()
        configureFetchedResultsController()
        getPosts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getPosts()
    }
    
    // MARK: - Action
    
    @objc func byDefault(_ sender: UIBarButtonItem ) {
        configureFetchedResultsController()
        getPosts()
    }
    
    @objc func findAuthor(_ sender: UIBarButtonItem ) {
        coordinator.findAuthor { [weak self] result in
            guard let self else { return }
            self.configureFetchedResultsController(format: "author CONTAINS %@", value: result)
            self.getPosts()
        }
    }
    
    // MARK: - Private
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItems = getRightBarButtonItems()
    }
    
    private func getRightBarButtonItems() -> [UIBarButtonItem] {
        let byDefault = UIBarButtonItem(image: UIImage(systemName: "person.slash.fill"), style: .plain, target: self, action: #selector(byDefault(_:)))
        let findAuthor = UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .plain, target: self, action: #selector(findAuthor(_:)))
        return [byDefault, findAuthor]
    }
    
    private func setupTable() {
        view.addSubview(postsTableView)
        postsTableView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        postsTableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.id)
        postsTableView.delegate = self
        postsTableView.dataSource = self
    }
    
    private func configureFetchedResultsController(format: String = "favorite = %d", value: CVarArg = true) {
        let fetchRequest: NSFetchRequest<PostModelCoreData> = PostModelCoreData.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "postId", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: format, value)
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataService.context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
    }
    
    private func getPosts() {
        do {
            try fetchedResultsController.performFetch()
            postsTableView.reloadData()
        } catch {
            print("Error")
        }
    }
    
}

extension FavoritePostsViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PostTableViewCell.id,
            for: indexPath
        ) as? PostTableViewCell else {
            return UITableViewCell()
        }
        
        let post = fetchedResultsController.object(at: indexPath)
        cell.configure(with: post)
        return cell
    }
}

extension FavoritePostsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let post = fetchedResultsController.object(at: indexPath)
        var postModel = PostModel(postModelCoreData: post)
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _ in
            postModel.favorite = !postModel.favorite
            _ = self.coreDataService.updatePost(post: postModel)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension FavoritePostsViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        postsTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath else { return }
            postsTableView.insertRows(at: [newIndexPath], with: .left)
        case .delete:
            guard let indexPath else { return }
            postsTableView.deleteRows(at: [indexPath], with: .right)
        case .move:
            ()
        case .update:
            guard let indexPath else { return }
            postsTableView.reloadRows(at: [indexPath], with: .fade)
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        postsTableView.endUpdates()
    }
}
