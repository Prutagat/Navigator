
import UIKit
import SnapKit

class InfoViewController: UIViewController {

    let coordinator: FeedCoordinator
    var residents: [Resident] = []
    
    private lazy var actionButton = CustomButton(title: "Inform", cornerRadius: 10) { [weak self] in
        self?.coordinator.present(.attention("Quack quack quack"))
    }
    private let taskFirst: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.clipsToBounds = true
        lable.numberOfLines = 3
        return lable
    }()
    private let taskSecond: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.clipsToBounds = true
        lable.numberOfLines = 3
        return lable
    }()
    private lazy var taskThird: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    init(coordinator: FeedCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTitle()
        getOrbitalPeriod()
        getResidents()
        view.backgroundColor = .systemGray4
        view.addSubview(actionButton)
        view.addSubview(taskFirst)
        view.addSubview(taskSecond)
        view.addSubview(taskThird)
        
        actionButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-130)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(44)
        }
        taskFirst.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(actionButton.snp.top).offset(-16)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(44)
        }
        taskSecond.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(taskFirst.snp.top).offset(-16)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(44)
        }
        taskThird.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(taskSecond.snp.top).offset(-16)
        }
    }
    
    func getTitle() {
        NetworkService.requestUser(id: Int.random(in: 1..<51)) { [weak self] name in
            self?.taskFirst.text = "Задание".localized + " 1: \(name)"
        }
    }
    
    func getOrbitalPeriod() {
        NetworkService.requestPlanet(id: Int.random(in: 1..<6)) { [weak self] planet in
            self?.taskSecond.text = "Задание".localized + " 2: Период вращения планеты \(planet.name) вокруг своей звезды - \(planet.rotationPeriod)"
        }
    }
    
    func getResidents() {
        NetworkService.requestPlanet(id: 1) { [weak self] planet in
            for resident in planet.residents {
                NetworkService.requestResident(url: resident) { residentName in
                    self?.residents.append(Resident(name: residentName, URL: resident))
                    self?.taskThird.reloadData()
                }
            }
        }
    }
}

extension InfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        residents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        var content: UIListContentConfiguration = cell.defaultContentConfiguration()
        content.text = residents[indexPath.row].name
        content.secondaryText = residents[indexPath.row].URL
        cell.contentConfiguration = content
        return cell
    }
}

extension InfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
