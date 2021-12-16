//
//===--- UPViewController.swift - Defines the UPViewController class ----------===//
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

class UPViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension UPViewController: TIUpDownSwipeApperanceProtocol {
    func controllerHasAppeared() {
        print("top appeared")
    }
}
