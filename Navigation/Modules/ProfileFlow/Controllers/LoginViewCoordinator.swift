
import UIKit

class LoginViewCoordinator: UIViewController {
    
    let coordinator: LoginCoordinator
    var loginDelegate: LoginViewControllerDelegate?
    
    // MARK: - Subviews
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var mailTextFields = CustomTextField(placeholderText: "Почта", text: "Duck" )
    private var passwordTextFields = CustomTextField(placeholderText: "Пароль", isSecureTextEntry: true)
    private lazy var logInButton = CustomButton(title: "Войти", cornerRadius: 10) { [weak self] in
        self?.logIn()
    }
    
    private lazy var authorizationFields: UIStackView = { [unowned self] in
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.clipsToBounds = true
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.borderWidth = 0.5
        stackView.layer.cornerRadius = 10
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.addArrangedSubview(mailTextFields)
        stackView.addArrangedSubview(passwordTextFields)
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    // MARK: - Actions
    
    @objc func willShowKeyboard(_ notification: NSNotification) {
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        scrollView.contentInset.bottom = keyboardHeight ?? 0.0
    }
    
    @objc func willHideKeyboard(_ notification: NSNotification) {
        scrollView.contentInset.bottom = 0.0
    }
    
    // MARK: - Private
        
    private func setupView() {
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        mailTextFields.delegate = self
        passwordTextFields.delegate = self
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(logoImageView)
        contentView.addSubview(authorizationFields)
        contentView.addSubview(logInButton)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
             
            authorizationFields.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            authorizationFields.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            authorizationFields.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            authorizationFields.heightAnchor.constraint(equalToConstant: 100),
            
            logInButton.topAnchor.constraint(equalTo: authorizationFields.bottomAnchor, constant: 16),
            logInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            logInButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willShowKeyboard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willHideKeyboard(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    private func presentError() {
        let alertController = UIAlertController(title: "Ошибка", message: "Введен некорректный логин и (или) пароль", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "Понял", style: .default)
        alertController.addAction(okBtn)
        present(alertController, animated: true)
    }

    private func logIn() {
        
        let login = mailTextFields.text!
        let password = passwordTextFields.text!
        
        guard let userIsCorrect = loginDelegate?.check(login: login, password: password) else { return presentError() }
        coordinator.showTabBarController(user: userIsCorrect)
    }
}

extension LoginViewCoordinator: UITextFieldDelegate {
    
    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

protocol LoginViewControllerDelegate {
    func check(login: String, password: String) -> User?
}

struct LoginInspector: LoginViewControllerDelegate {
    func check(login: String, password: String) -> User? {
        
        let userIsCorrect = Checker.shared.check(login: login, password: password)
        
        if userIsCorrect {
            #if DEBUG
                let user = CurrentUserService().getUser(login: login, password: password)
            #else
                let user = TestUserService().getUser(login: login, password: password)
            #endif

            if let userAutorized = user {
                return userAutorized
            }
        }
        return nil
    }
}

protocol LoginFactory {
    func makeLoginInspector() -> LoginInspector
}

struct MyLoginFactory: LoginFactory {
    func makeLoginInspector() -> LoginInspector {
        return LoginInspector()
    }
}
