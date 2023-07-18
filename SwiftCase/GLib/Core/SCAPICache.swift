//
//===--- SCAPICache.swift - Defines the SCAPICache class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2023/7/14.
// Copyright © 2023 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//
import Foundation

public extension SC {
    /// Set 缓存数据
    static func asyncSetCache(jsonResponse: AnyObject, URL: String, subPath: String?, completed: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            let result = self.setCache(jsonResponse, URL: URL, subPath: subPath)
            DispatchQueue.main.async {
                completed(result)
            }
        }
    }

    /// 写入/更新缓存(同步) [按APP版本号缓存,不同版本APP,同一接口缓存数据互不干扰]
    static func setCache(_ jsonResponse: AnyObject, URL: String, subPath: String?) -> Bool {
        lock.wait()
        let data = (jsonResponse as? [String: Any])?.toData()
        let atPath = getCacheFilePath(url: URL, subPath: subPath)
        let isSuccess = FileManager.default.createFile(atPath: atPath, contents: data, attributes: nil)
        lock.signal()
        return isSuccess
    }

    /// Get  获取数据
    static func getCacheJsonWithURL(_ URL: String, subPath: String = "") -> AnyObject? {
        lock.wait()
        var resultObject: AnyObject?
        let path = getCacheFilePath(url: URL, subPath: subPath)
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path, isDirectory: nil) == true {
            let data: Data = fileManager.contents(atPath: path)!
            resultObject = try? data.toObject() as AnyObject
        }
        lock.signal()
        return resultObject
    }

    /// 获取缓存文件路径
    fileprivate static func getCacheFilePath(url: String, subPath: String?) -> String {
        var newPath: String = SCSandbox.cacheAPIPath

        if let tempSubPath = subPath, tempSubPath.count > 0 {
            newPath = SCSandbox.cacheAPIPath + tempSubPath
        }

        checkDirectory(newPath)
        // check路径
        let cacheFileNameString = "URL:\(url) AppVersion:\(SC.versionS)"
        let cacheFileName: String = cacheFileNameString.md5
        newPath = newPath + cacheFileName
        return newPath
    }

    /// 检查文件夹
    static func checkDirectory(_ path: String) {
        let fileManager = FileManager.default

        var isDir = ObjCBool(false) // isDir判断是否为文件夹
        if !fileManager.fileExists(atPath: path, isDirectory: &isDir) {
            SC.createBaseDirectoryAtPath(path)
        } else {
            if !isDir.boolValue {
                do {
                    try fileManager.removeItem(atPath: path)
                    SC.createBaseDirectoryAtPath(path)
                } catch let error as NSError {
                    SC.log("创建缓存文件夹失败，error - [\(error)]")
                }
            }
        }
    }

    /// 创建文件夹
    static func createBaseDirectoryAtPath(_ path: String) {
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            addDoNotBackupAttribute(path)
        } catch let error as NSError {
            SC.log("创建文件夹失败！error[\(error)]")
        }
    }

    /// 设置不备份
    static func addDoNotBackupAttribute(_ path: String) {
        let url = URL(fileURLWithPath: path)
        do {
            try (url as NSURL).setResourceValue(NSNumber(value: true as Bool), forKey: URLResourceKey.isExcludedFromBackupKey)
        } catch let error as NSError {
            SC.log("设置不备份失败,error[\(error)]")
        }
    }
}
