//
//===--- ChatListViewController.swift - Defines the ChatListViewController class ----------===//
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

class ChatListViewController: BaseViewController {
    // MARK: - Lifecycle

    @objc func injected() {
        #if DEBUG
            SC.log("I've been injected: \(self)")
            setupUI()
            setupConstraints()
        #endif
    }

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

    @objc func exitButtonCLK() {
        guard let name = nickName else {
            return
        }

        SocketHelper.shared.leaveChatRoom(nickname: name) { [weak self] in
            guard let self = self else {
                return
            }

            self.navigationController?.popViewController(animated: true)
        }
    }

    // MARK: - Private

    private func navigationRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Exit",
            style: .done,
            target: self,
            action: #selector(exitButtonCLK)
        )
    }

    // MARK: - UI

    func setupUI() {
        title = "Welcome \(nickName ?? "")"
        navigationRightBarButton()
        view.addSubview(tblChatList)
        tblChatList.configureViewModel()
    }

    // MARK: - Constraints

    func setupConstraints() {
        tblChatList.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Property

    var nickName: String?

    private lazy var tblChatList: ChatListTableView = {
        let _chatList = ChatListTableView()
        _chatList.nickName = self.nickName

        _chatList.onDidSelect = { [weak self] (user: User) in

            guard let self = self,
                  let name = self.nickName
            else {
                return
            }

            let vc = ChatDetailViewController()
            vc.user = user
            vc.nickName = name
            self.navigationController?.pushViewController(vc, animated: true)
        }

        return _chatList
    }()
}
