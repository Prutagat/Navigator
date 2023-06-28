
import UIKit

class PostViewController: UIViewController {
   
    var post: Post = Post(title: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        title = post.title
        let button = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(buttonPressed(_:)))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        let infoViewController = InfoViewController()
        infoViewController.modalTransitionStyle = .coverVertical
        infoViewController.modalPresentationStyle = .pageSheet
        present(infoViewController, animated: true)
    }
}
