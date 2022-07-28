//
//===--- SCalendarDateRangePickerView.swift - Defines the SCalendarDateRangePickerView class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/9/26.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
// [miraan/CalendarDateRangePickerViewController](https://github.com/miraan/CalendarDateRangePickerViewController)
//===----------------------------------------------------------------------===//

import UIKit

public class SCalendarDateRangePickerView: UIView {
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
    deinit {
        yxc_debugPrint("===========<deinit: \(type(of: self))>===========")
    }

    // MARK: - Public

    /// 需要在开始日期、结束日期、及回调之后调用
    public func getDefaultDate() {
        // 如果有初始值执行一次回调
        if let tempClosure = gySelectDataRangeClosure,
           let startDate: Date = selectedStartDate,
           let endData: Date = selectedEndDate
        {
            tempClosure(startDate, endData)
        }
    }

    // MARK: - UI

    private func setupUI() {
        yxc_debugPrint("===========<loadClass: \(type(of: self))>===========")
        addSubview(collectionView)

        if minimumDate == nil {
            minimumDate = Date()
        }
        if maximumDate == nil {
            maximumDate = Calendar.current.date(byAdding: .year, value: 3, to: minimumDate)
        }
    }

    // MARK: - Constraints

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Property

    public var gySelectDataRangeClosure: ((_ startDate: Date, _ endDate: Date) -> Void)?
    // 最小的日期
    public var minimumDate: Date!
    // 最大的日期
    public var maximumDate: Date!

    // 默认开始、结束日期
    public var selectedStartDate: Date?
    public var selectedEndDate: Date?

    // 选择开始结束颜色
    public var selectedColor = UIColor.red
    // 选择背景颜色
    public var highlightedColor = UIColor.hexColor(0xFAE8E8)

    public var titleDateFormat: String = "yyyy年MM月"
    public var isWeekCN: Bool = true
    // 是否显示开始、结束
    public var showSubTitle: Bool = true

    private let cellReuseIdentifier = "SCalendarDateRangePickerCell"
    private let headerReuseIdentifier = "SCCalendarDateRangePickerHeaderView"
    private let weekCnDays = ["日", "一", "二", "三", "四", "五", "六"]
    private let itemsPerRow = 7
    private let itemHeight: CGFloat = 40
    private let collectionViewInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let _collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        _collection.backgroundColor = .white
        _collection.delegate = self
        _collection.dataSource = self
        _collection.register(SCalendarDateRangePickerCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        _collection.register(SCCalendarDateRangePickerHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        _collection.contentInset = collectionViewInsets

        return _collection
    }()
}

/// UICollectionViewDataSource, UICollectionViewDelegate
extension SCalendarDateRangePickerView: UICollectionViewDataSource, UICollectionViewDelegate {
    public func numberOfSections(in _: UICollectionView) -> Int {
        let difference = Calendar.current.dateComponents([.month], from: minimumDate, to: maximumDate)
        return difference.month! + 1
    }

    public func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let firstDateForSection = getFirstDateForSection(section: section)
        let weekdayRowItems = 7
        let blankItems = getWeekday(date: firstDateForSection) - 1
        let daysInMonth = getNumberOfDaysInMonth(date: firstDateForSection)
        return weekdayRowItems + blankItems + daysInMonth
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! SCalendarDateRangePickerCell
        cell.selectedColor = selectedColor
        cell.highlightedColor = highlightedColor
        cell.showSubTitle = showSubTitle
        cell.reset()

