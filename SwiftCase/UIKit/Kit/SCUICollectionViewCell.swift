//
//===--- SCUICollectionViewCell.swift - Defines the SCUICollectionViewCell class ----------===//
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

import Then
import UIKit

class SCUICollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)

        label.frame = CGRect(x: 5, y: 5, width: widthCell - 5.0 * 2, height: heightCell - 5.0 * 2)
        contentView.addSubview(label)
        contentView.backgroundColor = .red
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    var label = UILabel().then {
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.backgroundColor = UIColor.randomColor
    }

    let widthCell = (UIScreen.main.bounds.size.width - 10.0 * 3) / 2
    let heightCell: CGFloat = 80.0
}
