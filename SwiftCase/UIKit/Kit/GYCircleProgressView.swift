//
//===--- CircleProgressView.swift - Defines the CircleProgressView class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2022/6/14.
// Copyright © 2022 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import Foundation
import UIKit

class GYCircleProgressView: UIView {
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 执行析构过程
    deinit {
        print("===========<deinit: \(type(of: self))>===========")
    }

    // MARK: - Public

    public func configure(totalSize: Int = 100,
                          lineWidth: Float = 5.0,
                          totalColor: UIColor = UIColor.hexColor(0x9AA098),
                          processColor: UIColor = UIColor.hexColor(0xF9FBFA))
    {
        self.totalSize = totalSize
        self.lineWidth = lineWidth
        self.totalColor = totalColor
        self.processColor = processColor
    }

    public func setProgress(_ progress: Int) {
        self.progress = progress
        print("progress:\(progress)")
        setNeedsDisplay()
    }

    override func draw(_: CGRect) {
        if staticLayer == nil {
            staticLayer = createLayer(totalSize, totalColor)
        }

        layer.addSublayer(staticLayer)
        if arcLayer != nil {
            arcLayer.removeFromSuperlayer()
        }
        arcLayer = createLayer(progress, processColor)
        layer.addSublayer(arcLayer)
    }

    // MARK: - Private

    private func createLayer(_ progress: Int, _ color: UIColor) -> CAShapeLayer {
        let endAngle = -CGFloat.pi / 2 + (CGFloat.pi * 2) * CGFloat(progress) / CGFloat(totalSize)
        let layer = CAShapeLayer()
        layer.lineWidth = CGFloat(lineWidth)
        layer.strokeColor = color.cgColor
        layer.lineCap = .round
        layer.fillColor = UIColor.clear.cgColor
        let radius = bounds.width / 2 - layer.lineWidth
        let path = UIBezierPath(arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2), radius: radius, startAngle: -CGFloat.pi / 2, endAngle: endAngle, clockwise: true)
        layer.path = path.cgPath
        return layer
    }

    // MARK: - Property

    private var totalSize: Int = 1000
    private var lineWidth: Float = 2.0
    private var totalColor: UIColor = .lightGray
    private var processColor: UIColor = .cyan

    // 为了显示更精细，进度范围设置为 0 ~ 1000
    private var progress: Int = 0

    // 灰色静态圆环
    private var staticLayer: CAShapeLayer!

    // 进度可变圆环
    private var arcLayer: CAShapeLayer!
}
