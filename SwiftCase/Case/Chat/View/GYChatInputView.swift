//
//===--- GYChatInputView.swift - Defines the GYChatInputView class ----------===//
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

import Photos
import SnapKit
import ZLPhotoBrowser

class GYChatInputView: UIView, UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    enum GYChatInputType {
        case none
        case switchGroup
        case redPackage
        case pushActive
        case commendGoods
        case deliveryOrder
        case sendText
        case sendVoice
        case sendEmoji
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError()
    }

    // 执行析构过程
    deinit {
        SC.log("===========<deinit: \(type(of: self))>===========")
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Public

    public func hiddenMoreInput() {
        if isShowFunction {
            showFunction(isShow: false)
        }

        if isShowSelectFace {
            showSelectFace(isShow: false)
        }
    }

    // MARK: - Protocol

    func textView(_: UITextView, shouldChangeTextIn _: NSRange, replacementText text: String) -> Bool {
        // 添加发送键的事件
        if text.elementsEqual("\n") {
            if let tempClosure = gyChatInputClosure {
                tempClosure(.sendText, inputTextView.text)
                inputTextView.text = ""
                showMoreButton(isShow: true)
            }
            return false
        }

        return true
    }

    // 返回多少个cell
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return emojiArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GYChatInputCollectionViewCell", for: indexPath) as? GYChatInputCollectionViewCell else {
            return UICollectionViewCell()
        }

        let emoji: String = emojiArray[indexPath.row]
        cell.update(emoji: emoji)
        return cell
    }

    // MARK: 点击事件

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoji: String = emojiArray[indexPath.row]
        inputTextView.text += emoji
        showMoreButton(isShow: false)
    }

    // MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true) {
            let image = info[.originalImage] as? UIImage
            let url = info[.mediaURL] as? URL
            self.saveToAlbum(image: image, videoUrl: url)
        }
    }

    // MARK: - IBActions

    @objc private func textViewEditChanged(notification: NSNotification) {
        let textView: UITextView! = notification.object as? UITextView
        if textView != nil {
            let text: String = textView.text
            var isEmpty = true
            if text.count > 0 {
                isEmpty = false
            }
            showMoreButton(isShow: isEmpty)
        }
    }

    @objc private func buttonAction(button: UIButton) {
        var buttonType: GYChatInputType = .none
        if button.isEqual(deliveryOrderBtn) {
            buttonType = .deliveryOrder
        } else if button.isEqual(redPackageBtn) {
            buttonType = .redPackage
        } else if button.isEqual(pushActiveBtn) {
            buttonType = .pushActive
        } else if button.isEqual(commendGoodsBtn) {
            buttonType = .commendGoods
        } else if button.isEqual(sendMsgBtn) {
            buttonType = .sendText
            if isContainEmoji() {
                buttonType = .sendEmoji
            }
        } else if button.isEqual(sendVoiceBtn) {
            buttonType = .sendVoice
        }

        if let tempClosure = gyChatInputClosure {
            tempClosure(buttonType, inputTextView.text)
            inputTextView.text = ""
            showMoreButton(isShow: true)
        }
    }

    @objc private func switchInputAction() {
        isShowVoiceInput = !isShowVoiceInput

        if isShowVoiceInput {
            hiddenMoreInput()
            sendVoiceBtn.isHidden = false
            inputTextView.isHidden = true
            switchBtn.setImage(UIImage(named: "gy_chat_switch_keyboard"), for: .normal)
        } else {
            sendVoiceBtn.isHidden = true
            inputTextView.isHidden = false
            switchBtn.setImage(UIImage(named: "gy_chat_switch_voice"), for: .normal)
        }
    }

    @objc private func moreInputAction() {
        isShowFunction = !isShowFunction
        showFunction(isShow: isShowFunction)
    }

    @objc private func faceInputAction() {
        isShowSelectFace = !isShowSelectFace
        showSelectFace(isShow: isShowSelectFace)
    }

    @objc func longPressAction(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .began {
        } else if recognizer.state == .changed {
            let point = recognizer.location(in: nil)
            let pintT = sendVoiceBtn.convert(sendVoiceBtn.bounds.origin, to: nil)

            if pintT.y - 50 > point.y {}
        } else if recognizer.state == .ended {}
    }

    @objc private func graphicAlbumAction() {
        showSelectAlert(firstTitle: "拍照") {
            self.showCamera(isVideo: false)
        } albumClosure: {
            self.selectAlbum(isVideo: false)
        }
    }

    @objc private func graphicVideoAction() {
        showSelectAlert(firstTitle: "拍摄") {
            self.showCamera(isVideo: true)
        } albumClosure: {
            self.selectAlbum(isVideo: true)
        }
    }

    // MARK: - Private

    private func showMoreButton(isShow: Bool) {
        moreBtn.isHidden = !isShow
        sendMsgBtn.isHidden = !moreBtn.isHidden

        if isShow {
            sendMsgBtn.snp.remakeConstraints { make in
                make.bottom.equalToSuperview().offset(-4)
                make.height.equalTo(32)
                make.width.equalTo(32)
                make.right.equalToSuperview().offset(-20)
            }
        } else {
            sendMsgBtn.snp.remakeConstraints { make in
                make.bottom.equalToSuperview().offset(-4)
                make.height.equalTo(32)
                make.width.equalTo(60)
                make.right.equalToSuperview().offset(-20)
            }
        }
    }

    private func showFunction(isShow: Bool) {
        if isShow {
            isShowSelectFace = false
            showSelectFace(isShow: isShowSelectFace)

            functionBgView.snp.remakeConstraints { make in
                make.top.equalTo(toolBgView.snp.bottom).offset(10)
                make.bottom.equalTo(graphicBgView.snp.top).offset(-10)
                make.width.equalToSuperview()
            }

            graphicBgView.snp.remakeConstraints { make in
                make.bottom.equalToSuperview()
                make.height.equalTo(150)
                make.width.equalToSuperview()
            }
        } else {
            graphicBgView.snp.remakeConstraints { make in
                make.bottom.equalToSuperview()
                make.height.equalTo(1)
                make.width.equalToSuperview()
            }
        }
        graphicBgView.isHidden = !isShow
        endEditing(true)
    }

    private func showSelectFace(isShow: Bool) {
        if isShow {
            isShowFunction = false
            showFunction(isShow: isShowFunction)

            functionBgView.snp.remakeConstraints { make in
                make.top.equalTo(toolBgView.snp.bottom).offset(10)
                make.bottom.equalTo(collectionView.snp.top).offset(-10)
                make.width.equalToSuperview()
            }

            collectionView.snp.remakeConstraints { make in
                make.bottom.equalToSuperview()
                make.height.equalTo(240)
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
            }
        } else {
            collectionView.snp.remakeConstraints { make in
                make.bottom.equalToSuperview()
                make.height.equalTo(1)
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
            }
        }
        collectionView.isHidden = !isShow
        endEditing(true)
    }

    private func isContainEmoji() -> Bool {
        guard let content = inputTextView.text else {
            return false
        }

        if content.count <= 0 {
            return false
        }

        for emoji in emojiArray {
            if content.contains(emoji) {
                return true
            }
        }

        return false
    }

    private func showSelectAlert(firstTitle: String, shootClosure: @escaping () -> Void, albumClosure: @escaping () -> Void) {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shootAction = UIAlertAction(title: firstTitle, style: .default) { _ in
            shootClosure()
        }
        let albumAction = UIAlertAction(title: "从手机相册选择", style: .default) { _ in
            albumClosure()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ in }
        alertVC.addAction(shootAction)
        alertVC.addAction(albumAction)
        alertVC.addAction(cancelAction)
        parentVc?.present(alertVC, animated: true, completion: nil)
    }

    private func selectAlbum(isVideo: Bool = false) {
        guard let vc = parentVc else {
            SC.log("没有获取到当前控制器")
            return
        }

        let config = ZLPhotoConfiguration.default()
        config.allowEditVideo = false
        config.allowEditImage = false
        config.allowSelectOriginal = true

        if isVideo {
            config.allowSelectImage = false
            config.allowSelectVideo = true
        } else {
            config.allowSelectImage = true
            config.allowSelectVideo = false
            config.maxSelectCount = 9
        }

        let photoPicker = ZLPhotoPreviewSheet()
        photoPicker.selectImageBlock = { [weak self] images, assets, _ in
            if let tempClosure = self?.gySelectImageBlock {
                let hasSelectVideo = assets.first?.mediaType == .video
                tempClosure(images, assets, hasSelectVideo)
            }
        }
        photoPicker.showPhotoLibrary(sender: vc)
    }

    private func showCamera(isVideo: Bool) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .restricted || status == .denied {
            let tips = String(format: "请在iPhone的\"设置 > 隐私 > 相机\"选项中，允许%@访问你的相机", arguments: [SCDeviceInfo.getAppName()])
            let alertVC = UIAlertController(title: nil, message: tips, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "确定", style: .cancel) { _ in }
            alertVC.addAction(confirmAction)
            parentVc?.present(alertVC, animated: true, completion: nil)
            return
        }

        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            SC.log("相机不可用")
            return
        }

        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.videoQuality = .typeHigh
        picker.sourceType = .camera
        picker.cameraFlashMode = .auto
        var mediaTypes = [String]()
        if isVideo {
            mediaTypes.append("public.movie")
        } else {
            mediaTypes.append("public.image")
        }
        picker.mediaTypes = mediaTypes
        picker.videoMaximumDuration = TimeInterval(60 * 10)
        parentVc?.showDetailViewController(picker, sender: nil)
    }

    private func saveToAlbum(image: UIImage?, videoUrl: URL?) {
        let hud = ZLProgressHUD(style: ZLPhotoConfiguration.default().hudStyle)
        if let image = image {
            hud.show()
            ZLPhotoManager.saveImageToAlbum(image: image) { [weak self] suc, asset in
                if suc, let at = asset {
                    if let tempClosure = self?.gySelectImageBlock {
                        tempClosure([image], [at], false)
                    }

                } else {
                    SC.log("图片保存失败")
                }
                hud.hide()
            }
        } else if let videoUrl = videoUrl {
            hud.show()
            ZLPhotoManager.saveVideoToAlbum(url: videoUrl) { [weak self] suc, asset in
                if suc, let at = asset {
                    if let tempClosure = self?.gySelectImageBlock {
                        tempClosure([], [at], true)
                    }
                } else {
                    SC.log("视频保存失败")
                }
                hud.hide()
            }
        }
    }

    // MARK: - UI

    private func setupUI() {
        SC.log("===========<loadClass: \(type(of: self))>===========")
        backgroundColor = UIColor.hexColor(0xF4F5F6)

        addSubview(lineView)
        addSubview(toolBgView)
        toolBgView.addSubview(redPackageBtn)
        toolBgView.addSubview(pushActiveBtn)
        toolBgView.addSubview(commendGoodsBtn)
        toolBgView.addSubview(deliveryOrderBtn)
        addSubview(collectionView)

        // 功能区
        addSubview(functionBgView)
        functionBgView.addSubview(switchBtn)
        functionBgView.addSubview(showFaceBtn)
        functionBgView.addSubview(sendMsgBtn)
        functionBgView.addSubview(moreBtn)
        functionBgView.addSubview(sendVoiceBtn)
        functionBgView.addSubview(inputTextView)
        inputTextView.delegate = self

        // 更多
        addSubview(graphicBgView)
        graphicBgView.addSubview(graphicAlbumBtn)
        graphicBgView.addSubview(graphicAlbumLable)
        graphicBgView.addSubview(graphicVideoBtn)
        graphicBgView.addSubview(graphicVideoLable)

        deliveryOrderBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        redPackageBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        pushActiveBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        commendGoodsBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        sendMsgBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        let longPressGest = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
        sendVoiceBtn.addGestureRecognizer(longPressGest)

        switchBtn.addTarget(self, action: #selector(switchInputAction), for: .touchUpInside)
        showFaceBtn.addTarget(self, action: #selector(faceInputAction), for: .touchUpInside)
        moreBtn.addTarget(self, action: #selector(moreInputAction), for: .touchUpInside)
        graphicAlbumBtn.addTarget(self, action: #selector(graphicAlbumAction), for: .touchUpInside)
        graphicVideoBtn.addTarget(self, action: #selector(graphicVideoAction), for: .touchUpInside)

        // 输入框根据内容自动调整高度；该视图及父视图不设置高度会自动调整大小
        inputTextView.adjustUITextViewHeight()
        NotificationCenter.default.addObserver(self, selector: #selector(textViewEditChanged(notification:)), name: UITextView.textDidChangeNotification, object: inputTextView)

        sendVoiceBtn.isHidden = !isShowVoiceInput
        inputTextView.isHidden = !sendVoiceBtn.isHidden

        showMoreButton(isShow: true)
        showFunction(isShow: false)
        showSelectFace(isShow: false)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        lineView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }

        let topSpace = 10
        let tooBtnWidth = 75
        toolBgView.snp.makeConstraints { make in
            make.top.equalTo(topSpace)
            make.height.equalTo(28)
            make.width.equalTo(tooBtnWidth * 4 + 30)
            make.centerX.equalToSuperview()
        }

        redPackageBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(28)
            make.width.equalTo(tooBtnWidth)
            make.left.equalToSuperview()
        }

        pushActiveBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(28)
            make.width.equalTo(tooBtnWidth)
            make.left.equalTo(redPackageBtn.snp.right).offset(10)
        }

        commendGoodsBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(28)
            make.width.equalTo(tooBtnWidth)
            make.left.equalTo(pushActiveBtn.snp.right).offset(10)
        }

        deliveryOrderBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(28)
            make.width.equalTo(tooBtnWidth + 5)
            make.left.equalTo(commendGoodsBtn.snp.right).offset(10)
        }

        functionBgView.snp.makeConstraints { make in
            make.top.equalTo(toolBgView.snp.bottom).offset(topSpace)
            make.bottom.equalTo(collectionView.snp.top).offset(-10)
            make.width.equalToSuperview()
        }

        switchBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-4)
            make.height.width.equalTo(32)
            make.left.equalToSuperview().offset(20)
        }

        moreBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-4)
            make.height.width.equalTo(32)
            make.right.equalToSuperview().offset(-20)
        }

        sendMsgBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-4)
            make.height.equalTo(32)
            make.width.equalTo(60)
            make.right.equalToSuperview().offset(-20)
        }

        showFaceBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-4)
            make.height.width.equalTo(32)
            make.right.equalTo(sendMsgBtn.snp.left).offset(-10)
        }

        sendVoiceBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-4)
            make.height.equalTo(32)
            make.left.equalTo(switchBtn.snp.right).offset(10)
            make.right.equalTo(showFaceBtn.snp.left).offset(-10)
        }

        inputTextView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(40)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalTo(switchBtn.snp.right).offset(10)
            make.right.equalTo(showFaceBtn.snp.left).offset(-10)
        }

        collectionView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(240)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }

        graphicBgView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(150)
            make.width.equalToSuperview()
        }

        graphicAlbumBtn.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.width.height.equalTo(50)
            make.left.equalToSuperview().offset(30)
        }

        graphicAlbumLable.snp.makeConstraints { make in
            make.top.equalTo(graphicAlbumBtn.snp.bottom).offset(5)
            make.height.equalTo(21)
            make.width.equalTo(50)
            make.left.equalToSuperview().offset(30)
        }

        graphicVideoBtn.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.width.height.equalTo(50)
            make.left.equalTo(graphicAlbumBtn.snp.right).offset(30)
        }

        graphicVideoLable.snp.makeConstraints { make in
            make.top.equalTo(graphicVideoBtn.snp.bottom).offset(5)
            make.height.equalTo(21)
            make.width.equalTo(50)
            make.left.equalTo(graphicAlbumLable.snp.right).offset(30)
        }
    }

    // MARK: - Property

    public var gyChatInputClosure: ((_ inputType: GYChatInputType, _ inputInfo: String) -> Void)?
    public var gySelectImageBlock: (([UIImage], [PHAsset], Bool) -> Void)?

    public weak var parentVc: UIViewController?

    var isShowVoiceInput = false
    var isShowFunction = false
    var isShowSelectFace = false

    let lineView = UIView().then {
        $0.backgroundColor = UIColor.hexColor(0xB1B0AA)
    }

    let toolBgView = UIView()

    let redPackageBtn = UIButton(type: .custom).then {
        $0.backgroundColor = .white
        $0.setImage(UIImage(named: "gy_chat_redpackage"), for: .normal)
        $0.setTitle("发红包", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 13.0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        $0.layer.cornerRadius = 14
        $0.layer.borderColor = UIColor.hexColor(0xB1B0AA).cgColor
        $0.layer.borderWidth = 1.0
    }

    let pushActiveBtn = UIButton(type: .custom).then {
        $0.backgroundColor = .white
        $0.setImage(UIImage(named: "gy_chat_push_activity"), for: .normal)
        $0.setTitle("推活动", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        $0.titleLabel?.font = .systemFont(ofSize: 13.0)
        $0.layer.cornerRadius = 14
        $0.layer.borderColor = UIColor.hexColor(0xB1B0AA).cgColor
        $0.layer.borderWidth = 1.0
    }

    let commendGoodsBtn = UIButton(type: .custom).then {
        $0.backgroundColor = .white
        $0.setImage(UIImage(named: "gy_chat_commend_goods"), for: .normal)
        $0.setTitle("荐商品", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 13.0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        $0.layer.cornerRadius = 14
        $0.layer.borderColor = UIColor.hexColor(0xB1B0AA).cgColor
        $0.layer.borderWidth = 1.0
    }

    let deliveryOrderBtn = UIButton(type: .custom).then {
        $0.backgroundColor = .white
        $0.setImage(UIImage(named: "gy_chat_delivery_order"), for: .normal)
        $0.setTitle("送货订单", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 13.0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        $0.layer.cornerRadius = 14
        $0.layer.borderColor = UIColor.hexColor(0xB1B0AA).cgColor
        $0.layer.borderWidth = 1.0
    }

    let functionBgView = UIView()

    let switchBtn = UIButton(type: .custom).then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.setImage(UIImage(named: "gy_chat_switch_voice"), for: .normal)
    }

    let showFaceBtn = UIButton(type: .custom).then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.setImage(UIImage(named: "gy_chat_expression"), for: .normal)
    }

    let sendMsgBtn = UIButton(type: .custom).then {
        $0.backgroundColor = UIColor.hexColor(0x00C25F)
        $0.setTitle("发送", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 13.0)
        $0.layer.cornerRadius = 16
    }

    let moreBtn = UIButton(type: .custom).then {
        $0.backgroundColor = .white
        $0.setImage(UIImage(named: "gy_chat_more_functions"), for: .normal)
        $0.layer.cornerRadius = 14
    }

    let sendVoiceBtn = UIButton(type: .custom).then {
        $0.backgroundColor = .white
        $0.setTitle("按住 说话", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14.0)
        $0.layer.cornerRadius = 16
    }

    let inputTextView = UITextView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5

        // 字体设置
        $0.textAlignment = .left
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 14)
        // 去掉键盘上的工具栏
        $0.inputAccessoryView = UIToolbar(frame: CGRect(x: 0, y: 0, width: gScreenWidth, height: 0.01))

        // 修改键盘的确定为发送
        $0.returnKeyType = .send
        $0.textContainerInset = UIEdgeInsets(top: 12, left: 0, bottom: 10, right: 0)
        let phLabel = UILabel()
        phLabel.text = "输入内容"
        phLabel.font = UIFont.systemFont(ofSize: 16)
        phLabel.textColor = UIColor.lightGray
        phLabel.numberOfLines = 0
        phLabel.sizeToFit()
        $0.addSubview(phLabel)
        $0.setValue(phLabel, forKey: "_placeholderLabel")
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 45, height: 45)

        let _collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        _collection.backgroundColor = .white
        _collection.autoresizingMask = .flexibleHeight
        _collection.showsVerticalScrollIndicator = false
        _collection.delegate = self
        _collection.dataSource = self
        _collection.register(GYChatInputCollectionViewCell.self, forCellWithReuseIdentifier: "GYChatInputCollectionViewCell")
        return _collection
    }()

    let graphicBgView = UIView()

    let graphicAlbumBtn = UIButton(type: .custom).then {
        $0.backgroundColor = .white
        $0.setImage(UIImage(named: "gy_chat_more_album"), for: .normal)
        $0.layer.cornerRadius = 10
    }

    let graphicAlbumLable = UILabel().then {
        $0.text = "相册"
        $0.textColor = UIColor.hexColor(0x404040)
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .center
    }

    let graphicVideoBtn = UIButton(type: .custom).then {
        $0.backgroundColor = .white
        $0.setImage(UIImage(named: "gy_chat_more_video"), for: .normal)
        $0.layer.cornerRadius = 10
    }

    let graphicVideoLable = UILabel().then {
        $0.text = "视频"
        $0.textColor = UIColor.hexColor(0x404040)
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .center
    }

    let emojiArray = GYChatDefaultModel().emojiArray
}
