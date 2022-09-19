//
//  GYCPlayingView.swift
//  GYCompany
//
//  Created by applem1 on 2022/6/13.
//  Copyright © 2022 归一. All rights reserved.
//

import AVKit
import UIKit

class GYCPlayingView: UIView {
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // 执行析构过程
    deinit {
        fwDebugPrint("===========<deinit: \(type(of: self))>===========")
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Public

    public func playAudio(view: UIView, url: URL, completeClosure: @escaping () -> Void) {
        addPlayer(view: view, url: url, isVedio: false, coverImg: nil, completeClosure: completeClosure)
    }

    public func playVedio(url: URL, coverImg: UIImage?, completeClosure: @escaping () -> Void) {
        guard let keyWindow = gWindow else {
            fwDebugPrint("The keyWindow is nil.")
            return
        }

        addPlayer(view: keyWindow, url: url, isVedio: true, coverImg: coverImg, completeClosure: completeClosure)
    }

    public func play() {
        isPlay = true
        player?.play()
        mainPlayBtn.isHidden = true
        playBtn.setImage(UIImage(named: "gy_chat_bar_stop_video"), for: .normal)
    }

    public func stopPlay() {
        isPlay = false
        player?.pause()
        mainPlayBtn.isHidden = false
        playBtn.setImage(UIImage(named: "gy_chat_bar_play_video"), for: .normal)
    }

    public func pause() {
        if player?.rate == 1 {
            player?.pause()
            isPlay = false
        }
    }

    // MARK: - Protocol

    // MARK: - IBActions

    @objc private func videoPlayAction() {
        if isPlay {
            stopPlay()
        } else {
            play()
        }
    }

    @objc private func closeVideoAction() {
        stopPlay()

        if playerLayer != nil {
            playerLayer?.removeFromSuperlayer()
            playerLayer = nil
        }

        if player != nil {
            player = nil
        }

        removeFromSuperview()
    }

    @objc private func playEndTime() {
        if playProcessSlider.value == 1 {
            player?.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: 30))
            stopPlay()
        }

        if let tempClosure = gyPlayCompleteClosure {
            tempClosure()
        }

