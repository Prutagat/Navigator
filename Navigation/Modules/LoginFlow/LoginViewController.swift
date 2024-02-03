
import UIKit

class LoginViewController: UIViewController {
    
    let coordinator: LoginCoordinator
    var loginDelegate: LoginViewControllerDelegate?
    var workItem: DispatchWorkItem?
    
    // MARK: - Subviews
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
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

    private var mailTextFields = CustomTextField(placeholderText: "Mail", text: "a.v.golovanov@icloud.com" )
    private var passwordTextFields = CustomTextField(placeholderText: "Password", text: "Ghbdtn1324", isSecureTextEntry: true)
    private lazy var loginButton = CustomButton(title: "Login In", cornerRadius: 10) { [weak self] in
        self?.logIn()
    }
    private lazy var signUpButton = CustomButton(title: "Sing Up", cornerRadius: 10) { [weak self] in
        self?.signUp()
    }
    private lazy var choosePasswordButton = CustomButton(title: "Choose Password", cornerRadius: 10) {  [weak self] in
        self?.choosePassword()
    }
    private lazy var openMapButton = CustomButton(title: "Open Map", cornerRadius: 10) { [weak self] in
        self?.coordinator.presentMapViewController()
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
    
    @objc private func passwordChanged() {
        choosePasswordButton.isHidden = !passwordTextFields.text!.isEmpty
        loginButton.isEnabled = !passwordTextFields.text!.isEmpty
        signUpButton.isEnabled = !passwordTextFields.text!.isEmpty
    }
    
    // MARK: - Private
        
    private func setupView() {
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .black)
        mailTextFields.delegate = self
        passwordTextFields.delegate = self
        title = "Authorization window".localized
        
        passwordTextFields.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(logoImageView)
        contentView.addSubview(authorizationFields)
        contentView.addSubview(loginButton)
        contentView.addSubview(signUpButton)
        contentView.addSubview(choosePasswordButton)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(openMapButton)
        choosePasswordButton.isHidden = true
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
            
            loginButton.topAnchor.constraint(equalTo: authorizationFields.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            
            choosePasswordButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 16),
            choosePasswordButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            choosePasswordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            choosePasswordButton.heightAnchor.constraint(equalToConstant: 50),
            choosePasswordButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: passwordTextFields.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: passwordTextFields.centerYAnchor),
            
            openMapButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 16),
            openMapButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            openMapButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            openMapButton.heightAnchor.constraint(equalToConstant: 50),
            openMapButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
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

    private func logIn() {
        let login = mailTextFields.text!
        let password = passwordTextFields.text!
        
        loginDelegate?.checkCredentials(email: login, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                guard let profileUser = CurrentUserService().getUser() else { return }
                profileUser.name = user.name.isEmpty ? profileUser.name : user.name
                profileUser.status = user.email
                self?.coordinator.showTabBarController(user: profileUser)
            case .failure(let failure):
                let textError: String
                switch failure {
                case let .custom(text):
                    textError = text
                case .notAuthorized:
                    textError = "the user is not logged in"
                }
                self?.coordinator.presentAlert(title: "Error", message: textError)
                self?.loginButton.isEnabled = false
            }
        }
    }
    
    private func signUp() {
        let login = mailTextFields.text!
        let password = passwordTextFields.text!
        
        loginDelegate?.signUp(email: login, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                guard let profileUser = CurrentUserService().getUser() else { return }
                profileUser.name = user.name.isEmpty ? profileUser.name : user.name
                profileUser.status = user.email
                self?.coordinator.showTabBarController(user: profileUser)
                self?.coordinator.presentAlert(title: "Successfully", message: "You are registered")
            case .failure(let failure):
                let textError: String
                switch failure {
                case let .custom(text):
                    textError = text
                case .notAuthorized:
                    textError = "The user is not logged in"
                }
                self?.coordinator.presentAlert(title: "Error", message: textError)
                self?.signUpButton.isEnabled = false
            }
        }
    }
    
    private func choosePassword() {
        workItem?.cancel()
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let passwordToUnlock = String((0..<4).map { _ in letters.randomElement()! })
        activityIndicator.startAnimating()
        choosePasswordButton.isEnabled = false
        
        let choosePassword = DispatchWorkItem {
            let correctPassword = ChoosePasswordService.shared.bruteForce(passwordToUnlock: passwordToUnlock)
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                self?.passwordTextFields.text = correctPassword
                self?.passwordTextFields.isSecureTextEntry = false
                self?.activityIndicator.stopAnimating()
                self?.choosePasswordButton.isEnabled = true
            }
        }
        
        workItem = choosePassword
        DispatchQueue.global().async(execute: choosePassword)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

protocol LoginViewControllerDelegate: CheckerServiceProtocol {
    func check(login: String, password: String) -> UserOld?
}

struct LoginInspector: LoginViewControllerDelegate {
    func check(login: String, password: String) -> UserOld? {
        
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
