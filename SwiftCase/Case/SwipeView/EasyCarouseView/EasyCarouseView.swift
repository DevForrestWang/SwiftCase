//
//  EasyCarouseView.swift
//  EasyKits
//
// See more information
// https://github.com/MengLiMing/EasyKits
//
//  Created by 孟利明 on 2021/2/24.
//

import Foundation
import RxCocoa
import RxSwift

public protocol EasyCarouseViewDataSource: AnyObject {
    /// 自定义cell
    /// - Parameters:
    ///   - carouseView: 轮播view
    ///   - indexPath: IndexPath
    ///   - itemIndex: 对应数据源的下标
    func carouseView(_ carouseView: EasyCarouseView, cellForItemAt indexPath: IndexPath, itemIndex: Int) -> UICollectionViewCell

    /// 数据数量
    func numberOfItems(in caroueView: EasyCarouseView) -> Int
}

public protocol EasyCarouseViewDelegate: AnyObject {
    /// 点击下标
    func carouseView(_ carouseView: EasyCarouseView, selectedAt index: Int)
    /// 下标改变回调
    func carouseView(_ carouseView: EasyCarouseView, indexChanged index: Int)
}

public extension EasyCarouseViewDelegate {
    /// 点击下标
    func carouseView(_: EasyCarouseView, selectedAt _: Int) {}
    /// 下标改变回调
    func carouseView(_: EasyCarouseView, indexChanged _: Int) {}
}

/// 轮播 - 支持自定义view
open class EasyCarouseView: UIView {
    /// 方向
    public enum Direction {
        case horizontal
        case vertical

        var scrollDirection: UICollectionView.ScrollDirection {
            switch self {
            case .horizontal:
                return .horizontal
            case .vertical:
                return .vertical
            }
        }
    }

    public enum Status {
        /// 默认
        case none
        /// 循环
        case loop
        /// 自动滚动 (秒，是否顺时针)
        case auto(Int, Bool)

        /// 顺时针
        public static func auto(_: Int) -> Status {
            .auto(3, true)
        }
    }

    public weak var carouseDataSource: EasyCarouseViewDataSource?

    public weak var carouseDelegate: EasyCarouseViewDelegate?

    public var status: Status = .none {
        didSet {
            reloadData()
        }
    }

