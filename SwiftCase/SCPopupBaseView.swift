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

    public func show(_ contentHeight: CGFloat, headIcon _: Bool = false, titleName: String, vc: UIViewController? = nil) {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)

        // 隐藏横线图标
        headIconImage.isHidden = true
        if headIconImage.isHidden {
            headView.snp.updateConstraints { make in
                make.top.equalTo(-10)
                make.height.equalTo(20)
            }
            headView.layer.cornerRadius = 10
        }

        if titleName.isEmpty {
            titleLable.isHidden = true
        } else {
            titleLable.isHidden = false
            titleLable.text = titleName
        }

        topBarHeight = 0
        if let tmpVC = vc {
            topBarHeight = CGFloat(SC.topBarHeight)
            // 如果隐藏导航栏
            if let barState = tmpVC.navigationController?.navigationBar.isHidden {
                if barState {
                    topBarHeight = 0
                }
            }
            tmpVC.view.addSubview(self)
            reSetupConstraints()
        } else {
            // 解决 IQKeyboard 添加到 keyWindow 视图失效问题
            SC.window?.rootViewController?.view.addSubview(self)
        }

        updateContentHeight(contentHeight)

        if isAnimate {
            // 弹出动画
            contentView.frame = CGRectMake(0, SC.h, SC.w, contentHeight - 20)
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.contentView.frame.origin.y = SC.h - contentHeight - 20
            }
        }
    }

    public func updateContentHeight(_ contentHeight: CGFloat) {
        contentView.snp.updateConstraints { make in
            make.height.equalTo(contentHeight - 20)
        }
    }

    public func clearBgView() {
        backgroundColor = .clear
    }

    public func addContentiew(_ view: UIView) {
        contentView.addSubview(view)
    }

    public func expandTitle() {
        leftTitleButton.isHidden = true
        rightTitleButton.isHidden = true
        titleLable.font = .systemFont(ofSize: 20)
        titleLable.snp.remakeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.height.equalTo(30)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
        }
    }

    // MARK: - Protocol

    // MARK: - IBActions

    @objc public func closeAction() {
        if isAnimate {
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                self?.contentView.frame.origin.y = SC.h
            }, completion: { [weak self] _ in
                self?.removeFromSuperview()
            })
        } else {
            removeFromSuperview()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        let touch = (touches as NSSet).anyObject() as! UITouch
        guard let result = touch.view?.isDescendant(of: contentView) else { return }
        if !result, closeBGView {
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
        frame = CGRect(x: 0, y: 0, width: SC.w, height: SC.h)

        addSubview(contentView)
        contentView.addSubview(headView)
        headView.addSubview(headIconImage)
        contentView.addSubview(leftTitleButton)
        contentView.addSubview(titleLable)
        contentView.addSubview(rightTitleButton)

        hideKeyboardWhenTapedAround()
    }

    // MARK: - Constraints

    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(SC.h / 2)
        }

        headView.snp.makeConstraints { make in
            make.top.equalTo(-20)
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }

        headIconImage.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(20)
            make.center.equalToSuperview()
        }

        leftTitleButton.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.height.equalTo(30)
            make.width.equalTo(100)
            make.left.equalToSuperview().offset(15)
        }

        rightTitleButton.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.height.equalTo(30)
            make.width.equalTo(100)
            make.right.equalToSuperview().offset(-15)
        }

        titleLable.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.height.equalTo(30)
            make.left.equalTo(leftTitleButton.snp.right)
            make.right.equalTo(rightTitleButton.snp.left)
        }
    }

    private func reSetupConstraints() {
        frame = CGRect(x: 0, y: 0, width: SC.w, height: SC.h - topBarHeight)

        contentView.snp.remakeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo((SC.h - topBarHeight) / 2)
        }
    }

    // MARK: - Property

    @objc public var closeBGView = true

    @objc public var isAnimate = false

    public let contentView = UIView().then {
        $0.backgroundColor = UIColor.hexColor(0xFEFFFF)
    }

    // 是否在当前控制器上显示
    private var topBarHeight: CGFloat = 0

    private let headView = UIView().then {
        $0.backgroundColor = UIColor.hexColor(0xFEFFFF)
        $0.layer.cornerRadius = 20
    }

    private let headIconImage = UIImageView().then {
        $0.image = UIImage(named: "gy_assistant_head_icon")
    }

    @objc public let titleLable = UILabel().then {
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
