//
//===--- GYMainChatModel.swift - Defines the GYMainChatModel class ----------===//
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

import UIKit

enum GYMainChatSendType {
    case sendInfo
    case acceptInfo
}

enum GYMainChatMessageType {
    case text
    case voice
    case picture
    case video
    case emoji
    case activity
    case redpackage
    case goods
}

class GYCCharUserInfo: NSObject {
    var userName: String?
    var userAvatar: String?
    var levelName: String?
}

class GYMainChatModel: NSObject {
    var sendType: GYMainChatSendType?
    var messageTpye: GYMainChatMessageType?
    var msg: Any? // 文本时：字符串，图片、音频为字典
    var userInfo: GYCCharUserInfo?
    // OC中并没有optional，可选类型OC赋值会报错，且要有初始值
    var msgTimeStamp: TimeInterval = 0.0
}
