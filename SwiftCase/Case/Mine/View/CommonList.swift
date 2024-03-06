//
//===--- CommonList.swift - Defines the CommonList class ----------===//
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
import SnapKit
import UIKit

class CommonListCell<ItemType>: UITableViewCell {
    var item: ItemType?
    override required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

protocol CommonListDelegate: AnyObject {
    func didSelectItem<Item>(_ item: Item)
}

class CommonList<ItemType, CellType: CommonListCell<ItemType>>: UIView, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView
    var items: [ItemType]! = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    weak var delegate: CommonListDelegate?

    override init(frame: CGRect) {
        tableView = UITableView(frame: .zero, style: .plain)
        super.init(frame: frame)
        setupViews()
    }

    func setupViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: CellType? = tableView.dequeueReusableCell(withIdentifier: "cellId") as? CellType
        if cell == nil {
            cell = CellType(style: .subtitle, reuseIdentifier: "cellId")
        }
        cell?.item = items[indexPath.row]
        return cell!
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectItem(items[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
