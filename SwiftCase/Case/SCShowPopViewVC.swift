//
//===--- SCShowPopViewVC.swift - Defines the SCShowPopViewVC class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2023/7/18.
// Copyright © 2023 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import UIKit

/// 显示弹窗菜单
class SCShowPopViewVC: BaseViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - IBActions

    @objc private func showCalendarAction() {
        let pView = SCSelectDayView()
        pView.gyActivitySelectDayClosure = { startDay, endDay in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let startDay = dateFormatter.string(from: startDay)
            let endDay = dateFormatter.string(from: endDay)
            SC.toast("startDay:\(startDay) - endDay:\(endDay)")
        }

        pView.show(SC.h * 0.8, headIcon: false, titleName: "日期选择")
    }

    // MARK: - Private

    // MARK: - UI

    private func setupUI() {
        title = "弹出菜单"

        view.addSubview(calendarBtn)
        calendarBtn.addTarget(self, action: #selector(showCalendarAction), for: .touchUpInside)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        calendarBtn.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-44)
        }
    }

    // MARK: - Property

    let calendarBtn = UIButton(type: .custom).then {
        $0.backgroundColor = .white
        $0.setTitle("选择日期", for: .normal)
        $0.setTitleColor(UIColor.hexColor(0x3F6D03), for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14.0)
        $0.layer.cornerRadius = 5
    }
}
