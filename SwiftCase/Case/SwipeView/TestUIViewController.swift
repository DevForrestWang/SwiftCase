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

class TestUIViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan

        view.addSubview(upDView)
        upDView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    let upDView = MiddleView().then {
        $0.backgroundColor = .yellow
    }
}

class MiddleView: UpDownSwipeView, UpDownSwipeDataSource {
    override init(frame: CGRect) {
        super.init(frame: frame)

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
