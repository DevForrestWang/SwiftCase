//
//===--- ItemListViewController.swift - Defines the ItemListViewController class ----------===//
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

import SnapKit
import Then
import UIKit

class ItemListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    @objc func injected() {
        #if DEBUG
            yxc_debugPrint("I've been injected: \(self)")
            setupUI()
            setupConstraints()
        #endif
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    @objc public func expectAction() {
        showToast("Coming soon")
    }

    public func showLogs(_ msg: String = "console logs") {
        showToast(msg)
    }

    func itemDataSource() -> [SCItemModel]? {
        return nil
    }

    // MARK: - Protocol

    // MARK: - UITableViewDelegate

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return itemDataSource()?.count ?? 0
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SCUIKitTableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "SCUIKitTableViewCell")
        cell.selectionStyle = UITableViewCell.SelectionStyle.default
        cell.titleLable.text = itemDataSource()?[indexPath.row].title
        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 50
    }

    // MARK: - UITableViewDataSource

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            yxc_debugPrint("No found namespace")
            return
        }

        guard let model: SCItemModel = itemDataSource()?[indexPath.row] else {
            yxc_debugPrint("The model is empty")
            return
        }

        if model.action != nil {
            // 调用选择器
            perform(model.action)
            return
        }

        guard let conroller: AnyObject.Type = NSClassFromString("\(nameSpace).\(model.controllerName)") else {
            yxc_debugPrint("No found class")
            return
        }

        guard let vc = conroller as? UIViewController.Type else {
            yxc_debugPrint("not UIViewController")
            return
        }

        let tVC = vc.init()
        tVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(tVC, animated: true)
    }

    // MARK: - IBActions

    // MARK: - Private

    // MARK: - UI

    func setupUI() {
        view.backgroundColor = .white

        view.addSubview(tableView)
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

    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.tableFooterView = UIView()
        $0.backgroundColor = .white
        $0.register(SCUIKitTableViewCell.self, forCellReuseIdentifier: "SCUIKitTableViewCell")
    }

    /// action有回调时优先执行
    struct SCItemModel {
        let title: String
        let controllerName: String
        let action: Selector?
    }
}