        mainPlayBtn.isHidden = false
    }

    @objc private func onSliderValueChangedBegin() {
        player?.pause()
    }

    @objc private func onSliderValueChanged(slider: UISlider) {
        guard let duration = player?.currentItem?.duration else {
            fwDebugPrint("The video duration is nil.")
            return
        }

        let curTime = CMTimeGetSeconds(duration) * Double(slider.value)
        player?.seek(to: CMTimeMakeWithSeconds(curTime, preferredTimescale: 30))
        play()
    }

    @objc public func clickScreenAction() {
        isShowToolBar = !isShowToolBar
        if isShowToolBar {
            showToolBar()
        } else {
            hidenToolBar()
        }
    }

    // MARK: - Private

    private func addPlayer(view: UIView, url: URL, isVedio: Bool = false, coverImg: UIImage?, completeClosure: @escaping () -> Void) {
        coverBgView.isHidden = true
        if let image = coverImg {
            coverBgView.isHidden = false
            activityIndicatorView.startAnimating()
            coverImagView.image = image
        }

        let asset = AVAsset(url: url)
        // 检测文件是否可播放
        guard asset.isPlayable else {
            fwShowToast("检测文件播放失败")
            return
        }

        gyPlayCompleteClosure = completeClosure
        currentItemRemoveObserver()

        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        // 播放速度
        player?.rate = 1.0
        // 默认音量
        player?.volume = 1.0

        // 设置播放声音
        let session = AVAudioSession.sharedInstance()
        try? session.setActive(true)
        try? session.setCategory(.playback)

        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        let tmpPlayerLayer = AVPlayerLayer(player: player)
        playerLayer = tmpPlayerLayer

        tmpPlayerLayer.frame = view.bounds
        tmpPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        tmpPlayerLayer.transform = CATransform3DMakeRotation(0, 0, 0, 1)

        let interval = CMTime(seconds: 0.05, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        tmpPlayerLayer.player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { [weak self] _ in

            if let barCurTime = tmpPlayerLayer.player?.currentItem?.currentTime(),
               let barDuration = tmpPlayerLayer.player?.currentItem?.duration
            {
                let curTime = CMTimeGetSeconds(barCurTime)
                let duration = CMTimeGetSeconds(barDuration)
                if !curTime.isNaN, !duration.isNaN {
                    if curTime > 0 {
                        self?.activityIndicatorView.stopAnimating()
                        self?.coverBgView.isHidden = true
                    }
                    let progress = curTime / duration
                    self?.playProcessSlider.setValue(Float(progress), animated: false)
                    self?.playTimeLable.text = String(format: "%.2d:%.2d", arguments: [Int(curTime) / 60, Int(curTime) % 60])
                    self?.durationTimeLb.text = String(format: "%.2d:%.2d", arguments: [Int(duration) / 60, Int(duration) % 60])
                }
            }
        })

        if isVedio {
            view.addSubview(self)
            frame = view.bounds
            showVedioView.layer.addSublayer(tmpPlayerLayer)
        } else {
            view.layer.addSublayer(tmpPlayerLayer)
        }

        play()
        clickScreenAction()
        currentItemAddObserver()
    }

    // 播放前增加配置 监测
    private func currentItemAddObserver() {
        // 监控播放结束通知
        NotificationCenter.default.addObserver(self, selector: #selector(playEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }

    /// 播放后,删除监测
    private func currentItemRemoveObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }

    private func showToolBar() {
        toobarBgView.isHidden = false

        if !isMonitorToolBar {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                self.hidenToolBar()
                self.isMonitorToolBar = false
            }
            isMonitorToolBar = true
        }
    }

    private func hidenToolBar() {
        toobarBgView.isHidden = true
        isShowToolBar = false
    }

    // MARK: - UI

    private func setupUI() {
        fwDebugPrint("===========<init: \(type(of: self))>===========")
        addSubview(showVedioView)
        addSubview(coverBgView)
        coverBgView.addSubview(coverImagView)
        coverBgView.addSubview(activityIndicatorView)
        coverBgView.isHidden = true

        addSubview(mainPlayBtn)
        addSubview(toobarBgView)
        toobarBgView.addSubview(playBtn)
        toobarBgView.addSubview(playTimeLable)
        toobarBgView.addSubview(playProcessSlider)
        toobarBgView.addSubview(durationTimeLb)
        toobarBgView.addSubview(closeBtn)

        mainPlayBtn.addTarget(self, action: #selector(videoPlayAction), for: .touchUpInside)
        playBtn.addTarget(self, action: #selector(videoPlayAction), for: .touchUpInside)
        closeBtn.addTarget(self, action: #selector(closeVideoAction), for: .touchUpInside)
        playProcessSlider.addTarget(self, action: #selector(onSliderValueChangedBegin), for: .touchDown)
        playProcessSlider.addTarget(self, action: #selector(onSliderValueChanged), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickScreenAction))
        addGestureRecognizer(tapGesture)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        coverBgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        coverImagView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        activityIndicatorView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.center.equalToSuperview()
        }

        mainPlayBtn.snp.makeConstraints { make in
            make.width.height.equalTo(65)
            make.center.equalToSuperview()
        }

        toobarBgView.snp.makeConstraints { make in
            make.bottom.equalTo(-(gBottomSafeHeight + 10))
            make.height.equalTo(25 + 30 + 20)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        playBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.height.equalTo(25)
            make.left.equalToSuperview().offset(32)
        }
        playTimeLable.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.height.equalTo(21)
            make.width.equalTo(40)
            make.left.equalTo(playBtn.snp.right).offset(10)
        }
        playProcessSlider.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(playTimeLable.snp.right).offset(10)
            make.right.equalTo(durationTimeLb.snp.left).offset(-10)
        }
        durationTimeLb.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.height.equalTo(21)
            make.width.equalTo(40)
            make.right.equalToSuperview().offset(-32)
        }

        closeBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(50)
            make.left.equalToSuperview().offset(32)
        }
    }

    // MARK: - Property

    private var gyPlayCompleteClosure: (() -> Void)?

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var isPlay: Bool = false
    private var isShowToolBar = false
    private var isMonitorToolBar = false

    let showVedioView = UIView(frame: CGRect(x: 0, y: 0, width: gScreenWidth, height: gScreenHeight)).then {
        $0.backgroundColor = .black
    }

    let coverBgView = UIView().then {
        $0.backgroundColor = .clear
    }

    let coverImagView = UIImageView().then {
        // 比例不变
        $0.contentMode = .scaleAspectFit
    }

    let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)

    let mainPlayBtn = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "gy_chat_play_video"), for: .normal)
        $0.contentMode = .scaleToFill
    }

    let toobarBgView = UIView()

    let playBtn = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "gy_chat_bar_play_video"), for: .normal)
        $0.contentMode = .scaleToFill
    }

    let playTimeLable = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 14)
        $0.text = "00:00"
    }

    let playProcessSlider = UISlider().then {
        $0.minimumValue = 0
        $0.maximumValue = 1
        $0.minimumTrackTintColor = .white
    }

    let durationTimeLb = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 14)
        $0.text = "00:00"
    }

    let closeBtn = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "gy_chat_bar_close_video"), for: .normal)
        $0.contentHorizontalAlignment = .left
    }
}
