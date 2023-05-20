
import UIKit

class FeedViewController: UIViewController {
    
    private lazy var firstActionButton: UIButton = {
       let button = UIButton()
    
       button.translatesAutoresizingMaskIntoConstraints = false
       button.setTitle("Кнопка 1", for: .normal)
       button.setTitleColor(.systemBlue, for: .normal)
       
       return button
    }()
    
    private lazy var secondActionButton: UIButton = {
       let button = UIButton()
    
       button.translatesAutoresizingMaskIntoConstraints = false
       button.setTitle("Кнопка 2", for: .normal)
       button.setTitleColor(.systemBlue, for: .normal)
       
       return button
    }()
    
    private lazy var stackView: UIStackView = { [unowned self] in
        let stackView = UIStackView()
            
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.clipsToBounds = true
            
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
                
        stackView.addArrangedSubview(self.firstActionButton)
        stackView.addArrangedSubview(self.secondActionButton)
            
        return stackView
    }()
    
    private func setupUI() {
        
        firstActionButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        secondActionButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
        
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        let postViewController = PostViewController()
        postViewController.post = Post(title: "Переопределенный")
        
        postViewController.modalTransitionStyle = .flipHorizontal
        postViewController.modalPresentationStyle = .fullScreen
        
        navigationController?.pushViewController(postViewController, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(stackView)
        
        setupUI()
        
    }

}
