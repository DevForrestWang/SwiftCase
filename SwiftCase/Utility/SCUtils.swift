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

import Foundation
import Toast_Swift

// MARK: - Print info

public func yxc_debugPrint(_ message: Any...) {
    debugPrint(message)
}

public func printEnter(message: String) {
    debugPrint("================ \(message)====================")
}

public func printLine() {
    debugPrint("===================================================", terminator: "\n\n")
}

// MARK: - show info

public func showToast(_ message: String) {
    UIWindow.key?.makeToast(message, duration: 2.0, position: .center)
}

public func showAlert(_ vc: UIViewController, _ title: String, message: String) {
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
            yxc_debugPrint("Failed to archive, key: \(key)")
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
}
