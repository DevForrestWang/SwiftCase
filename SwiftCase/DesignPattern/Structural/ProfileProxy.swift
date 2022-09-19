//
//===--- ProfileProxy.swift - Defines the ProfileProxy class ----------===//
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
       代理是一种结构型设计模式，让你能提供真实服务对象的替代品给客户端使用。代理接收客户端的请求并进行一些处理（访问控制和缓存等），然后再将请求传递给服务对象。
  ### 理论：
      1、延迟初始化（虚拟代理）。如果你有一个偶尔使用的重量级服务对象，一直保持该对象运行会消耗系统资源时，可使用代理模式。
      2、访问控制（保护代理）。如果你只希望特定客户端使用服务对象，这里的对象可以是操作系统中非常重要的部分，而客户端则是各种已启动的程序（包括恶意程序），此时可使用代理模式。
      3、本地执行远程服务 远程代理）。适用于服务对象位于远程服务器上的情形。
      4、记录日志请求（日志记录代理）。适用于当你需要保存对于服务对象的请求历史记录时。代理可以在向服务传递请求前进行记录。
      5、智能引用。可在没有客户端使用某个重量级对象时立即销毁该对象。

 ### 用法
     testProfileProxy()

 */

//===----------------------------------------------------------------------===//
//                              Model
//===----------------------------------------------------------------------===//
struct BankAccount {
    var id: Int
    var amount: Double
}

struct PProfile {
    enum Keys: String {
        case firstName
        case lastName
        case email
    }

    var firstName: String?
    var lastName: String?
    var email: String?
    var bankAccount: BankAccount?
}

extension LocalizedError {
    var localizedSummary: String {
        return errorDescription ?? ""
    }
}

extension RawRepresentable {
    var raw: Self.RawValue {
        return rawValue
    }
}

//===----------------------------------------------------------------------===//
//                              Business
//===----------------------------------------------------------------------===//
enum AccessField {
    case basic
    case bankAccount
}

protocol ProfileService {
    typealias Sucess = (PProfile) -> Void
    typealias Failure = (LocalizedError) -> Void

    func loadProfile(with fields: [AccessField], success: Sucess, failure: Failure)
}

class PPKeychain: ProfileService {
    func loadProfile(with fields: [AccessField], success: (PProfile) -> Void, failure _: (LocalizedError) -> Void) {
        var profile = PProfile()

        for item in fields {
            switch item {
            case .basic:
                let info = loadBasicProfile()
                profile.firstName = info[PProfile.Keys.firstName.raw]
                profile.lastName = info[PProfile.Keys.lastName.raw]
                profile.email = info[PProfile.Keys.email.raw]
            case .bankAccount:
                profile.bankAccount = loadBankAccount()
            }
        }

        success(profile)
    }

    private func loadBasicProfile() -> [String: String] {
        return [
            PProfile.Keys.firstName.raw: "Vasya",
            PProfile.Keys.lastName.raw: "Pupkin",
            PProfile.Keys.email.raw: "vasya.pupkin@gmail.com",
        ]
    }

    private func loadBankAccount() -> BankAccount {
        return BankAccount(id: 12345, amount: 999)
    }
}

//===----------------------------------------------------------------------===//
//                              Proxy
//===----------------------------------------------------------------------===//
enum BiometricsService {
    enum Access {
        case authorized
        case denied
    }

    static func checkAccess() -> Access {
        /// The service uses Face ID, Touch ID or a plain old password to
        /// determine whether the current user is an owner of the device.

        /// Let's assume that in our example a user forgot a password :)
        return .denied
    }
}

enum ProfileError: LocalizedError {
    case accessDenied

    var errorDescription: String? {
        switch self {
        case .accessDenied:
            return "Access is denied. Please enter a valid password"
        }
    }
}

class ProfileProxy: ProfileService {
    private let keychain = PPKeychain()

    func loadProfile(with fields: [AccessField], success: (PProfile) -> Void, failure: (LocalizedError) -> Void) {
        if let error = checkAccess(for: fields) {
            failure(error)
        } else {
            /// Note:
            /// At this point, the `success` and `failure` closures can be
            /// passed directly to the original service (as it is now) or
            /// expanded here to handle a result (for example, to cache).

            keychain.loadProfile(with: fields, success: success, failure: failure)
        }
    }

    private func checkAccess(for fields: [AccessField]) -> LocalizedError? {
        if fields.contains(.bankAccount) {
            switch BiometricsService.checkAccess() {
            case .authorized:
                return nil
            case .denied:
                return ProfileError.accessDenied
            }
        }

        return nil
    }
}

//===----------------------------------------------------------------------===//
//                              ProxyClient
//===----------------------------------------------------------------------===//
class ProxyClient {
    func loadBasicProfile(with service: ProfileService) {
        service.loadProfile(with: [.basic]) { _ in
            fwDebugPrint("Client: Basic profile is loaded")
        } failure: { error in
            fwDebugPrint("Client: Cannot load a basic profile")
            fwDebugPrint("Client: Error: " + error.localizedSummary)
        }
    }

    func loadProfileWithBankAccount(with service: ProfileService) {
        service.loadProfile(with: [.basic, .bankAccount]) { _ in
            fwDebugPrint("Client: Basic profile with a bank account is loaded")
        } failure: { error in
            fwDebugPrint("Client: Cannot load a profile with a bank account")
            fwDebugPrint("Client: Error: " + error.localizedSummary)
        }
    }
}
