//
//===--- TableView+Extension.swift - Defines the TableView+Extension class ----------===//
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
import Foundation
import UIKit

public extension UITableView {
    static func emptyCell() -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        return cell
    }

    func scrollToBottom(animated: Bool = true) {
        DispatchQueue.main.async {
            var yOffset: CGFloat = 0.0

            if self.contentSize.height > self.bounds.size.height {
                yOffset = self.contentSize.height - self.bounds.size.height
            }

            self.setContentOffset(CGPoint(x: 0, y: yOffset), animated: animated)
        }
    }

    private func identifier<T>(cellClass: T.Type) -> String {
        String(describing: cellClass)
    }

    func register<T: UITableViewCell>(cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: identifier(cellClass: cellClass))
    }

    func nibRegister<T>(cellClass: T.Type, bundle _: Bundle?) {
        register(UINib(nibName: identifier(cellClass: cellClass), bundle: nil), forCellReuseIdentifier: identifier(cellClass: cellClass))
    }

    /// 根据View 获取对应Cell的indexpath
    func indexPath(by child: UIView) -> IndexPath? {
        let point = child.convert(CGPoint.zero, to: self)
        return indexPathForRow(at: point)
    }

    /// 根据 child view  获取对应Cell
    func cell(by child: UIView) -> UITableViewCell? {
        let point = child.convert(CGPoint.zero, to: self)
        if let indexPath = indexPathForRow(at: point) {
            return cellForRow(at: indexPath)
        }
        return nil
    }
}

public extension UICollectionView {
    /// 根据View 获取对应Cell的indexpath
    func indexPath(by child: UIView) -> IndexPath? {
        let point = child.convert(CGPoint.zero, to: self)
        return indexPathForItem(at: point)
    }

    /// 根据 child view  获取对应Cell
    func cell(by child: UIView) -> UICollectionViewCell? {
        let point = child.convert(CGPoint.zero, to: self)
        if let indexPath = indexPathForItem(at: point) {
            return cellForItem(at: indexPath)
        }
        return nil
    }
}
