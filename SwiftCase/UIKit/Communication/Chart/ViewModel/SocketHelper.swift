//
//===--- SocketHelper.swift - Defines the SocketHelper class ----------===//
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
import SocketIO
import UIKit

let kConnectUser = "connectUser"
let kUserList = "userList"
let kExitUser = "exitUser"

final class SocketHelper: NSObject {
    static let shared = SocketHelper()

    private var manager: SocketManager?
    private var socket: SocketIOClient?
    private var isConnection: Bool?

    override init() {
        super.init()
        configureSocketClient()
    }

    private func configureSocketClient() {
        guard let url = URL(string: GlobalConfig.gCharHost) else {
            return
        }

        // server: netty-socketio 版本2.0；客户端也要指定2的版本才能通信
        // https://github.com/socketio/socket.io-client-swift/blob/master/Usage%20Docs/Compatibility.md
        manager = SocketManager(socketURL: url, config: [.log(true), .compress, .forcePolling(true), .version(.two)])

        guard let manager = manager else {
            return
        }

        // socket = manager.socket(forNamespace: "/**********")
        socket = manager.defaultSocket

        socket?.on("testEvent", callback: { data, _ in
            print(data)
            let resp = data[0]
            print(resp)
        })
    }

    func testEvent() {
        guard let socket = manager?.defaultSocket else {
            return
        }

        socket.emit("testEvent", ["msg": "iphone info"])
    }

    func establishConnection() {
        guard let socket = manager?.defaultSocket else {
            return
        }

        socket.connect()
        isConnection = true
    }

    func reConnection() {
        guard let tConnect = isConnection else {
            establishConnection()
            return
        }

        if !tConnect {
            establishConnection()
        }
    }

    func closeConnection() {
        guard let socket = manager?.defaultSocket else {
            return
        }

        isConnection = false
        socket.disconnect()
    }

    func joinChatRoom(nickname: String, completion: () -> Void) {
        guard let socket = manager?.defaultSocket else {
            return
        }

        socket.emit(kConnectUser, nickname)
        completion()
    }

    func leaveChatRoom(nickname: String, completion: () -> Void) {
        guard let socket = manager?.defaultSocket else {
            return
        }

        socket.emit(kExitUser, nickname)
        isConnection = false
        completion()
    }

    func participantList(completion: @escaping (_ userList: [User]?) -> Void) {
        guard let socket = manager?.defaultSocket else {
            return
        }

        socket.on(kUserList) { [weak self] result, _ -> Void in

            // 注意：dataInfo变量，数据解析如果不重新赋值，将无法解析
            guard result.count > 0, let dataInfo = result.first, let _ = self else {
                return
            }

            if let user = dataInfo as? [[String: Any]],
               let data = UIApplication.jsonData(from: user)
            {
                do {
                    let userModel = try JSONDecoder().decode([User].self, from: data)
                    completion(userModel)
                } catch {
                    print("Something happen wrong here...\(error)")
                    completion(nil)
                }
            } else {
                do {
                    if let dataFromString = String(describing: dataInfo).data(using: .utf8, allowLossyConversion: false) {
                        let userModel = try JSONDecoder().decode([User].self, from: dataFromString)
                        yxc_debugPrint("userModel:\(userModel)")
                        completion(userModel)
                    }
                } catch {
                    print("Something happen wrong here...\(error)")
                }
            }
        }
    }

    func getMessage(completion: @escaping (_ messageInfo: Message?) -> Void) {
        guard let socket = manager?.defaultSocket else {
            return
        }

        socket.on("newChatMessage") { dataArray, _ -> Void in

            var messageInfo = [String: Any]()

            guard let nickName = dataArray[0] as? String,
                  let message = dataArray[1] as? String,
                  let date = dataArray[2] as? String
            else {
                return
            }

            messageInfo["nickname"] = nickName
            messageInfo["message"] = message
            messageInfo["date"] = date

            guard let data = UIApplication.jsonData(from: messageInfo) else {
                return
            }

            do {
                let messageModel = try JSONDecoder().decode(Message.self, from: data)
                completion(messageModel)

            } catch {
                print("Something happen wrong here...\(error)")
                completion(nil)
            }
        }
    }

    func sendMessage(message: String, withNickname nickname: String) {
        guard let socket = manager?.defaultSocket else {
            return
        }

        socket.emit("chatMessage", nickname, message)
    }
}
