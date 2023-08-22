//
//===--- UIView+Extension.swift - Defines the UIView+Extension class ----------===//
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

/// UIView的构造和函数
public extension UIView {
    convenience init(backgroundColor: UIColor = UIColor.white, cornerRadius: CGFloat? = nil) {
        self.init()
        self.backgroundColor = backgroundColor

        if let radius = cornerRadius {
            ex_cornerRadius = radius
        }
    }

    /// 从nib初始化一个View
    static func nib<T>(bundle: Bundle? = nil) -> T {
        return UINib(nibName: named, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as! T
    }

    /// 添加阴影
    func shadow(ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0), radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.2) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }

    /// 添加阴影图层
    func shadowLayer(ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0), radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.5, cornerRadius: CGFloat, bounds: CGRect) {
        let layer = CALayer()
        layer.frame = bounds
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.backgroundColor = UIColor.white.cgColor
        self.layer.insertSublayer(layer, at: 0)
        self.layer.addSublayer(layer)
    }

    /// 移除所有子视图
    func ex_removeAllSubViews() {
        for view in subviews {
            view.removeFromSuperview()
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

    /// 使用贝塞尔曲线设置圆角
    func cornerRadius(position: UIRectCorner, cornerRadius: CGFloat, roundedRect: CGRect) {
        let path = UIBezierPath(roundedRect: roundedRect, byRoundingCorners: position, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let layer = CAShapeLayer()
        layer.frame = roundedRect
        layer.path = path.cgPath
        self.layer.mask = layer
    }

    /// 添加点击手势
    @discardableResult
    func tapGestureRecognizer(target: Any?, action: Selector?, numberOfTapsRequired: Int = 1, numberOfTouchesRequired: Int = 1) -> UITapGestureRecognizer {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        tapGesture.numberOfTapsRequired = numberOfTapsRequired
        tapGesture.numberOfTouchesRequired = numberOfTouchesRequired
        tapGesture.cancelsTouchesInView = true
        tapGesture.delaysTouchesBegan = true
        tapGesture.delaysTouchesEnded = true

        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true

        return tapGesture
    }

    /// 添加长按手势
    @discardableResult
    func addLongPressGestureRecognizer(target: Any?, action: Selector?, pressDuration: Double = 1) -> UILongPressGestureRecognizer {
        let longPressGesture = UILongPressGestureRecognizer(target: target, action: action)
        longPressGesture.minimumPressDuration = pressDuration
        addGestureRecognizer(longPressGesture)
        isUserInteractionEnabled = true
        return longPressGesture
    }

    /// 获取view的UIViewController
    func parentViewController() -> UIViewController? {
        for view in sequence(first: superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self) {
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
    
    /// 添加View数组，
    /// Example：view.addSubviews(view1,view2)
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }
}

public extension UIView {
    /// 设置圆角
    var ex_cornerRadius: CGFloat {
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    /// 设置边框线颜色
    func border(color: UIColor, width: CGFloat = 1.0) {
        layer.masksToBounds = true
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }

    /// 将当前视图转为UIImage
    func screenshots() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }

    /// 带有高斯模糊的截屏
    func screenshotsdrawH() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
