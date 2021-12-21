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

public enum SCAssimationViewType: Int {
    case upView
    case bottomView
    case middleView
    case prevView
    case nextView
}

public protocol SCAssimtantCarouseViewProtocol: AnyObject {
    func currentView(viewType: SCAssimationViewType)
}

class SCAssimtantCarouseView: EasyCarouseView, EasyCarouseViewDelegate, EasyCarouseViewDataSource {
    public weak var astCarouseViewDelegate: SCAssimtantCarouseViewProtocol?

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

    // MARK: - EasyCarouseViewDelegate

    /// 点击下标
    func carouseView(_: EasyCarouseView, selectedAt _: Int) {
        // print("selcct, index: \(index), carouseView: \(carouseView)")
    }

    /// 下标改变回调
    func carouseView(_: EasyCarouseView, indexChanged index: Int) {
        // print("change, index: \(index), carouseView: \(carouseView)")
        if index == 0 {
            astCarouseViewDelegate?.currentView(viewType: SCAssimationViewType.prevView)
        } else if index == 1 {
            astCarouseViewDelegate?.currentView(viewType: SCAssimationViewType.middleView)
        } else if index == 2 {
            astCarouseViewDelegate?.currentView(viewType: SCAssimationViewType.nextView)
        }
    }
}
