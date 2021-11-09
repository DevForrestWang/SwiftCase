//
//===--- ContentShareBridge.swift - Defines the ContentShareBridge class ----------===//
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

/*:
  ### 例子： 父类形状，子类：圆形、房型；持有颜色对象； 父类颜色，子类：红色、蓝色
  ### 理论：
    1、如果你想要拆分或重组一个具有多重功能的庞杂类（例如能与多个数据库服务器进行交互的类），可以使用桥接模式。
    2、如果你希望在几个独立维度上扩展一个类，可使用该模式。
    3、如果你需要在运行时切换不同实现方法，可使用桥接模式。

 ### 用法
    testContentShareBridge()
 */

//===----------------------------------------------------------------------===//
//                              基础模型
//===----------------------------------------------------------------------===//
protocol Content: CustomStringConvertible {
    var title: String { get }
    var images: [UIImage] { get }
}

struct FoodDomainModel: Content {
    var title: String
    var images: [UIImage]
    var calories: Int

    var description: String {
        return "Food Model"
    }
}

//===----------------------------------------------------------------------===//
//                              分享平台
//===----------------------------------------------------------------------===//
protocol SharingService {
    func share(content: Content)
}

class FaceBookSharingService: SharingService {
    func share(content: Content) {
        /// Use FaceBook API to share a content
        yxc_debugPrint("Service: \(content) was posted to the facebook")
    }
}

class InstagramSharingService: SharingService {
    func share(content: Content) {
        yxc_debugPrint("Service: \(content) was posted to the Instagram")
    }
}

//===----------------------------------------------------------------------===//
//                              使用的页面
//===----------------------------------------------------------------------===//
protocol SharingSupportable {
    func update(content: Content)

    func accept(service: SharingService)
}

class BridgeBaseViewController: UIViewController, SharingSupportable {
    // 持有分享服务对象
    fileprivate var shareService: SharingService?

    func update(content: Content) {
        /// ...updating UI and showing a content...
        /// ...
        /// ... then, a user will choose a content and trigger an event
        yxc_debugPrint("\(description): User selected a \(content) to share")
        /// ...
        shareService?.share(content: content)
    }

    func accept(service: SharingService) {
        shareService = service
    }
}

class PhotoViewController: BridgeBaseViewController {
    /// Custom UI and features

    override var description: String {
        return "PhotoViewController"
    }
}

class FeedViewController: BridgeBaseViewController {
    /// Custom UI and features
    override var description: String {
        return "FeedViewController"
    }
}

//===----------------------------------------------------------------------===//
//                              客户端
//===----------------------------------------------------------------------===//
class BridgeClient {
    func push(_ container: SharingSupportable) {
        let instragram = InstagramSharingService()
        let facebook = FaceBookSharingService()

        container.accept(service: instragram)
        container.update(content: foodModel)

        container.accept(service: facebook)
        container.update(content: foodModel)
    }

    var foodModel: Content {
        return FoodDomainModel(title: "This food is so various and delicious!",
                               images: [UIImage(), UIImage()],
                               calories: 47)
    }
}
