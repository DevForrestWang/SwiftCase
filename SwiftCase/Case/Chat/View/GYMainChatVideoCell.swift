//
//  GYMainChatVideoCell.swift
//  GYCompany
//
//  Created by applem1 on 2022/6/13.
//  Copyright © 2022 归一. All rights reserved.
//

import Photos
import UIKit

class GYMainChatVideoCell: GYMainChatBaseInfoCell {
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
        if model.messageTpye != .video {
            return
        }

        super.update(model: model)

        if let msgDic = model.msg as? NSDictionary {
            showPlay(isPlay: true)
            if let thumbUrl = msgDic["thumbUrl"] as? String {
                vedioCoverImagView.kf.setImage(with: URL(string: thumbUrl), placeholder: UIImage(named: "gyhs_bigDefaultImage"))
            } else if let coverImg = msgDic["coverImg"] as? UIImage {
                vedioCoverImagView.image = coverImg
            }
        }
        reSetupConstraints()
    }

    public func updateProgress(progress: Int) {
        circleProgressView.setProgress(progress)
        if progress >= 100 {
            showPlay(isPlay: true)
        } else {
            showPlay(isPlay: false)
        }
    }

    @objc override public func clickAction(recognizer _: UITapGestureRecognizer) {
        guard let model = currentModel, let msgDic = model.msg as? NSDictionary else {
            yxc_debugPrint("The model:\(String(describing: currentModel)) is nill or msg is not dictionary")
            return
        }

        guard let videoUrl = msgDic["remoteVideoUrl"] as? String else {
            yxc_debugPrint("The remoteVideoUrl is nil.")
            return
        }

        guard let url = URL(string: videoUrl) else {
            yxc_debugPrint("The url is nil.")
            return
        }

        guard let image = SCUtils.videoCover(videoUrl: url) else {
            yxc_debugPrint("The video cover is nil.")
            return
        }

        if let tmpClosure = gyMainChatCellClosure {
            let dataDic: [String: Any] = [:]
            tmpClosure(.video, dataDic)
        }
        playingView.playVedio(url: url, coverImg: image) {}
    }

    override public func getUIMenuItems() -> [UIMenuItem] {
        var restAry: [UIMenuItem] = []
        let copyItem = UIMenuItem(title: "保存", action: #selector(saveVideoAction))
        restAry.append(copyItem)

        if isMessageRevoke {
            let revokeItem = UIMenuItem(title: "撤回", action: #selector(revokeAction))
            restAry.append(revokeItem)
        }

        return restAry
    }

    override public func iShowMenumItems(action: Selector) -> Bool {
        var actions: [Selector] = [#selector(saveVideoAction)]
        if isMessageRevoke {
            actions.append(#selector(revokeAction))
        }

        return actions.contains(action)
    }

    // MARK: - IBActions

    @objc private func saveVideoAction() {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                if status == PHAuthorizationStatus.denied {
                    fwShowToast("没有保存到相册的权限")
                } else {
                    self.downloadVideo()
                }
            }
        }
    }

    @objc private func revokeAction() {
        yxc_debugPrint(#function)
    }

    // MARK: - Private

    private func showPlay(isPlay: Bool) {
        playImagView.isHidden = !isPlay
        circleProgressView.isHidden = !playImagView.isHidden
    }

    private func downloadVideo() {
        guard let model = currentModel, let msgDic = model.msg as? NSDictionary else {
            yxc_debugPrint("The currentModel or msg is empty.")
            return
        }

        guard let videoUrl = msgDic["remoteVideoUrl"] as? String else {
            yxc_debugPrint("The remoteVideoUrl is nil.")
            return
        }

        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: videoUrl), let urlData = NSData(contentsOf: url) else {
                yxc_debugPrint("Failed to download vedio, videoUrl:\(videoUrl)")
                return
            }

            let galleryPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
            let uuid = Date().timeIntervalSince1970
            let filePath = "\(galleryPath)/\(uuid).mp4"

            DispatchQueue.main.async {
                urlData.write(toFile: filePath, atomically: true)

                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                }) { success, error in

                    DispatchQueue.main.async {
                        if success {
                            fwShowToast("视频保存成功")
                        } else {
                            yxc_debugPrint(error?.localizedDescription ?? "")
                            fwShowToast("视频保存失败")
                        }
                    }
                }
            }
        }
    }

    // MARK: - UI

    private func setupUI() {
        yxc_debugPrint("===========<loadClass: \(type(of: self))>===========")

        contentBgView.addSubview(bgView)
        bgView.addSubview(vedioCoverImagView)
        bgView.addSubview(playImagView)
        bgView.addSubview(circleProgressView)

        showPlay(isPlay: true)
    }

    // MARK: - Constraints

    private func reSetupConstraints() {
        bgView.snp.remakeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(120)
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        }

        vedioCoverImagView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }

        playImagView.snp.remakeConstraints { make in
            make.width.height.equalTo(30)
            make.center.equalToSuperview()
        }

        circleProgressView.snp.remakeConstraints { make in
            make.width.height.equalTo(40)
            make.center.equalToSuperview()
        }
    }

    // MARK: - Property

    private let bgView = UIView()

    private let vedioCoverImagView = UIImageView().then {
        $0.image = UIImage(named: "gyhs_bigDefaultImage")
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }

    private let playImagView = UIImageView().then {
        $0.image = UIImage(named: "gy_chat_play_video")
    }

    private let circleProgressView = SCircleProgressView()

    private let playingView = GYCPlayingView()
}
