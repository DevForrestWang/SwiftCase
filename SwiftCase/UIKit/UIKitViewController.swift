//
//===--- UIKitViewController.swift - Defines the UIKitViewController class ----------===//
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

class UIKitViewController: ItemListViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UIKit"
    }

    // MARK: - Public

    override func itemDataSource() -> [ItemListViewController.SCItemModel]? {
        return [
            SCItemModel(title: "Function", controllerName: "SCFunctionViewController", action: nil),
            SCItemModel(title: "UIVIew", controllerName: "SCUIVIewViewController", action: nil),
            SCItemModel(title: "UIButton", controllerName: "SCUIButtonViewController", action: nil),
            SCItemModel(title: "UILable", controllerName: "SCUILableViewController", action: nil),
            SCItemModel(title: "UICollectionView", controllerName: "SCUICollectionViewVC", action: nil),
            SCItemModel(title: "UITextField", controllerName: "SCUITextFieldVC", action: nil),
            SCItemModel(title: "UITextView", controllerName: "SCUITextViewVC", action: nil),
            SCItemModel(title: "MapView-GaoDe Map", controllerName: "SCUIMapViewVC", action: nil),
            SCItemModel(title: "Event", controllerName: "SCUIEventViewVC", action: nil),
            SCItemModel(title: "UI Event", controllerName: "", action: #selector(uiEventAction)),
            SCItemModel(title: "Thread", controllerName: "SCUIAnimationViewVC", action: #selector(expectAction)),
            SCItemModel(title: "Animation", controllerName: "SCUIAnimationViewVC", action: #selector(expectAction)),
            SCItemModel(title: "Communication：HTTP、gPRC、WebSocket、Bluetooth、Wifi", controllerName: "SCommunicationVC", action: nil),
        ]
    }

    // MARK: - Protocol

    // MARK: - IBActions

    @objc private func uiEventAction() {
        let vc = UIEventViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Private

    // MARK: - UI

    // MARK: - Constraints

    // MARK: - Constraints

    // MARK: - Property
}
