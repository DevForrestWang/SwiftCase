//
//===--- SCLayoutByStackViewVC.swift - Defines the SCLayoutByStackViewVC class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2023/7/12.
// Copyright © 2023 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import SnapKit
import Then
import UIKit

class SCLayoutByStackViewVC: BaseViewController {
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

    // MARK: - Private

    private func initHorStackView() {
        view.addSubview(horStackView)
        horStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(30)
        }

        for i in 0 ..< 3 {
            let lab = createLable(title: "标签\(i + 1)", color: UIColor.randomColor)
            horStackView.addArrangedSubview(lab)
        }
    }

    private func initVerStackView() {
        view.addSubview(verStackView)
        verStackView.snp.makeConstraints { make in
            make.top.equalTo(horStackView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(300)
        }

        for i in 0 ..< 3 {
            let lab = createLable(title: "标签\(i + 1)", color: UIColor.randomColor)
            verStackView.addArrangedSubview(lab)
        }
    }

    private func createLable(title: String, color: UIColor) -> UILabel {
        let threeLable = UILabel().then {
            $0.backgroundColor = color
            $0.text = title
            $0.textColor = UIColor.hexColor(0x010203)
            $0.font = .systemFont(ofSize: 14)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        return threeLable
    }

    // MARK: - UI

    private func setupUI() {
        title = "UIStackView页面布局"
        initHorStackView()
        initVerStackView()
    }

    // MARK: - Constraints

    private func setupConstraints() {}

    // MARK: - Property

    let horStackView = UIStackView().then {
        $0.backgroundColor = .orange
        $0.axis = .horizontal // 水平方向
        $0.spacing = 10.0 // 间距
        $0.distribution = .fillEqually // 等宽
    }

    let verStackView = UIStackView().then {
        $0.backgroundColor = .cyan
        $0.axis = .vertical // 垂直方向
        $0.spacing = 10.0
        $0.distribution = .fillEqually
        $0.alignment = .center
    }
}
