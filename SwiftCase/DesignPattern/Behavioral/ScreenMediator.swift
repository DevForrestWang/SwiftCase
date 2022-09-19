//
//===--- ScreenMediator.swift - Defines the ScreenMediator class ----------===//
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
  ###

  ### 理论：中介者是一种行为设计模式，让程序组件通过特殊的中介者对象进行间接沟通，达到减少组件之间依赖关系的目的。
    1、当一些对象和其他对象紧密耦合以致难以对其进行修改时，可使用中介者模式。
    2、组件因过于依赖其他组件而无法在不同应用中复用时，可使用中介者模式。
    3、如果为了能在不同情景下复用一些基本行为，导致你需要被迫创建大量组件子类时，可使用中介者模式。

 ### 用法
     testScreenMediator()
 */

//===----------------------------------------------------------------------===//
//                              Model
//===----------------------------------------------------------------------===//
struct SMNews: Equatable {
    let id: Int

    let title: String

    var likeCount: Int

    static func == (left: SMNews, right: SMNews) -> Bool {
        return left.id == right.id
    }
}

//===----------------------------------------------------------------------===//
//                              Mediator
//===----------------------------------------------------------------------===//
protocol ScreenUpdatable: AnyObject {
    func likedAdded(to news: SMNews)

    func likeRemoved(from news: SMNews)
}

class ScreenMediator: ScreenUpdatable {
    private var screens: [ScreenUpdatable]?

    func update(_ screens: [ScreenUpdatable]) {
        self.screens = screens
    }

    func likedAdded(to news: SMNews) {
        fwDebugPrint("Screen Mediator: Received a liked news model with id \(news.id)")
        screens?.forEach { $0.likedAdded(to: news) }
    }

    func likeRemoved(from news: SMNews) {
        fwDebugPrint("ScreenMediator: Received a disliked news model with id \(news.id)")
        screens?.forEach { $0.likeRemoved(from: news) }
    }
}

//===----------------------------------------------------------------------===//
//                              Component
//===----------------------------------------------------------------------===//
/// 通过 ScreenMediator类NewFeedViewController与NewDetailViewController、ProfileViewController隔离
class NewFeedViewController: ScreenUpdatable {
    private var newArray: [SMNews]
    private weak var mediator: ScreenUpdatable?

    init(_ mediator: ScreenUpdatable?, _ newArray: [SMNews]) {
        self.newArray = newArray
        self.mediator = mediator
    }

    func likedAdded(to news: SMNews) {
        fwDebugPrint("News Feed: Received a liked news model with id \(news.id)")

        for var item in newArray {
            if item == news {
                item.likeCount += 1
            }
        }
    }

    func likeRemoved(from news: SMNews) {
        fwDebugPrint("News Feed: Received a disliked news model with id \(news.id)")

        for var item in newArray {
            if item == news {
                item.likeCount -= 1
            }
        }
    }

    func userLikedAllNews() {
        fwDebugPrint("\n\nNews Feed: User LIKED all news models")
        fwDebugPrint("News Feed: I am telling to mediator about it...\n")
        newArray.forEach { item in
            mediator?.likedAdded(to: item)
        }
    }

    func userDislikedAllNews() {
        fwDebugPrint("\n\nNews Feed: User DISLIKED all news models")
        fwDebugPrint("News Feed: I am telling to mediator about it...\n")
        newArray.forEach { item in
            mediator?.likeRemoved(from: item)
        }
    }
}

class NewDetailViewController: ScreenUpdatable {
    private var news: SMNews
    private weak var mediator: ScreenUpdatable?

    init(_ mediator: ScreenUpdatable, _ news: SMNews) {
        self.news = news
        self.mediator = mediator
    }

    func likedAdded(to news: SMNews) {
        fwDebugPrint("News Detail: Received a liked news model with id \(news.id)")
        if self.news == news {
            self.news.likeCount += 1
        }
    }

    func likeRemoved(from news: SMNews) {
        fwDebugPrint("News Detail: Received a disliked news model with id \(news.id)")
        if self.news == news {
            self.news.likeCount -= 1
        }
    }
}

class ProfileViewController: ScreenUpdatable {
    private var numberOfGivenLikes: Int
    private weak var mediator: ScreenUpdatable?

    init(_ mediator: ScreenUpdatable?, _ numberOfGivenLikes: Int) {
        self.numberOfGivenLikes = numberOfGivenLikes
        self.mediator = mediator
    }

    func likedAdded(to news: SMNews) {
        fwDebugPrint("Profile: Received a liked news model with id \(news.id)")
        numberOfGivenLikes += 1
    }

    func likeRemoved(from news: SMNews) {
        fwDebugPrint("Profile: Received a disliked news model with id \(news.id)")
        numberOfGivenLikes -= 1
    }
}
