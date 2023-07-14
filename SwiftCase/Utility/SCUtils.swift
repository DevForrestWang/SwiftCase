//
//===--- SCUtils.swift - Defines the SCUtils class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/9/28.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import AVFoundation
import Foundation
import Kingfisher
import Toast_Swift

// MARK: - Print info

public func fwPrintEnter(message: String) {
    debugPrint("================ \(message)====================")
}

// MARK: - show info

public func fwShowToast(_ message: String) {
    gWindow?.makeToast(message, duration: 2.0, position: .center)
}

public func fwShowAlert(_ vc: UIViewController, _ title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(okAction)
    vc.present(alertController, animated: true, completion: nil)
}

// MARK: - Function

public enum SCUtils {
    public static func formatDate(_ date: String, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        if date.isEmpty {
            return ""
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "zh_CN")
        let fDate = dateFormatter.date(from: date)
        return dateFormatter.string(from: fDate ?? Date())
    }

    public static func formatDate2String(_ date: Date, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "zh_CN")
        return dateFormatter.string(from: date)
    }

    /// save data by userdefault
    /// - Parameters:
    ///  - value: save data
    ///  - key: save data of key
    public static func saveData(_ value: Any, key: String) {
        guard let archiveData = try? NSKeyedArchiver.archivedData(withRootObject: value,
                                                                  requiringSecureCoding: false)
        else {
            SC.log("Failed to archive, key: \(key)")
            return
        }

        UserDefaults.standard.set(archiveData, forKey: key)
    }

    /// load save data.
    /// - Parameters:
    ///  - key: save data of key
    public static func loadData(_ key: String) -> Any? {
        if let loadData = UserDefaults.standard.data(forKey: key) {
            return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(loadData)
        }

        return nil
    }

    /// 将开头设置为红色
    /// SCUtils.startToRed(lable: titleLable)
    public static func startToRed(lable: UILabel) {
        guard let textInfo = lable.text else {
            return
        }

        let attr = NSMutableAttributedString(string: textInfo).then {
            $0.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSMakeRange(0, 1))
        }
        lable.attributedText = attr
    }

    /// 更改Lable字体设置颜色
    /// numbersLable.text = "发送条数：\(number)"
    /// SCUtils.updateLableStyle(lable: numbersLable, target: "发送条数：", font: .systemFont(ofSize: 14), color: .red)
    ///
    public static func updateLableStyle(lable: UILabel, target: String, font: UIFont, color: UIColor, space: CGFloat = 0) {
        guard let text = lable.text else {
            SC.log("The lable is empty.")
            return
        }

        if text.count <= 0 || target.count <= 0 {
            SC.log("The lable or target is empty.")
            return
        }

        var startIndex = text.distance(of: target) ?? 0
        if startIndex > text.count {
            startIndex = text.count
        }

        let titleAttr = NSMutableAttributedString(string: text).then {
            $0.addAttributes([
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: color,
            ], range: NSMakeRange(startIndex, target.count))
        }

        if space > 0 {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = space
            titleAttr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: .init(location: 0, length: text.count))
            lable.sizeToFit()
        }

        lable.attributedText = titleAttr
    }

    /// 更新Lable 多段颜色
    public static func updateLableColor(lable: UILabel?, targets: [String], color: UIColor) {
        guard let msg = lable?.text else {
            return
        }

        let attr = NSMutableAttributedString(string: msg)

        var lastIndex = 0
        var mainString = msg
        for item in targets {
            let tarIndex = mainString.distance(of: item) ?? 0
            // 没有找到时进入下一个查找
            if tarIndex == 0, !mainString.starts(with: item) {
                continue
            }
            // 删除首次出现之前的字符
            lastIndex += tarIndex + 1
            if (msg.count - lastIndex) <= 0 {
                break
            }
            mainString = String(mainString.suffix(msg.count - lastIndex))

            attr.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(lastIndex - 1, item.count))
        }

        lable?.attributedText = attr
    }

    /// 字体在Lable的宽度
    /// SCUtils.getLableWidth(labelStr: strMember,font: titleLable.font, height: titleLable.font.lineHeight)
    public static func getLableWidth(labelStr: String, font: UIFont, height: CGFloat) -> CGFloat {
        let statusLabelText: NSString = labelStr as NSString
        let size = CGSize(width: 900, height: height)
        let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size,
                                                   options: .usesLineFragmentOrigin,
                                                   attributes: dic as? [NSAttributedString.Key: Any],
                                                   context: nil).size

        return strSize.width
    }

    /// 图片与文字的富文本
    /// lable.attributedText = SCUtils.imageAndTitleAttribute(title: title, iconName: bizp.icon, startX: 0, height: iHeight)
    public static func imageAndTitleAttribute(title: String,
                                              iconName: String,
                                              startX: CGFloat,
                                              height: CGFloat,
                                              color: UIColor = UIColor.black) -> NSMutableAttributedString
    {
        let attrImg = NSTextAttachment()
        attrImg.image = UIImage(named: iconName)
        // 设置图片显示的大小及位置
        attrImg.bounds = CGRect(x: startX, y: -2, width: height, height: height)
        let attrImageStr = NSAttributedString(attachment: attrImg)

        let attrTitleStr = NSAttributedString(string: "\(title)",
                                              attributes: [NSAttributedString.Key.foregroundColor: color])
        let attrString = NSMutableAttributedString()
        attrString.append(attrImageStr)
        attrString.append(attrTitleStr)
        return attrString
    }

    /// 生成从起始的年月到当前的字典，如value："2021-09" - "2022-06"；name： "2021年09月" - "2022年06月"
    /// let monthDic = SCUtils.generatorMonths(baseYear: 2021, baseMonth: 9)
    public static func generatorMonths(baseYear: Int, baseMonth: Int) -> [String: [String]] {
        let curYearAndMonth = Date().toString(dateFormat: "yyyy-MM")
        let yearAndMonthAry = curYearAndMonth.split(separator: "-")
        let year = String(yearAndMonthAry[0])
        let month = String(yearAndMonthAry[1])

        let iYear = year.toInt() ?? 2022
        let iMonth = month.toInt() ?? 1

        var nameArray: [String] = []
        var valueArray: [String] = []

        nameArray.append("月份")
        valueArray.append("")
        for year in stride(from: iYear, through: baseYear, by: -1) {
            var maxMonth = 12
            if iYear == year {
                maxMonth = iMonth
            }

            for month in stride(from: maxMonth, to: 0, by: -1) {
                if year != iYear, month < baseMonth {
                    break
                }
                nameArray.append("\(year)年\(String(format: "%02d", month))月")
                valueArray.append("\(year)-\(String(format: "%02d", month))")
            }
        }
        return ["name": nameArray, "value": valueArray]
    }

    /// 返回月份的最后一天
    public static func lastDay(yearAndMonth: String, separateFlag: Character, isCurentDay: Bool = false) -> Int {
        let yearAry = yearAndMonth.split(separator: separateFlag)
        if yearAndMonth.count < 2 {
            return 0
        }

        let year = String(yearAry[0]).toInt()
        let month = String(yearAry[1]).toInt() ?? 1

        let calendar = NSCalendar.current
        if isCurentDay {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let components = calendar.dateComponents([.year, .month, .day], from: Date())

            let cMonth = components.month
            let cYear = components.year
            if cYear == year, cMonth == month {
                return components.day ?? 1
            }
        }

        var comps = DateComponents(calendar: calendar, year: year, month: month)
        comps.setValue(month + 1, for: .month)
        comps.setValue(0, for: .day)
        let date = calendar.date(from: comps)!
        return calendar.component(.day, from: date)
    }

    /// 最近多少天
    /// param: days 天数
    /// param: format 日期格式，默认：yyyy-MM-dd
    public static func recentDays(days: Int, format: String = "yyyy-MM-dd") -> (startDay: String, endDay: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let nowDate = Date()

        let startDate = nowDate.addingTimeInterval(-Double(days * 24 * 3600))
        let startValue = dateFormatter.string(from: startDate)
        let endValue = dateFormatter.string(from: nowDate)

        return (startDay: startValue, endDay: endValue)
    }

    /// 最近月数
    /// param: months 月数
    /// param: format 日期格式，默认：yyyy-MM-dd
    public static func recentMonth(months: Int, format: String = "yyyy-MM-dd") -> (startDay: String, endDay: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let nowDate = Date()

        // 开始月份
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: nowDate)
        let cMonth = components.month ?? 0
        components.setValue(cMonth - months, for: .month)
        let startDate = calendar.date(from: components)!
        let startValue = dateFormatter.string(from: startDate)
        // 当前日期
        let endValue = dateFormatter.string(from: nowDate)

        return (startDay: startValue, endDay: endValue)
    }

    /// 时间差
    /// param: timeStamp 时间戳，单位秒
    /// return：返回时间差，单位秒
    public static func currenntDifferenceTime(timeStamp: TimeInterval) -> Int {
        let currentTime = Date().timeIntervalSince1970
        let reduceTime = Int(currentTime - timeStamp)
        return reduceTime
    }

    /// 本周开始日期（星期天）
    public static func startOfThisWeek() -> Date {
        let date = Date()
        let calendar = NSCalendar.current
        let components = calendar.dateComponents(
            Set<Calendar.Component>([.yearForWeekOfYear, .weekOfYear]), from: date
        )
        let startOfWeek = calendar.date(from: components)!
        return startOfWeek
    }

    /// 本周结束日期（星期六）
    public static func endOfThisWeek(returnEndTime: Bool = false) -> Date {
        let calendar = NSCalendar.current
        var components = DateComponents()
        if returnEndTime {
            components.day = 7
            components.second = -1
        } else {
            components.day = 6
        }

        let endOfMonth = calendar.date(byAdding: components, to: startOfThisWeek())!
        return endOfMonth
    }

    /// 图片下载
    /// - Parameters:
    ///  - urlStr: 下载URL
    ///  - complete: 下载的图片
    public static func downloadWith(urlStr: String, complete: ((UIImage?) -> Void)? = nil) {
        if let url = URL(string: urlStr) {
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case let .success(imgResult):
                    complete?(imgResult.image)
                case let .failure(error):
                    print(error)
                    complete?(nil)
                }
            }
        } else {
            complete?(nil)
        }
    }

    /// 加载GIF图片
    /// SCUtils.showGif(fileName: gifFile, imageView: playingImagView)
    public static func showGif(fileName: String, imageView: UIImageView) {
        // 1.加载Gif图片, 并转成Data类型
        guard let path = Bundle.main.path(forResource: fileName, ofType: nil) else {
            SC.log("The file:\(fileName) is not exist.")
            return
        }
        guard let data = NSData(contentsOfFile: path) else {
            return
        }

        // 2.从data中读取数据: 将data转成CGImageSource对象
        guard let imageSource = CGImageSourceCreateWithData(data, nil) else {
            SC.log("can not data to CGImageSource.")
            return
        }
        let imageCount = CGImageSourceGetCount(imageSource)

        // 3.遍历所有的图片
        var images = [UIImage]()
        var totalDuration: TimeInterval = 0
        for i in 0 ..< imageCount {
            // 3.1.取出每一帧图片
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else {
                continue
            }
            let image = UIImage(cgImage: cgImage)
            if i == 0 {
                imageView.image = image
            }
            images.append(image)

            // 3.2.取出持续的时间
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) as? NSDictionary else {
                continue
            }
            guard let gifDict = properties[kCGImagePropertyGIFDictionary] as? NSDictionary else {
                continue
            }

            guard let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber else {
                continue
            }
            totalDuration += frameDuration.doubleValue
        }

        // 4.设置imageView的属性
        imageView.animationImages = images
        imageView.animationDuration = totalDuration
        // 0代表不限重复次数(无限重复)
        imageView.animationRepeatCount = 0

        // 5.开始播放
        imageView.startAnimating()
    }

    /// 获取Domument目录
    public static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    /// UITextField 添加下划线
    public static func underline(textfield: UITextField, color: UIColor) {
        let underLine = UIView(frame: CGRect(x: 0, y: textfield.yxc_height - 1, width: textfield.yxc_width, height: 0.5))
        underLine.backgroundColor = color
        textfield.addSubview(underLine)
        // 然后别忘了把文本框外框设置成none
        textfield.borderStyle = .none
    }

    /// 获取视频封面
    public static func videoCover(videoUrl: URL) -> UIImage? {
        let asset = AVURLAsset(url: videoUrl, options: nil)
        let assetGen = AVAssetImageGenerator(asset: asset)
        assetGen.appliesPreferredTrackTransform = true
        let time = CMTimeMake(value: 0, timescale: 600)
        var actualTime: CMTime = .zero
        if let cgImage = try? assetGen.copyCGImage(at: time, actualTime: &actualTime) {
            let image = UIImage(cgImage: cgImage)
            return image
        }

        return nil
    }
}
