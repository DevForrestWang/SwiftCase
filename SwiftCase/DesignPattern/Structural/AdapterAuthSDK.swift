//
//===--- AdapterAuthSDK.swift - Defines the AdapterAuthSDK class ----------===//
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
      适配器模式: 适配器是一种结构型设计模式， 它能使不兼容的对象能够相互合作。
  ### 理论：
      1、当你希望使用某个类，但是其接口与其他代码不兼容时，可以使用适配器类。
      2、如果您需要复用这样一些类， 他们处于同一个继承体系，并且他们又有了额外的一些共同的方法， 但是这些共同的方法不是所有在这一继承体系中的子类所具有的共性。

 ### 用法
     testAdapteAuth()

 */

protocol AuthService {
    func presentAuthFlow(form viewController: UIViewController)
}

class FaceBookAuthSDK {
    func presentAuthFlow(form _: UIViewController) {
        // Call SDK methods and pass a view controller
        yxc_debugPrint("Facebook WebView has been shown.")
    }
}

class TwitterAuthSDK {
    func startAuthorization(with _: UIViewController) {
        // Call SDK methods and pass a view controller
        yxc_debugPrint("Twitter WebView has been shown. Users will be happy :)")
    }
}

//===----------------------------------------------------------------------===//
//                              Adapter
//===----------------------------------------------------------------------===//
extension TwitterAuthSDK: AuthService {
    /// This is an adapter
    ///
    /// Yeah, we are able to not create another class and just extend an
    /// existing one

    func presentAuthFlow(form viewController: UIViewController) {
        yxc_debugPrint("The Adapter is called! Redirecting to the original method...")
        startAuthorization(with: viewController)
    }
}

extension FaceBookAuthSDK: AuthService {
    /// This extension just tells a compiler that both SDKs have the same
    /// interface.
}
