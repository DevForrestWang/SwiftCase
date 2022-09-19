//
//  GYVoiceRecordingObject.swift
//  GYCompany
//
//  Created by applem1 on 2022/6/8.
//  Copyright © 2022 归一. All rights reserved.
//

import AVFoundation
import UIKit

class GYVoiceRecordingObject: NSObject {
    // 执行析构过程
    deinit {
        fwDebugPrint("===========<deinit: \(type(of: self))>===========")
    }

    // MARK: - Public

    public func startAudio() {
        if !isCanAudio() {
            let tips = String(format: "请在iPhone的\"设置 > 隐私 > 相机\"选项中，允许%@访问你的相机和麦克风", arguments: [SCUtils.getAppName()])
            let alertVC = UIAlertController(title: nil, message: tips, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "确定", style: .cancel) { _ in }
            alertVC.addAction(confirmAction)
            parentVc?.present(alertVC, animated: true, completion: nil)
            return
        }

        if let vc = parentVc {
            vc.view.addSubview(gifImageView)
            gifImageView.snp.makeConstraints { make in
                make.width.height.equalTo(150)
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-44)
            }
            SCUtils.showGif(fileName: "gy_voice_playing.gif", imageView: gifImageView)
        }

        recordtimer?.invalidate()
        startRecord()
    }

    public func stopAudio() {
        gifImageView.removeFromSuperview()
        recorder?.updateMeters()

        var interval = 0
        if (recorder?.isRecording) != nil {
            interval = Int(recorder?.currentTime ?? 0)
        }
        fwDebugPrint("stop current interval: \(interval)")

        let path = stopRecord()
        if interval < 1 {
            fwShowToast("录音时间太短")
            return
        }

        if let tmpClosure = gyVoiceRecordingClosure {
            tmpClosure(interval, path)
        }
    }

    public func cancleAudio() {
        cancelRecord()
        fwShowToast("取消发送")
    }

    // MARK: - Protocol

    // MARK: - IBActions

    @objc private func recordTick(timer _: Timer) {
        if !(recorder?.isRecording ?? false) {
            fwDebugPrint("It is not recroding.")
            return
        }

        recorder?.updateMeters()
        let interval = recorder?.currentTime ?? 0
        if interval > 60 {
            fwShowToast("录音时间太长")
            let path = stopRecord()
            if let tmpClosure = gyVoiceRecordingClosure {
                tmpClosure(Int(interval), path)
            }
        }
    }

    // MARK: - Private

    private func isCanAudio() -> Bool {
        var audioState = false

        let session = AVAudioSession.sharedInstance()
        session.requestRecordPermission { available in
            audioState = available
        }

        if canCamera(), audioState {
            return true
        }

        return false
    }

    private func canCamera() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .restricted || status == .denied {
            return false
        }

        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            fwShowToast("相机不可用")
            return false
        }

        return true
    }

    private func startRecord() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
            try session.setActive(true)

            // 设置参数
            let settings: [String: Any] = [
                // 采样率  8000/11025/22050/44100/96000（影响音频的质量）
                AVSampleRateKey: Float(8000.0),
                // 音频格式
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                // 采样位数  8、16、24、32 默认为16
                AVLinearPCMBitDepthKey: Int(16),
                // 音频通道数 1 或 2
                AVNumberOfChannelsKey: Int(1),
                // 录音质量
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            ]

            recorder = try AVAudioRecorder(url: getAudioFileUrl(), settings: settings)
            recorder?.isMeteringEnabled = true
            recorder?.prepareToRecord()
            recorder?.record()
            recorder?.updateMeters()

            recordtimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(recordTick), userInfo: nil, repeats: true)
        } catch {
            fwDebugPrint("error: \(error.localizedDescription)")
        }
    }

    private func getAudioFileUrl() -> URL {
        let voiceDataPath = SCUtils.getDocumentsDirectory().appendingPathComponent("voicedata")

        // 目录不存在创建目录
        if !FileManager.default.fileExists(atPath: voiceDataPath.path) {
            do {
                try FileManager.default.createDirectory(atPath: voiceDataPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                fwDebugPrint("Failed to create file, error: \(error.localizedDescription)")
            }
        }

        let uuid = Date().timeStamp
        let fileName = String(format: "%@_voice_%@.%@", arguments: ["groupchat", uuid, "m4a"])

        return voiceDataPath.appendingPathComponent(fileName)
    }

    private func stopRecord() -> String {
        if let tmpTimer = recordtimer {
            tmpTimer.invalidate()
            recordtimer = nil
        }

        guard let tmpRecorder = recorder else {
            return ""
        }

        if tmpRecorder.isRecording {
            tmpRecorder.stop()
        }

        return tmpRecorder.url.path
    }

    private func cancelRecord() {
        let path = stopRecord()
        if FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch {
                fwDebugPrint("error: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Property

    public weak var parentVc: UIViewController?
    public var gyVoiceRecordingClosure: ((_ duration: Int, _ fileName: String) -> Void)?

    private var recorder: AVAudioRecorder?
    private var recordtimer: Timer?
    private let gifImageView = UIImageView()
}
