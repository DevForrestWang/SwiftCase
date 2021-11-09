//
//===--- AuthViewAbstractFactory.swift - Defines the AuthViewAbstractFactory class ----------===//
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
  ###   抽象工厂模式提供了一种方式，可以将一组具有同一主题的单独的工厂封装起来。在正常使用中，客户端程序需要创建抽象工厂的具体实现，然后使用抽象工厂作为接口来创建这一主题的具体对象。

  ### 理论：
    1、如果代码需要与多个不同系列的相关产品交互，但是由于无法提前获取相关信息，或者出于对未来扩展性的考虑， 你不希望代码基于产品的具体类进行构建，在这种情况下，你可以使用抽象工厂。
    2、如果你有一个基于一组抽象方法的类，且其主要功能因此变得不明确， 那么在这种情况下可以考虑使用抽象工厂模式。

 ### 用法
     testAuthViewAbstractFactory()
     testAbstractFactory()
 */

enum AuthType {
    case login
    case signUp
}

/// 授权接口
protocol AuthView {
    typealias AuthAction = (AuthType) -> Void

    var contentView: UIView { get }
    var authHandler: AuthAction? { get set }

    var description: String { get }
}

/// 授权视图
class StudentSignUpView: UIView, AuthView {
    private class StudentSignUpContentView: UIView {
        /// This view contains a number of features available only during a
        /// STUDENT authorization.
    }

    var contentView: UIView = StudentSignUpContentView()

    /// The handler will be connected for actions of buttons of this view.
    var authHandler: AuthView.AuthAction?

    override var description: String {
        return "Student-SignUp-View"
    }
}

class StudentLoginView: UIView, AuthView {
    private let emailField = UITextField()
    private let passwardField = UITextField()
    private let signUpButton = UIButton()

    var contentView: UIView {
        return self
    }

    /// The handler will be connected for actions of buttons of this view.
    var authHandler: AuthView.AuthAction?

    override var description: String {
        return "Studten-Login-View"
    }
}

class TeacherSignUpView: UIView, AuthView {
    class TeacherSignUpContentView: UIView {
        /// This view contains a number of features available only during a
        /// TEACHER authorization.
    }

    var contentView: UIView = TeacherSignUpContentView()

    /// The handler will be connected for actions of buttons of this view.
    var authHandler: AuthView.AuthAction?

    override var description: String {
        return "Teacher-SignUp-View"
    }
}

class TeacherLoginView: UIView, AuthView {
    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let loginButton = UIButton()
    private let forgotPasswordButton = UIButton()

    var contentView: UIView {
        return self
    }

    /// The handler will be connected for actions of buttons of this view.
    var authHandler: AuthView.AuthAction?

    override var description: String {
        return "Theacher-Login-View"
    }
}

/// 授权控制器
class AuthViewController: UIViewController {
    fileprivate var contentView: AuthView

    init(contentView: AuthView) {
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
    }

    required convenience init?(coder _: NSCoder) {
        return nil
    }
}

class StudentAuthViewController: AuthViewController {
    /// Student-oriented features
}

class TeacherAutherViewController: AuthViewController {
    /// Teacher-oriented features
}

/// 工厂类，学生、教师控制器
protocol AuthViewFactory {
    static func authView(for type: AuthType) -> AuthView

    static func authController(for type: AuthType) -> AuthViewController
}

class StudentAuthViewFactory: AuthViewFactory {
    static func authView(for type: AuthType) -> AuthView {
        yxc_debugPrint("Student View has been created")
        switch type {
        case .login:
            return StudentLoginView()
        case .signUp:
            return StudentSignUpView()
        }
    }

    static func authController(for type: AuthType) -> AuthViewController {
        let controller = StudentAuthViewController(contentView: authView(for: type))
        yxc_debugPrint("Student View Controller has been created")
        return controller
    }
}

class TeacherAuthViewFactory: AuthViewFactory {
    static func authView(for type: AuthType) -> AuthView {
        yxc_debugPrint("Teacher View has been created")
        switch type {
        case .login:
            return TeacherLoginView()
        case .signUp:
            return TeacherSignUpView()
        }
    }

    static func authController(for type: AuthType) -> AuthViewController {
        let controller = TeacherAutherViewController(contentView: authView(for: type))
        yxc_debugPrint("Teacher View Controller has been created")
        return controller
    }
}

/// 客户端代码
class AuthViewClientCode {
    private var currentController: AuthViewController?

    private lazy var navigationController: UINavigationController = {
        guard let vc = currentController else { return UINavigationController() }
        return UINavigationController(rootViewController: vc)
    }()

    private let factoryType: AuthViewFactory.Type

    init(factoryType: AuthViewFactory.Type) {
        self.factoryType = factoryType
    }

    // MARK: - Presentation

    func presentLogin() {
        let controller = factoryType.authController(for: .login)
        navigationController.pushViewController(controller, animated: true)
    }

    func presentSignUp() {
        let controller = factoryType.authController(for: .signUp)
        navigationController.pushViewController(controller, animated: true)
    }
}
