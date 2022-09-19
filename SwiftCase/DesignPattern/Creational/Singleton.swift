//
//===--- Singleton.swift - Defines the Singleton class ----------===//
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

/*:
  ### 单例是一种创建型设计模式，让你能够保证一个类只有一个实例，并提供一个访问该实例的全局节点。
  ### 理论：
    1、如果程序中的某个类对于所有客户端只有一个可用的实例，可以使用单例模式。
    2、如果你需要更加严格地控制全局变量，可以使用单例模式。

 ### 用法
     testSingletonPattern()
     testSingleton()
 */

import Foundation

// 1、单例简化版本
final class SingletonPattern {
    static let shared = SingletonPattern()

    private init() {
        fwDebugPrint("init SingletonPattern")
    }

    public func publicFunction() {
        fwDebugPrint("Run publicFunction")
    }
}

/// 2、单例安全版本
/// The Singleton class defines the `shared` field that lets clients access the
/// unique singleton instance.
class Singleton {
    /// The static field that controls the access to the singleton instance.
    ///
    /// This implementation let you extend the Singleton class while keeping
    /// just one instance of each subclass around.
    static var shared: Singleton = {
        let instance = Singleton()
        // ... configure the instance
        // ...
        return instance
    }()

    /// The Singleton's initializer should always be private to prevent direct
    /// construction calls with the `new` operator.
    private init() {}

    /// Finally, any singleton should define some business logic, which can be
    /// executed on its instance.
    func someBusinessLogic() -> String {
        // ...
        return "Result of the 'someBusinessLogic' call"
    }
}

/// Singletons should not be cloneable.
extension Singleton: NSCopying {
    func copy(with _: NSZone? = nil) -> Any {
        return self
    }
}
