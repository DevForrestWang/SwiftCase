//
//===--- GYMainChatViewController.swift - Defines the GYMainChatViewController class ----------===//
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

class GYMainChatVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    // 执行析构过程
    deinit {
        yxc_debugPrint("===========<deinit: \(type(of: self))>===========")
    }

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - UITableViewDelegate

    func numberOfSections(in _: UITableView) -> Int {
        return dataSourceHeads.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = dataSourceHeads[section]
        let dataAry = dataSource[key]
        return dataAry?.count ?? 0
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 21
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let strTime = timeStampToRead(timeStamp: dataSourceHeads[section])
        let lable = UILabel().then {
            $0.text = strTime
            $0.textColor = UIColor.hexColor(0x828282)
            $0.font = .systemFont(ofSize: 14)
            $0.textAlignment = .center
        }
        lable.frame = CGRect(x: 20, y: 0, width: UIScreen.main.bounds.width, height: 21)
        return lable
    }

    func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_: UITableView, viewForFooterInSection _: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let key = dataSourceHeads[indexPath.section]
        let dataAry = dataSource[key]
        guard indexPath.row < dataAry?.count ?? 0, let model: GYMainChatModel = dataAry?[indexPath.row] else {
            return GYMainChatBaseInfoCell()
        }

        var cell = GYMainChatBaseInfoCell()
        if model.messageTpye == .picture {
            if let tmpCell = tableView.dequeueReusableCell(withIdentifier: "GYMainChatPictureCell", for: indexPath) as? GYMainChatPictureCell {
                tmpCell.update(model: model, dataSource: dataSource)
                cell = tmpCell
            }
        } else if model.messageTpye == .voice {
            if let tmpCell = tableView.dequeueReusableCell(withIdentifier: "GYMainChatVoiceCell", for: indexPath) as? GYMainChatVoiceCell {
                tmpCell.update(model: model)
                cell = tmpCell
            }
        } else if model.messageTpye == .text {
            if let tmpCell = tableView.dequeueReusableCell(withIdentifier: "GYMainChatTextCell", for: indexPath) as? GYMainChatTextCell {
                tmpCell.update(model: model)
                cell = tmpCell
            }
        }

        cell.gyMainChatCellClosure = { _, _ in
        }

        cell.selectionStyle = .none
        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let key = dataSourceHeads[indexPath.section]
        let dataAry = dataSource[key]
        if indexPath.row < dataAry?.count ?? 0, let model: GYMainChatModel = dataAry?[indexPath.row] {
            yxc_debugPrint("item select: \(String(describing: model))")
        }
    }

    // MARK: - IBActions

    @objc func singleTapAction(recognizer _: UITapGestureRecognizer) {
        view.endEditing(true)
        chatInputView.hiddenMoreInput()
    }

    // MARK: - Private

    private func addDataSource(key: String, model: GYMainChatModel) {
        if dataSourceHeads.contains(key) {
            dataSource[key]?.append(model)
        } else {
            dataSource[key] = [model]
            dataSourceHeads.append(key)
        }
    }

    private func scrollToBottom() {
        if dataSourceHeads.count < 1 {
            yxc_debugPrint("The dataSourceHeads less 1.")
            return
        }
        let section = dataSourceHeads.count - 1
        let dataAry = dataSource[dataSourceHeads[section]]
        let dataCount = dataAry?.count ?? 0
        if dataCount < 1 {
            yxc_debugPrint("The dataAry less 1.")
            return
        }

        let indexPath = IndexPath(row: dataCount - 1, section: section)
        chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }

    private func timeStampToRead(timeStamp: String) -> String {
        let timeStamp = timeStamp.toDouble() ?? 0
        let date = NSDate(timeIntervalSince1970: timeStamp) as Date
        let strHour = date.toString(withFormat: "HH:mm")

        if Calendar.current.isDateInToday(date) {
            return "今天\(strHour)"
        } else if Calendar.current.isDateInYesterday(date) {
            return "昨天\(strHour)"
        }

        return date.toString(withFormat: "yyyy-MM-dd HH:mm")
    }

    private func insertChatData(key: String, model: GYMainChatModel) {
        // 添加数据前检测是否包含，如果包含则插入，不包含从新加载表格；表格不支持新section的插入
        let section = dataSourceHeads.firstIndex(of: key) ?? 0
        addDataSource(key: key, model: model)

        if section > 0 {
            let dataAry = dataSource[key]
            let indexPath = IndexPath(row: (dataAry?.count ?? 1) - 1, section: section)
            chatTableView.beginUpdates()
            chatTableView.insertRows(at: [indexPath], with: .automatic)
            chatTableView.endUpdates()
            chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        } else {
            chatTableView.reloadData()
            scrollToBottom()
        }
    }

    private func initData() {
        let imageURL = GYChatDefaultModel().imageURL

        let m1 = GYMainChatModel()
        m1.sendType = .acceptInfo
        m1.messageTpye = .text
        m1.msg = "文本字符文本字符文本字符文本字符文本字符文本字符文本字符文本字符文本字符"
        // yyyy-MM-dd HH:mm:ss
        m1.msgTimeStamp = floor("2022-06-02 10:10:01".toDate()?.timeIntervalSince1970 ?? 0)
        let u1 = GYCCharUserInfo()
        m1.userInfo = u1
        u1.userName = "张三"
        u1.levelName = "店员"
        u1.userAvatar = imageURL
        insertChatData(key: "\(m1.msgTimeStamp)", model: m1)

        let m2 = GYMainChatModel()
        m2.sendType = .sendInfo
        m2.messageTpye = .picture
        m2.msg = ["imgUrl": imageURL]
        m2.msgTimeStamp = floor("2022-06-03 10:10:01".toDate()?.timeIntervalSince1970 ?? 0)
        let u2 = GYCCharUserInfo()
        m2.userInfo = u2
        u2.userName = "李四"
        u2.levelName = "店主"
        u2.userAvatar = imageURL
        insertChatData(key: "\(m2.msgTimeStamp)", model: m2)
    }

    // MARK: - UI

    private func setupUI() {
        yxc_debugPrint("===========<loadClass: \(type(of: self))>===========")
        title = "会员福利群"

        view.addSubview(chatTableView)
        chatTableView.delegate = self
        chatTableView.dataSource = self

        view.addSubview(chatInputView)
        chatInputView.parentVc = self
        chatInputView.gyChatInputClosure = { inputType, inputInfo in
            yxc_debugPrint("type: \(inputType), info:\(inputInfo)")

            if inputType == .switchGroup {
            } else if inputType == .redPackage {
            } else if inputType == .pushActive {
            } else if inputType == .commendGoods {
            } else if inputType == .sendText || inputType == .sendEmoji {
                let model = GYMainChatModel()
                model.sendType = .sendInfo
                model.messageTpye = .text
                model.msg = inputInfo
                // 只保留到分钟
                let strDate = Date().toString(withFormat: "yyyy-MM-dd HH:mm")
                let timpStamp = floor(strDate.toDate(withFormat: "yyyy-MM-dd HH:mm")?.timeIntervalSince1970 ?? 0)
                model.msgTimeStamp = timpStamp

                let infoModel = GYCCharUserInfo()
                model.userInfo = infoModel
                infoModel.userName = "李四"
                infoModel.levelName = "店主"
                infoModel.userAvatar = GYChatDefaultModel().imageURL

                self.insertChatData(key: "\(model.msgTimeStamp)", model: model)
            } else if inputType == .sendVoice {}
        }

        let singleFinger = UITapGestureRecognizer(target: self, action: #selector(singleTapAction))
        singleFinger.numberOfTapsRequired = 1
        singleFinger.numberOfTouchesRequired = 1
        chatTableView.addGestureRecognizer(singleFinger)

        initData()
    }

    // MARK: - Constraints

    private func setupConstraints() {
        chatTableView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.bottom.equalTo(chatInputView.snp.top)
            make.width.equalToSuperview()
        }

        chatInputView.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-gBottomSafeHeight)
            make.width.equalToSuperview()
        }
    }

    // MARK: - Property

    let chatTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = UIColor.hexColor(0xEEEEEE)
        $0.tableFooterView = UIView()
        $0.tableHeaderView = UIView()
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.register(GYMainChatTextCell.self, forCellReuseIdentifier: "GYMainChatTextCell")
        $0.register(GYMainChatPictureCell.self, forCellReuseIdentifier: "GYMainChatPictureCell")
        $0.register(GYMainChatVoiceCell.self, forCellReuseIdentifier: "GYMainChatVoiceCell")
    }

    var dataSourceHeads: [String] = []
    // key:时间戳，value：时间戳下的数据
    var dataSource: [String: [GYMainChatModel]] = .init()

    let chatInputView = GYChatInputView()
}
