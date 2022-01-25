//
//===--- SCFlexBoxVC.swift - Defines the SCFlexBoxVC class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wfd on 2022/1/25.
// Copyright © 2022 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import UIKit
import YogaKit

class SCFlexBoxVC: BaseViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        var contentViewRect: CGRect = .zero
        for view in contentView.subviews {
            contentViewRect = contentViewRect.union(view.frame)
        }
        contentView.contentSize = contentViewRect.size
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - UITableViewDataSource

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return datasource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ShowTableViewCell =
            tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ShowTableViewCell
        cell.show = datasource[indexPath.row]
        return cell
    }

    // MARK: - UITableViewDelegate methods

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 100.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected row \(indexPath.row)")
    }

    // MARK: - IBActions

    // MARK: - Private

    private func showLableFor(text: String, font: UIFont = .systemFont(ofSize: 14.0)) -> UILabel {
        let label = UILabel(frame: .zero)
        label.font = font
        label.textColor = .lightGray
        label.text = text

        label.configureLayout { layout in
            layout.isEnabled = true
            layout.marginBottom = 5.0
        }

        return label
    }

    private func showActionViewFor(imageName: String, text: String) -> UIView {
        let actionView = UIView(frame: .zero)
        actionView.configureLayout { layout in
            layout.isEnabled = true
            layout.alignItems = .center
            layout.marginRight = 20.0
        }

        let actionButton = UIButton(type: .custom)
        actionButton.setImage(UIImage(named: imageName), for: .normal)
        actionButton.configureLayout { layout in
            layout.isEnabled = true
            layout.padding = 10.0
        }
        actionView.addSubview(actionButton)

        let actionLable = showLableFor(text: text)
        actionView.addSubview(actionLable)

        return actionView
    }

    private func showTabBarFor(text: String, selected: Bool) -> UIView {
        let tabView = UIView(frame: .zero)
        tabView.configureLayout { layout in
            layout.isEnabled = true
            layout.alignItems = .center
            layout.marginRight = 20.0
        }

        let tabLableFont = selected ? UIFont.boldSystemFont(ofSize: 14.0) : UIFont.systemFont(ofSize: 14.0)
        let fontSize = text.size(withAttributes: [NSAttributedString.Key.font: tabLableFont])
        let tabSelectView = UIView(frame: CGRect(x: 0, y: 0, width: fontSize.width, height: 3))
        if selected {
            tabSelectView.backgroundColor = .red
        }
        tabSelectView.configureLayout { layout in
            layout.isEnabled = true
            layout.marginBottom = 5.0
        }
        tabView.addSubview(tabSelectView)

        let tabLabel = showLableFor(text: text, font: tabLableFont)
        tabView.addSubview(tabLabel)

        return tabView
    }

    // MARK: - UI

    private func setupUI() {
        title = "Flexbox Case"
        view.backgroundColor = .white

        datasource = LoadData.loadShows()
    }

    // MARK: - Constraints

    private func setupConstraints() {
        // Content View
        contentView.backgroundColor = .black
        contentView.configureLayout { layout in
            layout.isEnabled = true
            layout.height = YGValue(self.view.bounds.size.height)
            layout.width = YGValue(self.view.bounds.size.width)
        }
        view.addSubview(contentView)

        // Main Image View
        let show = datasource[2]
        let episodeImageView = UIImageView(frame: .zero)
        episodeImageView.backgroundColor = .gray
        let image = UIImage(named: show.image)
        let imageWidth = image?.size.width ?? 1.0
        let imageHeight = image?.size.height ?? 1.0
        episodeImageView.image = image
        episodeImageView.configureLayout { layout in
            layout.isEnabled = true
            layout.flexGrow = 1.0
            layout.aspectRatio = imageWidth / imageHeight
        }
        contentView.addSubview(episodeImageView)

        // Apply the layout to view and subviews
        contentView.yoga.applyLayout(preservingOrigin: false)
    }

    // MARK: - Property

    fileprivate var datasource = [LoadData]()

    fileprivate let cellIdentifier = "ShowCell"

    fileprivate let contentView = UIScrollView(frame: .zero)
}
