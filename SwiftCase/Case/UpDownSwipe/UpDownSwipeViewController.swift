//
//===--- TestUIViewController.swift - Defines the TestUIViewController class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/12/17.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import SnapKit
import Then
import UIKit

class UpDownSwipeViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Up Down Swipe"

        view.addSubview(upDView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // navigationController?.navigationBar.isHidden = true
    }

    let upDView = MiddleView(frame: CGRect(x: 20, y: 20, width: GlobalConfig.gScreenWidth - 40, height: GlobalConfig.gScreenHeight - 40 - 64), itemIndex: 1).then {
        $0.backgroundColor = .yellow
    }
}

class MiddleView: UpDownSwipeView, UpDownSwipeDataSource {
    override init(frame: CGRect, itemIndex: Int) {
        super.init(frame: frame, itemIndex: itemIndex)

        dataSource = self
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    var upDownSwipeTopView: UpDownSwipeAppearance {
        let v = VerticalView().then {
            $0.backgroundColor = .orange
        }
        return v
    }

    var upDownSwipeMiddleView: UpDownSwipeAppearance {
        let v = VerticalView().then {
            $0.backgroundColor = .cyan
        }
        return v
    }

    var upDownSwipeBottomView: UpDownSwipeAppearance {
        let v = VerticalView().then {
            $0.backgroundColor = .green
        }
        return v
    }
}

class VerticalView: UIView, UpDownSwipeAppearance {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func hasAppeared() {
        print("vertical view")
    }
}
