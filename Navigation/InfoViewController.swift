
import UIKit

class InfoViewController: UIViewController {

    private lazy var actionButton: UIButton = {
           let button = UIButton()
           button.translatesAutoresizingMaskIntoConstraints = false
           button.setTitle("Открыть", for: .normal)
           button.setTitleColor(.systemBlue, for: .normal)
           
           return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemMint
        
        view.addSubview(actionButton)
        
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: 20.0
            ),
            actionButton.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -20.0
            ),
            actionButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 44.0)
        ])
        
        actionButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Внимание", message: "Кря кря кря", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "Кря (в консоль)", style: .default) { (action) in
           print("Кря кря")
        }
        let cancelBtn = UIAlertAction(title: "Бред", style: .cancel)
        alertController.addAction(okBtn)
        alertController.addAction(cancelBtn)
        
        present(alertController, animated: true)
    }
    
}
