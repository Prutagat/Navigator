//
//  VoiceRecorderViewController.swift
//  Navigation
//
//  Created by Алексей Голованов on 26.09.2023.
//

import UIKit
import AVKit

final class VoiceRecorderViewController: UIViewController, AVAudioRecorderDelegate {
    
    enum Buttons {
        case record
        case play
    }
    
    let coordinator: FeedCoordinator
    private var recordingSession: AVAudioSession!
    private var whistleRecorder: AVAudioRecorder!
    private var audioPlayer: AVAudioPlayer!
    var audioURL: URL?
    
    private lazy var recordButton = CustomButton(title: " Запись", cornerRadius: 10, image: UIImage(systemName: "record.circle.fill")!) { [weak self] in
        self?.pressButton(button:.record)
        
    }
    private lazy var playButton = CustomButton(title: " Воспроизвести", cornerRadius: 10, image: UIImage(systemName: "play.fill")!) { [weak self] in
        self?.pressButton(button:.play)
        
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
        view.backgroundColor = .systemGray4
        title = "Диктофон"
        audioPermission()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(recordButton)
        view.addSubview(playButton)
        recordButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        playButton.snp.makeConstraints { make in
            make.top.equalTo(recordButton.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
    }
    
    private func pressButton(button: Buttons) {
        switch button {
        case .record:
            if whistleRecorder == nil {
                startRecording()
            } else {
                finishRecording(success: true)
            }
        case .play:
            playSound()
        }
    }
    
    private func playSound() {
        guard let URL = audioURL else {
            coordinator.present(.attention("Не удалось получить запись, возможно вы еще ничего не записали."))
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL)
            setupAudioSession()
            audioPlayer.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func audioPermission() {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [weak self] granted in
                DispatchQueue.main.async {
                    let message = granted ? "Доступ к микрофону разрешен" : "Доступ к микрофону не разрешен"
                    self?.coordinator.present(.attention(message))
                }
            }
        } catch {
            coordinator.present(.attention("Не удалось изменить сессию записи"))
        }
    }
    
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    class func getWhistleURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("whistle.m4a")
    }
    
    func startRecording() {
        view.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1)
        recordButton.setTitle(" Остановить запись", for: .normal)
        audioURL = VoiceRecorderViewController.getWhistleURL()
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            whistleRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            whistleRecorder.delegate = self
            whistleRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)

        whistleRecorder.stop()
        whistleRecorder = nil

        if success {
            recordButton.setTitle(" Запись", for: .normal)
        } else {
            recordButton.setTitle(" Запись", for: .normal)
            coordinator.present(.attention("Возникли проблемы при записи с микрофона. Попробуйте снова"))
        }
    }
}