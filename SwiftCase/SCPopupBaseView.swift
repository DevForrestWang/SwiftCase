//
//===--- GYPopupBaseView.swift - Defines the GYPopupBaseView class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/9/26.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import SnapKit
import Then
import UIKit

/// 弹出页面基本视图
class SCPopupBaseView: UIView {
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    public func show(_ contentHeight: CGFloat, headIcon: Bool, titleName: String, vc: UIViewController? = nil) {
        headIconImage.isHidden = true
        if headIcon {
            headIconImage.isHidden = false
        }

        if titleName.isEmpty {
            titleLable.isHidden = true
        } else {
            titleLable.isHidden = false
            titleLable.text = titleName
        }

        topBarHeight = 0
        if let tmpVC = vc {
            topBarHeight = CGFloat(gTopBarHeight)
            tmpVC.view.addSubview(self)
            reSetupConstraints()
        } else {
            // 解决 IQKeyboard 添加到 keyWindow 视图失效问题
            UIWindow.key?.rootViewController?.view.addSubview(self)
        }

        updateContentHeight(contentHeight)
    }

    public func updateContentHeight(_ contentHeight: CGFloat) {
        bgView.snp.updateConstraints { make in
            make.height.equalTo(gScreenWidth - topBarHeight - contentHeight + 20)
        }

        contentView.snp.updateConstraints { make in
            make.height.equalTo(contentHeight - 20)
        }
    }

    public func clearBgView() {
        bgView.backgroundColor = .clear
    }

    // MARK: - Protocol

    // MARK: - IBActions

    @objc public func closeAction() {
        removeFromSuperview()
    }

    @objc private func bgTabAction() {
        if closeBGView {
            closeAction()
        }
    }

    // MARK: - Private

    /// 隐藏键盘
    private func hideKeyboardWhenTapedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        endEditing(true)
    }

    // MARK: - UI

    private func setupUI() {
        frame = CGRect(x: 0, y: 0, width: gScreenWidth, height: gScreenWidth)
        backgroundColor = .clear

        addSubview(bgView)
        addSubview(contentView)
        contentView.addSubview(headView)
        headView.addSubview(headIconImage)
        contentView.addSubview(leftTitleButton)
        contentView.addSubview(titleLable)
        contentView.addSubview(rightTitleButton)

        let closeGesture = UITapGestureRecognizer(target: self, action: #selector(bgTabAction))
        closeGesture.numberOfTapsRequired = 1
        closeGesture.numberOfTouchesRequired = 1
        bgView.addGestureRecognizer(closeGesture)

        hideKeyboardWhenTapedAround()
    }

    // MARK: - Constraints

    private func setupConstraints() {
        bgView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.width.equalToSuperview()
            make.height.equalTo(gScreenWidth * viewScale / 2)
        }

        contentView.snp.makeConstraints { make in
            make.top.equalTo(bgView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(gScreenWidth * viewScale / 2)
        }

        headView.snp.makeConstraints { make in
            make.top.equalTo(-20 * viewScale)
            make.width.equalToSuperview()
            make.height.equalTo(40 * viewScale)
        }

        headIconImage.snp.makeConstraints { make in
            make.width.equalTo(50 * viewScale)
            make.height.equalTo(20 * viewScale)
            make.center.equalToSuperview()
        }

        leftTitleButton.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.height.equalTo(21 * viewScale)
            make.width.equalTo(100 * viewScale)
            make.left.equalToSuperview().offset(15)
        }

        rightTitleButton.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.height.equalTo(21 * viewScale)
            make.width.equalTo(100 * viewScale)
            make.right.equalToSuperview().offset(-15)
        }

        titleLable.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.height.equalTo(21 * viewScale)
            make.left.equalTo(leftTitleButton.snp.right)
            make.right.equalTo(rightTitleButton.snp.left)
        }
    }

    private func reSetupConstraints() {
        frame = CGRect(x: 0, y: 0, width: gScreenWidth, height: gScreenWidth - topBarHeight)

        bgView.snp.remakeConstraints { make in
            make.top.equalTo(0)
            make.width.equalToSuperview()
            make.height.equalTo((gScreenWidth - topBarHeight) * viewScale / 2)
        }

        contentView.snp.remakeConstraints { make in
            make.top.equalTo(bgView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo((gScreenWidth - topBarHeight) * viewScale / 2)
        }
    }

    // MARK: - Property

    public var closeBGView = true

    public let contentView = UIView().then {
        $0.backgroundColor = UIColor.hexColor(0xFEFFFF)
    }

    // 是否在当前控制器上显示
    private var topBarHeight: CGFloat = 0

    private let viewScale = gEqualScale

    private let bgView = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }

    private let headView = UIView().then {
        $0.backgroundColor = UIColor.hexColor(0xFEFFFF)
        $0.layer.cornerRadius = device_6S_7_8 ? 25 * 0.8 : 25
    }

    private let headIconImage = UIImageView().then {
        $0.image = UIImage(named: "gy_assistant_head_icon")
    }

    public let titleLable = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 20)
        $0.adjustsFontSizeToFitWidth = true
        $0.textAlignment = .center
    }

    public let leftTitleButton = UIButton(type: .custom).then {
        $0.backgroundColor = .white
        $0.contentHorizontalAlignment = .left
    }

    public let rightTitleButton = UIButton(type: .custom).then {
        $0.backgroundColor = .white
        $0.contentHorizontalAlignment = .right
    }
}
