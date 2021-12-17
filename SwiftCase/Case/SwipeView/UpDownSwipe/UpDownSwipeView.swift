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
//
//===----------------------------------------------------------------------===//

import UIKit

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
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - IBActions

    // MARK: - Private

    private func initScrollView() {
        guard let dataSource = dataSource else {
            return
        }
        childViews = [dataSource.upDownSwipeTopView, dataSource.upDownSwipeMiddleView, dataSource.upDownSwipeBottomView]

        scrollView.contentInsetAdjustmentBehavior = .never

        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false

        addSubview(scrollView)
        scrollView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        scrollView.contentSize = CGSize(width: 0, height: CGFloat(childViews.count) * screenHeight)

        let uiView = childViews.map { mView -> UIView in
            mView as UIView
        }

        _ = uiView.map {
            scrollView.addSubview($0)
            $0.frame = CGRect(x: 0, y: CGFloat(uiView.firstIndex(of: $0)!) * screenHeight, width: screenWidth, height: screenHeight)
            // $0.frame.origin = CGPoint(x: 0, y: CGFloat(uiView.firstIndex(of: $0)!) * screenHeight)
        }

        scrollView.delegate = self
        // scrollView.backgroundColor = middleColor
    }

    // MARK: - UI

    func setupUI() {
        initScrollView()

        //
        scrollView.contentOffset = CGPoint(x: 0, y: 1 * screenHeight)
    }

    // MARK: - Constraints

    func setupConstraints() {}

    // MARK: - Property

    let screenHeight = UIScreen.main.bounds.size.height
    let screenWidth = UIScreen.main.bounds.size.width

    public var dataSource: UpDownSwipeDataSource! {
        didSet {
            initScrollView()
        }
    }

    private let scrollView = AvoidingScrollView()
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

//        let scolor = scrollColor(percent: Double(percentageVerticalOffset))
//        scrollView.backgroundColor = scolor

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
