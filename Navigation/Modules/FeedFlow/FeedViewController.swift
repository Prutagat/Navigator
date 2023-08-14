
import UIKit
import SnapKit

class FeedViewController: UIViewController {
    
    private let viewModel: FeedViewModel
    
    private lazy var firstActionButton = CustomButton(title: "Кнопка 1", cornerRadius: 10) { [weak self] in
        self?.viewModel.changeAction(.pushAction)
    }
    private lazy var secondActionButton = CustomButton(title: "Кнопка 2", cornerRadius: 10) { [weak self] in
        self?.viewModel.changeAction(.pushAction)
    }
    private lazy var checkGuessButton = CustomButton(title: "Проверить", cornerRadius: 10) { [weak self] in
        self?.viewModel.checkWord = (self?.passwordTextField.text)!
        self?.viewModel.changeAction(.checkWordAtion)
    }
    private var passwordTextField = CustomTextField(placeholderText: "Пароль", text: "Donald")
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private var statusLabel: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.clipsToBounds = true
        lable.text = "Корректно"
        return lable
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
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.stateChanged = { [weak self] state in
            switch state {
            case .pushButtonAction:
                self?.pushViewController()
            case .checkWordButtonAction(let word):
                self?.checkWord(word: word)
            case .none:
                ()
            }
        }
    }
    
    private func layout() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        title = "Лента"
        view.backgroundColor = .systemGray4
        view.addSubview(stackView)
        view.addSubview(statusLabel)
        view.addSubview(passwordTextField)
        view.addSubview(checkGuessButton)
        view.addSubview(activityIndicator)
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(80)
        }
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(16)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
        }
        checkGuessButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.height.equalTo(35)
        }
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func pushViewController() {
        let postViewController = PostViewController()
        postViewController.post = Post(title: "Переопределенный")
        postViewController.modalTransitionStyle = .flipHorizontal
        postViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(postViewController, animated: true)
    }
    
    private func checkWord(word: String) {
        let isCorrect = FeedModel().check(word: word)
        let alertController = UIAlertController(title: "Внимание", message: isCorrect ? "Пароль верный":"Пароль не верный", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "ОК", style: .default)
        let cancelBtn = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(okBtn)
        alertController.addAction(cancelBtn)
        present(alertController, animated: true)
        statusLabel.textColor = isCorrect ? .green : .red
        statusLabel.text = isCorrect ? "Верно" : "Не верно"
    }
}
