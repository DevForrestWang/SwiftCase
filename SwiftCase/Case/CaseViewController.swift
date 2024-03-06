//
//===--- CaseViewController.swift - Defines the CaseViewController class ----------===//
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

class CaseViewController: ItemListViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Case"
    }

    // MARK: - Public

    override func itemDataSource() -> [ItemListViewController.SCItemModel]? {
        return [
            SCItemModel(title: "Brows Images", controllerName: "SCShowPopViewVC", action: nil),
            SCItemModel(title: "Call OC function", controllerName: "SCObjectClass", action: #selector(callOCFunction)),
            SCItemModel(title: "List", controllerName: "ListViewController", action: nil),
            SCItemModel(title: "Up down swipe", controllerName: "UpDownSwipeViewController", action: nil),
            SCItemModel(title: "Show RxSwift + MVVM", controllerName: "SCMvvmVC", action: nil),
            SCItemModel(title: "Chat", controllerName: "GYMainChatVC", action: nil),
            SCItemModel(title: "Calendar", controllerName: "SCShowPopViewVC", action: nil),
            SCItemModel(title: "Long Press Pop Menu", controllerName: "SCPopMenuVC", action: nil),
            SCItemModel(title: "Pop Menu", controllerName: "SCPopListViewVC", action: nil),
            SCItemModel(title: "Recording and sound playback", controllerName: "SCRecordPlayVC", action: nil),
        ]
    }

    // MARK: - Protocol

    // MARK: - IBActions

    @objc private func callOCFunction() {
        let oc = SCObjectClass()
        oc.sayHello()
    }

    // MARK: - Private

    // MARK: - UI

    // MARK: - Constraints

    // MARK: - Constraints

    // MARK: - Property
}
