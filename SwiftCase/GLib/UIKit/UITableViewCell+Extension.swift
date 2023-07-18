//
//===--- UITableViewCell+Extension.swift - Defines the TUITableViewCell+Extension class ----------===//
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

public extension UITableViewCell {
    /// 获取 Cell Identifier
    static func ex_identifier() -> String {
        return NSStringFromClass(classForCoder())
    }

    /// 给某个 tableView 注册当前 cell
    /// - Parameter tableView: tableView
    static func ex_registerCell(_ tableView: UITableView) {
        tableView.register(classForCoder(), forCellReuseIdentifier: ex_identifier())
    }

    /// 根据某个 TableView 从复用池中获取一个 Cell
    /// - Parameters:
    ///   - tableView: tableView
    ///   - indexPath: indexPath
    /// - Returns: cell
    static func ex_dequeueReusableCell(forTableView tableView: UITableView, atIndexPath indexPath: IndexPath) -> Self {
        let cell = tableView.dequeueReusableCell(withIdentifier: ex_identifier(), for: indexPath) as! Self
        return cell
    }
}

public extension UICollectionViewCell {
    /// 获取 Cell Identifier
    static func ex_identifier() -> String {
        return NSStringFromClass(classForCoder())
    }

    /// 给某个 CollectionView 注册当前 cell
    /// - Parameter collectionView: collectionView
    static func ex_registerCell(_ collectionView: UICollectionView) {
        collectionView.register(classForCoder(), forCellWithReuseIdentifier: ex_identifier())
    }

    /// 根据某个 CollectionView 从复用池中获取一个 Cell
    /// - Parameters:
    ///   - collectionView: collectionView
    ///   - indexPath: indexPath
    /// - Returns: cell
    static func ex_dequeueReusableCell(forCollectionView collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> Self {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ex_identifier(), for: indexPath) as! Self
        return cell
    }
}
