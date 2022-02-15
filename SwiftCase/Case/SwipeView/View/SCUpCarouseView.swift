//
//===--- SCUpCarouseView.swift - Defines the SCUpCarouseView class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/12/21.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import SnapKit
import Then
import UIKit

class SCUpCarouseView: UIView {
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - IBActions

    // MARK: - Private

    // MARK: - UI

    func setupUI() {
        backgroundColor = UIColor.hexColor(0xFEFFFF)
        addSubview(tLable)
    }

    // MARK: - Constraints

    func setupConstraints() {
        tLable.snp.makeConstraints { make in
            make.height.equalTo(21)
            make.width.equalTo(100)
            make.center.equalToSuperview()
        }
    }

    // MARK: - Property//

    let tLable = UILabel().then {
        $0.textColor = .red
        $0.text = "登记积分"
        $0.font = .systemFont(ofSize: 16)
    }
}
