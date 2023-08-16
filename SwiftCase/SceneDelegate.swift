//
//===--- SceneDelegate.swift - Defines the SceneDelegate class ----------===//
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

import AMapFoundationKit
import IQKeyboardManagerSwift
import MAMapKit
import SwiftUI
import Then
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            // window.rootViewController = UIHostingController(rootView: ContentView())
            // window.rootViewController = UINavigationController(rootViewController: SCAssistantMainViewController())
            window.rootViewController = SCUITabBarController()
            self.window = window
            window.makeKeyAndVisible()

            startSplashScreen(window: window)

            IQKeyboardManager.shared.enable = true
            IQKeyboardManager.shared.shouldResignOnTouchOutside = true

            // 添加高德地图key
            AMapServices.shared().apiKey = GlobalConfig.gGaoDeMapKey
            AMapServices.shared().enableHTTPS = true
            SCMapPrivacyUtility.showPrivacyInfoInWindow()
        }

        #if DEBUG
            do {
                let injectionBundle = Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")
                if let bundle = injectionBundle {
                    try bundle.loadAndReturnError()
                } else {
                    debugPrint("Injection into failure, failed to detect the Injection")
                }
            } catch {
                debugPrint("Injection into failure\(error)")
            }
        #endif
    }

    func sceneDidDisconnect(_: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_: UIScene) {
        // SocketHelper.shared.establishConnection()
    }

    func sceneWillResignActive(_: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_: UIScene) {
        SocketHelper.shared.closeConnection()
    }

    // MARK: - Private

    /// 添加启动闪屏动画
    private func startSplashScreen(window: UIWindow) {
        let splashView = UIView().then {
            $0.frame = UIScreen.main.bounds
            $0.backgroundColor = UIColor(red: 0.27, green: 0.71, blue: 0.94, alpha: 1)
        }
        window.addSubview(splashView)

        let imageView = UIImageView().then {
            $0.image = UIImage(named: "forrest-icon")
            $0.frame = CGRect(x: 0, y: 0, width: 320, height: 320)
            $0.contentMode = .scaleToFill
            $0.center = splashView.center
        }
        splashView.addSubview(imageView)

        let animationDuration: Float = 1.4
        let shrinkDuration = TimeInterval(animationDuration * 0.3)
        let growDuration = TimeInterval(animationDuration * 0.7)

        // "15.0.1" 会导致崩溃
        var version = UIDevice.current.systemVersion
        let range = version.range(of: ".")
        version = String(version[version.startIndex ..< range!.lowerBound])

        guard Float(version) ?? 0 > 13.0 else {
            return
        }

        UIView.animate(withDuration: shrinkDuration, delay: 1.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10,
                       options: .curveEaseInOut)
        {
            let scaleTransform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            imageView.transform = scaleTransform
        } completion: { _ in
            UIView.animate(withDuration: growDuration) {
                let scaleTransform = CGAffineTransform(scaleX: 20.0, y: 20.0)
                imageView.transform = scaleTransform
                splashView.alpha = 0
            } completion: { _ in
                splashView.removeFromSuperview()
            }
        }
    }
}
