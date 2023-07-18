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

    @objc private func showImageView() {
        let imageView = SCBrowseImageView()
        let baseURL = "https://cdn.pixabay.com/photo"
        let imageURL: NSArray = [baseURL + "/2021/08/19/12/53/bremen-6557996_960_720.jpg",
                                 baseURL + "/2020/09/01/21/03/sunset-5536777_960_720.jpg",
                                 baseURL + "/2020/07/21/16/24/landscape-5426755_960_720.jpg",
                                 baseURL + "/2021/09/07/11/53/car-6603726_960_720.jpg",
                                 baseURL + "/2021/07/30/17/58/dragonfly-6510395_960_720.jpg",
                                 baseURL + "/2021/09/12/15/18/sunflowers-6618618_960_720.jpg"]

        imageView.show(imageURL)
    }

    // MARK: - Private

    // MARK: - UI

    private func setupUI() {
        title = "弹出菜单"

        view.addSubview(calendarBtn)
        view.addSubview(showImageBtn)
        calendarBtn.addTarget(self, action: #selector(showCalendarAction), for: .touchUpInside)
        showImageBtn.addTarget(self, action: #selector(showImageView), for: .touchUpInside)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        calendarBtn.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-44)
        }

        showImageBtn.snp.makeConstraints { make in
            make.width.height.equalTo(calendarBtn)
            make.centerX.equalToSuperview()
            make.top.equalTo(calendarBtn.snp.bottom).offset(40)
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

    let showImageBtn = UIButton(type: .custom).then {
        $0.backgroundColor = .white
        $0.setTitle("浏览图片", for: .normal)
        $0.setTitleColor(UIColor.hexColor(0x3F6D03), for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14.0)
        $0.layer.cornerRadius = 5
    }
}
