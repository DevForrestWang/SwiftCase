//
//===--- SCScreenFPS.swift - Defines the SCScreenFPS class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by Forrest on 2023/6/22.
// Copyright © 2023 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import SnapKit
import Then
import UIKit

/// 查看屏幕帧数
/// 使用方法：
///      显示：SCScreenFPS.show()
///      隐藏：SCScreenFPS.dismiss()
///
class SCScreenFPS: NSObject {
    // MARK: - Lifecycle

    /// 显示屏幕帧数
    public static func show() {
        screenObj = SCScreenFPS()
    }

    /// 关闭屏幕帧数
    public static func dismiss() {
        screenObj?.closeFefresh()
    }

    override private init() {
        super.init()

        displayLink = CADisplayLink(target: self, selector: #selector(screenFefresh(link:)))
        displayLink?.add(to: RunLoop.current, forMode: .common)
        setupUI()
        setupConstraints()
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - IBActions

    @objc private func screenFefresh(link: CADisplayLink) {
        if lastTime == 0 {
            lastTime = link.timestamp
            return
        }

        count += 1
        let delta = link.timestamp - lastTime

        if delta < 1 {
            return
        }

        lastTime = link.timestamp
        let fps = Double(count) / delta

        count = 0

        let text = String(format: "%02.0f帧", round(fps))
        fwDebugPrint(text)
        tipsLable.text = text
    }

    // MARK: - Private

    private func closeFefresh() {
        tipsLable.removeFromSuperview()
        displayLink?.invalidate()
        displayLink = nil
    }

    // MARK: - UI

    private func setupUI() {
        UIWindow.keyWindow?.addSubview(tipsLable)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        tipsLable.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(30)
            make.top.equalToSuperview().offset(gTopBarHeight)
            make.right.equalToSuperview().offset(-10)
        }
    }

    // MARK: - Property

    private static var screenObj: SCScreenFPS?

    private var displayLink: CADisplayLink?

    private var lastTime: TimeInterval = 0.0

    private var count: Int = 0

    let tipsLable = UILabel().then {
        $0.text = ""
        $0.backgroundColor = UIColor.hexColor(0x45B5F0)
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .center
        $0.layer.zPosition = 1
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
}
