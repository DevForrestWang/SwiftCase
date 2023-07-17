//
//===--- SCPopListView.swift - Defines the SCPopListView class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2023/6/15.
// Copyright © 2023 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import UIKit

/// 弹出菜单组件
public class SCPopListView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - Lifecycle

    /// 初始化弹框
    /// titleNames:标题名
    /// imageNames:图片名
    /// arrowSize:定义箭头大小，默认宽：10，高：10
    /// iconLeft:图标在左侧还是右侧
    public init(titleNames: [String],
                imageNames: [String],
                arrowSize: CGSize = CGSize(width: 10, height: 15),
                iconLeft: Bool = true)
    {
        super.init(frame: UIScreen.main.bounds)

        self.titleNames = titleNames
        self.imageNames = imageNames
        self.arrowSize = arrowSize
        self.iconLeft = iconLeft
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 重绘图形
    override public func draw(_: CGRect) {
        if arrowPoint != nil {
            drowArrow(arrowPoint, size: arrowSize, isDown: isDownArrow)
        }
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        let touch = (touches as NSSet).anyObject() as! UITouch

        guard let result = touch.view?.isDescendant(of: connentBgView) else {
            return
        }

        if !result {
            hidePopView()
        }
    }

    // MARK: - Public

    /// 隐藏PopView
    public func hidePopView() {
        removeFromSuperview()
    }

    /// 显示popView, 目标组件
    public func showPopView(targetView: UIView) {
        var point = targetView.convert(targetView.bounds.origin, to: UIWindow.keyWindow)
        point = CGPoint(x: point.x + targetView.frame.width / 2, y: point.y + targetView.frame.height - kArrowSpace)
        showPopView(arrowPoint: point, targetRect: targetView.frame)
    }

    /// 显示popView，指定坐标点
    public func showPopView(arrowPoint: CGPoint, targetRect: CGRect) {
        self.arrowPoint = arrowPoint
        frame = UIScreen.main.bounds
        backgroundColor = UIColor.black.withAlphaComponent(0.1)
        UIWindow.keyWindow?.addSubview(self)

        createBgView(arrowPoint: arrowPoint, arrowSize: arrowSize, targetRect: targetRect)

        connentBgView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.reloadData()
    }

    // MARK: - IBActions

    // MARK: - Protocol

    // 返回多少个cell
    public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return titleNames.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SCPopListViewCell", for: indexPath) as? SCPopListViewCell else {
            return UICollectionViewCell()
        }

        let title = indexPath.row < titleNames.count ? titleNames[indexPath.row] : ""
        let imageName = indexPath.row < imageNames.count ? imageNames[indexPath.row] : ""
        let cellWidth = (SC.w - kMarginWidth * 2 - lineNumber) / lineNumber
        cell.update(name: title, imageName: imageName, width: cellWidth, height: cellHeight, iconLeft: iconLeft)
        return cell
    }

    // MARK: 点击事件

    public func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title = indexPath.row < titleNames.count ? titleNames[indexPath.row] : ""
        if let tmpClourse = popListViewSelectItemClosure {
            tmpClourse(title, indexPath.row)
            hidePopView()
        }
    }

    // MARK: - Private

    /// 添加button的背景图
    private func createBgView(arrowPoint: CGPoint, arrowSize: CGSize, targetRect: CGRect) {
        let titleCount = titleNames.count
        if titleCount <= 0 {
            return
        }

        // 屏幕宽度
        var xPoint = kMarginWidth
        var iWidth = SC.w - kMarginWidth * 2

        if titleCount < Int(lineNumber) {
            iWidth = CGFloat(titleCount) * (SC.w / lineNumber)
            xPoint = (SC.w - iWidth) / 2
        }

        let popHeight = ceil(Double(titleNames.count) / lineNumber) * cellHeight
        let popViewSize = CGSize(width: iWidth, height: popHeight)
        connentBgView = UIView(frame: CGRect(origin: CGPoint(x: xPoint, y: arrowPoint.y + arrowSize.height), size: popViewSize))

        // X 坐标超过屏幕左边
        let originX = connentBgView.frame.origin.x
        if originX < kMarginWidth {
            connentBgView.frame.origin.x = kMarginWidth
        }
        // X 坐标超过屏幕右边
        if (originX + popViewSize.width + kMarginWidth) > SC.w {
            connentBgView.frame.origin.x = SC.w - popViewSize.width - kMarginWidth
        }

        // Y 坐标超过屏幕底部
        let originY = connentBgView.frame.origin.y
        if (originY + popViewSize.height + kMarginWidth) > SC.h {
            connentBgView.frame.origin.y = targetRect.origin.y - popViewSize.height - kArrowSpace
            self.arrowPoint.y = connentBgView.frame.origin.y + popViewSize.height + arrowSize.height
            isDownArrow = true
        }

        // 设置背景阴影
        connentBgView.backgroundColor = UIColor.hexColor(0xFFFEFE)
        connentBgView.layer.cornerRadius = 5
        connentBgView.layer.shadowOpacity = 0.5
        connentBgView.layer.shadowColor = UIColor.gray.cgColor
        connentBgView.layer.shadowRadius = 5
        connentBgView.layer.shadowOffset = CGSize(width: 3, height: 3)
        connentBgView.layer.masksToBounds = true
        addSubview(connentBgView)

        // 触发drawRect
        setNeedsDisplay()
    }

    /// 画三角形
    private func drowArrow(_ point: CGPoint, size: CGSize, isDown: Bool = false) {
        let context = UIGraphicsGetCurrentContext()
        context?.move(to: point)

        var leftPoint = CGPoint(x: point.x - size.width, y: point.y + size.height)
        var rightPoint = CGPoint(x: point.x + size.width, y: point.y + size.height)
        if isDown {
            leftPoint = CGPoint(x: point.x - size.width, y: point.y - size.height)
            rightPoint = CGPoint(x: point.x + size.width, y: point.y - size.height)
        }

        context?.addLine(to: leftPoint)
        context?.addLine(to: rightPoint)
        context?.addLine(to: point)
        context?.setFillColor(red: 1, green: 1, blue: 1, alpha: 1)
        context?.fillPath()
        context?.strokePath()
    }

    // MARK: - Property

    public var popListViewSelectItemClosure: ((_ name: String, _ index: Int) -> Void)?

    // 一行组件个数
    public var lineNumber: CGFloat = 3
    // 每个单元格高度
    public var cellHeight: CGFloat = 30
    // 默认边界距离
    public var kMarginWidth: CGFloat = 15
    // 箭头的间隙
    public var kArrowSpace: CGFloat = 10

    private var connentBgView: UIView!
    private var arrowPoint: CGPoint!
    private var arrowSize: CGSize!
    private var isDownArrow = false

    private var titleNames: [String]!
    private var imageNames: [String]!
    private var iconLeft: Bool = true

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        let cellWidth = (SC.w - kMarginWidth * 2 - lineNumber) / lineNumber
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)

        let _collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        _collection.backgroundColor = .white
        _collection.autoresizingMask = .flexibleHeight
        _collection.showsVerticalScrollIndicator = false
        _collection.bounces = false
        _collection.delegate = self
        _collection.dataSource = self
        _collection.register(SCPopListViewCell.self, forCellWithReuseIdentifier: "SCPopListViewCell")
        return _collection
    }()
}

