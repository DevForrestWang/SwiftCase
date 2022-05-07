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
// [Yoga 教程-使用跨平台布局引擎](https://iangeli.com/2018/04/16/Yoga%E6%95%99%E7%A8%8B.html#gbjvt)
// [iOS - FlexBox layout YOGAKIT](https://www.programmerall.com/article/68451490868/)
// [Flexbox playground](https://codepen.io/enxaneta/full/adLPwv/)
//
// [Table Views | Apple Developer Documentation](https://developer.apple.com/documentation/uikit/views_and_controls/table_views)
//===----------------------------------------------------------------------===//

import UIKit
import YogaKit

class SCFlexBoxVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 代码调试
        // contentView.showAllBoder()
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

    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return datasource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ShowTableViewCell =
            tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ShowTableViewCell
        cell.show = datasource[indexPath.row]

        let lineView = UIView(frame: CGRect(x: 0, y: cell.frame.size.height - 1, width: view.bounds.size.width, height: 1))
        lineView.backgroundColor = .lightGray
        cell.addSubview(lineView)

        // 去掉选中背景颜色
        cell.selectionStyle = .none
        return cell
    }

    /*
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 21
     }

     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         let view = UIView().then {
             $0.backgroundColor = UIColor.hexColor(0xf2f6f7)
         }
         return view
     }
     */

    // MARK: - UITableViewDelegate methods

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 100.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showToast("Selected row \(indexPath.row)")
    }

    // MARK: - IBActions

    @objc private func buttonAction(_ button: UIButton) {
        if button.tag == 100 {
            showToast("My List action")
        } else if button.tag == 101 {
            showToast("Share action")
        }
    }

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

    private func showActionViewFor(buttonTag: Int, imageName: String, selectImage: String, text: String) -> UIView {
        let actionView = UIView(frame: .zero)
        actionView.configureLayout { layout in
            layout.isEnabled = true
            layout.alignItems = .center
            layout.marginRight = 20.0
        }

        let actionButton = UIButton(type: .custom)
        actionButton.tag = buttonTag
        actionButton.setImage(UIImage(named: imageName), for: .normal)
        actionButton.setImage(UIImage(named: selectImage), for: .selected)
        actionButton.configureLayout { layout in
            layout.isEnabled = true
            layout.padding = 10.0
        }
        actionButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
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
        let tabSelectView = UIView(frame: .zero)
        tabSelectView.backgroundColor = .clear
        if selected {
            tabSelectView.backgroundColor = .red
        }
        tabSelectView.configureLayout { layout in
            layout.isEnabled = true
            layout.width = YGValue(fontSize.width)
            layout.height = 3
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

        datasource = SCFlexBoxData.loadShows()
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
        let image = UIImage(named: "sherlock")
        let imageWidth = image?.size.width ?? 1.0
        let imageHeight = image?.size.height ?? 1.0
        episodeImageView.image = image
        episodeImageView.configureLayout { layout in
            layout.isEnabled = true
            // layout.flexGrow = 1.0
            layout.aspectRatio = imageWidth / imageHeight
        }
        contentView.addSubview(episodeImageView)

        // Sumary View
        let summaryView = UIView(frame: .zero)
        summaryView.configureLayout { layout in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.padding = self.padding
        }

        let summaryPopularityLable = UILabel(frame: .zero)
        summaryPopularityLable.text = String(repeating: "★", count: 5)
        summaryPopularityLable.font = .systemFont(ofSize: 14.0)
        summaryPopularityLable.textColor = .red
        summaryPopularityLable.configureLayout { layout in
            layout.isEnabled = true
            layout.flexBasis = 25%
        }
        summaryView.addSubview(summaryPopularityLable)

        // Info: Year, Rating, Length
        let summaryInfoView = UIView(frame: .zero)
        summaryInfoView.configureLayout { layout in
            layout.isEnabled = true
            layout.flexBasis = 50%
            layout.flexDirection = .row
            layout.justifyContent = .spaceBetween
        }

        for text in ["2022", "TV-14", "3 Series"] {
            let summaryInfoLable = UILabel(frame: .zero)
            summaryInfoLable.text = text
            summaryInfoLable.font = .systemFont(ofSize: 14.0)
            summaryInfoLable.textColor = .lightGray
            summaryInfoLable.configureLayout { layout in
                layout.isEnabled = true
            }
            summaryInfoView.addSubview(summaryInfoLable)
        }
        summaryView.addSubview(summaryInfoView)

        let summaryInfoSpacerView = UIView(frame: .zero)
        summaryInfoSpacerView.configureLayout { layout in
            layout.isEnabled = true
            layout.flexBasis = 25%
        }
        summaryView.addSubview(summaryInfoSpacerView)
        contentView.addSubview(summaryView)

        // title view
        let titleView = UIView(frame: .zero)
        titleView.configureLayout { layout in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.padding = self.padding
        }

        let titleEpisodeLabel = showLableFor(text: "S3:E3", font: .boldSystemFont(ofSize: 16.0))
        titleView.addSubview(titleEpisodeLabel)

        let titleFullLabel = UILabel(frame: .zero)
        titleFullLabel.text = show.title
        titleFullLabel.font = .boldSystemFont(ofSize: 16.0)
        titleFullLabel.textColor = .lightGray
        titleFullLabel.configureLayout { layout in
            layout.isEnabled = true
            layout.marginLeft = 20.0
            layout.marginBottom = 5.0
        }
        titleView.addSubview(titleFullLabel)
        contentView.addSubview(titleView)

        // Description View
        let descriptionView = UIView(frame: .zero)
        descriptionView.configureLayout { layout in
            layout.isEnabled = true
            layout.paddingHorizontal = self.paddingHorizontal
        }

        let descriptionLabel = UILabel(frame: .zero)
        descriptionLabel.font = .systemFont(ofSize: 14.0)
        descriptionLabel.numberOfLines = 3
        descriptionLabel.textColor = .lightGray
        descriptionLabel.text = show.detail
        descriptionLabel.configureLayout { layout in
            layout.isEnabled = true
            layout.marginBottom = 5.0
        }
        descriptionView.addSubview(descriptionLabel)

        let castLabel = showLableFor(text: "Cast: Benedict Cumberbatch, Martin Freeman, Una Stubbs", font: .systemFont(ofSize: 14.0))
        descriptionView.addSubview(castLabel)

        let creatorLabel = showLableFor(text: "Creators: Mark Gatiss, Steven Moffat", font: .systemFont(ofSize: 14.0))
        descriptionView.addSubview(creatorLabel)
        contentView.addSubview(descriptionView)

        // Actions View
        let actionView = UIView(frame: .zero)
        actionView.configureLayout { layout in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.padding = self.padding
        }

        let addActionView = showActionViewFor(buttonTag: 100, imageName: "add", selectImage: "add_select", text: "My List")
        actionView.addSubview(addActionView)

        let shareActionView = showActionViewFor(buttonTag: 101, imageName: "share", selectImage: "share_select", text: "Share")
        actionView.addSubview(shareActionView)
        contentView.addSubview(actionView)

        // Tabs View
        let tabsView = UIView(frame: .zero)
        tabsView.configureLayout { layout in
            layout.isEnabled = true
            layout.flexDirection = .row
            layout.padding = self.padding
        }

        let episodesTabView = showTabBarFor(text: "EPISODES", selected: false)
        tabsView.addSubview(episodesTabView)

        let moreTabView = showTabBarFor(text: "MORE LIKE THIS", selected: true)
        tabsView.addSubview(moreTabView)
        contentView.addSubview(tabsView)

        // Shows
        let tableViewSpace = UIView(frame: .zero)
        tableViewSpace.configureLayout { layout in
            layout.isEnabled = true
            layout.height = YGValue(integerLiteral: self.datasource.count * 100)
        }

        let showTableView = UITableView(frame: .zero, style: .plain)
        showTableView.delegate = self
        showTableView.dataSource = self
        showTableView.backgroundColor = .black
        showTableView.register(ShowTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        showTableView.configureLayout { layout in
            layout.isEnabled = true
            layout.flexGrow = 1.0
        }
        tableViewSpace.addSubview(showTableView)
        contentView.addSubview(tableViewSpace)

        // Apply the layout to view and subviews
        contentView.yoga.applyLayout(preservingOrigin: false)
    }

    // MARK: - Property

    fileprivate var datasource = [SCFlexBoxData]()

    fileprivate let cellIdentifier = "ShowCell"

    private let paddingHorizontal: YGValue = 8.0
    private let padding: YGValue = 8.0

    fileprivate let contentView = UIScrollView(frame: .zero)
}
