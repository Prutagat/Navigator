
import UIKit
import StorageService
import MobileCoreServices

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
        self.posts = coreDataService.fetchPosts()
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
        title = "Profile".localized
        #if DEBUG
            view.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .black)
        #else
            view.backgroundColor = UIColor.createColor(lightMode: .blue, darkMode: .blue)
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
        Self.postTableView.dragDelegate = self
        Self.postTableView.dropDelegate = self
        Self.postTableView.dragInteractionEnabled = true
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

extension ProfileViewController: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: any UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let post = posts[indexPath.row]
        let description = post.postDescription
        let image = UIImage(named: post.nameImage)!
        
        let descriptionProvider = NSItemProvider(object: description as NSItemProviderWriting)
        let imageProvider = NSItemProvider(object: image)
        
        return [UIDragItem(itemProvider: descriptionProvider), UIDragItem(itemProvider: imageProvider)]
    }
    
}
    
extension ProfileViewController: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, canHandle session: any UIDropSession) -> Bool {
        session.canLoadObjects(ofClass: UIImage.self) && session.canLoadObjects(ofClass: NSString.self)
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: any UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        var dropProposal = UITableViewDropProposal(operation: .copy)
        guard session.items.count == 1 else { return dropProposal }
        
        if tableView.hasActiveDrag {
            if tableView.isEditing {
                dropProposal = UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
        } else {
            dropProposal = UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
        
        return dropProposal
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: any UITableViewDropCoordinator) {
        
        var description = ""
        var postImage = UIImage()
        
        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            guard let strings = items as? [String] else { return }
            
            for (index, string) in strings.enumerated() {
                description = string
                return
            }
        }
        
        coordinator.session.loadObjects(ofClass: UIImage.self) { items in
            guard let images = items as? [UIImage] else { return }
            
            var indexPaths = [IndexPath]()
            
            for (index, image) in images.enumerated() {
                postImage = image
            }
        }
        
        DispatchQueue.main.async {
            self.posts.append(PostModel(postId: "6", favorite: false, author: "Drag&Drop", postDescription: description, nameImage: "Donald", likes: 0, views: 0))
            tableView.reloadData()
        }
    }
}