/// 选择的Cell
class SCPopListViewCell: UICollectionViewCell {
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError()
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    // MARK: - Protocol

    public func update(name: String, imageName: String,
                       width: CGFloat, height: CGFloat,
                       iconLeft: Bool = true)
    {
        nameLable.text = name

        imagView.isHidden = true
        if imageName.count > 0 {
            imagView.isHidden = false
            imagView.image = UIImage(named: imageName)
        }

        let nameSize = name.getBoundingRect(font: nameLable.font, limitSize: CGSize(width: SC.w, height: height))
        let isOutMaxWidth = (nameSize.width + 14 + 4) > width ? true : false

        if iconLeft {
            setupConstraintsLeft(isOutMaxWidth: isOutMaxWidth)
        } else {
            setupConstraintsRight(isOutMaxWidth: isOutMaxWidth)
        }

        // 设置边框
        bgView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        bgView.addBottomBorder(borderColor: UIColor.hexColor(0xC7C7C7))
        bgView.addRightBorder(borderColor: UIColor.hexColor(0xC7C7C7))
    }

    // MARK: - IBActions

    // MARK: - Private

    // MARK: - UI

    private func setupUI() {
        addSubview(bgView)
        bgView.addSubview(nameLable)
        bgView.addSubview(imagView)
    }

    // MARK: - Constraints

    private func setupConstraintsRight(isOutMaxWidth: Bool) {
        if isOutMaxWidth {
            nameLable.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(2)
                make.right.equalTo(imagView.snp.left)
            }

            imagView.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()

                var width: CGFloat = 14
                if imagView.isHidden {
                    width = 0
                }
                make.width.height.equalTo(width)
                make.right.equalToSuperview().offset(-2)
            }
        } else {
            nameLable.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()

                var offSet: CGFloat = -16
                if imagView.isHidden {
                    offSet = 0
                }
                make.centerX.equalToSuperview().offset(offSet)
            }

            imagView.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.width.height.equalTo(14)
                make.left.equalTo(nameLable.snp.right).offset(2)
            }
        }
    }

    private func setupConstraintsLeft(isOutMaxWidth: Bool) {
        if isOutMaxWidth {
            nameLable.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(imagView.snp.right)
                make.right.equalToSuperview().offset(-2)
            }

            imagView.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()

                var width: CGFloat = 14
                if imagView.isHidden {
                    width = 0
                }
                make.width.height.equalTo(width)
                make.left.equalToSuperview().offset(2)
            }
        } else {
            nameLable.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()

                var offSet: CGFloat = 16
                if imagView.isHidden {
                    offSet = 0
                }
                make.centerX.equalToSuperview().offset(offSet)
            }

            imagView.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.width.height.equalTo(14)
                make.right.equalTo(nameLable.snp.left).offset(2)
            }
        }
    }

    // MARK: - Property

    let bgView = UIView()

    let nameLable = UILabel().then {
        $0.text = ""
        $0.textColor = UIColor.hexColor(0x676767)
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .center
        $0.adjustsFontSizeToFitWidth = true
    }

    let imagView = UIImageView().then {
        $0.image = UIImage(named: "")
    }
}
