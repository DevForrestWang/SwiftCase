//
//===--- UITextView+Extension.swift - Defines the UITextView+Extension class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/9/28.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import Foundation
import UIKit

public extension UITextView {
    /// 自动调整视图高度
    func adjustUITextViewHeight() {
        translatesAutoresizingMaskIntoConstraints = true
        sizeToFit()
        isScrollEnabled = false
    }
}
