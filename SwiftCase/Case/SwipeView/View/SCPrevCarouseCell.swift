//
//===--- SCPrevCarouseCell.swift - Defines the SCPrevCarouseCell class ----------===//
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

class SCPrevCarouseCell: UICollectionViewCell {
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
        backgroundColor = .orange // UIColor.hexColor(0xFEFFFF)
        addSubview(tLable)
    }

    // MARK: - Constraints

    func setupConstraints() {
        tLable.snp.makeConstraints { make in
            make.height.equalTo(21)
            make.width.equalTo(150)
            make.center.equalToSuperview()
        }
    }

    // MARK: - Property

    let tLable = UILabel().then {
        $0.textColor = .red
        $0.text = "固定积分登记码"
        $0.font = .systemFont(ofSize: 16)
    }
}
