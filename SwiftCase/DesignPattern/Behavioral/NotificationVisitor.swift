//
//===--- NotificationVisitor.swift - Defines the NotificationVisitor class ----------===//
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
/*:
  ###    访问者是一种行为设计模式，允许你在不修改已有代码的情况下向已有类层次结构中增加新的行为。
  ### 理论：
    1、如果你需要对一个复杂对象结构（例如对象树）中的所有元素执行某些操作，可使用访问者模式。
    2、可使用访问者模式来清理辅助行为的业务逻辑。
    3、当某个行为仅在类层次结构中的一些类中有意义，而在其他类中没有意义时，可使用该模式。

 ### 用法
     testNotificationVisitor()
 */

//===----------------------------------------------------------------------===//
//                              Model
//===----------------------------------------------------------------------===//
struct NVEmail {
    let emailOfSender: String

    var description: String {
        return "Email"
    }
}

struct NVSMS {
    let phoneNumberOfSender: String
    var description: String {
        return "SMS"
    }
}

struct NVPush {
    let userNameOfSender: String
    var description: String {
        return "Push"
    }
}

//===----------------------------------------------------------------------===//
//                              NVNotification
//===----------------------------------------------------------------------===//
protocol NotificationPolicy: CustomStringConvertible {
    func isTurnedOn(for email: NVEmail) -> Bool

    func isTurnedOn(for sms: NVSMS) -> Bool

    func isTurnedOn(for push: NVPush) -> Bool
}

class NightPolicyVistor: NotificationPolicy {
    func isTurnedOn(for _: NVEmail) -> Bool {
        return false
    }

    func isTurnedOn(for _: NVSMS) -> Bool {
        return true
    }

    func isTurnedOn(for _: NVPush) -> Bool {
        return false
    }

    var description: String {
        return "Night Policy Visitor"
    }
}

class DefaultPolicyVisitor: NotificationPolicy {
    func isTurnedOn(for _: NVEmail) -> Bool {
        return true
    }

    func isTurnedOn(for _: NVSMS) -> Bool {
        return true
    }

    func isTurnedOn(for _: NVPush) -> Bool {
        return true
    }

    var description: String {
        return "Default Policy Visitor"
    }
}

/// 黑名单
class BlackListVisitor: NotificationPolicy {
    private var bannedEmails = [String]()
    private var bannedPhones = [String]()
    private var bannedUserNames = [String]()

    init(emails: [String], phones: [String], userNames: [String]) {
        bannedEmails = emails
        bannedPhones = phones
        bannedUserNames = userNames
    }

    func isTurnedOn(for email: NVEmail) -> Bool {
        return bannedEmails.contains(email.emailOfSender)
    }

    func isTurnedOn(for sms: NVSMS) -> Bool {
        return bannedPhones.contains(sms.phoneNumberOfSender)
    }

    func isTurnedOn(for push: NVPush) -> Bool {
        return bannedUserNames.contains(push.userNameOfSender)
    }

    var description: String {
        return "Black List Vistor"
    }
}

//===----------------------------------------------------------------------===//
//                              Visitor 扩展内容
//===----------------------------------------------------------------------===//
protocol NVNotification: CustomStringConvertible {
    func accept(visitor: NotificationPolicy) -> Bool
}

extension NVEmail: NVNotification {
    func accept(visitor: NotificationPolicy) -> Bool {
        return visitor.isTurnedOn(for: self)
    }
}

extension NVSMS: NVNotification {
    func accept(visitor: NotificationPolicy) -> Bool {
        return visitor.isTurnedOn(for: self)
    }
}

extension NVPush: NVNotification {
    func accept(visitor: NotificationPolicy) -> Bool {
        return visitor.isTurnedOn(for: self)
    }
}

//===----------------------------------------------------------------------===//
//                              Client
//===----------------------------------------------------------------------===//
class VisitorClient {
    func clientCode(handle notifications: [NVNotification], with policy: NotificationPolicy) {
        let blackList = BlackListVisitor(emails: ["banned@email.com"],
                                         phones: ["000000000", "1234325232"],
                                         userNames: ["Spammer"])
        yxc_debugPrint("\nClient: Using \(policy.description) and \(blackList.description)")

        notifications.forEach { item in
            guard !item.accept(visitor: blackList) else {
                yxc_debugPrint("\tWARNING: " + item.description + " is in a black list")
                return
            }

            if item.accept(visitor: policy) {
                yxc_debugPrint("\t" + item.description + " notification will be shown")
            } else {
                yxc_debugPrint("\t" + item.description + " notification will be silenced")
            }
        }
    }
}
