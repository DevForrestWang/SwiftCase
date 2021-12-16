//
//===--- MiddleViewController.swift - Defines the MiddleViewController class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/12/16.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import UIKit

class MiddleViewController: TIUpDownSwipeViewController, TIUpDownSwipeDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        datasource = self
        topControllerColor = .orange
        middleControllerColor = .cyan
        bottomControllerColor = .green
        topText = "Prev"
        bottomText = "Next"
        hideGripperViews = true
    }

    var upDownSwipeTopViewController: TIUpDownSwipeController {
        let vc = UPViewController()
        vc.title = "UP VC"
        vc.view.backgroundColor = .orange
        return vc
    }

    var upDownSwipeMiddleViewController: TIUpDownSwipeController {
        let vc = UPViewController()
        vc.title = "Middle VC"
        vc.view.backgroundColor = .cyan
        return vc
    }

    var upDownSwipeBottomViewController: TIUpDownSwipeController {
        let vc = UPViewController()
        vc.title = "Down VC"
        vc.view.backgroundColor = .green
        return vc
    }
}
