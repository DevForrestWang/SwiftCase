//
//===--- MessageViewModel.swift - Defines the MessageViewModel class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/9/26.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// Inspirations are taken from:
// https://medium.com/mindful-engineering/sockets-mvvm-in-swift-8f32b1401aa5
//
//===----------------------------------------------------------------------===//

import Foundation

final class MessageViewModel {
    var arrMessage = KxSwift<[Message]>([])

    func getMessagesFromServer() {
        SocketHelper.shared.getMessage { [weak self] (message: Message?) in

            guard let self = self,
                  let msgInfo = message
            else {
                return
            }

            self.arrMessage.value.append(msgInfo)
        }
    }
}
