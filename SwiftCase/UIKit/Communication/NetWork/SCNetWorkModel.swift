//
//===--- SCNetWorkModel.swift - Defines the SCNetWorkModel class ----------===//
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

public struct SCResponseName {
    var retCode: String
    var data: String
    var msg: String

    public init() {
        data = "data"
        retCode = "retCode"
        msg = "msg"
    }

    public init(retCode: String, data: String, msg: String) {
        self.retCode = retCode
        self.data = data
        self.msg = msg
    }
}

public struct SCServiceError: Error {
    public var retCode: Int = 0
    public var msg: String = ""

    init(retCode: Int, msg: String) {
        self.retCode = retCode
        self.msg = msg
    }
}

public enum SCImageType {
    case png
    case jpeg
    case jpg
    case gif

    var valueName: String {
        switch self {
        case .png:
            return "png"
        case .jpeg:
            return "jpeg"
        case .jpg:
            return "jpg"
        case .gif:
            return "gif"
        }
    }
}

/// 基础数据类型
public protocol SCJsonModel: AFBaseModel {}
