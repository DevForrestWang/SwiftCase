//
//===--- SCSelectDayView.swift - Defines the SCSelectDayView class ----------===//
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

class SCSelectDayView: SCPopupBaseView {
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
        SC.log("===========<deinit: \(type(of: self))>===========")
    }

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - IBActions

    @objc private func confirmAction() {
        if let tmpStart = startDay, let tmpEnd = endDay, let tempClourse = gyActivitySelectDayClosure {
            tempClourse(tmpStart, tmpEnd)
            closeAction()
        }
    }

    // MARK: - Private

    // MARK: - UI

    private func setupUI() {
        SC.log("===========<loadClass: \(type(of: self))>===========")
        contentView.addSubview(calendarPickerView)
        contentView.addSubview(confirmBtn)

        calendarPickerView.minimumDate = Date()
        calendarPickerView.maximumDate = Calendar.current.date(byAdding: .month, value: 6, to: Date())

        calendarPickerView.selectedStartDate = startDay
        if startDay == nil {
            calendarPickerView.selectedStartDate = Date()
        }

        calendarPickerView.selectedEndDate = endDay
        if endDay == nil {
            calendarPickerView.selectedEndDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        }

        calendarPickerView.selectedColor = .red
        calendarPickerView.gySelectDataRangeClosure = { [weak self] startDate, endDate in
            self?.startDay = startDate
            self?.endDay = endDate
        }
        calendarPickerView.getDefaultDate()

        rightTitleButton.setImage(UIImage(named: "gy_member_activity_close"), for: .normal)
        rightTitleButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        confirmBtn.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        calendarPickerView.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp.bottom).offset(20)
            make.bottom.equalTo(confirmBtn.snp.top).offset(-10)
            make.left.right.equalToSuperview()
        }

        confirmBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-(10 + gBottomSafeHeight))
            make.height.equalTo(44)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }

    // MARK: - Property

    public var gyActivitySelectDayClosure: ((_ startDay: Date, _ endDay: Date) -> Void)?

    private var startDay: Date?
    private var endDay: Date?

    let calendarPickerView = SCalendarDateRangePickerView()

    let confirmBtn = UIButton(type: .custom).then {
        $0.backgroundColor = .red
        $0.setTitle("确定", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14.0)
        $0.layer.cornerRadius = 22
    }
}
