//
//  GYChatInputView.swift
//  GYCompany
//
//  Created by wfd on 2022/5/19.
//  Copyright © 2022 归一. All rights reserved.
//

import SnapKit
import UIKit

class GYChatInputView: UIView, UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    enum GYChatInputType {
        case none
        case switchGroup
        case redPackage
        case pushActive
        case commendGoods
        case deliveryOrde
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
        yxc_debugPrint("===========<deinit: \(type(of: self))>===========")
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
            buttonType = .deliveryOrde
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
            print("start long press")

            if let vc = parentVc {
                vc.view.addSubview(gifImageView)
                gifImageView.snp.makeConstraints { make in
                    make.width.height.equalTo(150)
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview().offset(-44)
                }
                // GYCompanyUtils.showGif(fileName: "gy_voice_playing.gif", imageView: gifImageView)
            }
        } else if recognizer.state == .ended {
            print("end long press")
            gifImageView.removeFromSuperview()
        }
    }

    @objc private func graphicAlbumAction() {
        print("graphicAlbumAction")
    }

    @objc private func graphicVideoAction() {
        print("graphicVideoAction")
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

    // MARK: - UI

    private func setupUI() {
        yxc_debugPrint("===========<loadClass: \(type(of: self))>===========")
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

    let gifImageView = UIImageView()

    let emojiArray = GYChatDefaultModel().emojiArray
}
