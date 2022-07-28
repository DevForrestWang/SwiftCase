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
            SCItemModel(title: "Brows Images", controllerName: "SCBrowseImageView", action: #selector(showImageView)),
            SCItemModel(title: "Call OC function", controllerName: "SCObjectClass", action: #selector(callOCFunction)),
            SCItemModel(title: "List", controllerName: "ListViewController", action: nil),
            SCItemModel(title: "Up down swipe", controllerName: "UpDownSwipeViewController", action: nil),
            SCItemModel(title: "Show RxSwift + MVVM", controllerName: "SCMvvmVC", action: nil),
            SCItemModel(title: "Chat", controllerName: "GYMainChatVC", action: nil),
            SCItemModel(title: "Calendar", controllerName: "", action: #selector(showCalendarAction)),
        ]
    }

    // MARK: - Protocol

    // MARK: - IBActions

    @objc private func showImageView() {
        let imageView = SCBrowseImageView()
        let imageURL: NSArray = ["https://cdn.pixabay.com/photo/2021/08/19/12/53/bremen-6557996_960_720.jpg",
                                 "https://cdn.pixabay.com/photo/2020/09/01/21/03/sunset-5536777_960_720.jpg",
                                 "https://cdn.pixabay.com/photo/2020/07/21/16/24/landscape-5426755_960_720.jpg",
                                 "https://cdn.pixabay.com/photo/2021/09/07/11/53/car-6603726_960_720.jpg",
                                 "https://cdn.pixabay.com/photo/2021/07/30/17/58/dragonfly-6510395_960_720.jpg",
                                 "https://cdn.pixabay.com/photo/2021/09/12/15/18/sunflowers-6618618_960_720.jpg"]

        imageView.show(imageURL)
    }

    @objc private func callOCFunction() {
        let oc = SCObjectClass()
        oc.sayHello()
    }

    @objc private func showCalendarAction() {
        let pView = SCSelectDayView()
        let iHeight = gScreenHeight * 0.8
        pView.gyActivitySelectDayClosure = { [weak self] startDay, endDay in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let startDay = dateFormatter.string(from: startDay)
            let endDay = dateFormatter.string(from: endDay)
            showToast("startDay:\(startDay) - endDay:\(endDay)")
        }

        pView.show(iHeight, headIcon: false, titleName: "日期选择")
    }

    // MARK: - Private

    // MARK: - UI

    // MARK: - Constraints

    // MARK: - Constraints

    // MARK: - Property
}
