
import UIKit

class ProfileHeaderView: UIView {
    
//    private let imageProfilePicture: UIImage = {
//        let image = UIImage(named: "profile picture")
//        
//        return image!
//    }()
    
    private let labelName: UILabel = {
        let label = UILabel()
        label.text = "Утка Уткович"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let labelStatus: UILabel = {
        let label = UILabel()
        label.text = "Ожидание..."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        
        return label
    }()
    
    private let buttonShowStatus: UIButton = {
        let button = UIButton()
        button.setTitle("Показать статус", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4.0
        button.layer.shadowOpacity = 0.7
        
        return button
    }()
    
    private func setupContraints() {
            
        NSLayoutConstraint.activate([
            labelName.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 27),
            labelName.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            labelName.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        addSubview(labelName)
        setupContraints()
        }
    
}
