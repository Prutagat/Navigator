
import UIKit
import StorageService

class ProfileViewController: UIViewController {
    
    // MARK: - parametrs
    
    var coordinator: ProfileCoordinator
    private var coreDataService = CoreDataService.shared
    private var user: UserOld
    private var posts: [PostModel]
    
    
    // MARK: - Subviews
    
    static var postTableView: UITableView =  {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupTable()
        setupConstraints()
    }
    
    init(coordinator: ProfileCoordinator, user: UserOld) {
        self.coordinator = coordinator
        self.user = user
        self.posts = coreDataService.fetchPosts(favorite: nil)
        if posts.count != 4 {
            self.posts = PostModel.makePosts()
        }
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupView() {
        title = "Профиль"
        #if DEBUG
            view.backgroundColor = .systemGray4
        #else
            view.backgroundColor = .blue
        #endif
    }
    
    private func addSubviews() {
        view.addSubview(Self.postTableView)
        
    }
    
    private func setupTable() {
        Self.postTableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.id)
        Self.postTableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.id)
        Self.postTableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: "ProfileHeaderView")
        Self.postTableView.delegate = self
        Self.postTableView.dataSource = self
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            Self.postTableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            Self.postTableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            Self.postTableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            Self.postTableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
        ])
    }
    
}

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return posts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PhotosTableViewCell.id,
                for: indexPath
            ) as? PhotosTableViewCell else {
                fatalError("could not dequeueReusableCell")
            }

            return cell
        }
        
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

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: "ProfileHeaderView")
                as? ProfileHeaderView else {return UITableViewCell()}
        headerView.setupUser(user: user)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 220
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            coordinator.pushPhotos()
        }
    }
}
