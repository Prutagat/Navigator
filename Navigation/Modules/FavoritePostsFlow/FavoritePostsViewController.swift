//
//  FavoritePostsViewController.swift
//  Navigation
//
//  Created by Алексей Голованов on 15.11.2023.
//

import UIKit
import SnapKit

final class FavoritePostsViewController: UIViewController {
    
    let coordinator: FavoritePostsCoordinator
    private var coreDataService = CoreDataService.shared
    private var posts: [PostModel] = []
    
    
    // MARK: - Subviews
    
    private var postTableView: UITableView =  {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(coordinator: FavoritePostsCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.title = "Понравившиеся посты"
        getFavouritePosts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getFavouritePosts()
    }
    
    // MARK: - Action
    
    @objc func byDefault(_ sender: UIBarButtonItem ) {
        getFavouritePosts()
    }
    
    @objc func findAuthor(_ sender: UIBarButtonItem ) {
        coordinator.findAuthor { [weak self] result in
            guard let self else { return }
            self.coreDataService.backgroundFetchPosts(format: "author == %@", value: result) { result in
                self.posts = result
                self.postTableView.reloadData()
            }
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
        view.addSubview(postTableView)
        postTableView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        postTableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.id)
        postTableView.delegate = self
        postTableView.dataSource = self
    }
    
    private func getFavouritePosts() {
        self.coreDataService.backgroundFetchPosts(format: "favorite = %d", value: true) { [weak self] result in
            self?.posts = result
            self?.postTableView.reloadData()
        }
    }
    
}

extension FavoritePostsViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PostTableViewCell.id,
            for: indexPath
        ) as? PostTableViewCell else {
            return UITableViewCell()
        }
        
        let post = posts[indexPath.row]
        cell.configure(with: post)
        return cell
    }
}

extension FavoritePostsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let post = posts[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _ in
            self.coreDataService.backgroundUpdatePost(post: post) { result in
                if result {
                    self.postTableView.performBatchUpdates {
                        self.posts.remove(at: indexPath.row)
                        self.postTableView.deleteRows(at: [indexPath], with: .right)
                    }
                }
            }
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