        let blankItems = getWeekday(date: getFirstDateForSection(section: indexPath.section)) - 1
        if indexPath.item < 7 {
            cell.label.text = getWeekdayLabel(weekday: indexPath.item + 1)
        } else if indexPath.item < 7 + blankItems {
            cell.label.text = ""
        } else {
            let dayOfMonth = indexPath.item - (7 + blankItems) + 1
            let date = getDate(dayOfMonth: dayOfMonth, section: indexPath.section)
            cell.date = date
            cell.label.text = "\(dayOfMonth)"

            if isBefore(dateA: date, dateB: minimumDate) {
                cell.disable()
            }

            if selectedStartDate != nil, selectedEndDate != nil, isBefore(dateA: selectedStartDate!, dateB: date), isBefore(dateA: date, dateB: selectedEndDate!) {
                // Cell falls within selected range
                if dayOfMonth == 1 {
                    cell.highlightRight()
                } else if dayOfMonth == getNumberOfDaysInMonth(date: date) {
                    cell.highlightLeft()
                } else {
                    cell.highlight()
                }
                cell.label.textColor = selectedColor
            } else if selectedStartDate != nil, areSameDay(dateA: date, dateB: selectedStartDate!) {
                // Cell is selected start date
                cell.select(isLeft: true)
                if selectedEndDate != nil {
                    cell.highlightRight()
                }
            } else if selectedEndDate != nil, areSameDay(dateA: date, dateB: selectedEndDate!) {
                cell.select(isLeft: false)
                cell.highlightLeft()
            }
        }
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! SCCalendarDateRangePickerHeaderView
            headerView.label.text = getMonthLabel(date: getFirstDateForSection(section: indexPath.section))
            return headerView
        default:
            fatalError("Unexpected element kind")
        }
    }
}

extension SCalendarDateRangePickerView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SCalendarDateRangePickerCell
        if cell.date == nil {
            return
        }
        if isBefore(dateA: cell.date!, dateB: minimumDate) {
            return
        }
        if selectedStartDate == nil {
            selectedStartDate = cell.date
        } else if selectedEndDate == nil {
            if isBefore(dateA: selectedStartDate!, dateB: cell.date!) {
                selectedEndDate = cell.date
            } else {
                // If a cell before the currently selected start date is selected then just set it as the new start date
                selectedStartDate = cell.date
            }

            if let tempClosure = gySelectDataRangeClosure,
               let startDate: Date = selectedStartDate,
               let endData: Date = selectedEndDate
            {
                tempClosure(startDate, endData)
            }
        } else {
            selectedStartDate = cell.date
            selectedEndDate = nil
        }
        collectionView.reloadData()
    }

    public func collectionView(_: UICollectionView,
                               layout _: UICollectionViewLayout,
                               sizeForItemAt _: IndexPath) -> CGSize
    {
        let padding = collectionViewInsets.left + collectionViewInsets.right
        let availableWidth = frame.width - padding
        let itemWidth = availableWidth / CGFloat(itemsPerRow)
        return CGSize(width: itemWidth, height: itemHeight)
    }

    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForHeaderInSection _: Int) -> CGSize {
        return CGSize(width: frame.size.width, height: 50)
    }

    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 5
    }

    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 0
    }
}

/// Helper functions
extension SCalendarDateRangePickerView {
    func getFirstDate() -> Date {
        var components = Calendar.current.dateComponents([.month, .year], from: minimumDate)
        components.day = 1
        return Calendar.current.date(from: components)!
    }

    func getFirstDateForSection(section: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: section, to: getFirstDate())!
    }

    func getMonthLabel(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = titleDateFormat
        return dateFormatter.string(from: date)
    }

    func getWeekdayLabel(weekday: Int) -> String {
        var components = DateComponents()
        components.calendar = Calendar.current
        components.weekday = weekday
        let date = Calendar.current.nextDate(after: Date(), matching: components, matchingPolicy: Calendar.MatchingPolicy.strict)
        if date == nil {
            return "E"
        }

        var week = ""
        if isWeekCN {
            let weekdayIndex = components.calendar?.component(.weekday, from: date!) ?? 0
            if (weekdayIndex - 1) <= weekCnDays.count {
                week = weekCnDays[weekdayIndex - 1]
            }
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEEE"
            week = dateFormatter.string(from: date!)
        }

        return week
    }

    func getWeekday(date: Date) -> Int {
        return Calendar.current.dateComponents([.weekday], from: date).weekday!
    }

    func getNumberOfDaysInMonth(date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)!.count
    }

    func getDate(dayOfMonth: Int, section: Int) -> Date {
        var components = Calendar.current.dateComponents([.month, .year], from: getFirstDateForSection(section: section))
        components.day = dayOfMonth
        return Calendar.current.date(from: components)!
    }

    func areSameDay(dateA: Date, dateB: Date) -> Bool {
        return Calendar.current.compare(dateA, to: dateB, toGranularity: .day) == ComparisonResult.orderedSame
    }

    func isBefore(dateA: Date, dateB: Date) -> Bool {
        return Calendar.current.compare(dateA, to: dateB, toGranularity: .day) == ComparisonResult.orderedAscending
    }
}
