
import UIKit
import StorageService

class PostViewController: UIViewController {
   
    let coordinator: FeedCoordinator
    var post: Post = Post(title: "")
    
    init(coordinator: FeedCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .black)
        title = post.title
        let button = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(buttonPressed(_:)))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        coordinator.present(.info)
    }
}
