//
//===--- SCPopListViewVC.swift - Defines the SCPopListViewVC class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2023/6/15.
// Copyright © 2023 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import UIKit

/// 弹出菜单演示
class SCPopListViewVC: BaseViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // 底部按钮偏移问题
        edgesForExtendedLayout = UIRectEdge.all

        setupUI()
        setupConstraints()
    }

    // 执行析构过程
    deinit {
        debugPrint("===========<deinit: \(type(of: self))>===========")
    }

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - IBActions

    @objc private func showPopViewAction(button: UIButton) {
        let popView = SCPopListView(titleNames: titleNames, imageNames: imageNames, iconLeft: false)
        popView.popListViewSelectItemClosure = { name, index in
            print("select, name:\(name), index:\(index)")
        }

        popView.showPopView(targetView: button)
    }

    @objc private func bottomPopViewAction(button: UIButton) {
        let popView = SCPopListView(titleNames: titleNames, imageNames: imageNames)
        popView.popListViewSelectItemClosure = { name, index in
            print("select, name:\(name), index:\(index)")
        }

        // popView.cellHeight = 50
        let point = button.convert(button.bounds.origin, to: view)
        popView.showPopView(arrowPoint: CGPoint(x: point.x + button.frame.width / 2, y: point.y + 40), targetRect: button.frame)
//        popView.showPopView(targetView: button)
    }

    // MARK: - Private

    // MARK: - UI

    private func setupUI() {
        title = "弹出菜单"
        view.backgroundColor = .white

        view.addSubview(popViewBtn)
        view.addSubview(bottomPopBtn)

        popViewBtn.addTarget(self, action: #selector(showPopViewAction), for: .touchUpInside)
        bottomPopBtn.addTarget(self, action: #selector(bottomPopViewAction), for: .touchUpInside)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        popViewBtn.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(44)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }

        bottomPopBtn.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-50)
            make.right.equalToSuperview().offset(-100)
        }
    }

    // MARK: - Property

    let imageNames = ["gy_chat_commend_goods", "gy_chat_delivery_order", "", "", "gy_chat_commend_goods"]
    let titleNames = ["发图文发图文发图文", "拍小视频拍小视频", "上传视频拍小视频", "上传视频拍小视频2", "上传视频3", "上传视频4", "上传视频5"]

    let popViewBtn = UIButton(type: .custom).then {
        $0.backgroundColor = .white
        $0.setTitle("显示弹出菜单", for: .normal)
        $0.setTitleColor(UIColor.blue, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16.0)
    }

    let bottomPopBtn = UIButton(type: .custom).then {
        $0.backgroundColor = .white
        $0.setTitle("底部显示弹出菜单", for: .normal)
        $0.setTitleColor(UIColor.blue, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16.0)
    }
}
