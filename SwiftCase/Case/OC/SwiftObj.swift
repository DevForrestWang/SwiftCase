//
//===--- SwiftObj.swift - Defines the SwiftObj class ----------===//
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

/// 用Swift写的类，如果不继承NSObject或NSObject的派生类，编译后将不会生成对应的转换类
class SwiftObj: NSObject {
    @objc public func sayhello() {
        showToast("sayhello-from Swift")
    }
}
