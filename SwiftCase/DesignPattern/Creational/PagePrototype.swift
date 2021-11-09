//
//===--- PagePrototype.swift - Defines the PagePrototype class ----------===//
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
  ### 原型模式是一种创建型设计模式，使你能够复制已有对象，而又无需使代码依赖它们所属的类。一个细胞的分裂。
      识别方法：原型可以简单地通过 clone或 copy等方法来识别。
  ### 理论：
    1、 如果你需要复制一些对象，同时又希望代码独立于这些对象所属的具体类，可以使用原型模式。
    2、 如果子类的区别仅在于其对象的初始化方式，那么你可以使用该模式来减少子类的数量。别人创建这些子类的目的可能是为了创建特定类型的对象。

 ### 用法
     testPagePrototype()
 */

//===----------------------------------------------------------------------===//
//                              Model
//===----------------------------------------------------------------------===//
struct PPComment {
    let date = Date()
    let message: String
}

class PPAuthor {
    private var id: Int
    private var username: String
    private var pages = [PPPage]()

    init(id: Int, username: String) {
        self.id = id
        self.username = username
    }

    func add(page: PPPage) {
        pages.append(page)
    }

    var pageCount: Int {
        return pages.count
    }
}

//===----------------------------------------------------------------------===//
//                              Prototype
//===----------------------------------------------------------------------===//
class PPPage: NSCopying {
    // private(set) 带有私有设置方法的属性
    // https://swift.gg/2016/01/11/public-properties-with-private-setters/
    private(set) var title: String
    private(set) var contents: String
    private weak var author: PPAuthor?
    private(set) var comments = [PPComment]()

    init(title: String, contents: String, author: PPAuthor?) {
        self.title = title
        self.contents = contents
        self.author = author
        author?.add(page: self)
    }

    func add(comment: PPComment) {
        comments.append(comment)
    }

    // MARK: - NSCopying

    func copy(with _: NSZone? = nil) -> Any {
        return PPPage(title: "Copy of '" + title + "'", contents: contents, author: author)
    }
}
