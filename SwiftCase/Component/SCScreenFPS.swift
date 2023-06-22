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
        screenObj?.closeRefresh()
    }

    override private init() {
        super.init()

        displayLink = CADisplayLink(target: self, selector: #selector(screenFefresh(link:)))
        // commonMode会添加timer到所有mode上面
        displayLink?.add(to: RunLoop.current, forMode: .common)
        setupUI()
        setupConstraints()
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - IBActions

    /// 记录屏幕刷新次数
    @objc private func screenFefresh(link: CADisplayLink) {
        if lastTime == 0 {
            lastTime = link.timestamp
            return
        }

        // 记录一秒进入次数
        count += 1
        let delta = link.timestamp - lastTime

        // 不足一秒就返回，count记录
        if delta < 1 {
            return
        }

        // 已经到一秒了把lastTime更新至当前时间以便下一次计算
        lastTime = link.timestamp
        let fps = Double(count) / delta
        count = 0
        let text = String(format: "%02.0f帧", round(fps))
        tipsLable.text = text
    }

    /// 进行拖拽操作
    @objc private func dragView(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            if let panView = gesture.view {
                // 手势移动的x和y值随时间变化的总平移量
                let translation = gesture.translation(in: panView)
                // 移动
                panView.transform = panView.transform.translatedBy(x: translation.x, y: translation.y)
                // 复位，相当于现在是起点
                gesture.setTranslation(.zero, in: panView)
            }
        } else if gesture.state == .ended {
            if let panView = gesture.view {
                // 检测X方向不要超出屏幕
                let xPoint = panView.frame.origin.x
                if xPoint < 10 {
                    panView.frame.origin.x = 10
                } else if (xPoint + 60 + 10) > gScreenWidth {
                    panView.frame.origin.x = gScreenWidth - 60 - 10
                }

                // 检测Y方向不要超出屏幕
                let yPoint = panView.frame.origin.y
                if yPoint < gTopBarHeight {
                    panView.frame.origin.y = gTopBarHeight + 10
                } else if (yPoint + 30 + 10 + gBottomSafeHeight) > gScreenHeight {
                    panView.frame.origin.y = gScreenHeight - 30 - 10 - gBottomSafeHeight
                }
            }
        }
    }

    // MARK: - Private

    /// 关闭页面刷新
    private func closeRefresh() {
        tipsLable.removeFromSuperview()
        displayLink?.invalidate()
        displayLink = nil
    }

    // MARK: - UI

    private func setupUI() {
        UIWindow.keyWindow?.addSubview(tipsLable)

        // 添加退拽移动
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragView(gesture:)))
        tipsLable.addGestureRecognizer(panGesture)
        tipsLable.isUserInteractionEnabled = true
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
        $0.layer.cornerRadius = 3
        $0.layer.masksToBounds = true
    }
}
