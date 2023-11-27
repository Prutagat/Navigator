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
    private var posts: [PostModel]
    
    
    // MARK: - Subviews
    
    private var postTableView: UITableView =  {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(coordinator: FavoritePostsCoordinator) {
        self.coordinator = coordinator
        self.posts = coreDataService.fetchPosts(favorite: true)
        super.init(nibName: nil, bundle: nil)
        self.title = "Понравившиеся посты"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(postTableView)
        postTableView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        setupTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        posts = coreDataService.fetchPosts(favorite: true)
        postTableView.reloadData()
    }
    
    // MARK: - Private
    
    private func setupTable() {
        postTableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.id)
        postTableView.delegate = self
        postTableView.dataSource = self
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
    }
}
