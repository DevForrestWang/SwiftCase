//
//===--- ChatDetailViewController.swift - Defines the ChatDetailViewController class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/9/26.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// Inspirations are taken from:
// https://medium.com/mindful-engineering/sockets-mvvm-in-swift-8f32b1401aa5
//
//===----------------------------------------------------------------------===//

import SnapKit
import Then
import UIKit

class ChatDetailViewController: BaseViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - IBActions

    @objc private func btnSendCLK(_: UIButton) {
        guard txtMessage.text.count > 0,
              let message = txtMessage.text,
              let name = nickName
        else {
            fwDebugPrint("Please type your message.")
            return
        }

        txtMessage.resignFirstResponder()
        SocketHelper.shared.sendMessage(message: message, withNickname: name)
        txtMessage.text = nil
    }

    // MARK: - Private

    // MARK: - UI

    func setupUI() {
        if let user = user {
            title = user.nickname
        }

        view.addSubview(tblChat)
        tblChat.configureViewModel()

        view.addSubview(messageView)
        messageView.addSubview(txtMessage)
        messageView.addSubview(sendButton)

        // 输入框根据内容自动调整高度；该视图及父视图不设置高度会自动调整大小
        txtMessage.adjustUITextViewHeight()

        sendButton.addTarget(self, action: #selector(btnSendCLK), for: .touchUpInside)
    }

    // MARK: - Constraints

    func setupConstraints() {
        tblChat.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(messageView.snp.top).offset(1)
        }

        messageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).offset(0)
        }

        txtMessage.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(40)
            make.top.equalTo(messageView.snp.top).offset(10)
            make.bottom.equalTo(messageView.snp.bottom).offset(-10)
            make.width.equalTo(view).offset(-80)
            make.left.equalTo(view).offset(15)
        }

        sendButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.right.equalToSuperview()
            make.bottom.equalTo(messageView.snp.bottom).offset(-1)
        }
    }

    // MARK: - Property

    var user: User?
    var nickName: String?

    private lazy var tblChat: ChatDetailsTableView = {
        let _cdView = ChatDetailsTableView()
        _cdView.nickName = nickName
        _cdView.backgroundColor = .white
        return _cdView
    }()

    private let messageView = UIView().then {
        $0.backgroundColor = UIColor.hexColor(0xF6F6F6)
    }

    private let txtMessage = UITextView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5

        // 字体设置
        $0.textAlignment = .left
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16)
    }

    private let sendButton = UIButton(type: .custom).then {
        $0.backgroundColor = .clear
        $0.setImage(R.image.send(), for: .normal)
    }
}
