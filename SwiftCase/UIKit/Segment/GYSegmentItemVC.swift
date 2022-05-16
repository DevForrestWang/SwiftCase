//
//===--- GYSegmentItemVC.swift - Defines the GYSegmentItemVC class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wfd on 2022/5/16.
// Copyright © 2022 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import JXSegmentedView
import UIKit

class GYSegmentItemVC: UIViewController, JXSegmentedListContainerViewListDelegate {
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

    // MARK: - JXSegmentedListContainerViewListDelegate

    func listView() -> UIView {
        return view
    }

    // MARK: - IBActions

    // MARK: - Private

    // MARK: - UI

    private func setupUI() {}

    // MARK: - Constraints

    private func setupConstraints() {}

    // MARK: - Property
}
