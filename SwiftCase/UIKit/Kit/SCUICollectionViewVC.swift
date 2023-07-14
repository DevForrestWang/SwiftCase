//
//===--- SCUICollectionViewVC.swift - Defines the SCUICollectionViewVC class ----------===//
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

class SCUICollectionViewVC: BaseViewController, UICollectionViewDataSource,
    UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    @objc func injected() {
        #if DEBUG
            SC.log("I've been injected: \(self)")
            setupUI()
            setupConstraints()
        #endif
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    // MARK: - Protocol

    /// 返回多少个组
    func numberOfSections(in _: UICollectionView) -> Int {
        return 10
    }

    /*
     /// 返回HeadView的宽高
     func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForHeaderInSection _: Int) -> CGSize {
         return CGSize(width: UIScreen.main.bounds.size.width, height: heightHeader)
     }

     /// 返回footview的宽高
     func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForFooterInSection _: Int) -> CGSize {
         return CGSize(width: view.frame.width, height: heightFooter)
     }
     */

    /// 返回自定义HeadView或者FootView，我这里以headview为例
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView
    {
        var reusableview: UICollectionReusableView!

        if kind == UICollectionView.elementKindSectionHeader {
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SCUICollectionReusableViewHeader", for: indexPath)
            reusableview.backgroundColor = .white

            (reusableview as! SCUICollectionReusableViewHeader).label.text = String(format: "The %d header", arguments: [indexPath.section])
        } else if kind == UICollectionView.elementKindSectionFooter {
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SCUICollectionReusableViewFooter", for: indexPath)
            reusableview.backgroundColor = .orange
            (reusableview as! SCUICollectionReusableViewFooter).label.text = String(format: "The %d footer", arguments: [indexPath.section])
        }

        return reusableview
    }

    // 返回多少个cell
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return dataSource.count
    }

    /*
     // cell的宽高
     func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
         return CGSize(width: widthCell, height: heightCell)
     }
     */
    // cell上下左右的间距
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    // 自定义的cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SCUICollectionViewCell", for: indexPath) as! SCUICollectionViewCell

        cell.layer.borderWidth = 3
        cell.layer.borderColor = UIColor.orange.cgColor

        let model = dataSource[indexPath.row]
        cell.label.text = String(format: "Section %d \(model.text ?? "")", arguments: [indexPath.section + 1])
        return cell
    }

    // MARK: 点击事件

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let text = String(format: "clicked %d-%d cell", arguments: [indexPath.section + 1, indexPath.row + 1])
        fwShowToast(text)
    }

    // MARK: - IBActions

    // MARK: - Private

    private func loadData() {
        for number in 1 ... 4 {
            var model = CollectionModel()
            model.text = String(format: "Row %d ", arguments: [number])
            dataSource.append(model)
        }
    }

    // MARK: - UI

    func setupUI() {
        title = "UICollectionView"
        loadData()
        view.addSubview(collectionView)
    }

    // MARK: - Constraints

    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Property

    let heightHeader: CGFloat = 40.0
    let heightFooter: CGFloat = 20.0

    let widthCell = (UIScreen.main.bounds.size.width - 10.0 * 3) / 2
    let heightCell: CGFloat = 80.0

    var dataSource: [CollectionModel] = []

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        // 宽高可以通过：属性化设置或代理方法设置
        // cell的宽高
        layout.itemSize = CGSize(width: widthCell, height: heightCell)
        // 页眉宽高
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.size.width, height: heightHeader)
        // 页脚宽高
        layout.footerReferenceSize = CGSize(width: UIScreen.main.bounds.size.width, height: heightFooter)

        let _collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        _collection.autoresizingMask = .flexibleHeight
        _collection.backgroundColor = .cyan
        _collection.dataSource = self
        _collection.delegate = self
        _collection.showsVerticalScrollIndicator = false

        _collection.register(SCUICollectionViewCell.self, forCellWithReuseIdentifier: "SCUICollectionViewCell")
        _collection.register(SCUICollectionReusableViewHeader.self,
                             forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                             withReuseIdentifier: "SCUICollectionReusableViewHeader")
        _collection.register(SCUICollectionReusableViewFooter.self,
                             forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                             withReuseIdentifier: "SCUICollectionReusableViewFooter")

        return _collection
    }()

    struct CollectionModel {
        var text: String?
    }
}
