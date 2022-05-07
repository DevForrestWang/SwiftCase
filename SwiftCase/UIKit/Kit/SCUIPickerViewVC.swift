//
//===--- SCUIPickerViewVC.swift - Defines the SCUIPickerViewVC class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wfd on 2022/5/7.
// Copyright © 2022 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import UIKit

class SCUIPickerViewVC: BaseViewController, UIPickerViewDataSource, UIPickerViewDelegate {
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

    func numberOfComponents(in _: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return hoursArray.count
        } else {
            return minuteArray.count
        }
    }

    public func pickerView(_: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var itemLabel = view as? UILabel

        if itemLabel == nil {
            itemLabel = UILabel().then {
                $0.textColor = UIColor.hexColor(0x010203)
                $0.font = .systemFont(ofSize: 14)
                $0.textAlignment = .center
            }
        }

        var title = ""
        if component == 0 {
            if row < hoursArray.count {
                title = String(format: "%02d", arguments: [hoursArray[row]])
            }
        } else {
            if row < minuteArray.count {
                title = String(format: "%02d", arguments: [minuteArray[row]])
            }
        }

        itemLabel?.text = title
        return itemLabel!
    }

    // MARK: - IBActions

    // MARK: - Private

    // MARK: - UI

    private func setupUI() {
        title = "UIPickerView"
        view.addSubview(pickerView)
        pickerView.dataSource = self
        pickerView.delegate = self
    }

    // MARK: - Constraints

    private func setupConstraints() {
        pickerView.snp.makeConstraints { make in
            make.height.equalTo(300)
            make.width.equalTo(300)
            make.center.equalToSuperview()
        }
    }

    // MARK: - Property

    let hoursArray = Array(0 ... 23)
    let minuteArray = Array(0 ... 59)

    let pickerView = UIPickerView().then {
        $0.backgroundColor = .white
        $0.selectRow(0, inComponent: 0, animated: true)
    }
}
