//
//===--- ProjectorFactory.swift - Defines the ProjectorFactory class ----------===//
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
  ###   工厂方法是一种创建型设计模式，解决了在不指定具体类的情况下创建产品对象的问题。例如物流工程，具体包括陆路物流、海运物流
  ### 理论：
    1、当你在编写代码的过程中，如果无法预知对象确切类别及其依赖关系时，可使用工厂方法。
    2、如果你希望用户能扩展你软件库或框架的内部组件，可使用工厂方法。
    3、如果你希望复用现有对象来节省系统资源， 而不是每次都重新创建对象，可使用工厂方法。

 ### 用法
     testProjectorFactory()
     testFactoryPattern():CurrencyFactory

 */

//===----------------------------------------------------------------------===//
//                              投影仪
//===----------------------------------------------------------------------===//
// 投影仪接口
protocol Projector {
    /// Abstract projector interface

    var currentPage: Int { get }

    func present(info: String)

    func sync(with projector: Projector)

    func update(with page: Int)
}

extension Projector {
    /// Base implementation of Projector methods

    func sync(with projector: Projector) {
        projector.update(with: currentPage)
    }
}

/// wifi投影仪
class WifiProjector: Projector {
    var currentPage: Int = 0

    func present(info: String) {
        yxc_debugPrint("Info is presented over Wifi: \(info)")
    }

    func update(with page: Int) {
        /// ... scroll page via WiFi connection
        /// ...

        currentPage = page
    }
}

/// 蓝牙类型投影仪
class BluetoothProjector: Projector {
    var currentPage: Int = 0

    func present(info: String) {
        yxc_debugPrint("Info is presented over Bluetooth: \(info)")
    }

    func update(with page: Int) {
        /// ... scroll page via Bluetooth connection
        /// ...

        currentPage = page
    }
}

//===----------------------------------------------------------------------===//
//                              Factory
//===----------------------------------------------------------------------===//
/// 工厂类接口
protocol ProjectorFactory {
    func createProjector() -> Projector

    func syncedProjector(with projector: Projector) -> Projector
}

// 封装公共业务
extension ProjectorFactory {
    /// Base implementation of ProjectorFactory

    func syncedProjector(with projector: Projector) -> Projector {
        /// Every instance creates an own projector
        let newProjector = createProjector()

        /// sync projectors
        newProjector.sync(with: projector)
        return newProjector
    }
}

// wifi 工厂
class WifiFactory: ProjectorFactory {
    func createProjector() -> Projector {
        return WifiProjector()
    }
}

// 蓝牙工厂
class BluetoothFactory: ProjectorFactory {
    func createProjector() -> Projector {
        return BluetoothProjector()
    }
}

//===----------------------------------------------------------------------===//
//                              Client
//===----------------------------------------------------------------------===//
class ProjectorFactoryClientCode {
    private var currentProjector: Projector?

    func present(info: String, with factory: ProjectorFactory) {
        /// Check wheater a client code already present smth...
        /// Check wheater a client code already present smth...

        guard let projector = currentProjector else {
            /// 'currentProjector' variable is nil. Create a new projector and
            /// start presentation.

            let projector = factory.createProjector()
            projector.present(info: info)
            currentProjector = projector
            return
        }

        /// Client code already has a projector. Let's sync pages of the old
        /// projector with a new one.

        currentProjector = factory.syncedProjector(with: projector)
        currentProjector?.present(info: info)
    }
}