    public private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop = false
        collectionView.isPagingEnabled = false
        backgroundColor = .clear
        collectionView.backgroundColor = .clear
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight,
        ]
        return collectionView
    }()

    private let flowLayout: EasyCarouseViewLayout

    public private(set) var direction: Direction

    fileprivate var timeDisposeBag = DisposeBag()

    /// isLoop == true时 扩大的倍数
    fileprivate let multiple: Int = 100_000

    fileprivate var totalItemsCount: Int = 0

    private let itemWidthScale: CGFloat
    private let itemHeightScale: CGFloat
    private let itemIndex: Int

    private var currentIndexPath = IndexPath(row: 0, section: 0)

    /// 初始化方法
    /// - Parameters:
    ///   - direction: 滚动方向
    ///   - transformScale: 缩放比例最小值 0-1
    ///   - alphaScale: 透明多改变最小值 0-1
    ///   - itemSpace: 间距
    ///   - itemWidthScale: 0-1 cell的宽 = itemWidthScale * collectionView.width
    ///   - itemHeightScale: 0-1 cell的高 = itemHeightScale * collectionView.height
    ///   - itemIndex: 显示的页面
    public init(direction: Direction,
                transformScale: CGFloat = 1,
                alphaScale: CGFloat = 1,
                itemSpace: CGFloat = 0,
                itemWidthScale: CGFloat = 1,
                itemHeightScale: CGFloat = 1,
                itemIndex: Int = 0)
    {
        self.itemWidthScale = max(0, min(1, itemWidthScale))
        self.itemHeightScale = max(0, min(1, itemHeightScale))
        self.itemIndex = itemIndex
        self.direction = direction
        flowLayout = EasyCarouseViewLayout(transformScale: transformScale,
                                           alphaScale: alphaScale,
                                           itemSpace: itemSpace)
        flowLayout.scrollDirection = self.direction.scrollDirection
        super.init(frame: .zero)

        setupUI()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError()
    }

    private func setupUI() {
        addSubview(collectionView)
    }

    fileprivate var sourceCount: Int {
        return carouseDataSource?.numberOfItems(in: self) ?? 0
    }

    fileprivate func scroll(to index: Int) {
        safeScrollToItem(at: IndexPath(row: index, section: 0),
                         animated: true)
    }

    fileprivate func safeScrollToItem(at indexPath: IndexPath, animated: Bool) {
        guard indexPath.item >= 0,
              indexPath.section >= 0,
              indexPath.section < collectionView.numberOfSections,
              indexPath.item < collectionView.numberOfItems(inSection: indexPath.section)
        else {
            return
        }
        var position: UICollectionView.ScrollPosition
        switch direction {
        case .vertical:
            position = .centeredVertically
        case .horizontal:
            position = .centeredHorizontally
        }
        currentIndexPath = indexPath
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: position, animated: animated)
        }
    }

    fileprivate func judgeScrollView(by _: CGPoint) {
        guard isLoop, totalItemsCount > 0 else {
            return
        }
        var targetIndexPath: IndexPath?

        if currentIndexPath.row >= (multiple - 1) * sourceCount {
            targetIndexPath = IndexPath(row: multiple * sourceCount / 2, section: 0)
        } else if currentIndexPath.row == sourceCount - 1 {
            targetIndexPath = IndexPath(row: multiple * sourceCount / 2 + (sourceCount - 1), section: 0)
        }
        if let targetIndexPath = targetIndexPath {
            DispatchQueue.main.async {
                self.safeScrollToItem(at: targetIndexPath, animated: false)
            }
        }
    }

    public func reloadData() {
        totalItemsCount = sourceCount * (isLoop ? multiple : 1)
        if totalItemsCount > 1 {
            collectionView.isScrollEnabled = true
        } else {
            collectionView.isScrollEnabled = false
        }
        collectionView.reloadData()
        if isAuto {
            setupTimer()
        }
        if isLoop {
            safeScrollToItem(at: .init(row: multiple * sourceCount / 2, section: 0), animated: false)
        } else {
            safeScrollToItem(at: .init(row: 0, section: 0), animated: false)
        }

        if itemIndex != 0, itemIndex < sourceCount {
            safeScrollToItem(at: .init(row: itemIndex, section: 0), animated: false)
        }

        initCurrentRow()
    }

    // MARK: override

    override public func layoutSubviews() {
        super.layoutSubviews()

        let targetSize = CGSize(width: itemWidthScale * bounds.size.width,
                                height: itemHeightScale * bounds.size.height)
        if targetSize != flowLayout.itemSize {
            let hInset = (frame.size.width - targetSize.width) / 2
            let vInset = (frame.size.height - targetSize.height) / 2
            flowLayout.sectionInset = .init(top: vInset, left: hInset, bottom: vInset, right: hInset)

            flowLayout.itemSize = targetSize

            reloadData()
        }
    }
}

private extension EasyCarouseView {
    /// 是否循环
    private var isLoop: Bool {
        switch status {
        case .none:
            return false
        case .loop:
            return true
        case .auto:
            return true
        }
    }

    /// 是否自动
    private var isAuto: Bool {
        switch status {
        case .none:
            return false
        case .loop:
            return false
        case .auto:
            return true
        }
    }

    /// 是否顺时针
    private var isClockwise: Bool {
        switch status {
        case .none:
            return false
        case .loop:
            return false
        case let .auto(_, isClockwise):
            return isClockwise
        }
    }

    /// 自动滚动时间间隔
    private var autoSeconds: Int {
        switch status {
        case .none:
            return 0
        case .loop:
            return 0
        case let .auto(second, _):
            return second
        }
    }
}

public extension EasyCarouseView {
    /// indexPath 转下标
    func pageIndex(by indexPath: IndexPath) -> Int {
        return pageIndex(by: indexPath.row)
    }

    func pageIndex(by row: Int) -> Int {
        if sourceCount == 0 {
            return 0
        }
        return row % sourceCount
    }

