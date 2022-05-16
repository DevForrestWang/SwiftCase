//
//===--- GYSegmentVC.swift - Defines the GYSegmentVC class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wfd on 2022/5/16.
// Copyright © 2022 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// https://github.com/pujiaxin33/JXSegmentedView
//
//===----------------------------------------------------------------------===//

import JXSegmentedView
import UIKit

class GYSegmentVC: BaseViewController, JXSegmentedViewDelegate, JXSegmentedListContainerViewDataSource {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - JXSegmentedViewDelegate

    func segmentedView(_: JXSegmentedView, didSelectedItemAt index: Int) {
        if let dotDataSource = segmentedDataSource as? JXSegmentedDotDataSource {
            // 先更新数据源的数据
            dotDataSource.dotStates[index] = false
        }
    }

    // MARK: - JXSegmentedListContainerViewDataSource

    func numberOfLists(in _: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }

        return 0
    }

    func listContainerView(_: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let vc = GYSegmentItemVC()
        switch index {
        case 0:
            vc.view.backgroundColor = .cyan
        default:
            vc.view.backgroundColor = .green
        }

        return vc
    }

    // MARK: - IBActions

    // MARK: - Private

    // MARK: - UI

    private func setupUI() {
        title = "分类切换控制器"

        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        view.addSubview(segmentedView)
        segmentedView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 50)

        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
        listContainerView.frame = CGRect(x: 0, y: 50, width: view.bounds.size.width, height: view.bounds.size.height - 50)
    }

    // MARK: - Constraints

    private func setupConstraints() {}

    // MARK: - Property

    lazy var segmentedDataSource: JXSegmentedBaseDataSource = {
        let _dataSource = JXSegmentedTitleDataSource()
        _dataSource.isTitleColorGradientEnabled = true
        _dataSource.titles = ["很长的第一名", "第二"]
        _dataSource.itemWidth = view.bounds.size.width / CGFloat(_dataSource.titles.count)
        _dataSource.itemSpacing = 0
        _dataSource.isTitleZoomEnabled = true

        return _dataSource
    }()

    lazy var segmentedView: JXSegmentedView = {
        let _segmentedView = JXSegmentedView()

        // 配置指示器
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.isIndicatorWidthSameAsItemContent = true
        _segmentedView.indicators = [indicator]

        return _segmentedView
    }()

    lazy var listContainerView: JXSegmentedListContainerView = .init(dataSource: self)
}
