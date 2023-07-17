//
//===--- UIWindow+Extension.swift - Defines the UIWindow+Extension class ----------===//
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

public extension UIWindow {
    static var keyWindow: UIWindow? {
        var originalKeyWindow: UIWindow?

        #if swift(>=5.1)
            if #available(iOS 13, *) {
                originalKeyWindow = UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap { $0.windows }
                    .first(where: { $0.isKeyWindow })
            } else {
                originalKeyWindow = UIApplication.shared.keyWindow
            }
        #else
            originalKeyWindow = UIApplication.shared.keyWindow
        #endif
        return originalKeyWindow
    }
}
