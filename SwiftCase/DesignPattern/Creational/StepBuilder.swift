//
//===--- StepBuilder.swift - Defines the StepBuilder class ----------===//
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
  ###     生成器是一种创建型设计模式， 使你能够分步骤创建复杂对象。
  ### 理论：
    1、使用生成器模式可避免 “重叠构造函数（telescopic constructor）” 的出现；如果一个类中有很多属性，为了避免构造函数的参数列表过长，影响代码的可读性和易用性，我们可以通过构造函数配合set() 方法来解决。
    2、当你希望使用代码创建不同形式的产品（例如石头或木头房屋）时，可使用生成器模式。
    3、使用生成器构造组合树或其他复杂对象。

 ### 用法
       testBuilder()
       testBuilder()
 */

//===----------------------------------------------------------------------===//
//                              Model
//===----------------------------------------------------------------------===//
protocol DomainModel {
    /// The protocol groups domain models to the common interface
}

struct SBUser: DomainModel {
    let id: Int
    let age: Int
    let email: String
}

//===----------------------------------------------------------------------===//
//                              Builder
//===----------------------------------------------------------------------===//
class BaseQueryBuilder<Model: DomainModel> {
    typealias Predicate = (Model) -> (Bool)

    func limit(_: Int) -> BaseQueryBuilder<Model> {
        return self
    }

    func filter(_: @escaping Predicate) -> BaseQueryBuilder<Model> {
        return self
    }

    func fetch() -> [Model] {
        preconditionFailure("Should be overridden in subclasses.")
    }
}

//===----------------------------------------------------------------------===//
//                              Builder Implementation
//===----------------------------------------------------------------------===//
// 领域范围的查询
class RealmQueryBuilder<Model: DomainModel>: BaseQueryBuilder<Model> {
    enum Query {
        case filter(Predicate)
        case limit(Int)
    }

    fileprivate var operations = [Query]()

    @discardableResult
    override func limit(_ limit: Int) -> RealmQueryBuilder<Model> {
        operations.append(Query.limit(limit))
        return self
    }

    @discardableResult
    override func filter(_ predicate: @escaping BaseQueryBuilder<Model>.Predicate) -> RealmQueryBuilder<Model> {
        operations.append(Query.filter(predicate))
        return self
    }

    override func fetch() -> [Model] {
        SC.log("RealmQueryBuilder: Initializing CoreDataProvider with \(operations.count) operations:")
        return RealmProvider().fetch(operations)
    }
}

class RealmProvider {
    func fetch<Model: DomainModel>(_ operations: [RealmQueryBuilder<Model>.Query]) -> [Model] {
        SC.log("RealmProvider: Retrieving data from Realm...")
        for item in operations {
            switch item {
            case .filter:
                SC.log("RealmProvider: executing the 'filter' operation.")
            /// Use Realm instance to filter results.
            case .limit:
                SC.log("RealmProvider: executing the 'limit' operation.")
                /// Use Realm instance to limit results.
            }
        }

        /// Return results from Realm
        return []
    }
}

// 核心数据的过滤
class CoreDataQueryBuilder<Model: DomainModel>: BaseQueryBuilder<Model> {
    enum Query {
        case filter(Predicate)
        case limit(Int)
        case includesPropertyValues(Bool)
    }

    fileprivate var operations = [Query]()

    override func limit(_ limit: Int) -> CoreDataQueryBuilder<Model> {
        operations.append(Query.limit(limit))
        return self
    }

    override func filter(_ predicate: @escaping Predicate) -> CoreDataQueryBuilder<Model> {
        operations.append(Query.filter(predicate))
        return self
    }

    func includesPropertyValues(_ toggle: Bool) -> CoreDataQueryBuilder<Model> {
        operations.append(Query.includesPropertyValues(toggle))
        return self
    }

    override func fetch() -> [Model] {
        SC.log("CoreDataQueryBuilder: Initializing CoreDataProvider with \(operations.count) operations.")
        return CoreDataProvider().fetch(operations)
    }
}

class CoreDataProvider {
    func fetch<Model: DomainModel>(_ operations: [CoreDataQueryBuilder<Model>.Query]) -> [Model] {
        /// Create a NSFetchRequest

        SC.log("CoreDataProvider: Retrieving data from CoreData...")

        for item in operations {
            switch item {
            case .filter:
                SC.log("CoreDataProvider: executing the 'filter' operation.")
            /// Set a 'predicate' for a NSFetchRequest.
            case .limit:
                SC.log("CoreDataProvider: executing the 'limit' operation.")
            /// Set a 'fetchLimit' for a NSFetchRequest.
            case .includesPropertyValues:
                SC.log("CoreDataProvider: executing the 'includesPropertyValues' operation.")
                /// Set an 'includesPropertyValues' for a NSFetchRequest.
            }
        }

        /// Execute a NSFetchRequest and return results.
        return []
    }
}

//===----------------------------------------------------------------------===//
//                              Client
//===----------------------------------------------------------------------===//
class BuilderClient {
    func clientCode(builder: BaseQueryBuilder<SBUser>) {
        let results = builder.filter { $0.age < 20 }
            .limit(1)
            .fetch()

        SC.log("Client: I have fetched: " + String(results.count) + " records.")
    }
}
