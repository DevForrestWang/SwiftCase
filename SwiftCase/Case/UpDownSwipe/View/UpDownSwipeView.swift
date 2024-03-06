//
//===--- UpDownSwipeView.swift - Defines the UpDownSwipeView class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/12/17.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
// https://github.com/wachus77/TIUpDownSwipe
//
//===----------------------------------------------------------------------===//

import UIKit

/// 注册的View视图
public protocol UpDownSwipeDataSource {
    var upDownSwipeTopView: UpDownSwipeAppearance { get }
    var upDownSwipeMiddleView: UpDownSwipeAppearance { get }
    var upDownSwipeBottomView: UpDownSwipeAppearance { get }
}

func != (lhs: UpDownSwipeAppearanceProtocol?, rhs: UpDownSwipeAppearanceProtocol?) -> Bool {
    guard let lhs = lhs, let rhs = rhs else { return true }
    return !(lhs == rhs)
}

public protocol UpDownSwipeAppearanceProtocol: UIView {
    func hasAppeared()
}

public typealias UpDownSwipeAppearance = UpDownSwipeAppearanceProtocol

class UpDownSwipeView: UIView {
    // MARK: - Public

    /// 初始化方法
    /// - Parameters:
    ///   - frame: 视图大小
    ///   - itemIndex: 默认显示的视图
    public init(frame: CGRect, itemIndex: Int = 0) {
        self.itemIndex = itemIndex

        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private

    private func initScrollView() {
        guard let dataSource = dataSource else {
            print("The dataSource is empty")
            return
        }

        let fWidth: CGFloat = frame.size.width
        let fHeight: CGFloat = frame.size.height
        if fWidth <= 0 || fHeight <= 0 {
            print("The frame:\(frame) is zero.")
            return
        }

        childViews = [dataSource.upDownSwipeTopView, dataSource.upDownSwipeMiddleView, dataSource.upDownSwipeBottomView]

        addSubview(scrollView)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false

        scrollView.frame = CGRect(x: 0, y: 0, width: fWidth, height: fHeight)
        scrollView.contentSize = CGSize(width: 0, height: CGFloat(childViews.count) * fHeight)
        scrollView.delegate = self

        let uiView = childViews.map { mView -> UIView in
            mView as UIView
        }

        _ = uiView.map {
            scrollView.addSubview($0)
            $0.frame = CGRect(x: 0, y: CGFloat(uiView.firstIndex(of: $0)!) * fHeight, width: fWidth, height: fHeight)
        }

        if itemIndex < childViews.count {
            scrollView.contentOffset = CGPoint(x: 0, y: CGFloat(itemIndex) * fHeight)
        }
    }

    // MARK: - UI

    func setupUI() {
        initScrollView()
    }

    // MARK: - Constraints

    func setupConstraints() {}

    // MARK: - Property

    public var dataSource: UpDownSwipeDataSource! {
        didSet {
            initScrollView()
        }
    }

    private var itemIndex: Int = 0
    private let scrollView = UIScrollView()
    private var currentView: UpDownSwipeAppearance? {
        didSet {
            if oldValue != currentView {
                currentView?.hasAppeared()
            }
        }
    }

    private var childViews: [UpDownSwipeAppearance] = []
}

extension UpDownSwipeView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_: UIScrollView) {
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVertiicalOffset: CGFloat = scrollView.contentOffset.y
        let percentageVerticalOffset: CGFloat = currentVertiicalOffset / maximumVerticalOffset

        switch percentageVerticalOffset {
        case 0.0:
            currentView = childViews[0]
        case 0.5:
            currentView = childViews[1]
        case 1.0:
            currentView = childViews[2]
        default:
            break
        }
    }
}
