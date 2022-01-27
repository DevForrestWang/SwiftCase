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
}
