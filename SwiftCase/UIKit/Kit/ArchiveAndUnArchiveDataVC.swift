//
//===--- ArchiveAndUnArchiveDataVC.swift - Defines the ArchiveAndUnArchiveDataVC class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2023/10/26.
// Copyright © 2023 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import UIKit

class ArchiveModel: NSObject, NSSecureCoding {
    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        name = coder.decodeObject(of: [NSString.self], forKey: "name") as? String
        date = coder.decodeObject(of: [NSDate.self], forKey: "date") as? Date
        count = coder.decodeObject(of: [NSNumber.self], forKey: "count") as? NSInteger
    }

    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(date, forKey: "date")
        coder.encode(count, forKey: "count")
    }

    static var supportsSecureCoding: Bool {
        return true
    }

    var name: String?
    var date: Date?
    var count: NSInteger?
}

class ArchiveAndUnArchiveDataVC: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Archiver And Unarchiver Data"

        let obj1 = ArchiveModel()
        obj1.name = "name1"
        obj1.date = Date()
        obj1.count = 1

        let obj2 = ArchiveModel()
        obj2.name = "name2"
        obj2.date = Date()
        obj2.count = 2

        let objAry: [ArchiveModel] = [obj1, obj2]

        // 接归档对象
        do {
            // 归档数据
            let modelData = try NSKeyedArchiver.archivedData(withRootObject: obj1, requiringSecureCoding: true)

            // 接归档对象
            let unarchived = try NSKeyedUnarchiver.unarchivedObject(ofClass: ArchiveModel.self, from: modelData)
            SC.log("Object unarchived:\(String(describing: unarchived))")
        } catch {
            SC.log(error)
        }

        // 接归档数组
        do {
            // 归档数据
            let modelData = try NSKeyedArchiver.archivedData(withRootObject: objAry, requiringSecureCoding: true)

            // 接归档对象
            let classTypeAry = [NSArray.self, ArchiveModel.self]
            let unarchived = try NSKeyedUnarchiver.unarchivedObject(ofClasses: classTypeAry, from: modelData) as? [ArchiveModel]
            SC.log("Array unarchived:\(String(describing: unarchived))")
        } catch {
            SC.log(error)
        }

        // 接归档字典
        do {
            let objDic: [String: [ArchiveModel]] = [
                "objKey": objAry,
            ]

            // 归档数据
            let modelData = try NSKeyedArchiver.archivedData(withRootObject: objDic, requiringSecureCoding: true)

            // 接归档对象
            let classTypeAry = [NSDictionary.self, NSArray.self, ArchiveModel.self, NSString.self]
            let unarchivedDic = try NSKeyedUnarchiver.unarchivedObject(ofClasses: classTypeAry, from: modelData) as? NSDictionary

            SC.log("Dictionary unarchived:\(String(describing: unarchivedDic))")

            if let unarchivedAry = unarchivedDic?["objKey"] as? NSArray, unarchivedAry.count > 0 {
                if let unObj1 = unarchivedAry[0] as? ArchiveModel {
                    SC.log(unObj1)
                    SC.toast(unObj1.named)
                }
            }
        } catch {
            SC.log(error)
        }
    }
}
