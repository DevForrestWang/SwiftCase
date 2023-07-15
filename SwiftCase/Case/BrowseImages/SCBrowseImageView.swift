//
//===--- SCBrowseImageView.swift - Defines the SCBrowseImageView class ----------===//
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

import Kingfisher
import SnapKit
import Then
import UIKit

class SCBrowseImageView: UIView, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{
    // MARK: - Lifecycle

    @objc func injected() {
        #if DEBUG
            SC.log("I've been injected: \(self)")
            setupUI()
            setupConstraints()
        #endif
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    @objc public func show(_ imageAry: NSArray) {
        if imageAry.count <= 0 {
            SC.log("The imageAry is empty")
            return
        }

        dataSource = imageAry
        selectImage = 0
        updateImage(index: selectImage)
        collectionView.reloadData()
        collectionView.selectItem(at: NSIndexPath(row: 0, section: 0) as IndexPath, animated: true, scrollPosition: .top)

        SC.window?.addSubview(self)
    }

    func dismiss() {
        removeFromSuperview()
    }

    // MARK: - Protocol

    // MARK: - UIScrollViewDelegate

    func viewForZooming(in _: UIScrollView) -> UIView? {
        return shopImageView
    }

    func scrollViewDidEndZooming(_: UIScrollView, with _: UIView?, atScale scale: CGFloat) {
        // 把当前的缩放比例设进ZoomScale，以便下次缩放时实在现有的比例的基础上
        imageScrollView.setZoomScale(scale, animated: false)
    }

    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return dataSource?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SCBrowsImageCell", for: indexPath) as! SCBrowsImageCell

        cell.selectedBackgroundView = UIView(frame: cell.frame)
        // cell.selectedBackgroundView?.backgroundColor = .lightGray
        cell.selectedBackgroundView?.layer.borderWidth = 2
        cell.selectedBackgroundView?.layer.cornerRadius = 3
        cell.selectedBackgroundView?.layer.borderColor = UIColor.red.cgColor

        let imageURL = dataSource?[indexPath.item] as! String
        cell.imageView.kf.setImage(with: URL(string: imageURL), placeholder: UIImage(named: "placeholder"))

        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectImage = indexPath.item
        updateImage(index: selectImage)

        let scale: CGFloat = imageScrollView.zoomScale * 1.0
        imageScrollView.setZoomScale(scale, animated: false)
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    // 最小行间距
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 10
    }

    // 每个分区的内边距
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    // item 的尺寸
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let itemHeight = collectionItemHeight - 10
        return CGSize(width: itemHeight, height: itemHeight)
    }

    // MARK: - IBActions

    @objc private func closeBtnAction() {
        dismiss()
    }

    @objc func swipeImageAction(recognizer: UISwipeGestureRecognizer) {
        if recognizer.direction == .left {
            selectImage += 1
            if selectImage > dataSource!.count - 1 {
                selectImage = dataSource!.count - 1
            }
            updateImage(index: selectImage)
            collectionView.selectItem(at: NSIndexPath(row: selectImage, section: 0) as IndexPath, animated: true, scrollPosition: .left)
        } else if recognizer.direction == .right {
            selectImage -= 1
            if selectImage < 0 {
                selectImage = 0
            }
            updateImage(index: selectImage)
            collectionView.selectItem(at: NSIndexPath(row: selectImage, section: 0) as IndexPath, animated: true, scrollPosition: .right)
        }
    }

    // MARK: - Private

    private func updateImage(index: Int) {
        guard index < dataSource?.count ?? 0 else {
            SC.log("the index out dataSource count")
            return
        }

        let imageURL = dataSource?[index] as! String
        shopImageView.kf.setImage(with: URL(string: imageURL), placeholder: UIImage(named: "placeholder"))
    }

    private func addSwipeGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeImageAction))
        swipeLeft.direction = .left
        swipeLeft.numberOfTouchesRequired = 1
        imageScrollView.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeImageAction))
        swipeRight.direction = .right
        imageScrollView.addGestureRecognizer(swipeRight)
    }

    // MARK: - UI

    func setupUI() {
        frame = CGRect(x: 0, y: 0, width: SC.w, height: SC.w)
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        addSubview(titleLable)

        addSubview(imageScrollView)
        imageScrollView.addSubview(shopImageView)
        imageScrollView.delegate = self
        imageScrollView.minimumZoomScale = 1
        imageScrollView.maximumZoomScale = 3

        addSubview(contentView)
        contentView.addSubview(closeButton)
        // 放到then里会导致无响应
        closeButton.addTarget(self, action: #selector(closeBtnAction), for: .touchUpInside)
        contentView.addSubview(collectionView)
        contentView.addSubview(lineView)

        let closeGesture = UITapGestureRecognizer(target: self, action: #selector(closeBtnAction))
        closeGesture.numberOfTapsRequired = 1
        closeGesture.numberOfTouchesRequired = 1
        imageScrollView.addGestureRecognizer(closeGesture)

        addSwipeGesture()
    }

    // MARK: - Constraints

    func setupConstraints() {
        titleLable.snp.makeConstraints { make in
            make.height.equalTo(21)
            make.width.equalTo(self)
            make.top.equalTo(35)
        }

        imageScrollView.snp.makeConstraints { make in
            make.width.equalTo(SC.w)
            make.height.equalTo(SC.w - contentViewHeight)
            // make.center.equalToSuperview()
        }

        shopImageView.snp.makeConstraints { make in
            make.width.equalTo(self)
            make.height.equalTo(SC.w)
            make.center.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.height.equalTo(contentViewHeight)
            make.width.equalToSuperview()
            make.bottom.equalTo(self.snp.bottom)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(collectionItemHeight)
        }

        lineView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.width.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom).offset(1)
        }

        closeButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(self)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }

    // MARK: - Property

    let contentViewHeight: CGFloat = 130
    let collectionItemHeight: CGFloat = 80
    var dataSource: NSArray?
    var selectImage: Int = 0

    let titleLable = UILabel().then {
        $0.text = "Picture"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 18)
        $0.textAlignment = .center
    }

    let imageScrollView = UIScrollView().then {
        $0.isUserInteractionEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.scrollsToTop = false
        $0.isScrollEnabled = true
        $0.frame = CGRect(x: 0, y: 0, width: SC.w, height: SC.w)
    }

    let shopImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "placeholder")
        // 设置这个_imageView能被缩放的最大尺寸，这句话很重要，一定不能少,如果没有这句话，图片不能缩放
        $0.frame = CGRect(x: 0, y: 0, width: SC.w * 2.5, height: SC.w * 2.5)
    }

    let contentView = UIView().then {
        $0.backgroundColor = .white
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemHeight = collectionItemHeight - 10
        layout.itemSize = CGSize(width: itemHeight, height: itemHeight)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.scrollDirection = .horizontal

        let _collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        _collection.register(SCBrowsImageCell.self, forCellWithReuseIdentifier: "SCBrowsImageCell")
        _collection.backgroundColor = .white
        _collection.showsHorizontalScrollIndicator = false
        _collection.allowsSelection = true
        _collection.delegate = self
        _collection.dataSource = self

        return _collection
    }()

    let lineView = UIView().then {
        $0.backgroundColor = UIColor.hexColor(0xD7D8D9)
    }

    let closeButton = UIButton(type: .custom).then {
        $0.backgroundColor = .white
        $0.setTitle("Close", for: .normal)
        $0.setTitleColor(UIColor.hexColor(0x47484A), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
}
