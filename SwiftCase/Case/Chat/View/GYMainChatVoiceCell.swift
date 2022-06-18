//
//===--- GYMainChatVoiceCell.swift - Defines the GYMainChatVoiceCell class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/9/26.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//
import UIKit

class GYMainChatVoiceCell: GYMainChatBaseInfoCell {
    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        reSetupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // 执行析构过程
    deinit {
        yxc_debugPrint("===========<deinit: \(type(of: self))>===========")
    }

    // MARK: - Public

    override public func update(model: GYMainChatModel) {
        if model.messageTpye != .voice {
            return
        }

        super.update(model: model)

        if let msgDic = model.msg as? NSDictionary {
            if let second = msgDic["second"] as? Int64, let remoteAudioUrl = msgDic["remoteAudioUrl"] as? String {
                durationLable.text = "\(second) ''"
                audioUrl = remoteAudioUrl
            }
            contentBgView.backgroundColor = UIColor.hexColor(0xFFF7EB)
        }

        reSetupConstraints()
    }

    @objc override public func clickAction(recognizer _: UITapGestureRecognizer) {
        isPlay = !isPlay
        var gifFile = "gy_chat_voice_left.gif"
        if sendType == .sendInfo {
            gifFile = "gy_chat_voice_right.gif"
        }

        if isPlay {
            showPlaying(isPlaying: true)
            SCUtils.showGif(fileName: gifFile, imageView: playingImagView)
        } else {
            showPlaying(isPlaying: false)
        }
    }

    // MARK: - Protocol

    // MARK: - IBActions

    // MARK: - Private

    private func showPlaying(isPlaying: Bool) {
        playingImagView.isHidden = !isPlaying
        voiceImagView.isHidden = !playingImagView.isHidden
    }

    // MARK: - UI

    private func setupUI() {
        yxc_debugPrint("===========<loadClass: \(type(of: self))>===========")

        contentBgView.addSubview(bgView)
        bgView.addSubview(durationLable)
        bgView.addSubview(voiceImagView)
        bgView.addSubview(playingImagView)

        showPlaying(isPlaying: false)
    }

    // MARK: - Constraints

    private func reSetupConstraints() {
        bgView.snp.remakeConstraints { make in
            make.height.equalTo(25)
            make.width.equalTo(120)
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        }

        voiceImagView.snp.remakeConstraints { make in
            make.width.height.equalTo(20)
            make.top.equalToSuperview().offset(2)

            if sendType == .acceptInfo {
                make.left.equalToSuperview().offset(10)
            } else {
                make.right.equalToSuperview().offset(-10)
            }
        }

        playingImagView.snp.remakeConstraints { make in
            make.width.height.equalTo(20)
            make.top.equalToSuperview().offset(2)

            if sendType == .acceptInfo {
                make.left.equalToSuperview().offset(10)
            } else {
                make.right.equalToSuperview().offset(-10)
            }
        }

        durationLable.snp.remakeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(60)
            make.top.equalToSuperview().offset(2)

            if sendType == .acceptInfo {
                make.left.equalTo(voiceImagView.snp.right).offset(10)
            } else {
                make.right.equalTo(voiceImagView.snp.left).offset(-10)
            }
        }

        if sendType == .acceptInfo {
            durationLable.textAlignment = .left
            voiceImagView.image = UIImage(named: "gy_chat_voice_left")

        } else {
            durationLable.textAlignment = .right
            voiceImagView.image = UIImage(named: "gy_chat_voice_right")
        }
    }

    // MARK: - Property

    private var isPlay = false
    private var audioUrl: String?

    private let bgView = UIView()

    private let durationLable = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .left
    }

    private let voiceImagView = UIImageView().then {
        $0.image = UIImage(named: "gy_chat_voice_left")
    }

    private let playingImagView = UIImageView()
}
