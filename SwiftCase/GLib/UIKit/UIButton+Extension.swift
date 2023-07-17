//
//===--- UIButton+Extension.swift - Defines the UIButton+Extension class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2023/7/17.
// Copyright © 2023 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import UIKit

public extension UIButton {
    var image: UIImage? {
        set {
            setImage(newValue, for: .normal)
        }
        get {
            return self.image(for: .normal)!
        }
    }

    var backgroundImage: UIImage? {
        set {
            setBackgroundImage(newValue, for: .normal)
        }
        get {
            return self.backgroundImage(for: .normal)!
        }
    }

    var title: String? {
        set {
            setTitle(newValue, for: .normal)
        }
        get {
            return self.title(for: .normal) ?? ""
        }
    }

    var titleColor: UIColor? {
        set {
            setTitleColor(newValue, for: .normal)
        }
        get {
            return self.titleColor(for: .normal)!
        }
    }

    var titleFont: UIFont? {
        set {
            titleLabel?.font = newValue
        }

        get {
            return titleLabel!.font
        }
    }
}

public extension UIButton {
    convenience init(title: String?, titleColor: UIColor?, titleFont: UIFont?, backgroundColor: UIColor = UIColor.clear, cornerRadius: CGFloat = 0) {
        self.init()
        self.title = title
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.backgroundColor = backgroundColor
        if cornerRadius > 0 {
            ex_cornerRadius = cornerRadius
        }
    }

    convenience init(imageName: String) {
        self.init()
        image = UIImage(named: imageName)
    }

    convenience init(normalImageName: String, selectImageName: String) {
        self.init()
        setImage(UIImage(named: normalImageName), for: .normal)
        setImage(UIImage(named: selectImageName), for: .selected)
        setImage(UIImage(named: selectImageName), for: .highlighted)
    }

    private enum AssociatedKeys {
        static var eventInterval = "eventInterval"
        static var interactiveMoreSize = "interactiveMoreSize"
    }

    /// 重复点击的时间 属性设置
    @objc var eventInterval: TimeInterval {
        get {
            if let interval = objc_getAssociatedObject(self, &AssociatedKeys.eventInterval) as? TimeInterval {
                return interval
            }
            return 0.4
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.eventInterval, newValue as TimeInterval, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// 区域大增加值
    @objc var interactiveMoreSize: CGSize {
        get {
            if let size = objc_getAssociatedObject(self, &AssociatedKeys.interactiveMoreSize) as? CGSize {
                return size
            }
            return .zero
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.interactiveMoreSize, newValue as CGSize, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
