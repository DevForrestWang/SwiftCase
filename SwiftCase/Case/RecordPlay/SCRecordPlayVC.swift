//
//===--- SCRecordPlayVC.swift - Defines the SCRecordPlayVC class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2024/3/6.
// Copyright © 2024 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import AVFoundation
import UIKit

/// 录音及声音播放
class SCRecordPlayVC: BaseViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        configure()
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - IBActions

    /// 进行录音
    @IBAction func record(_: Any) {
        // Stop the audio player before recording
        if let player = audioPlayer, player.isPlaying {
            player.stop()
        }

        if !audioRecorder.isRecording {
            let audioSession = AVAudioSession.sharedInstance()

            do {
                try audioSession.setActive(true)

                // Start recording
                audioRecorder.record()
                startTimer()

                // Change to the Pause image
                recordButton.setImage(UIImage(named: "Pause"), for: UIControl.State.normal)
            } catch {
                print(error)
            }

        } else {
            // Pause recording
            audioRecorder.pause()
            pauseTimer()

            // Change to the Record image
            recordButton.setImage(UIImage(named: "Record"), for: UIControl.State.normal)
        }

        stopButton.isEnabled = true
        playButton.isEnabled = false
    }

    /// 声音播放
    @IBAction func play(_: Any) {
        if !audioRecorder.isRecording {
            guard let player = try? AVAudioPlayer(contentsOf: audioRecorder.url) else {
                print("Failed to initialize AVAudioPlayer")
                return
            }

            if let aPlayer = audioPlayer, aPlayer.isPlaying {
                return
            }

            audioPlayer = player
            audioPlayer?.delegate = self
            audioPlayer?.play()
            startTimer()
        }
    }

    /// 暂停声音
    @IBAction func stop(_: Any) {
        recordButton.setImage(UIImage(named: "Record"), for: UIControl.State.normal)
        recordButton.isEnabled = true
        stopButton.isEnabled = false
        playButton.isEnabled = true

        // Stop the audio recorder
        audioRecorder?.stop()
        resetTimer()

        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setActive(false)
        } catch {
            print(error)
        }
    }

    // MARK: - Private

    /// 初始化录音配置
    private func configure() {
        // Disable Stop/Play button when application launches
        stopButton.isEnabled = false
        playButton.isEnabled = false

        // Get the document directory. If fails, just skip the rest of the code
        guard let directoryURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else {
            showAlert(title: "Error", message: "Failed to get the document directory for recording the audio. Please try again later.", confirmName: "OK")
            return
        }

        // Set the default audio file
        let audioFileURL = directoryURL.appendingPathComponent("MyAudioMemo.m4a")

        // Setup audio session
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])

            // Define the recorder setting
            let recorderSetting: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            ]

            // Initiate and prepare the recorder
            audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: recorderSetting)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()

        } catch {
            print(error)
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            self.elapsedTimeInSecond += 1
            self.updateTimeLabel()
        })
    }

    private func pauseTimer() {
        timer?.invalidate()
    }

    private func resetTimer() {
        timer?.invalidate()
        elapsedTimeInSecond = 0
        updateTimeLabel()
    }

    private func updateTimeLabel() {
        let seconds = elapsedTimeInSecond % 60
        let minutes = (elapsedTimeInSecond / 60) % 60

        timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }

    private func showAlert(title: String, message: String, confirmName: String) {
        let alertMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertMessage.addAction(UIAlertAction(title: confirmName, style: .default, handler: nil))
        present(alertMessage, animated: true, completion: nil)
    }

    // MARK: - UI

    private func setupUI() {
        title = "Recording And Play"
    }

    // MARK: - Constraints

    private func setupConstraints() {}

    // MARK: - Property

    @IBOutlet var timeLabel: UILabel!

    @IBOutlet var recordButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var stopButton: UIButton!

    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer?

    private var timer: Timer?
    private var elapsedTimeInSecond: Int = 0
}

/// 录音完成
extension SCRecordPlayVC: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            showAlert(title: "Finish Recording", message: "Successfully recorded the audio!", confirmName: "OK")
        }
    }
}

/// 播放完成
extension SCRecordPlayVC: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully _: Bool) {
        playButton.isSelected = false
        audioPlayer?.stop()
        resetTimer()
        showAlert(title: "Finish Playing", message: "Finish playing the recording!", confirmName: "OK")
    }
}
