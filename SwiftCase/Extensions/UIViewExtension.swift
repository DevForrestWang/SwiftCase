//
//  UIViewEextension.swift
//  SwiftDemo
//
//  Created by GGT on 2021/8/10.
//

import Foundation
import UIKit

public extension CACornerMask {
    /// 左上
    static let topLeft: CACornerMask = .layerMinXMinYCorner
    /// 右上
    static let topRight: CACornerMask = .layerMaxXMinYCorner
    /// 左下
    static let bottomLeft: CACornerMask = .layerMinXMaxYCorner
    /// 右下
    static let bottomRight: CACornerMask = .layerMaxXMaxYCorner
    /// 所有角
    static let all: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    /// 没有圆角
    static let none: CACornerMask = []
    /// 顶部两边
    static let top: CACornerMask = [.topLeft, .topRight]
    /// 底部两边
    static let bottom: CACornerMask = [.bottomLeft, .bottomRight]
}

public extension UIView {
    /// View 的 X 值
    var yxc_x: CGFloat {
        set {
            let oldFrame = frame
            frame = CGRect(x: newValue,
                           y: oldFrame.origin.y,
                           width: oldFrame.size.width,
                           height: oldFrame.size.height)
        }
        get {
            frame.origin.x
        }
    }

    /// View 的 Y 值
    var yxc_y: CGFloat {
        set {
            let oldFrame = frame
            frame = CGRect(x: oldFrame.origin.x,
                           y: newValue,
                           width: oldFrame.size.width,
                           height: oldFrame.size.height)
        }
        get {
            frame.origin.y
        }
    }

    /// View 的宽度
    var yxc_width: CGFloat {
        set {
            let oldFrame = frame
            frame = CGRect(x: oldFrame.origin.x, y: oldFrame.origin.y, width: newValue, height: oldFrame.size.height)
        }
        get {
            frame.size.height
        }
    }

    /// View 的高度
    var yxc_height: CGFloat {
        set {
            let oldFrame = frame
            frame = CGRect(x: oldFrame.origin.x, y: oldFrame.origin.y, width: oldFrame.size.width, height: newValue)
        }
        get {
            frame.size.height
        }
    }

    /// View 的 CenterX
    var yxc_centerX: CGFloat {
        set {
            let oldPoint = center
            center = CGPoint(x: newValue, y: oldPoint.y)
        }
        get {
            center.x
        }
    }

    /// View 的 CenterY
    var yxc_centerY: CGFloat {
        set {
            let oldPoint = center
            center = CGPoint(x: oldPoint.x, y: newValue)
        }
        get {
            center.y
        }
    }

    /// View 的 size
    var yxc_size: CGSize {
        set {
            frame.size = newValue
        }
        get {
            frame.size
        }
    }

    /// View 的 origin
    var yxc_origin: CGPoint {
        set {
            frame.origin = newValue
        }
        get {
            frame.origin
        }
    }

    /// View 的 左边的值（X的值）
    var yxc_left: CGFloat {
        set {
            yxc_x = newValue
        }
        get {
            yxc_x
        }
    }

    /// View 的顶部（Y 的值）
    var yxc_top: CGFloat {
        set {
            yxc_y = newValue
        }
        get {
            yxc_y
        }
    }

    /// View 的底部的值（在设置这个值之前，先设置 height）
    var yxc_bottom: CGFloat {
        set {
            yxc_y = newValue - yxc_height
        }
        get {
            yxc_y + yxc_height
        }
    }

    /// View 的右边的值 （在设置这个值之前，先设置 width）
    var yxc_right: CGFloat {
        set {
            yxc_x = newValue - yxc_width
        }
        get {
            yxc_x + yxc_width
        }
    }

    /// 移除所有子视图
    func yxc_removeAllSubViews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }

    /// 显示当前View边框
    func yxc_showBorder(_ color: UIColor = .blue, _ width: CGFloat = 1) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }

    /// 显示View及子View边框
    func yxc_showAllBoder(_ color: UIColor = .blue, _ width: CGFloat = 1) {
        for view in subviews {
            view.yxc_showBorder(color, width)

            if view.subviews.count > 0 {
                view.yxc_showAllBoder(color, width)
            }
        }
    }

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
        layer.lineWidth = 1 / UIScreen.main.scale
        // 虚线边框
        layer.lineDashPattern = [NSNumber(value: 5), NSNumber(value: 5)]
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color.cgColor

        self.layer.addSublayer(layer)
    }

    /// 添加上边框
    func addTopBorder(borderWidth: CGFloat = (1 / UIScreen.main.scale), borderColor: UIColor = UIColor.hexColor(0xEBEBEB)) {
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: -borderWidth, width: frame.size.width, height: borderWidth)
        topBorder.backgroundColor = borderColor.cgColor
        layer.addSublayer(topBorder)
    }

    /// 添加左边框
    func addLeftBorder(borderWidth: CGFloat = (1 / UIScreen.main.scale), borderColor: UIColor = UIColor.hexColor(0xEBEBEB)) {
        let leftBorder = CALayer()
        leftBorder.frame = CGRect(x: -borderWidth, y: 0, width: borderWidth, height: frame.size.height)
        leftBorder.backgroundColor = borderColor.cgColor
        layer.addSublayer(leftBorder)
    }

    /// 添加下边框
    func addBottomBorder(borderWidth: CGFloat = (1 / UIScreen.main.scale), borderColor: UIColor = UIColor.hexColor(0xEBEBEB)) {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        bottomBorder.backgroundColor = borderColor.cgColor
        layer.addSublayer(bottomBorder)
    }

    /// 添加右边框
    func addRightBorder(borderWidth: CGFloat = (1 / UIScreen.main.scale), borderColor: UIColor = UIColor.hexColor(0xEBEBEB)) {
        let rightBorder = CALayer()
        rightBorder.frame = CGRect(x: frame.size.width - borderWidth, y: 0, width: borderWidth, height: frame.size.height)
        rightBorder.backgroundColor = borderColor.cgColor
        layer.addSublayer(rightBorder)
    }

    /// 添加边框
    func addAllBoard(borderWidth: CGFloat = (1 / UIScreen.main.scale), borderColor: UIColor = UIColor.hexColor(0xEBEBEB)) {
        addTopBorder(borderWidth: borderWidth, borderColor: borderColor)
        addLeftBorder(borderWidth: borderWidth, borderColor: borderColor)
        addBottomBorder(borderWidth: borderWidth, borderColor: borderColor)
        addRightBorder(borderWidth: borderWidth, borderColor: borderColor)
    }

    /// 部分圆角设置
    func layerMaskedCorner(maskedCorners: CACornerMask, radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = maskedCorners
    }
}
