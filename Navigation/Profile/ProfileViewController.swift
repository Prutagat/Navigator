
import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Subviews
    
    private let profileHeaderView = ProfileHeaderView()
    
    private let tableView: UITableView =  {
        let tableView = UITableView.init()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var dataSource: [PostModel] = [
        PostModel(
            author: "Дональд Дак",
            description: "Дядя Билли, Вилли и Дилли. Отдал детей на воспитание скруджу, так как сам занят и не может с ними сидеть.",
            image: "Donald",
            likes: 537,
            views: 4021),
        PostModel(
            author: "Билли. Храбрее утки пожалуй не найти.",
            description: "Лидер трио, и самый смелый из трех братьев. Обычно он делает так, что планы Вилли в очереди, и Дилли не попадает в беду. Носит красную одежду.",
            image: "Huey",
            likes: 133,
            views: 829),
        PostModel(
            author: "Вилли. Умнейший из троих.",
            description: "Умный брат, и он также очень хорошо организован. Обычно он придумывает планы. Носит синюю одежду.",
            image: "Dewey",
            likes: 154,
            views: 1013),
        PostModel(
            author: "Дилли. Добрая душа.",
            description: "Самый добрый из группы, и очень непринужденный, беззаботный и нежный. Он также очень креативен. Носит зеленую одежду.",
            image: "Louie",
            likes: 75,
            views: 1213),
    ]
   
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
