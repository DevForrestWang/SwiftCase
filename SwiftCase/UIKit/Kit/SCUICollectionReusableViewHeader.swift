//
//===--- SCUICollectionReusableViewHeader.swift - Defines the SCUICollectionReusableViewHeader class ----------===//
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

class SCUICollectionReusableViewHeader: UICollectionReusableView {
    let heightHeader: CGFloat = 40.0
    var label: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        label = UILabel(frame: CGRect(x: 10, y: 0, width: bounds.width - 10.0 * 2, height: heightHeader))
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 16)
        addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
