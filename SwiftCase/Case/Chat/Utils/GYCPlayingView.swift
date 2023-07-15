//
//  GYCPlayingView.swift
//  GYCompany
//
//  Created by applem1 on 2022/6/13.
//  Copyright © 2022 归一. All rights reserved.
//

import AVKit
import UIKit

/// 视频播放器，支持缓存功能
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
        SC.log("===========<deinit: \(type(of: self))>===========")
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Public

    public func playAudio(view: UIView, url: URL, completeClosure: @escaping () -> Void) {
        addPlayer(view: view, url: url, isVedio: false, coverImg: nil, completeClosure: completeClosure)
    }

    public func playVedio(url: URL, coverImg: UIImage?, completeClosure: @escaping () -> Void) {
        guard let keyWindow = SC.window else {
            SC.log("The keyWindow is nil.")
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
            SC.log("The video duration is nil.")
            return
        }

        var curTime = CMTimeGetSeconds(duration) * Double(slider.value)

        if curTime < 0 {
            curTime = 0
        }
        if totalTime > 0, curTime > totalTime {
            curTime = totalTime
        }

        let curPlay = isPlay
        pause()

        player?.seek(to: CMTimeMakeWithSeconds(curTime, preferredTimescale: 300), completionHandler: { [weak self] finish in

            if !finish {
                SC.toast("快进未加载完")
                return
            }

            if curPlay {
                self?.play()
            }
        })
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

        // 检测文件是否可播放
        guard AVAsset(url: url).isPlayable else {
            SC.toast("检测文件播放失败")
            return
        }

        gyPlayCompleteClosure = completeClosure
        removeObserver(from: playerItem)
        totalTime = 0

        playerItem = CachingPlayerItem(url: url)
        playerItem?.download()

        player = AVPlayer(playerItem: playerItem)
        player?.automaticallyWaitsToMinimizeStalling = false
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
        addObserver(to: playerItem)
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

    /// AVPlayerItem添加监控
    private func addObserver(to playerItem: AVPlayerItem?) {
        if playerItem != nil {
            // 监控播放状态
            playerItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
            // 监控网络加载情况
            playerItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
            // 正在缓冲
            playerItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
            // 缓冲结束
            playerItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
        }

        // 监控播放结束通知
        NotificationCenter.default.addObserver(self, selector: #selector(playEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }

    /// 移除监控
    private func removeObserver(from playerItem: AVPlayerItem?) {
        if playerItem != nil {
            playerItem?.removeObserver(self, forKeyPath: "status")
            playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
            playerItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty")
            playerItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
        }

        // 移除结束通知
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }

    /**
     *  通过KVO监控播放器状态
     *
     *  @param keyPath 监控属性
     *  @param object  监视器
     *  @param change  状态改变
     *  @param context 上下文
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change _: [NSKeyValueChangeKey: Any]?, context _: UnsafeMutableRawPointer?) {
        guard let playerItem = object as? AVPlayerItem else {
            return
        }

        if keyPath == "status" {
            switch playerItem.status {
            case .unknown:
                SC.log("Loading status: Unknown status")
            case .readyToPlay:
                totalTime = playerItem.asset.duration.seconds
                SC.log("Loading status: Play time: \(String(describing: totalTime))")
            case .failed:
                SC.log("Loading status: Failed to load, error: \(String(describing: playerItem.error))")
            default:
                break
            }

        } else if keyPath == "loadedTimeRanges" {
        } else if keyPath == "playbackBufferEmpty" {
            SC.log("is loading")
            activityIndicatorView.startAnimating()
        } else if keyPath == "playbackLikelyToKeepUp" {
            SC.log("end loading")
            activityIndicatorView.stopAnimating()
        }
    }

    // MARK: - UI

    private func setupUI() {
        SC.log("===========<init: \(type(of: self))>===========")
        addSubview(showVedioView)
        addSubview(coverBgView)
        coverBgView.addSubview(coverImagView)
        addSubview(activityIndicatorView)
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
            make.bottom.equalTo(-(SC.bottomSafeHeight + 10))
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

    private var player: AVPlayer? // 播放器实例
    private var playerLayer: AVPlayerLayer? // 视频渲染图层
    private var playerItem: CachingPlayerItem?
    private var totalTime: Double = 0 // 总时长

    private var isPlay: Bool = false
    private var isShowToolBar = false
    private var isMonitorToolBar = false

    let showVedioView = UIView(frame: CGRect(x: 0, y: 0, width: SC.w, height: SC.h)).then {
        $0.backgroundColor = .black
    }

    let coverBgView = UIView().then {
        $0.backgroundColor = .clear
    }

    let coverImagView = UIImageView().then {
        // 比例不变
        $0.contentMode = .scaleAspectFit
    }

    let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)

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
