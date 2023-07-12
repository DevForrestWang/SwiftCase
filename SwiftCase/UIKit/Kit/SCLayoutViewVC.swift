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

    @objc func changeLableAction(recognizer _: UITapGestureRecognizer) {
        dynamicLable.text! += ", \(dynamicLable.text!)"
    }

    @objc func change2LableAction(recognizer _: UITapGestureRecognizer) {
        dynamicTwoLable.text! += ", \(dynamicTwoLable.text!)"
    }

    // MARK: - Private

    // MARK: - UI

    private func setupUI() {
        title = "页面布局"
        scrollViewLayout()

        let tapGest = UITapGestureRecognizer(target: self, action: #selector(changeLableAction))
        dynamicLable.addGestureRecognizer(tapGest)
        dynamicLable.isUserInteractionEnabled = true

        let tapGest2 = UITapGestureRecognizer(target: self, action: #selector(change2LableAction))
        dynamicTwoLable.addGestureRecognizer(tapGest2)
        dynamicTwoLable.isUserInteractionEnabled = true
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
            // 确定高度撑起竖直方向
            make.height.equalTo(200)
            // 确定宽度撑起水平方向；水平方向上有一个子视图撑起来，整个sizeView会被撑起来
            make.width.equalTo(scrollView)
        }

        sizeView.addSubview(dynamicLable)
        dynamicLable.snp.makeConstraints { make in
            make.top.equalTo(redView.snp.bottom)
            make.left.right.equalTo(sizeView)
            // 确定高度撑起竖直方向
            make.height.greaterThanOrEqualTo(40)
        }

        sizeView.addSubview(dynamicTwoLable)
        dynamicTwoLable.snp.makeConstraints { make in
            make.top.equalTo(dynamicLable.snp.bottom)
            make.bottom.left.right.equalTo(sizeView)
            make.height.greaterThanOrEqualTo(40)
        }
    }

    // MARK: - Constraints

    private func setupConstraints() {}

    // MARK: - Property

    let dynamicLable = UILabel().then {
        $0.text = "One: 点击会变大！"
        $0.backgroundColor = .cyan
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }

    let dynamicTwoLable = UILabel().then {
        $0.text = "Two: 点击会变大！"
        $0.backgroundColor = .green
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
}
