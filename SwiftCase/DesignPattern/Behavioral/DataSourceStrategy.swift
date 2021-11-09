//
//===--- DataSourceStrategy.swift - Defines the DataSourceStrategy class ----------===//
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
  ### 策略模式: 景区导航，采用公交、骑行、不行等不同策略
  ### 理论：
    1、当你想使用对象中各种不同的算法变体，并希望能在运行时切换算法时，可使用策略模式。
    2、当你有许多仅在执行某些行为时略有不同的相似类时，可使用策略模式。
    3、 如果算法在上下文的逻辑中不是特别重要，使用该模式能将类的业务逻辑与其算法实现细节隔离开来。
    4、 当类中使用了复杂条件运算符以在同一算法的不同变体中切换时，可使用该模式。

 ### 用法
     testDataSouceStrategy()
 */

//===----------------------------------------------------------------------===//
//                              Model
//===----------------------------------------------------------------------===//
protocol DSDomainModel {
    var id: Int { get }
}

struct DSUser: DSDomainModel {
    var id: Int
    var userName: String
}

//===----------------------------------------------------------------------===//
//                              Strategy
//===----------------------------------------------------------------------===//
class DataSourceStrategy {
    private var dataSource: DataSource?

    func update(dataSource: DataSource) {
        /// ... resest current states ...
        self.dataSource = dataSource
    }

    func displayModels() {
        guard let dataSource = dataSource else {
            return
        }

        let models = dataSource.loadModels() as [DSUser]
        /// Bind models to cells of a list view...
        yxc_debugPrint("\nDataSourceStrategy: Displaying models...")
        models.forEach { yxc_debugPrint($0) }
    }
}

//===----------------------------------------------------------------------===//
//                              Strategy implementation
//===----------------------------------------------------------------------===//
protocol DataSource {
    func loadModels<T: DSDomainModel>() -> [T]
}

class MemoryStorage<Model>: DataSource {
    private lazy var items = [Model]()

    func add(_ items: [Model]) {
        self.items.append(contentsOf: items)
    }

    func loadModels<T>() -> [T] where T: DSDomainModel {
        guard T.self == DSUser.self else {
            return []
        }

        return items as! [T]
    }
}

class CoreDataStorage: DataSource {
    func loadModels<T>() -> [T] where T: DSDomainModel {
        guard T.self == DSUser.self else {
            return []
        }

        let firstUser = DSUser(id: 3, userName: "username3")
        let secondUser = DSUser(id: 4, userName: "username4")
        return [firstUser, secondUser] as! [T]
    }
}

class RealmStorage: DataSource {
    func loadModels<T>() -> [T] where T: DSDomainModel {
        guard T.self == DSUser.self else {
            return []
        }
        let firstUser = DSUser(id: 5, userName: "username5")
        let secondUser = DSUser(id: 6, userName: "username6")
        return [firstUser, secondUser] as! [T]
    }
}

//===----------------------------------------------------------------------===//
//                              Client
//===----------------------------------------------------------------------===//
class StrategyClient {
    func clientCode(use strategy: DataSourceStrategy, with dataSource: DataSource) {
        strategy.update(dataSource: dataSource)
        strategy.displayModels()
    }

    func usersFormNetWork() -> [DSUser] {
        let firstUser = DSUser(id: 1, userName: "useranme1")
        let secondUser = DSUser(id: 2, userName: "username2")
        return [firstUser, secondUser]
    }
}
