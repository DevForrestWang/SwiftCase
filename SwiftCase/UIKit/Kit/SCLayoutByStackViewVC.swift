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

    // MARK: - UI

    private func setupUI() {
        title = "UIStackView页面布局"
    }

    // MARK: - Constraints

    private func setupConstraints() {}

    // MARK: - Property
}
