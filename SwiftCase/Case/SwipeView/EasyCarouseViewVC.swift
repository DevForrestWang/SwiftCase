//
//  EasyCarouseViewVC.swift
//  EasyKits_Example
//
//  Created by 孟利明 on 2021/2/24.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Then
import UIKit

class EasyCarouseViewVC: UIViewController {
    fileprivate let carouseView = CustomCarouseView().then {
        $0.status = .none
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "轮播"
        setSubviews()
    }

    fileprivate func setSubviews() {
        view.addSubview(carouseView)
        carouseView.snp.makeConstraints { maker in
            maker.top.equalTo(64)
            maker.left.right.equalTo(0)
            maker.height.equalTo(UIScreen.main.bounds.height - 74)
        }
    }
}

class CustomCarouseView: EasyCarouseView, EasyCarouseViewDelegate, EasyCarouseViewDataSource {
    init() {
        super.init(direction: .horizontal, transformScale: 0.9, alphaScale: 0.4, itemSpace: 10, itemWidthScale: 0.85, itemHeightScale: 1, itemIndex: 1)
        status = .none
        carouseDataSource = self
        carouseDelegate = self

        collectionView.register(PrevCarouseCell.self, forCellWithReuseIdentifier: "prevCell")
        collectionView.register(MiddleCarouseCell.self, forCellWithReuseIdentifier: "middleCell")
        collectionView.register(LastCarouseCell.self, forCellWithReuseIdentifier: "lastCell")
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func carouseView(_ carouseView: EasyCarouseView, cellForItemAt indexPath: IndexPath, itemIndex: Int) -> UICollectionViewCell {
        if itemIndex == 0 {
            let cell = carouseView.collectionView.dequeueReusableCell(withReuseIdentifier: "prevCell", for: indexPath) as!
                PrevCarouseCell
            cell.desLB.text = "Page：\(itemIndex)"
            return cell
        } else if itemIndex == 1 {
            let cell = carouseView.collectionView.dequeueReusableCell(withReuseIdentifier: "middleCell", for: indexPath) as!
                MiddleCarouseCell
            return cell
        } else {
            let cell = carouseView.collectionView.dequeueReusableCell(withReuseIdentifier: "lastCell", for: indexPath) as!
                LastCarouseCell
            cell.desLB.text = "Page：\(itemIndex)"
            return cell
        }
    }

    func numberOfItems(in _: EasyCarouseView) -> Int {
        return 3
    }
}

class PrevCarouseCell: UICollectionViewCell {
    let desLB = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .orange
        addSubview(desLB)
        desLB.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MiddleCarouseCell: UICollectionViewCell {
    let verCarouseView = VerticalCarouseView().then {
        $0.status = .none
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        addSubview(verCarouseView)
        verCarouseView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LastCarouseCell: UICollectionViewCell {
    let desLB = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
        addSubview(desLB)
        desLB.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VerticalCarouseView: EasyCarouseView, EasyCarouseViewDelegate, EasyCarouseViewDataSource {
    init() {
        super.init(direction: .vertical, transformScale: 1, alphaScale: 0.4, itemSpace: 20, itemWidthScale: 1, itemHeightScale: 1, itemIndex: 1)
        status = .none
        carouseDataSource = self
        carouseDelegate = self
        collectionView.register(LastCarouseCell.self, forCellWithReuseIdentifier: "lastCell")
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func carouseView(_ carouseView: EasyCarouseView, cellForItemAt indexPath: IndexPath, itemIndex: Int) -> UICollectionViewCell {
        let cell = carouseView.collectionView.dequeueReusableCell(withReuseIdentifier: "lastCell", for: indexPath) as!
            LastCarouseCell
        cell.desLB.text = "Page：\(itemIndex)"
        cell.backgroundColor = .cyan
        return cell
    }

    func numberOfItems(in _: EasyCarouseView) -> Int {
        return 3
    }
}
