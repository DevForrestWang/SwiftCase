//
//===--- ChatDetailsTableView.swift - Defines the ChatDetailsTableView class ----------===//
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

class ChatDetailsTableView: UIView, UITableViewDelegate, UITableViewDataSource {
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
        messageViewModel.arrMessage.subscribe { [weak self] (_: [Message]) in

            guard let self = self else {
                return
            }

            self.tableView.reloadData()
            self.tableView.scrollToBottom(animated: false)
        }
        messageViewModel.getMessagesFromServer()
    }

    // MARK: - Protocol

    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return messageViewModel.arrMessage.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message: Message = messageViewModel.arrMessage.value[indexPath.row]

        if message.nickname == nickName {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageSendTableViewCell") as? MessageSendTableViewCell else {
                return UITableView.emptyCell()
            }

            cell.configureCell(message)
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell") as? MessageTableViewCell else {
            return UITableView.emptyCell()
        }

        cell.configureCell(message)
        return cell
    }

    // MARK: - IBActions

    // MARK: - Private

    // MARK: - UI

    func setupUI() {
        addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - Constraints

    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Property

    var nickName: String?

    private var messageViewModel = MessageViewModel()

    private lazy var tableView = UITableView().then {
        $0.backgroundColor = UIColor.hexColor(0xEDEDED)
        $0.tableFooterView = UIView()
        $0.separatorStyle = .none
        $0.register(UINib(nibName: "MessageSendTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageSendTableViewCell")
        $0.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCell")
    }
}
