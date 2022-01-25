//
//===--- SCFlexBoxVC.swift - Defines the SCFlexBoxVC class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wfd on 2022/1/25.
// Copyright © 2022 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import UIKit

class SCFlexBoxVC: BaseViewController {
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
        title = "Flexbox Case"
    }

    // MARK: - Constraints

    private func setupConstraints() {}

    // MARK: - Property
}
