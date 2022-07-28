//
//===--- SCCalendarDateRangePickerHeaderView.swift - Defines the SCCalendarDateRangePickerHeaderView class ----------===//
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

class SCCalendarDateRangePickerHeaderView: UICollectionReusableView {
    var label: UILabel!

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
        label.font = .boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.textAlignment = .center
        addSubview(label)
    }
}
