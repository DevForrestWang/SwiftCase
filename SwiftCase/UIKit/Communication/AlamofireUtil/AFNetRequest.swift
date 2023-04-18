//
//===--- AFNetRequest.swift - Defines the AFNetRequest class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2023/4/17.
// Copyright © 2023 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import Alamofire
import UIKit

enum AFMethodType {
    case get
    case post
    case upload
    case download
}

class AFNetRequest: NSObject {
    // MARK: - Lifecycle

    // 执行析构过程
    deinit {
        print("===========<deinit: \(type(of: self))>===========")
    }

    // MARK: - Public

    public func requestData(URLString: String,
                            type: AFMethodType,
                            parameters: [String: Any]? = nil,
                            respondCallback: @escaping (_ responseObject: [String: AnyObject]?, _ error: NSError?) -> Void)
    {
        AFNetRequest.requestId += 1
        request = getRequest(URLString: URLString, type: type, parameters: parameters)
        printRequestLog(URLString: URLString, type: type, parameters: parameters)

        let start = CACurrentMediaTime()
        let requestComplete: (HTTPURLResponse?, Result<String, AFError>) -> Void = { _, result in
            let end = CACurrentMediaTime()
            self.elapsedTime = end - start

            switch type {
            case .get, .post:
                switch result {
                case let .success(value):
                    self.printResponseLog(json: value)
                    let dataDic = self.convertStringToDictionary(text: value)
                    respondCallback(dataDic, nil)

                case let .failure(error):
                    let tmpError = NSError(domain: "\(String(describing: error.url))",
                                           code: error.responseCode ?? -1,
                                           userInfo: [NSLocalizedDescriptionKey: "\(error)"])
                    respondCallback(nil, tmpError)
                }
            case .download:
                let downInfo = self.downloadedBodyString()
            case .upload:
                print("upload")
            }
        }

        if let request = request as? DataRequest {
            request.responseString { response in
                requestComplete(response.response, response.result)
            }
        } else if let request = request as? DownloadRequest {
            request.responseString { response in
                requestComplete(response.response, response.result)
            }
        }
    }

    // MARK: - Protocol

    // MARK: - Private

    private func getRequest(URLString: String, type: AFMethodType, parameters: [String: Any]? = nil) -> Request? {
        switch type {
        case .get:
            return AF.request(URLString, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        case .post:
            return AF.request(URLString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        case .download:
            let destination = DownloadRequest.suggestedDownloadDestination(for: .cachesDirectory, in: .userDomainMask)
            return AF.download(URLString, to: destination)
        default:
            return nil
        }
    }

    private func printRequestLog(URLString: String, type _: AFMethodType, parameters: [String: Any]? = nil) {
        print("===========<request-id:\(AFNetRequest.requestId) tag:>===========")
        print("\(URLString)")

        if let parameters = parameters {
            print("httpBody:{")
            for item in parameters {
                print("    \(item.key):\(item.value)")
            }
            print("}")
        }

        print("Request Header:{")
        for item in headers {
            print("    \(item.name):\(item.value)")
        }
        print("}")
    }

    private func printResponseLog(json: String) {
        print("===========<response-id:\(AFNetRequest.requestId) tag:>===========")
        let time = String(format: "%.2fs", elapsedTime ?? 0)
        print("Response Time:\(time)")
        print("\(json)")
    }

    private func convertStringToDictionary(text: String) -> [String: AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject]
                return json
            } catch let error as NSError {
                print("Failed to dictionary: \(error)")
            }
        }
        return nil
    }

    private func downloadedBodyString() -> String {
        let fileManager = FileManager.default
        let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]

        do {
            let contents = try fileManager.contentsOfDirectory(at: cachesDirectory,
                                                               includingPropertiesForKeys: nil,
                                                               options: .skipsHiddenFiles)

            if let fileURL = contents.first, let data = try? Data(contentsOf: fileURL) {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
                let prettyData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)

                if let prettyString = String(data: prettyData, encoding: String.Encoding.utf8) {
                    try fileManager.removeItem(at: fileURL)
                    return prettyString
                }
            }
        } catch {
            // No-op
        }

        return ""
    }

    // MARK: - Property

    static var requestId: Int = 0

    private var request: Request? {
        didSet {
            oldValue?.cancel()
            elapsedTime = nil
        }
    }

    private var elapsedTime: TimeInterval?

    private var headers: HTTPHeaders = [
        "Accept": "application/json",
        "appName": SCDeviceInfo.getAppName(),
        "version": SCDeviceInfo.appVersion,
        "custId": "init CustId",
        "token": "init token",
    ]
}
