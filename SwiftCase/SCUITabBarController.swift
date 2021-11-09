//
//===--- SCUITabBarController.swift - Defines the SCUITabBarController class ----------===//
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

import UIKit

class SCUITabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let kitVC = UIKitViewController()
        addBarItem(vc: kitVC, title: "UIKit", image: R.image.home(), selectImage: R.image.home_selected())

        let algVC = AlgorithmViewController()
        addBarItem(vc: algVC, title: "Algorithm", image: R.image.algorithm(), selectImage: R.image.algorithm())

        let dsVC = DesignPatternViewController()
        addBarItem(vc: dsVC, title: "Pattern", image: R.image.design_pattern(), selectImage: R.image.design_pattern())

        let caseVC = CaseViewController()
        addBarItem(vc: caseVC, title: "Case", image: R.image.case(), selectImage: R.image.case())
    }

    private func addBarItem(vc: UIViewController, title: String, image: UIImage?, selectImage: UIImage?) {
        vc.tabBarItem.title = title
        vc.tabBarItem.image = image
        vc.tabBarItem.selectedImage = selectImage
        vc.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.hexColor(0x1C80E7)], for: .selected)

        let nv = UINavigationController(rootViewController: vc)
        addChild(nv)
    }
}
