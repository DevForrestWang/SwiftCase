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

    func dequeueReusableCell<T: UITableViewCell>(cellClass: T.Type, indexPath: IndexPath) -> T? {
        dequeueReusableCell(withIdentifier: identifier(cellClass: cellClass), for: indexPath) as? T
    }
}
