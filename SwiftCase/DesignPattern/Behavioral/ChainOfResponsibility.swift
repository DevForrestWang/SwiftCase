//
//===--- ChainOfResponsibility.swift - Defines the ChainOfResponsibility class ----------===//
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
import UIKit
/*:
  ### 责任链模式是一种行为设计模式，允许你将请求沿着处理者链进行发送。收到请求后，每个处理者均可对请求进行处理， 或将其传递给链上的下个处理者。
  ### 理论：
    1、当程序需要使用不同方式处理不同种类请求，而且请求类型和顺序预先未知时，可以使用责任链模式。
    2、当必须按顺序执行多个处理者时，可以使用该模式。
    3、如果所需处理者及其顺序必须在运行时进行改变，可以使用责任链模式。

 ### 用法
     testChainResponsibility()
 */

//===----------------------------------------------------------------------===//
//                              Models
//===----------------------------------------------------------------------===//
enum AuthError: LocalizedError {
    case emptyFirstName
    case emptyLastName

    case emptyEmail
    case emptyPassword

    case invalidEmail
    case invalidPassword
    case differentPasswords

    case locationDisabled
    case notificationsDisabled

    var errorDescription: String? {
        switch self {
        case .emptyFirstName:
            return "First name is empty"
        case .emptyLastName:
            return "Last name is empty"
        case .emptyEmail:
            return "Email is empty"
        case .emptyPassword:
            return "Password is empty"
        case .invalidEmail:
            return "Email is invalid"
        case .invalidPassword:
            return "Password is invalid"
        case .differentPasswords:
            return "Password and repeated password should be equal"
        case .locationDisabled:
            return "Please turn location services on"
        case .notificationsDisabled:
            return "Please turn notifications on"
        }
    }
}

protocol CRRequest {
    var firstName: String? { get }
    var lastName: String? { get }

    var email: String? { get }
    var password: String? { get }
    var repeatedPassword: String? { get }
}

extension CRRequest {
    /// Default implementations

    var firstName: String? { return nil }
    var lastName: String? { return nil }

    var email: String? { return nil }
    var password: String? { return nil }
    var repeatedPassword: String? { return nil }
}

struct SignUpRequest: CRRequest {
    var firstName: String?
    var lastName: String?

    var email: String?
    var password: String?
    var repeatedPassword: String?
}

struct LoginRequest: CRRequest {
    var email: String?
    var password: String?
}

//===----------------------------------------------------------------------===//
//                              Handler
//===----------------------------------------------------------------------===//
protocol Handler {
    var next: Handler? { get }

    func handle(_ request: CRRequest) -> LocalizedError?
}

class BaseHander: Handler {
    var next: Handler?

    init(with handler: Handler? = nil) {
        next = handler
    }

    func handle(_ request: CRRequest) -> LocalizedError? {
        return next?.handle(request)
    }
}

class LoginHandler: BaseHander {
    override func handle(_ request: CRRequest) -> LocalizedError? {
        guard request.email?.isEmpty == false else {
            return AuthError.emptyEmail
        }

        guard request.password?.isEmpty == false else {
            return AuthError.emptyPassword
        }

        return next?.handle(request)
    }
}

class SignUpHandler: BaseHander {
    private enum Limit {
        static let passwordLength = 8
    }

    override func handle(_ request: CRRequest) -> LocalizedError? {
        guard request.email?.contains("@") == true else {
            return AuthError.invalidEmail
        }

        guard (request.password?.count ?? 0) >= Limit.passwordLength else {
            return AuthError.invalidPassword
        }

        guard request.password == request.repeatedPassword else {
            return AuthError.differentPasswords
        }

        return next?.handle(request)
    }
}

class LocationHandler: BaseHander {
    override func handle(_ request: CRRequest) -> LocalizedError? {
        guard isLocationEnabled() else {
            return AuthError.locationDisabled
        }
        return next?.handle(request)
    }

    func isLocationEnabled() -> Bool {
        /// Calls special method
        return true
    }
}

class NotificationHandler: BaseHander {
    override func handle(_ request: CRRequest) -> LocalizedError? {
        guard isNotificationEnabled() else {
            return AuthError.notificationsDisabled
        }
        return next?.handle(request)
    }

    func isNotificationEnabled() -> Bool {
        /// Calls special method
        return false
    }
}

//===----------------------------------------------------------------------===//
//                              Controller
//===----------------------------------------------------------------------===//
protocol AuthHandlerSupportable: AnyObject {
    var handler: Handler? { get set }
}

class BaseAuthViewController: UIViewController, AuthHandlerSupportable {
    /// Base class or extensions can be used to implement a base behavior
    var handler: Handler?

    init(handler: Handler) {
        self.handler = handler
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class LoginViewController: BaseAuthViewController {
    func loginButtonSelected() {
        SC.log("Login View Controller: User selected Login button")
        let request = LoginRequest(email: "smth@gmail.com", password: "123HardPass")

        if let error = handler?.handle(request) {
            SC.log("Login View Controller: something went wrong")
            SC.log("Login View Controller: Error -> " + (error.errorDescription ?? ""))
        } else {
            SC.log("Login View Controller: Preconditions are successfully validated")
        }
    }
}

class SignUpViewController: BaseAuthViewController {
    func signUpButtonSelected() {
        SC.log("SignUp View Controller: User selected SignUp button")

        let request = SignUpRequest(firstName: "Vasya",
                                    lastName: "Pupkin",
                                    email: "vasya.pupkin@gmail.com",
                                    password: "123HardPass",
                                    repeatedPassword: "123HardPass")

        if let error = handler?.handle(request) {
            SC.log("SignUp View Controller: something went wrong")
            SC.log("SignUp View Controller: Error -> " + (error.errorDescription ?? ""))
        } else {
            SC.log("SignUp View Controller: Preconditions are successfully validated")
        }
    }
}
