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
                            parameters _: [String: Any]? = nil,
                            respondCallback _: @escaping (_ responseObject: [String: Any], _ error: NSError) -> Void)
    {
        request = getRequest(URLString: URLString, type: type)

        let start = CACurrentMediaTime()
        let requestComplete: (HTTPURLResponse?, Result<String, AFError>) -> Void = { response, result in
            let end = CACurrentMediaTime()
            self.elapsedTime = end - start

            if let response = response {
                for (field, value) in response.allHeaderFields {
                    self.headers["\(field)"] = "\(value)"
                }
            }

            switch type {
            case .get, .post:
                switch result {
                case let .success(value):
                    print("\(value)")
                case let .failure(error):
                    print("error:\(error)")
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

    private func getRequest(URLString: String, type: AFMethodType) -> Request? {
        switch type {
        case .get:
            return AF.request(URLString, method: .get)
        case .post:
            return AF.request(URLString, method: .post)
        case .download:
            let destination = DownloadRequest.suggestedDownloadDestination(for: .cachesDirectory, in: .userDomainMask)
            return AF.download(URLString, to: destination)
        default:
            return nil
        }
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

    private var request: Request? {
        didSet {
            oldValue?.cancel()
            elapsedTime = nil
        }
    }

    private var elapsedTime: TimeInterval?

    private var headers: [String: String] = ["Accept": "application/json"]
}
