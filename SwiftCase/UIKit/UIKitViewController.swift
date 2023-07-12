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

import Foundation
import UIKit
import ZippyJSON

class UIKitViewController: ItemListViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UIKit"

        SCScreenFPS.show()
    }

    // MARK: - Public

    override func itemDataSource() -> [ItemListViewController.SCItemModel]? {
        return [
            SCItemModel(title: "Function", controllerName: "SCFunctionViewController", action: nil),
            SCItemModel(title: "UIVIew", controllerName: "SCUIVIewViewController", action: nil),
            SCItemModel(title: "Flexbox case", controllerName: "SCFlexBoxVC", action: nil),
            SCItemModel(title: "UIButton", controllerName: "SCUIButtonViewController", action: nil),
            SCItemModel(title: "UILable", controllerName: "SCUILableViewController", action: nil),
            SCItemModel(title: "AttributedString ", controllerName: "SCAttributedStringVC", action: nil),
            SCItemModel(title: "UICollectionView", controllerName: "SCUICollectionViewVC", action: nil),
            SCItemModel(title: "UITextField, SelectTableView", controllerName: "SCUITextFieldVC", action: nil),
            SCItemModel(title: "UITextView", controllerName: "SCUITextViewVC", action: nil),
            SCItemModel(title: "Widget By Rx", controllerName: "SCWidgetVC", action: nil),
            SCItemModel(title: "RxSwift and RxCocoa", controllerName: "SCRxSwiftAndRxCocoaVC", action: nil),
            SCItemModel(title: "PickerView", controllerName: "SCUIPickerViewVC", action: nil),
            SCItemModel(title: "JXSegmentedView: segmented view ", controllerName: "GYSegmentVC", action: nil),
            SCItemModel(title: "MapView-GaoDe Map", controllerName: "SCUIMapViewVC", action: nil),
            SCItemModel(title: "Event", controllerName: "SCUIEventViewVC", action: nil),
            SCItemModel(title: "UI Event", controllerName: "", action: #selector(uiEventAction)),
            SCItemModel(title: "Thread, OperationQueue, GCD", controllerName: "SCThreadViewController", action: nil),
            SCItemModel(title: "Animation", controllerName: "SCUIAnimationViewVC", action: nil),
            SCItemModel(title: "Parse JSON by simdjson(Cocoapods ZippyJSON)", controllerName: "", action: #selector(zippyParseJSON)),
            SCItemModel(title: "Communication：HTTP、gPRC、WebSocket、Bluetooth、Wifi、Alamofire request", controllerName: "SCommunicationVC", action: nil),
            SCItemModel(title: "Click dismiss Screen FPS", controllerName: "", action: #selector(dismissScreenFPS)),
            SCItemModel(title: "Page Layout by ScrollView", controllerName: "SCLayoutByScrollViewVC", action: nil),
            SCItemModel(title: "Page Layout by StackView", controllerName: "SCLayoutByStackViewVC", action: nil),
        ]
    }

    // MARK: - Protocol

    // MARK: - IBActions

    @objc private func uiEventAction() {
        let vc = UIEventViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    ///  Parsing JSON by simdjson
    ///
    /// [simdjson/simdjson: Parsing gigabytes of JSON per second (github.com)](https://github.com/simdjson/simdjson)
    /// [michaeleisel/ZippyJSON: A much faster version of JSONDecoder (github.com)](https://github.com/michaeleisel/zippyjson)
    @objc private func zippyParseJSON() {
        fwPrintEnter(message: "ZippyJSON")

        let json = """
        {
            "id": "100",
            "username": "Joannis",
            "role": "admin",
            "awesome": true,
            "superAwesome": false
        }
        """.data(using: .utf8)!

        struct User: Decodable {
            let id: String
            let username: String
            let role: String
            let awesome: Bool
            let superAwesome: Bool
        }

        #if targetEnvironment(simulator)
            // M1模拟器崩溃
            showLogs("ZippyJSONDecoder crash")
        #else
            let user = try! ZippyJSONDecoder().decode(User.self, from: json)

            fwDebugPrint("User data: ")
            fwDebugPrint("id:\(user.id), \nusername: \(user.username), \nrole: \(user.role), \nawesome: \(user.awesome), \nsuperAwesome: \(user.superAwesome)")
            showLogs()
        #endif
    }

    @objc private func dismissScreenFPS() {
        SCScreenFPS.dismiss()
    }

    // MARK: - Private

    // MARK: - UI

    // MARK: - Constraints

    // MARK: - Constraints

    // MARK: - Property
}
