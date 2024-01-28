//
//  VideoViewController.swift
//  Navigation
//
//  Created by Алексей Голованов on 25.09.2023.
//

import UIKit
import AVKit
import WebKit

struct Video {
    let name: String
    let URL: String
}

final class VideoViewController: UIViewController {
 
    let coordinator: FeedCoordinator
    private var videos: [Video] = []
    
    private lazy var tableView: UITableView = {
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
        view.backgroundColor = .systemGray4
        title = "Video Player".localized
        getVideos()
        setupUI()
    }
    
    private func getVideos() {
        videos.append(Video(name: "Утиные Истории - Возвращение На Клондайк", URL: "https://youtu.be/a9r8e8dn7Nc?si=uW33XZwuBkk-FIIF"))
        videos.append(Video(name: "Утиные Истории - Кряка-Трясение", URL: "https://youtu.be/8c3g5NDEGMA?si=AvCUBdCJxwI5F1li"))
        videos.append(Video(name: "Утиные Истории - Сладкоголосая Утка Юности", URL: "https://youtu.be/pWLvweij8mI?si=bSrPx-DgfmwozEP1"))
    }
                      
    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        self.tableView.reloadData()
    }
}

extension VideoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        var content: UIListContentConfiguration = cell.defaultContentConfiguration()
        content.text = videos[indexPath.row].name
        content.secondaryText = videos[indexPath.row].URL
        cell.contentConfiguration = content
        return cell
    }
}

extension VideoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = YoutubeVideoView(url: videos[indexPath.row].URL)
        present(controller, animated: true)
    }
}

class YoutubeVideoView: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    var url: String
    
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}

