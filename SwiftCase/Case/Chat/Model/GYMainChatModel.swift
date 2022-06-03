//
//  GYMainChatModel.swift
//  GYCompany
//
//  Created by wfd on 2022/5/26.
//  Copyright © 2022 归一. All rights reserved.
//

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
