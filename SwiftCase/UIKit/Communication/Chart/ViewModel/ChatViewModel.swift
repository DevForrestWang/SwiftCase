//
//===--- ChatViewModel.swift - Defines the ChatViewModel class ----------===//
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

final class ChatViewModel {
    var arrUsers = KxSwift<[User]>([])

    func fetchParticipantList(_ name: String) {
        SocketHelper.shared.participantList { [weak self] (result: [User]?) in

            guard let self = self,
                  let users = result
            else {
                return
            }

            var filterUsers: [User] = users

            // Removed login user from list
            if let index = filterUsers.firstIndex(where: { $0.nickname == name }) {
                filterUsers.remove(at: index)
            }

            self.arrUsers.value = filterUsers
        }
    }
}
