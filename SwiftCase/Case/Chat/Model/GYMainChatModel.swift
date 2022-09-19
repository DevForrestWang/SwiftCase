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

/// 消息接收类型
enum GYMainChatSendType {
    case sendInfo
    case acceptInfo
}

/// 消息发送状态
enum GYMainChatSendStatus {
    case sendFailed
    case sending
    case sendSucessed
}

/// 消息类型
enum GYMainChatMessageType: String {
    case welcome = "0" // 公告、欢迎语
    case text = "1" // 普通文本、图标
    case replyMessage = "2" // 回复消息
    case voice = "3" // 语音
    case picture = "4" // 图片
    case time = "12" // 时间
    case video = "14" // 短视频
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
    var sendTime: String?
    var imgUrl: String?
    var userInfo: GYCCharUserInfo?
    // OC中并没有optional，可选类型OC赋值会报错，且要有初始值
    var msgTimeStamp: TimeInterval = 0.0
    var sendStatus: GYMainChatSendStatus = .sendSucessed
}
