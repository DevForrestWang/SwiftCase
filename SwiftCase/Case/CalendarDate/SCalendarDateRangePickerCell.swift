//
//===--- SCalendarDateRangePickerCell.swift - Defines the SCalendarDateRangePickerCell class ----------===//
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

class SCalendarDateRangePickerCell: UICollectionViewCell {
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        initLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initLabel()
    }

    func initLabel() {
        label = UILabel(frame: frame)
        label.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        label.font = .systemFont(ofSize: 15)
        label.textColor = .darkGray
        label.textAlignment = .center
        addSubview(label)
    }

    func reset() {
        backgroundColor = .clear
        label.textColor = defaultTextColor
        label.backgroundColor = .clear
        if selectedView != nil {
            selectedView?.removeFromSuperview()
            selectedView = nil
        }
        if halfBackgroundView != nil {
            halfBackgroundView?.removeFromSuperview()
            halfBackgroundView = nil
        }
        if roundHighlightView != nil {
            roundHighlightView?.removeFromSuperview()
            roundHighlightView = nil
        }
    }

    func select(isLeft: Bool) {
        let width = frame.size.width
        let height = frame.size.height
        selectedView = UIView(frame: CGRect(x: (width - height) / 2, y: 0, width: height, height: height))
        selectedView?.backgroundColor = selectedColor

        // 添加子标题
        let descriptLb = UILabel(frame: CGRect(x: 0, y: height * 0.7, width: height, height: height / 4))
        descriptLb.font = .systemFont(ofSize: 10)
        descriptLb.textColor = .white
        descriptLb.textAlignment = .center
        selectedView?.addSubview(descriptLb)

        // 部分圆角
        if isLeft {
            selectedView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            descriptLb.text = "开始"
        } else {
            selectedView?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            descriptLb.text = "结束"
        }
        // selectedView?.layer.cornerRadius = height / 2
        selectedView?.layer.cornerRadius = 5
        selectedView?.layer.masksToBounds = true

        addSubview(selectedView!)
        sendSubviewToBack(selectedView!)

        label.textColor = UIColor.white
        descriptLb.isHidden = !showSubTitle
    }

    func highlightRight() {
        // This is used instead of highlight() when we need to highlight cell with a rounded edge on the left
        let width = frame.size.width
        let height = frame.size.height
        halfBackgroundView = UIView(frame: CGRect(x: width / 2, y: 0, width: width / 2, height: height))
        halfBackgroundView?.backgroundColor = highlightedColor
        addSubview(halfBackgroundView!)
        sendSubviewToBack(halfBackgroundView!)

        addRoundHighlightView(isLeft: false)
    }

    func highlightLeft() {
        // This is used instead of highlight() when we need to highlight the cell with a rounded edge on the right
        let width = frame.size.width
        let height = frame.size.height
        halfBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: width / 2, height: height))
        halfBackgroundView?.backgroundColor = highlightedColor
        addSubview(halfBackgroundView!)
        sendSubviewToBack(halfBackgroundView!)

        addRoundHighlightView(isLeft: true)
    }

    private func addRoundHighlightView(isLeft: Bool) {
        let width = frame.size.width
        let height = frame.size.height
        roundHighlightView = UIView(frame: CGRect(x: (width - height) / 2, y: 0, width: height, height: height))
        roundHighlightView?.backgroundColor = highlightedColor
        // roundHighlightView?.layer.cornerRadius = height / 2
        if isLeft {
            roundHighlightView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        } else {
            roundHighlightView?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
        roundHighlightView?.layer.cornerRadius = 5
        roundHighlightView?.layer.masksToBounds = true

        addSubview(roundHighlightView!)
        sendSubviewToBack(roundHighlightView!)
    }

    func highlight() {
        backgroundColor = highlightedColor
    }

    func disable() {
        label.textColor = disabledColor
    }

    // MARK: - Property

    var selectedColor: UIColor!
    var highlightedColor = UIColor.hexColor(0xFAE8E8)
    var showSubTitle: Bool = true
    var label: UILabel!
    var date: Date?

    private let defaultTextColor = UIColor.darkGray
    private let disabledColor = UIColor.lightGray

    private var selectedView: UIView?
    private var halfBackgroundView: UIView?
    private var roundHighlightView: UIView?
}
