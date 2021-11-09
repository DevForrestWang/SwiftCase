//
//===--- FakeData.swift - Defines the FakeData class ----------===//
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

class FakeData {
    private static var products = [Product]()

    static func createProducts() -> [Product] {
        if products.count == 0 {
            let p1 = Product(imageUrl: "https://cdn.pixabay.com/photo/2021/08/19/12/53/bremen-6557996_960_720.jpg", name: "JavaScript核心原理解析", desc: "重构你对JavaScript语言的认知", price: 129, teacher: "周爱民", total: 21, update: 4, studentCount: 2532, detail: "作为前端工程师必备技能，JavaScript 的重要性不言而喻。但是，很多人对 JavaScript 的印象都只是“简单易学”，对其掌握也仅仅停留在“会用就好”，以至于不求甚解、迷失于 JavaScript 。究其原因，他们从来都只是“写代码”，而没有去真正去了解、去探索“什么是语言”。.", courseList: "从零开始 (3讲)")
            let p2 = Product(imageUrl: "https://cdn.pixabay.com/photo/2020/09/01/21/03/sunset-5536777_960_720.jpg", name: "设计模式", desc: "前Google工程师手把手教你写高质量代码", price: 129, teacher: "王争", total: 100, update: 7, studentCount: 1512, detail: "设计模式对你来说，应该不陌生。在面试中，经常会被问到；在工作中，有时候也会用到。一些设计模式书籍，比如大名鼎鼎的 GoF 的《设计模式》、通俗易懂的《Head First 设计模式》，估计你也都研读过。那你是否觉得自己已经掌握了设计模式呢？是否思考过怎么才算真正掌握了设计模式呢？是熟练掌握每种设计模式的原理和代码实现吗？", courseList: "开篇词 (1讲)")
            let p3 = Product(imageUrl: "https://cdn.pixabay.com/photo/2020/07/21/16/24/landscape-5426755_960_720.jpg", name: "项目管理实战", desc: "网易内部项目管理心法", price: 129, teacher: "雷蓓蓓", total: 20, update: 9, studentCount: 3122, detail: "当下，项目管理能力已经逐渐成为我们每一个人的必备技能。随着项目复杂度的增加、竞争压力的增大，只是做一名优秀的项目参与者是远远不够的。实际上，我们都应该成为拥有全局视角和主人翁意识的项目管理者。如果能够跨出自己的日常职责范围，主动推进项目目标的落地，促进各角色的高效协同运转，自己的职场精进之路将更加顺畅。而这一切，都离不开项目管理能力的支撑。", courseList: "开篇词(1讲)")

            products = [p1, p2, p3]
        }
        return products
    }
}
