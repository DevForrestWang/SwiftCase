//
//===--- SwiftPopMenu.swift - Defines the SwiftPopMenu class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wfd on 2022/1/21.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import SnapKit
import Then
import UIKit

class SCPopMenuVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    // 执行析构过程
    deinit {
        debugPrint("===========<deinit: \(type(of: self))>===========")
    }

    // MARK: - Public

    // MARK: - Protocol

    // MARK: - UITableViewDelegate

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return dataSource.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SCPopMenuCell") as? SCPopMenuCell else {
            return UITableViewCell()
        }
        let title = dataSource[indexPath.row]
        cell.update(title: title)

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 80
    }

    // MARK: - UITableViewDataSource

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = dataSource[indexPath.row]
        SC.toast("click cell title: \(title)")
    }

    // MARK: - IBActions

    @objc private func longPressAction(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            // 获取屏幕位置
            let screenPoint = gesture.location(in: gWindow)

            // 获取长按的行号
            let tvPoint = gesture.location(in: tableView)
            let indexPath = tableView.indexPathForRow(at: tvPoint)
            guard let cellIndex = indexPath else {
                debugPrint("The indexPath is nil.")
                return
            }

            showPopMenu(point: screenPoint, row: cellIndex.row)
        }
    }

    // MARK: - Private

    private func showPopMenu(point: CGPoint, row: Int) {
        SC.toast("point:\(point), row: \(row)")

        let popData = [(icon: "", title: "解除禁言")]

        // 设置参数
        let parameters: [SwiftPopMenuConfigure] = [
            .PopMenuTextColor(UIColor.black),
            .popMenuItemHeight(44),
            .PopMenuTextFont(UIFont.systemFont(ofSize: 16)),
            .popMenuIconLeftMargin(0),
        ]

        popMenu = SwiftPopMenu(menuWidth: 120,
                               arrow: CGPoint(x: gScreenWidth - 20, y: point.y),
                               datas: popData, configures: parameters)

        popMenu?.didSelectMenuBlock = { index in
            debugPrint("block select \(index)")
        }
        popMenu?.show()
    }

    // MARK: - UI

    private func setupUI() {
        title = "长按弹出菜单"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        // 添加长按手势
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
        gesture.minimumPressDuration = 1.5
        tableView.addGestureRecognizer(gesture)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Property

    var popMenu: SwiftPopMenu?

    let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .white
        $0.tableFooterView = UIView()
        $0.tableHeaderView = UIView()
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.register(SCPopMenuCell.self, forCellReuseIdentifier: "SCPopMenuCell")
    }

    var dataSource: [String] = ["row1", "row2", "row3", "row4", "row5", "row6", "row7", "row8",
                                "row9", "row10", "row11", "row12", "row13", "row14", "row15", "row16"]

    public let gScreenHeight = UIScreen.main.bounds.height
    public let gScreenWidth = UIScreen.main.bounds.width

    public var gWindow: UIWindow? {
        guard let window = UIApplication.shared.delegate?.window else {
            return nil
        }
        return window
    }
}

class SCPopMenuCell: UITableViewCell {
    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 开启否则按钮无事件响应
        contentView.isUserInteractionEnabled = true
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // 执行析构过程
    deinit {}

    func update(title: String) {
        titleLable.text = title
    }

    // MARK: - Private

    // MARK: - UI

    private func setupUI() {
        backgroundColor = .white
        addSubview(titleLable)
    }

    // MARK: - Constraints

    private func setupConstraints() {
        titleLable.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }

    let titleLable = UILabel().then {
        $0.text = ""
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textAlignment = .left
    }
}
