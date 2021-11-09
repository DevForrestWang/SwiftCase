//
//===--- SCUIVIewViewController.swift - Defines the SCUIVIewViewController class ----------===//
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

import SnapKit
import UIKit

/*
 [snapkit](http://snapkit.io/docs/)
 [iOS SnapKit自动布局使用详解（Swift版Masonry）](https://www.programminghunter.com/article/4805365079/)
 [移动端 Swift自动布局篇之Snapkit简单使用](https://www.dazhuanlan.com/lxalex/topics/1356918)
 [Swift自动布局SnapKit的详细使用介绍](https://www.jianshu.com/p/2bad53a2a180)

 */
class SCUIVIewViewController: BaseViewController {
    // MARK: - Property

    let box1 = UIView().then {
        $0.backgroundColor = UIColor.green
    }

    let box2 = UIView().then {
        $0.backgroundColor = UIColor.red
    }

    let box3 = UIView().then {
        $0.backgroundColor = UIColor.green
    }

    let box4 = UIView().then {
        $0.backgroundColor = UIColor.red
    }

    let box5 = UIView().then {
        $0.backgroundColor = UIColor.green
    }

    let box6 = UIView().then {
        $0.backgroundColor = UIColor.red
    }

    let box7 = UIView().then {
        $0.backgroundColor = UIColor.green
    }

    let box8 = UIView().then {
        $0.backgroundColor = UIColor.red
    }

    let box82 = UIView().then {
        $0.backgroundColor = UIColor.red
    }

    var box8TopConstraint: Constraint?

    // MARK: - Lifecycle

    @objc func injected() {
        #if DEBUG
            yxc_debugPrint("I've been injected: \(self)")
            setupUI()
            setupConstraints()
        #endif
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 添加动画效果
        UIView.animate(withDuration: 5) {
            self.box8TopConstraint?.update(offset: 100)
            self.view.layoutIfNeeded()
        }
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - IBActions

    // MARK: - Private

    // MARK: - UI

    func setupUI() {
        title = "UIView"
        view.addSubview(box1)
        view.addSubview(box2)

        view.addSubview(box3)
        view.addSubview(box4)

        view.addSubview(box5)
        view.addSubview(box6)

        view.addSubview(box7)
        view.addSubview(box8)
        view.addSubview(box82)
    }

    // MARK: - Constraints

    func setupConstraints() {
        box1.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.top.equalTo(self.view).offset(20)
            make.centerX.equalTo(self.view)
        }

        box2.snp.makeConstraints { make in
            make.top.equalTo(box1.snp.top).offset(15)
            make.left.equalTo(box1)
            make.right.equalTo(box1)
            make.height.equalTo(30)
        }

        box3.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(60)
            make.top.equalTo(box1.snp.bottom).offset(30)
            make.centerX.equalTo(self.view)
        }
        box4.snp.makeConstraints { make in
            make.height.width.equalTo(box3)
            make.top.equalTo(box3.snp.bottom)
            make.centerX.equalTo(self.view)
        }

        box5.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.top.equalTo(box4.snp.bottom).offset(30)
            make.left.equalTo(self.view).offset(15)
        }

        box6.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.top.equalTo(box4.snp.bottom).offset(30)
            make.right.equalTo(self.view).offset(-15)
        }

        box7.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.top.equalTo(box6.snp.bottom).offset(30)
            make.centerX.equalTo(self.view)
        }

        box8.snp.makeConstraints { make in
            make.size.equalTo(box7).multipliedBy(0.5)
            self.box8TopConstraint = make.top.equalTo(box7.snp.bottom).offset(30).constraint
            make.centerX.equalTo(self.view)
        }

        box82.snp.makeConstraints { make in
            make.edges.equalTo(box7).inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }
    }
}
