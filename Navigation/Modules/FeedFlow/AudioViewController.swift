//
//  AudioViewController.swift
//  Navigation
//
//  Created by Алексей Голованов on 25.09.2023.
//

import UIKit
import AVKit

final class AudioViewController: UIViewController {
    
    enum Buttons {
        case play
        case pause
        case stop
        case previous
        case next
    }
    
    let coordinator: FeedCoordinator
    private var audioPlayer: AVAudioPlayer!
    private var soundtrack: UILabel = UILabel()
    private var currentSong: Int = 1
    private var songs = [Int: String]()
    private lazy var playButton = CustomButton(title: "", cornerRadius: 10, image: UIImage(systemName: "play.fill")!) { [weak self] in self?.pressButton(button:.play) }
    private lazy var pauseButton = CustomButton(title: "", cornerRadius: 10, image: UIImage(systemName: "pause.fill")!) { [weak self] in self?.pressButton(button: .pause) }
    private lazy var stopButton = CustomButton(title: "", cornerRadius: 10, image: UIImage(systemName: "stop.fill")!) { [weak self] in self?.pressButton(button: .stop) }
    private lazy var previousButton = CustomButton(title: "", cornerRadius: 10, image: UIImage(systemName: "backward.end.fill")!) { [weak self] in self?.pressButton(button: .previous) }
    private lazy var nextButton = CustomButton(title: "", cornerRadius: 10, image: UIImage(systemName: "forward.end.fill")!) { [weak self] in self?.pressButton(button: .next) }
    
    init(coordinator: FeedCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .black)
        title = "Audio Player".localized
        getSongs()
        setupAudioPlayer()
        setupUI()
    }
    
    private func getSongs() {
        songs[1] = "M83 - Couleurs"
        songs[2] = "M83 - Go"
        songs[3] = "M83 - Intro"
        songs[4] = "M83 - Nothing To Give"
        songs[5] = "M83 - Midnight City"
    }
    
    private func setupUI() {
        pauseButton.isHidden = true
        soundtrack.textAlignment = .center
        view.addSubview(playButton)
        view.addSubview(soundtrack)
        view.addSubview(pauseButton)
        view.addSubview(stopButton)
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        playButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        soundtrack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(playButton.snp.top).offset(-16)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
        }
        pauseButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        stopButton.snp.makeConstraints { make in
            make.top.equalTo(playButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        previousButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(playButton.snp.leading).offset(-10)
        }
        nextButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(playButton.snp.trailing).offset(10)
        }
    }
    
    private func setupAudioPlayer() {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: Bundle.main.url(forResource: songs[currentSong]!, withExtension: "mp3")!)
            soundtrack.text = songs[currentSong]!
            setupAudioSession()
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
    
    private func pressButton(button: Buttons) {
        switch button {
        case .play:
            playButton.isHidden = true
            pauseButton.isHidden = false
            audioPlayer.play()
        case .pause:
            pauseButton.isHidden = true
            playButton.isHidden = false
            audioPlayer.pause()
        case .stop:
            pauseButton.isHidden = true
            playButton.isHidden = false
            audioPlayer.currentTime = 0
            audioPlayer.stop()
        case .previous:
            let isPlaying = audioPlayer.isPlaying
            currentSong -= 1
            if currentSong < 1 { currentSong = 5 }
            setupAudioPlayer()
            if isPlaying { pressButton(button: .play) }
        case .next:
            let isPlaying = audioPlayer.isPlaying
            currentSong += 1
            if currentSong > 5 { currentSong = 1 }
            setupAudioPlayer()
            if isPlaying { pressButton(button: .play) }
        }
    }
}
