
import UIKit

class ProfileHeaderView: UIView {
    
    private let imageProfilePicture: UIImageView = {
        let image = UIImage(named: "profile picture")
        let imageView = UIImageView(image: image!)
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
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
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var buttonShowStatus: UIButton = {
        let button = UIButton()
        button.setTitle("Показать статус", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4.0
        button.layer.shadowOpacity = 0.7
        
        button.addTarget(
            self,
            action: #selector(buttonPressed),
            for: .touchUpInside)
        
        return button
    }()
    
    private lazy var textFieldNewStatus: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 12
        textField.placeholder = "Введите статус"
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 40))
        textField.leftViewMode = .always

        textField.addTarget(
            self,
            action: #selector(statusTextChanged),
            for: .editingChanged)
        
        return textField
    }()
    
    @objc func buttonPressed() {
        labelStatus.text = statusText
        print("Текущий статус: \(labelStatus.text ?? "")")
    }
    
    private var statusText: String = ""
    
    @objc func statusTextChanged(_ textField: UITextField) {
        statusText = textField.text ?? ""
    }
    
    private func setupContraints() {
        addSubview(imageProfilePicture)
        addSubview(labelName)
        addSubview(labelStatus)
        addSubview(buttonShowStatus)
        addSubview(textFieldNewStatus)
            
        NSLayoutConstraint.activate([
            imageProfilePicture.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            imageProfilePicture.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageProfilePicture.widthAnchor.constraint(equalToConstant: 100),
            imageProfilePicture.heightAnchor.constraint(equalToConstant: 100),
            
            labelName.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 27),
            labelName.leadingAnchor.constraint(equalTo: imageProfilePicture.trailingAnchor, constant: 16),
            labelName.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            buttonShowStatus.topAnchor.constraint(equalTo: imageProfilePicture.bottomAnchor, constant: 16),
            buttonShowStatus.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            buttonShowStatus.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            buttonShowStatus.heightAnchor.constraint(equalToConstant: 50),
            
            textFieldNewStatus.bottomAnchor.constraint(equalTo: buttonShowStatus.topAnchor, constant: -16),
            textFieldNewStatus.leadingAnchor.constraint(equalTo: imageProfilePicture.trailingAnchor, constant: 16),
            textFieldNewStatus.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textFieldNewStatus.heightAnchor.constraint(equalToConstant: 40),
            
            labelStatus.bottomAnchor.constraint(equalTo: textFieldNewStatus.topAnchor, constant: -10),
            labelStatus.leadingAnchor.constraint(equalTo: imageProfilePicture.trailingAnchor, constant: 16),
            labelStatus.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
