
import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Subviews
    
    private let profileHeaderView = ProfileHeaderView()
    
    private let tableView: UITableView =  {
        let tableView = UITableView.init()
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
        view.addSubview(profileHeaderView)
        view.addSubview(tableView)
        
    }
    
    private func setupTable() {
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.id)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            profileHeaderView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            profileHeaderView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            profileHeaderView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            profileHeaderView.heightAnchor.constraint(equalToConstant:220),
            
            tableView.topAnchor.constraint(equalTo: profileHeaderView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
        ])
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.id, for: indexPath) as? PostTableViewCell
        else { return UITableViewCell() }
        let post = dataSource[indexPath.row]
        cell.configure(with: post)
        return cell
    }
    
}
