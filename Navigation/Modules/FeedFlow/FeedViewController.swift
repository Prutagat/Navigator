
import UIKit

class FeedViewController: UIViewController {
    
    let coordinator: FeedCoordinator
    private let viewModel: FeedViewModel
    var localNotificationsService: LocalNotificationsService?
    
    private lazy var audioButton = CustomButton(title: "Audio Player", cornerRadius: 10) { [weak self] in
        self?.coordinator.present(.audio)
    }
    private lazy var videoButton = CustomButton(title: "Video Player", cornerRadius: 10) { [weak self] in
        self?.coordinator.present(.video)
    }
    private lazy var voiceRecorderButton = CustomButton(title: "Voice recorder", cornerRadius: 10) { [weak self] in
        self?.coordinator.present(.voiceRecorder)
    }
    private lazy var infoButton = CustomButton(title: "Information", cornerRadius: 10) { [weak self] in
        self?.coordinator.present(.info)
    }
    
    private lazy var checkGuessButton = CustomButton(title: "Check", cornerRadius: 10) { [weak self] in
        self?.viewModel.checkWord = (self?.passwordTextField.text)!
        self?.viewModel.changeAction(.checkWordAtion)
    }
    
    private lazy var setupNotification = CustomButton(title: "Setup notification", cornerRadius: 10) { [weak self] in
        guard let self else { return }
        self.localNotificationsService?.requestAuthorization(completion: { result in
                switch result {
                case .success(let isCorrect):
                    if isCorrect {
                        self.localNotificationsService?.authorized(completion: { result in
                            if result {
                                self.localNotificationsService?.removeAllDeliveredNotifications()
                                self.localNotificationsService?.addCalendarNotification(id: "CalendarNotification", text: "Посмотрите последние обновления")
                                self.coordinator.present(.attention("Уведомление установлено"))
                            }
                        })
                    } else {
                        self.coordinator.present(.attention("Нет прав на установку уведомлений"))
                    }
                case .failure(let error):
                    self.coordinator.present(.attention(error.localizedDescription))
                }
        })
    }
    
    private var passwordTextField = CustomTextField(placeholderText: "Password", text: "Donald")
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private var statusLabel: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.clipsToBounds = true
        lable.text = "Correct".localized
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
        stackView.addArrangedSubview(self.audioButton)
        stackView.addArrangedSubview(self.videoButton)
        stackView.addArrangedSubview(self.voiceRecorderButton)
        stackView.addArrangedSubview(self.infoButton)
        return stackView
    }()
    
    init(viewModel: FeedViewModel, coordinator: FeedCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bindViewModel()
        setupServices()
    }

    private func bindViewModel() {
        viewModel.stateChanged = { [weak self] state in
            switch state {
            case .pushButtonAction:
                self?.coordinator.present(.post)
            case .checkWordButtonAction(let word):
                self?.checkWord(word: word)
            case .none:
                ()
            }
        }
    }
    
    private func setupServices() {
        localNotificationsService = LocalNotificationsService.shared
    }
    
    private func layout() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        title = "Feed".localized
        view.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .black)
        view.addSubview(stackView)
        view.addSubview(statusLabel)
        view.addSubview(passwordTextField)
        view.addSubview(checkGuessButton)
        view.addSubview(activityIndicator)
        view.addSubview(setupNotification)
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
            make.width.equalTo(200)
            make.height.equalTo(200)
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
        setupNotification.snp.makeConstraints { make in
            make.top.equalTo(checkGuessButton.snp.bottom).offset(16)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.height.equalTo(35)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func checkWord(word: String) {
        var isCorrect = false
        do {
            isCorrect = try FeedModel().check(word: word)
            coordinator.present(.autorized)
        } catch ApiError.unauthorized {
            coordinator.present(.error(.unauthorized))
        } catch ApiError.notFound {
            coordinator.present(.error(.notFound))
        } catch ApiError.isEmpty {
            coordinator.present(.error(.isEmpty))
        } catch {
            coordinator.present(.error(.unauthorized))
        }
        
        statusLabel.textColor = isCorrect ? .green : .red
        statusLabel.text = (isCorrect ? "True" : "Not true").localized
    }
}