    /// 获取滑动过程中的IndexPath值
    func scrollingIndexPath() -> IndexPath {
        let center = CGPoint(x: collectionView.contentOffset.x + bounds.size.width / 2, y: collectionView.contentOffset.y + bounds.size.height / 2)
        guard let indexPath = collectionView.indexPathForItem(at: center) else {
            /// 间距可能为 - 此时可能是滑动到了间距的地方 取可见区域内item距离中心最近的item
            let indexPaths = collectionView.indexPathsForVisibleItems
            if indexPaths.count == 0 {
                return .init(row: 0, section: 0)
            } else if indexPaths.count % 2 == 0 {
                let rightIndex = indexPaths.count / 2
                let leftIndex = rightIndex - 1
                guard let leftCell = collectionView.cellForItem(at: indexPaths[leftIndex]),
                      let rightCell = collectionView.cellForItem(at: indexPaths[rightIndex])
                else {
                    return .init(row: 0, section: 0)
                }
                var targetIndex: Int
                switch direction {
                case .horizontal:
                    let centerX = collectionView.contentOffset.x + bounds.size.width / 2
                    if abs(centerX - leftCell.center.x) < abs(centerX - rightCell.center.x) {
                        targetIndex = leftIndex
                    } else {
                        targetIndex = rightIndex
                    }
                case .vertical:
                    let centerY = collectionView.contentOffset.y + bounds.size.height / 2
                    if abs(centerY - leftCell.center.y) < abs(centerY - rightCell.center.y) {
                        targetIndex = leftIndex
                    } else {
                        targetIndex = rightIndex
                    }
                }
                return indexPaths[targetIndex]
            } else {
                let centerIndex: Int = indexPaths.count / 2
                return indexPaths[centerIndex]
            }
        }

        return indexPath
    }

    func currentRow() -> Int {
        currentIndexPath.row
    }

    /// 暂停
    func pause() {
        if isAuto {
            invalidateTimer()
        }
    }

    /// 恢复
    func restore() {
        if isAuto {
            setupTimer()
        }
    }
}

/// Timer
private extension EasyCarouseView {
    @objc func automaticScroll() {
        if isAuto == false { return }
        if totalItemsCount == 0 { return }
        let currentIndex = currentRow()
        let targetIndex: Int
        if isClockwise {
            targetIndex = currentIndex + 1
        } else {
            targetIndex = currentIndex - 1
        }
        scroll(to: targetIndex)
    }

    func setupTimer() {
        guard isAuto else {
            return
        }
        invalidateTimer()
        let second = autoSeconds
        guard second > 0 else {
            return
        }
        Observable<Int>
            .interval(.seconds(second), scheduler: MainScheduler.asyncInstance)
            .takeUntil(rx.deallocated)
            .subscribe(onNext: { [weak self] _ in
                self?.automaticScroll()
            })
            .disposed(by: timeDisposeBag)
    }

    func invalidateTimer() {
        timeDisposeBag = DisposeBag()
    }
}

private extension EasyCarouseView {
    func initCurrentRow() {
        if sourceCount == 0 { return }
        let offsetIndex = currentRow()
        let pageIndex = self.pageIndex(by: offsetIndex)
        carouseDelegate?.carouseView(self, indexChanged: pageIndex)
    }
}

extension EasyCarouseView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_: UIScrollView) {
        let scrollIndexPath = scrollingIndexPath()
        let pageIndex = pageIndex(by: scrollIndexPath)
        carouseDelegate?.carouseView(self, indexChanged: pageIndex)
    }

    public func scrollViewWillEndDragging(_: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset _: UnsafeMutablePointer<CGPoint>) {
        setupTimer()

        var velocityForward: CGFloat
        switch flowLayout.scrollDirection {
        case .horizontal:
            velocityForward = velocity.x
        case .vertical:
            velocityForward = velocity.y
        @unknown default:
            velocityForward = 0
        }

        if velocityForward > 0 {
            currentIndexPath.row += 1
        } else if velocityForward < 0 {
            currentIndexPath.row -= 1
        } else {
            currentIndexPath = scrollingIndexPath()
        }
        safeScrollToItem(at: currentIndexPath, animated: true)
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewEndScroll(scrollView)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewEndScroll(scrollView)
    }

    fileprivate func scrollViewEndScroll(_ scrollView: UIScrollView) {
        judgeScrollView(by: scrollView.contentOffset)
    }

    public func scrollViewWillBeginDragging(_: UIScrollView) {
        invalidateTimer()
    }
}

// MARK: CollectionDelegate/DataSource/DelegateFlowLayout

extension EasyCarouseView: UICollectionViewDelegate {
    public func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = pageIndex(by: indexPath)
        carouseDelegate?.carouseView(self, selectedAt: index)

        /// 处理点击之后打断之前滑动动画
        safeScrollToItem(at: scrollingIndexPath(), animated: true)
    }
}

extension EasyCarouseView: UICollectionViewDataSource {
    public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return totalItemsCount
    }

    public func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = pageIndex(by: indexPath)
        let cell = carouseDataSource?.carouseView(self, cellForItemAt: indexPath, itemIndex: index)
        return cell ?? UICollectionViewCell()
    }
}
