//
//===--- SCAttributedStringVC.swift - Defines the SCAttributedStringVC class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2022/12/5.
// Copyright © 2022 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import UIKit

class SCAttributedStringVC: BaseViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    // 执行析构过程
    deinit {
        fwDebugPrint("===========<deinit: \(type(of: self))>===========")
    }

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - IBActions

    // MARK: - Private

    // MARK: - UI

    private func setupUI() {
        fwDebugPrint("===========<loadClass: \(type(of: self))>===========")
    }

    // MARK: - Constraints

    private func setupConstraints() {}

    // MARK: - Property
}
