
import UIKit
import SnapKit

class ProfileHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - parametrs
    
    private var avatarOriginPoint = CGPoint()
    private var statusText: String = ""
    private var changeStatusTimer: Timer = Timer()
    
    // MARK: - Subviews
    
    private let avatarBackground: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .black)
        view.isHidden = true
        view.alpha = 0
        return view
    }()
    
    private let returnAvatarButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.backgroundColor = .clear
        button.contentMode = .scaleToFill
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var setStatusButton = CustomButton(title: "Set status", cornerRadius: 10) {  [weak self] in
        self?.setStatus()
    }
    
    private lazy var statusTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 12
        textField.clipsToBounds = true
        textField.placeholder = "Enter status".localized
        textField.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .black)
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // MARK: - Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubviews()
        addTargets()
        addGestures()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Actions
    
    @objc func buttonPressed() {
        statusLabel.text = statusText
        print("Текущий статус: \(statusText)")
    }
    
    @objc func statusTextChanged(_ textField: UITextField) {
        statusText = textField.text ?? "Wait...".localized
    }
    
    @objc private func didTapOnAvatar() {
        
        avatarImageView.isUserInteractionEnabled = false
        
        ProfileViewController.postTableView.isScrollEnabled = false
        ProfileViewController.postTableView.cellForRow(at: IndexPath(row: 0, section: 0))?.isUserInteractionEnabled = false
        
        avatarOriginPoint = avatarImageView.center
        let scale = UIScreen.main.bounds.width / avatarImageView.bounds.width
        
        UIView.animate(withDuration: 0.5) {
            self.avatarImageView.center = CGPoint(
                x: UIScreen.main.bounds.midX,
                y: UIScreen.main.bounds.midY - self.avatarOriginPoint.y
            )
            self.avatarImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.avatarImageView.layer.cornerRadius = 0
            self.avatarBackground.isHidden = false
            self.avatarBackground.alpha = 0.7
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.returnAvatarButton.alpha = 1
            }
        }
    }
    
    @objc private func returnAvatarToOrigin() {
        UIImageView.animate(withDuration: 0.5) {
                self.returnAvatarButton.alpha = 0
                self.avatarImageView.center = self.avatarOriginPoint
                self.avatarImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.width / 2
                self.avatarBackground.alpha = 0
        } completion: { _ in
            ProfileViewController.postTableView.isScrollEnabled = true
            ProfileViewController.postTableView.cellForRow(at: IndexPath(row: 0, section: 0))?.isUserInteractionEnabled = true
            self.avatarImageView.isUserInteractionEnabled = true
        }
    }
    
    // MARK: - Public
    
    public func setupUser(user: UserOld) {
        fullNameLabel.text = user.name
        statusLabel.text = user.status
        avatarImageView.image = user.avatar
    }
    
    // MARK: - Private
    
    private func addSubviews() {
        addSubview(fullNameLabel)
        addSubview(statusLabel)
        addSubview(setStatusButton)
        addSubview(statusTextField)
        addSubview(avatarBackground)
        addSubview(returnAvatarButton)
        addSubview(avatarImageView)
    }
    
    private func addTargets() {
        statusTextField.addTarget(
            self,
            action: #selector(statusTextChanged),
            for: .editingChanged
        )
        returnAvatarButton.addTarget(
            self,
            action: #selector(returnAvatarToOrigin),
            for: .touchUpInside
        )
    }
    
    private func addGestures() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapOnAvatar)
        )
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        avatarImageView.addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(16)
            make.width.height.equalTo(100)
        }
        fullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(27)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.trailing.equalTo(contentView).inset(16)
        }
        setStatusButton.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.height.equalTo(50)
        }
        statusTextField.snp.makeConstraints { make in
            make.bottom.equalTo(setStatusButton.snp.top).offset(-16)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.trailing.equalTo(contentView).inset(16)
            make.height.equalTo(40)
        }
        statusLabel.snp.makeConstraints { make in
            make.bottom.equalTo(statusTextField.snp.top).offset(-10)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.trailing.equalTo(contentView).inset(16)
        }
        returnAvatarButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func createTimer(statusText: String) {
        var changeTime = 3
        
        changeStatusTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            self?.setStatusButton.setTitle("The status will change after".localized + " \(changeTime). " + "Cancel?", for: .normal)
            changeTime -= 1
            
            if changeTime == 0 {
                self?.statusLabel.text = statusText
                self?.setStatusButton.setTitle("Set status".localized, for: .normal)
                timer.invalidate()
            }
        }
    }
    
    private func setStatus() {
        if changeStatusTimer.isValid {
            setStatusButton.setTitle("Set status".localized, for: .normal)
            changeStatusTimer.invalidate()
        } else {
            getStatus(textLabel: statusText) { [weak self] result in
                switch result {
                case .success(let success):
                    self?.createTimer(statusText: success)
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    }
    
    private func getStatus(textLabel: String,complection: @escaping (Result<String, ApiError>) -> Void) {
        if textLabel == "" {
            complection(.failure(.isEmpty))
        } else {
            complection(.success(textLabel))
        }
    }
    
    private func pushAlert(text: String) {
        
    }
}
