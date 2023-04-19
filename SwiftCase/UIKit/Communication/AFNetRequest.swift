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

/// 网络请求类型
enum AFMethodType {
    case get
    case post
    case upload
    case download
}

/// 全局变量记录APP启动请求Id
var gAFRequestId: Int = 0

/// Alamofire 网络信息封装
class AFNetRequest: NSObject {
    // MARK: - Lifecycle

    /**
     *  初始化参数
     *
     *  @param isParse 是否检查返回成功，返回码200
     *  @param retCode 返回码的key
     *  @param msg 错误信息key
     *  @param timeout 超时时间，默认30秒
     */
    public init(isParse: Bool = true, retCode: String = "retCode", msg: String = "msg", timeout: TimeInterval = 30) {
        self.isParse = isParse
        self.retCode = retCode
        self.msg = msg
        self.timeout = timeout

        gAFRequestId += 1
        requestId = gAFRequestId
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    /// GET、POST网络请求
    public func requestData(URLString: String,
                            type: AFMethodType,
                            parameters: [String: Any]? = nil,
                            respondCallback: @escaping (_ responseObject: [String: AnyObject]?, _ error: NSError?) -> Void)
    {
        request = getRequest(URLString: URLString, type: type, parameters: parameters)
        printRequestLog(URLString: URLString, type: type, parameters: parameters)

        let start = CACurrentMediaTime()

        let requestComplete: (Result<String, AFError>) -> Void = { result in
            let end = CACurrentMediaTime()
            self.elapsedTime = end - start

            switch type {
            case .get, .post:
                switch result {
                case let .success(strJson):
                    self.printResponseLog(json: strJson)
                    let dataDic = self.convertStringToDictionary(text: strJson)

                    if self.isParse, let tmpDic = dataDic {
                        let retcode = tmpDic[self.retCode] as? Int ?? 0
                        if retcode != 200 {
                            let msg = tmpDic[self.msg] as? String ?? ""
                            let tmpError = NSError(domain: "\(URLString)",
                                                   code: retcode,
                                                   userInfo: [NSLocalizedDescriptionKey: "\(msg)"])
                            respondCallback(nil, tmpError)
                            return
                        }

                        respondCallback(dataDic, nil)
                    } else {
                        respondCallback(dataDic, nil)
                    }

                case let .failure(error):
                    let tmpError = NSError(domain: "\(URLString)",
                                           code: error.responseCode ?? -1,
                                           userInfo: [NSLocalizedDescriptionKey: "\(error)"])
                    respondCallback(nil, tmpError)
                }
            default:
                debugPrint("default")
            }
        }

        if let request = request as? DataRequest {
            request.responseString { response in
                requestComplete(response.result)
            }
        }
    }

    /// 文件下载
    public func download(URLString: String,
                         parameters: [String: Any]? = nil,
                         fileName: String,
                         directory: FileManager.SearchPathDirectory,
                         respondCallback: @escaping (_ progress: Double, _ fileURL: URL?, _ error: NSError?) -> Void)
    {
        printRequestLog(URLString: URLString, type: .download, parameters: parameters)

        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: directory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(fileName)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        AF.download(URLString, parameters: parameters, headers: headers, to: destination).downloadProgress { progress in
            respondCallback(progress.fractionCompleted, nil, nil)
        }.response { response in

            debugPrint("===========<response-id:\(self.requestId) tag:>===========")
            if let error = response.error {
                let tmpError = NSError(domain: "\(URLString)",
                                       code: error.responseCode ?? -1,
                                       userInfo: [NSLocalizedDescriptionKey: "\(error)"])
                respondCallback(0, nil, tmpError)
                return
            }
            respondCallback(1, response.fileURL, nil)
        }
    }

    /// 文件上传
    public func upload(fileURL: URL?,
                       URLString: String,
                       respondCallback: @escaping (_ progress: Double, _ responseObject: [String: AnyObject]?, _ error: NSError?) -> Void)
    {
        guard let fileURL = fileURL else {
            return
        }
        printRequestLog(URLString: URLString, type: .upload, parameters: nil)

        AF.upload(fileURL, to: URLString, headers: headers).uploadProgress { progress in
            respondCallback(progress.fractionCompleted, nil, nil)
        }
        .responseString(completionHandler: { response in

            debugPrint("===========<response-id:\(self.requestId) tag:>===========")
            switch response.result {
            case let .success(strJson):
                respondCallback(1, self.convertStringToDictionary(text: strJson), nil)
            case let .failure(error):
                let tmpError = NSError(domain: "\(URLString)",
                                       code: error.responseCode ?? -1,
                                       userInfo: [NSLocalizedDescriptionKey: "\(error)"])
                respondCallback(0, nil, tmpError)
            }
        })
    }

    // MARK: - Protocol

    // MARK: - Private

    /// 获得请求对象
    private func getRequest(URLString: String, type: AFMethodType, parameters: [String: Any]? = nil) -> Request? {
        switch type {
        case .get:
            return AF.request(URLString, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers) { urlRequest in
                urlRequest.timeoutInterval = self.timeout
                urlRequest.allowsConstrainedNetworkAccess = true
            }
        case .post:
            return AF.request(URLString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers) { urlRequest in
                urlRequest.timeoutInterval = self.timeout
                urlRequest.allowsConstrainedNetworkAccess = true
            }
        default:
            return nil
        }
    }

    /// 打印请求日志
    private func printRequestLog(URLString: String, type _: AFMethodType, parameters: [String: Any]? = nil) {
        debugPrint("===========<request-id:\(requestId) tag:>===========")
        debugPrint("\(URLString)")

        if let parameters = parameters {
            debugPrint("httpBody:{")
            for item in parameters {
                debugPrint("    \(item.key):\(item.value)")
            }
            debugPrint("}")
        }

        debugPrint("Request Header:{")
        for item in headers {
            debugPrint("    \(item.name):\(item.value)")
        }
        debugPrint("}")
    }

    /// 打印响应日志
    private func printResponseLog(json: String) {
        debugPrint("===========<response-id:\(requestId) tag:>===========")
        let time = String(format: "%.2fs", elapsedTime ?? 0)
        debugPrint("Response Time:\(time)")

        if let data = json.data(using: .utf8) {
            debugPrint(data.prettyPrintedJSONString ?? json)
        } else {
            debugPrint("\(json)")
        }
    }

    /// json字符串转换成字典；json如果是数组，会用 array最为key的字典
    private func convertStringToDictionary(text: String) -> [String: AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                if let json = jsonObj as? [String: AnyObject] {
                    return json
                } else if let array = jsonObj as? NSArray {
                    let json: [String: AnyObject] = [
                        "array": array,
                    ]
                    return json
                }

            } catch let error as NSError {
                debugPrint("Failed to dictionary: \(error)")
            }
        }

        return nil
    }

    // MARK: - Property

    private var request: Request? {
        didSet {
            oldValue?.cancel()
            elapsedTime = nil
        }
    }

    private var isParse: Bool = true

    private var retCode: String = "retCode"

    private var msg: String = "msg"

    private var timeout: TimeInterval = 30

    private var requestId: Int = 0

    private var elapsedTime: TimeInterval?

    // 请求头信息
    private var headers: HTTPHeaders = [
        "Accept": "application/json",
        "appName": SCDeviceInfo.getAppName(),
        "version": SCDeviceInfo.appVersion,
        "custId": "init custId",
        "token": "init token",
    ]
}
