//
//===--- SCTailDescriptionView.swift - Defines the SCTailDescriptionView class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2022/6/14.
// Copyright © 2022 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// 底部说明文字添加
// See more information
// Example:
//  let tailDescription = GYTailDescriptionView()
//  view.addSubview(tailDescription)
//
//  tailDescription.snp.makeConstraints { make in
//      make.edges.equalToSuperview().offset(10)
//  }
//  let itemAry = ["每次发送短信限制1条/会员。",
//                 "以避免给用户带来恶意骚扰的烦恼。"]
//  tailDescription.updateData(title: "使用须知", titleColor: .red, titleFont: .systemFont(ofSize: 15),
//                             itemsAry: itemAry, itemsColor: .red, itemFont: .systemFont(ofSize: 15))
//
//===----------------------------------------------------------------------===//

import SnapKit
import Then
import UIKit

public class SCTailDescriptionView: UIView {
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public

    public func updateData(title: String,
                           titleColor: UIColor = .red,
                           titleFont: UIFont = .systemFont(ofSize: 14),
                           itemsAry: [String],
                           itemsColor: UIColor = .red,
                           itemFont: UIFont = .systemFont(ofSize: 14))
    {
        titleLable.text = title
        titleLable.textColor = titleColor
        titleLable.font = titleFont

        createItemView(itemsAry: itemsAry, itemsColor: itemsColor, itemFont: itemFont)
    }

    // MARK: - Private

    private func createItemView(itemsAry: [String], itemsColor: UIColor, itemFont: UIFont) {
        var index = 1
        var lastValueLable: UILabel?

        for item in itemsAry {
            let indexLable = UILabel().then {
                $0.text = "\(index)、"
                $0.textColor = itemsColor
                $0.font = itemFont
                $0.textAlignment = .left
            }
            let valueLable = UILabel().then {
                $0.text = item
                $0.textColor = itemsColor
                $0.font = itemFont
                $0.numberOfLines = 0
                $0.textAlignment = .left
            }
            itemsView.addSubview(indexLable)
            itemsView.addSubview(valueLable)

            if let tmpLastValueLable = lastValueLable {
                indexLable.snp.makeConstraints { make in
                    make.top.equalTo(tmpLastValueLable.snp.bottom)
                    make.height.equalTo(21 * viewScale)
                    make.width.equalTo(30 * viewScale)
                    make.left.equalToSuperview()
                }

                valueLable.snp.makeConstraints { make in
                    make.top.equalTo(tmpLastValueLable.snp.bottom)
                    make.left.equalTo(indexLable.snp.right)
                    make.right.equalToSuperview()
                }
            } else {
                indexLable.snp.makeConstraints { make in
                    make.top.equalTo(1)
                    make.height.equalTo(21 * viewScale)
                    make.width.equalTo(30 * viewScale)
                    make.left.equalToSuperview()
                }

                valueLable.snp.makeConstraints { make in
                    make.top.equalTo(1)
                    make.left.equalTo(indexLable.snp.right)
                    make.right.equalToSuperview()
                }
            }

            index += 1
            lastValueLable = valueLable
        }
    }

    // MARK: - UI

    private func setupUI() {
        addSubview(titleLable)
        addSubview(itemsView)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        titleLable.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.height.equalTo(30 * viewScale)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }

        itemsView.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    // MARK: - Property

    let viewScale = gEqualScale

    let titleLable = UILabel().then {
        $0.text = ""
        $0.textAlignment = .left
    }

    let itemsView = UIView()
}
