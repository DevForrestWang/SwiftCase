//
//===--- ChatListTableView.swift - Defines the ChatListTableView class ----------===//
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

import UIKit

class ChatListTableView: UIView, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    public func configureViewModel() {
        guard let name = nickName else {
            return
        }

        chatViewModel.arrUsers.subscribe { [weak self] (_: [User]) in
            guard let self = self else {
                return
            }

            self.tableView.reloadData()
        }
        chatViewModel.fetchParticipantList(name)
    }

    // MARK: - Protocol

    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return chatViewModel.arrUsers.value.count
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListTableViewCell") as? ChatListTableViewCell else {
            return UITableView.emptyCell()
        }

        let user: User = chatViewModel.arrUsers.value[indexPath.row]
        cell.configureCell(user)
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user: User = chatViewModel.arrUsers.value[indexPath.row]
        onDidSelect?(user)
    }

    // MARK: - IBActions

    // MARK: - Private

    // MARK: - UI

    func setupUI() {
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Constraints

    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Property

    var onDidSelect: ((User) -> Void)?
    var nickName: String?

    private var chatViewModel = ChatViewModel()

    private let tableView = UITableView().then {
        $0.tableFooterView = UIView()
        $0.backgroundColor = .white
        $0.register(UINib(nibName: "ChatListTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListTableViewCell")
    }
}
