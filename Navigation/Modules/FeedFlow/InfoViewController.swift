
import UIKit
import SnapKit

class InfoViewController: UIViewController {

    let coordinator: FeedCoordinator
    
    private lazy var actionButton = CustomButton(title: "Открыть", cornerRadius: 10) { [weak self] in
        self?.coordinator.present(.attention)
    }
    
    init(coordinator: FeedCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        view.addSubview(actionButton)
        
        actionButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(44)
        }
    }
}
