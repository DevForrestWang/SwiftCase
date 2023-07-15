//
//===--- SCSelectTableView.swift - Defines the SCSelectTableView class ----------===//
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

/// 头部为蓝色背景，有选择框的表格
public class SCSelectTableView: UIView {
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError()
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    public func show(dataSource: [[String]], noDataInfo: String) {
        if dataSource.count < 0 {
            SC.log("The dataSource is empty.")
            return
        }

        let titleAry = dataSource.map { itemAry in
            itemAry[0]
        }

        // 创建表格头部
        let titleView = createView(yPoint: 0, titleAry: titleAry)
        addSubview(titleView)

        // 校验数据，按最短的输出创建表格
        var dataSize: Int = dataSource.first?.count ?? 0
        for itemAry in dataSource {
            if itemAry.count < dataSize {
                dataSize = itemAry.count
            }
        }

        if dataSize > 1 {
            for index in 1 ..< dataSize {
                let itemAry = dataSource.map { tmpAry in
                    tmpAry[index]
                }
                let oneItemView = createItemView(yPoint: index * cellHeight, tag: baseTag + index, dataAry: itemAry)
                addSubview(oneItemView)
            }
        } else {
            let emptyView = createEmptyItemView(yPoint: cellHeight, message: noDataInfo)
            addSubview(emptyView)
        }
    }

    // MARK: - Protocol

    // MARK: - IBActions

    @objc private func selectButtonAction(button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            button.setImage(UIImage(named: "gy_assistant_active_select_box"), for: .normal)
        } else {
            button.setImage(UIImage(named: "gy_assistant_active_unselect_box"), for: .normal)
        }

        if let tmpClosure = gySelectTableViewClosure {
            tmpClosure(button.tag - baseTag, button.isSelected)
        }
    }

    // MARK: - Private

    private func createView(yPoint: Int, titleAry: [String]) -> UIView {
        let bgView = UIView().then {
            $0.backgroundColor = bgColor
        }
        let iWidth = Int(SC.w) - Int(leftSpace * 2)
        bgView.frame = CGRect(x: leftSpace, y: yPoint, width: iWidth + 1, height: cellHeight)

        let itemWidth = Int((iWidth - selectCellWidth) / titleAry.count)
        var index = 0
        for name in titleAry {
            let lineView = UIView().then {
                $0.backgroundColor = .white
            }
            bgView.addSubview(lineView)
            lineView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                make.width.equalTo(1)
                make.left.equalTo(selectCellWidth + index * itemWidth)
            }

            let itemLable = UILabel().then {
                $0.text = name
                $0.textColor = .white
                $0.font = fontSize
                $0.textAlignment = .center
                $0.backgroundColor = bgColor
            }
            bgView.addSubview(itemLable)
            itemLable.snp.makeConstraints { make in
                make.height.equalTo(21)
                make.width.equalTo(itemWidth - 1)
                make.centerY.equalToSuperview()
                make.left.equalTo(lineView.snp.right)
            }

            index += 1
        }

        return bgView
    }

    private func createItemView(yPoint: Int, tag: Int, dataAry: [String]) -> UIView {
        let bgView = UIView().then {
            $0.backgroundColor = bgColor
        }
        let iWidth = Int(SC.w) - Int(leftSpace * 2)
        bgView.frame = CGRect(x: leftSpace, y: yPoint, width: iWidth + 1, height: cellHeight)

        let selectBtn = UIButton(type: .custom).then {
            $0.backgroundColor = .white
            $0.setImage(UIImage(named: "gy_assistant_active_unselect_box"), for: .normal)
            $0.isSelected = false
            $0.tag = tag
        }
        bgView.addSubview(selectBtn)
        selectBtn.addTarget(self, action: #selector(selectButtonAction), for: .touchUpInside)
        selectBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-1)
            make.width.equalTo(selectCellWidth - 1)
            make.left.equalToSuperview().offset(1)
        }

        let itemWidth = Int((iWidth - selectCellWidth) / dataAry.count)
        var index = 0
        for value in dataAry {
            let itemLable = UILabel().then {
                $0.backgroundColor = .white
                $0.text = value
                $0.textColor = itemFontColor
                $0.font = fontSize
                $0.textAlignment = .center
            }
            bgView.addSubview(itemLable)

            var tmpWidth = itemWidth - 1
            if index == (dataAry.count - 1), dataAry.count % 2 == 0 {
                tmpWidth += 1
            }
            itemLable.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview().offset(-1)
                make.width.equalTo(tmpWidth)
                make.left.equalTo(selectCellWidth + index * itemWidth + 1)
            }

            index += 1
        }

        return bgView
    }

    private func createEmptyItemView(yPoint: Int, message: String) -> UIView {
        let bgView = UIView().then {
            $0.backgroundColor = bgColor
        }
        let iWidth = Int(SC.w) - Int(leftSpace * 2)
        bgView.frame = CGRect(x: leftSpace, y: yPoint, width: iWidth + 1, height: cellHeight + 10)

        let messageLable = UILabel().then {
            $0.backgroundColor = .white
            $0.text = message
            $0.textColor = UIColor.hexColor(0x808080)
            $0.font = fontSize
            $0.textAlignment = .center
        }
        bgView.addSubview(messageLable)
        messageLable.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-1)
            make.left.equalToSuperview().offset(1)
            make.right.equalToSuperview().offset(-1)
        }

        return bgView
    }

    // MARK: - UI

    private func setupUI() {}

    // MARK: - Constraints

    private func setupConstraints() {}

    // MARK: - Property

    public var gySelectTableViewClosure: ((_ row: Int, _ isSelect: Bool) -> Void)?
    public var bgColor = UIColor.hexColor(0x00AEFF)
    public var itemFontColor = UIColor.black
    public var fontSize = UIFont.systemFont(ofSize: 14)
    public var cellHeight = 40
    public var selectCellWidth = 53
    public var leftSpace: Int = 20

    let baseTag = 8000
}
