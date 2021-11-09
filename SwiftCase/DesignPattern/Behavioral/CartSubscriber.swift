//
//===--- CartSubscriber.swift - Defines the CartSubscriber class ----------===//
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
  ### 观察者模式: 发布者：人们日报，订阅者：广大消费者；允许一个对象将其状态的改变通知其他对象
  ### 理论：
    1、当一个对象状态的改变需要改变其他对象，或实际对象是事先未知的或动态变化的时，可使用观察者模式。
    2、当应用中的一些对象必须观察其他对象时，可使用该模式。但仅能在有限时间内或特定情况下使用。

 ### 用法
     testCartSubscriber()
 */

//===----------------------------------------------------------------------===//
//                              Model
//===----------------------------------------------------------------------===//
protocol DSProduct {
    var id: Int { get }
    var name: String { get }
    var price: Double { get }
    func isEqual(to product: DSProduct) -> Bool
}

extension DSProduct {
    func isEqual(to product: DSProduct) -> Bool {
        return id == product.id
    }
}

struct DSFood: DSProduct {
    var id: Int
    var name: String
    var price: Double

    // foot specific properties
    var calories: Int
}

struct DSClothes: DSProduct {
    var id: Int
    var name: String
    var price: Double

    // clother speciefic proterties
    var size: String
}

//===----------------------------------------------------------------------===//
//                              Subscriber
//===----------------------------------------------------------------------===//
protocol CarSubscriber: CustomStringConvertible {
    func accept(changed car: [DSProduct])
}

extension UINavigationBar: CarSubscriber {
    func accept(changed: [DSProduct]) {
        yxc_debugPrint("UINavigationBar: Updating an appearance of nanigation items:\(changed)")
    }

    override open var description: String {
        return "UINavigationBar"
    }
}

class CartViewController: UIViewController, CarSubscriber {
    func accept(changed: [DSProduct]) {
        yxc_debugPrint("CartViewController: Updating an appearance of a list view with products:\(changed)")
    }

    override open var description: String {
        return "CarViewController"
    }
}

//===----------------------------------------------------------------------===//
//                              Publisher
//===----------------------------------------------------------------------===//
class CarManager {
    private lazy var cars = [DSProduct]()
    private lazy var subscribers = [CarSubscriber]()

    func add(subscriber: CarSubscriber) {
        yxc_debugPrint("CartManager: I'am adding a new subscriber: \(subscriber.description)")
        subscribers.append(subscriber)
    }

    func add(product: DSProduct) {
        yxc_debugPrint("\nCartManager: I'am adding a new product: \(product.name)")
        cars.append(product)
        notifySubscribers()
    }

    func remove(subscriber filter: (CarSubscriber) -> (Bool)) {
        guard let index = subscribers.firstIndex(where: filter) else {
            return
        }

        subscribers.remove(at: index)
    }

    func remove(product: DSProduct) {
        guard let index = cars.firstIndex(where: { $0.isEqual(to: product) }) else {
            return
        }

        yxc_debugPrint("\nCartManager: Product '\(product.name)' is removed from a cart")
        cars.remove(at: index)
        notifySubscribers()
    }

    private func notifySubscribers() {
        subscribers.forEach { $0.accept(changed: cars) }
    }
}
