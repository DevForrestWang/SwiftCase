//
//===--- UIView+Extension.swift - Defines the UIView+Extension class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wfd on 2022/1/27.
// Copyright © 2022 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import Foundation
import UIKit

public extension UIView {
    /// 显示当前View边框
    func showBorder(_ color: UIColor = .blue, _ width: CGFloat = 1) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }

    /// 显示View及子View边框
    func showAllBoder(_ color: UIColor = .blue, _ width: CGFloat = 1) {
        for view in subviews {
            view.showBorder(color, width)

            if view.subviews.count > 0 {
                view.showAllBoder(color, width)
            }
        }
    }
    
    /// 绘制虚线
    func drawDottedLine(_ rect: CGRect, _ radius: CGFloat, _ color: UIColor) {
        let layer = CAShapeLayer()
        layer.bounds = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
        layer.position = CGPoint(x: rect.midX, y: rect.midY)
        layer.path = UIBezierPath(rect: layer.bounds).cgPath
        layer.path = UIBezierPath(roundedRect: layer.bounds, cornerRadius: radius).cgPath
        layer.lineWidth = 1/UIScreen.main.scale
        //虚线边框
        layer.lineDashPattern = [NSNumber(value: 5), NSNumber(value: 5)]
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color.cgColor
        
        self.layer.addSublayer(layer)
    }
}
