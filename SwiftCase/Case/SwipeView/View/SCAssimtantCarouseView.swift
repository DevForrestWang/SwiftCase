//
//===--- SCAssimtantCarouseView.swift - Defines the SCAssimtantCarouseView class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/12/21.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import UIKit

class SCAssimtantCarouseView: EasyCarouseView, EasyCarouseViewDelegate, EasyCarouseViewDataSource {
    init() {
        super.init(direction: .horizontal, transformScale: 0.9, alphaScale: 0.4, itemSpace: 10,
                   itemWidthScale: 0.85, itemHeightScale: 1, itemIndex: 1)
        status = .none
        carouseDataSource = self
        carouseDelegate = self

        collectionView.register(SCPrevCarouseCell.self, forCellWithReuseIdentifier: "prevCell")
        collectionView.register(SCMiddleCarouseCell.self, forCellWithReuseIdentifier: "middleCell")
        collectionView.register(SCNextCarouseCell.self, forCellWithReuseIdentifier: "lastCell")
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func carouseView(_ carouseView: EasyCarouseView, cellForItemAt indexPath: IndexPath, itemIndex: Int) -> UICollectionViewCell {
        if itemIndex == 0 {
            let cell = carouseView.collectionView.dequeueReusableCell(withReuseIdentifier: "prevCell", for: indexPath) as!
                SCPrevCarouseCell
            return cell
        } else if itemIndex == 1 {
            let cell = carouseView.collectionView.dequeueReusableCell(withReuseIdentifier: "middleCell", for: indexPath) as!
                SCMiddleCarouseCell
            return cell
        } else {
            let cell = carouseView.collectionView.dequeueReusableCell(withReuseIdentifier: "lastCell", for: indexPath) as!
                SCNextCarouseCell
            return cell
        }
    }

    func numberOfItems(in _: EasyCarouseView) -> Int {
        return 3
    }
}
