//
//===--- SCLayoutViewVC.swift - Defines the SCLayoutViewVC class ----------===//
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

/// 页面布局示例
class SCLayoutViewVC: BaseViewController {
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
        title = "页面布局"
        scrollViewLayout()
    }

    /// 使用scrollView进行页面布局
    private func scrollViewLayout() {
        let scrollView = UIScrollView().then {
            $0.backgroundColor = .orange
        }
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let sizeView = UIView()
        scrollView.addSubview(sizeView)
        sizeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let redView = UIView().then {
            $0.backgroundColor = .red
        }
        sizeView.addSubview(redView)
        redView.snp.makeConstraints { make in
            make.top.left.right.equalTo(sizeView)
            // 确定高度，撑起来竖直方向
            make.height.equalTo(500)
            // 确定宽度，撑起来水平方向；这里水平方向上有一个子视图撑起来，整个sizeView就会被撑起来
            make.width.equalTo(scrollView)
        }

        let blueView = UIView().then {
            $0.backgroundColor = .blue
        }
        sizeView.addSubview(blueView)
        blueView.snp.makeConstraints { make in
            make.top.equalTo(redView.snp.bottom)
            make.bottom.left.right.equalTo(sizeView)
            // 确定高度，撑起来竖直方向
            make.height.equalTo(700)
        }
    }

    // MARK: - Constraints

    private func setupConstraints() {}

    // MARK: - Property
}
