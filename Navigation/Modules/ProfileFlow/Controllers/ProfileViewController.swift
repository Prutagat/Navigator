
import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Subviews
    
    static var tableView: UITableView =  {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var dataSource = PostModel.makeDataSource()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addSubviews()
        setupTable()
        setupConstraints()
    }
    
    // MARK: - Private
    
    private func setupView() {
        title = "Профиль"
        view.backgroundColor = .systemGray4
    }
    
    private func addSubviews() {
        view.addSubview(Self.tableView)
        
    }
    
    private func setupTable() {
        Self.tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.id)
        Self.tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.id)
        Self.tableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: "ProfileHeaderView")
        Self.tableView.delegate = self
        Self.tableView.dataSource = self
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            Self.tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            Self.tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            Self.tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            Self.tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
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
            return dataSource.count
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
        
        let post = dataSource[indexPath.row]
        cell.configure(with: post)
        
        return cell
    }
    
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: "ProfileHeaderView")
                as? ProfileHeaderView else {return UITableViewCell()}
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
            let nextViewController = PhotosViewController()
            navigationController?.navigationBar.isHidden = false
            navigationController?.pushViewController(
                nextViewController,
                animated: true
            )
        }
    }
}
