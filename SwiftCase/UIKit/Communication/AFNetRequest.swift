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

/// 将任意基本类型转换为字符串，其他类型为nil
@propertyWrapper public struct AFBString: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        var string: String?

        // 字段为空时
        if container.decodeNil() {
            string = nil
        } else {
            if let result = try? container.decode(String.self) {
                string = result
            } else if let result = try? container.decode(Int.self) {
                string = String(result)
            } else if let result = try? container.decode(Double.self) {
                string = String(result)
            } else if let result = try? container.decode(Float.self) {
                string = String(result)
            } else if let result = try? container.decode(Bool.self) {
                string = String(result)
            } else if let result = try? container.decode(Int8.self) {
                string = String(result)
            } else if let result = try? container.decode(Int16.self) {
                string = String(result)
            } else if let result = try? container.decode(Int64.self) {
                string = String(result)
            } else if let result = try? container.decode(UInt.self) {
                string = String(result)
            } else if let result = try? container.decode(UInt8.self) {
                string = String(result)
            } else if let result = try? container.decode(UInt16.self) {
                string = String(result)
            } else if let result = try? container.decode(UInt64.self) {
                string = String(result)
            } else {
                string = nil
            }
        }

        wrappedValue = string
    }

    public var wrappedValue: String?
}

/// 网络解析的基础类
public protocol AFBaseModel: Codable {}

/// AFBaseModel 扩展
public extension AFBaseModel {
    /// model转字典
    func toJson() -> [String: Any]? {
        guard let jsonData = try? JSONEncoder().encode(self) else {
            return nil
        }

        do {
            return try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any]
        } catch let error as NSError {
            fwDebugPrint("\(error.description)")
            return nil
        }
    }

    /// 转JSON字符串
    func toJsonString() -> String? {
        if let json = toJson() {
            return json.toJsonString()
        }

        return nil
    }

    /// Json格式打印
    func prettyPrint() {
        if let json = toJson() {
            print(json.jsonPrint())
        }
    }
}

/// 网络请求类型
public enum AFMethodType {
    case get
    case post
    case upload
    case download
}

/// 全局变量记录APP启动请求Id
var gAFRequestId: Int = 0

/// Alamofire 网络信息封装
public class AFNetRequest: NSObject {
    // MARK: - Lifecycle

    /**
     *  初始化参数
     *
     *  @param isParse 是否检查返回成功，返回码200
     *  @param retCode 返回码的key
     *  @param data 返回数据key为data
     *  @param msg 错误信息key
     *  @param timeout 超时时间，默认30秒
     */
    public init(isParse: Bool = true,
                retCode: String = "retCode",
                data: String = "data",
                msg: String = "msg",
                timeout: TimeInterval = 30)
    {
        self.isParse = isParse
        self.retCode = retCode
        self.data = data
        self.msg = msg
        self.timeout = timeout

        gAFRequestId += 1
        requestId = gAFRequestId
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    /// 更新请求头信息
    public func updateHead(headInfo: [String: String]) -> AFNetRequest {
        for (key, value) in headInfo {
            headers.add(name: key, value: value)
        }

        return self
    }

    /// GET、POST网络请求
    public func requestData(URLString: String,
                            type: AFMethodType = .get,
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
                        let retcode = self.parseRetCode(dataDic: tmpDic)
                        if retcode != 200 {
                            let msg = tmpDic[self.msg] as? String ?? ""
                            respondCallback(nil, self.makeError(url: URLString, code: retcode, msg: msg))
                            return
                        }

                        respondCallback(dataDic, nil)
                    } else {
                        respondCallback(dataDic, nil)
                    }

                case let .failure(error):
                    respondCallback(nil, self.makeError(url: URLString, code: error.responseCode ?? -1, msg: "\(error)"))
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

    /// GET、POST网络请求, 返回指定Module为字典
    public func requestDecodable<T: AFBaseModel>(of model: T.Type = T.self,
                                                 URLString: String,
                                                 type: AFMethodType = .get,
                                                 parameters: [String: Any]? = nil,
                                                 decoder: JSONDecoder = JSONDecoder(),
                                                 respondCallback: @escaping (_ item: T?, _ error: NSError?) -> Void)
    {
        requestDecodableArray(of: model, URLString: URLString, type: type, parameters: parameters, decoder: decoder) { [weak self] items, error in
            if error != nil {
                respondCallback(nil, error)
                return
            }

            guard let dataAry = items as? NSArray else {
                respondCallback(nil, self?.makeError(url: URLString, code: self!.errorCode, msg: "返回数据不是数组类型"))
                return
            }

            if dataAry.count > 0, let tModel = dataAry.firstObject as? T {
                respondCallback(tModel, nil)
            } else {
                respondCallback(nil, self?.makeError(url: URLString, code: self!.errorCode, msg: "返回数据为空"))
            }
        }
    }

    /// GET、POST网络请求, 返回指定Module为数组
    public func requestDecodableArray<T: AFBaseModel>(of _: T.Type = T.self,
                                                      URLString: String,
                                                      type: AFMethodType = .get,
                                                      parameters: [String: Any]? = nil,
                                                      decoder: JSONDecoder = JSONDecoder(),
                                                      respondCallback: @escaping (_ items: [T?]?, _ error: NSError?) -> Void)
    {
        requestData(URLString: URLString, type: type, parameters: parameters, respondCallback: { [weak self] responseObject, error in

            if error != nil {
                respondCallback(nil, error)
                return
            }

            guard let tmpDic = responseObject else {
                respondCallback(nil, self?.makeError(url: URLString, code: self!.errorCode, msg: "响应的数据为空"))
                return
            }

            guard JSONSerialization.isValidJSONObject(tmpDic) else {
                respondCallback(nil, self?.makeError(url: URLString, code: self!.errorCode, msg: "JSON格式非法"))
                return
            }

            let retcode = self?.parseRetCode(dataDic: tmpDic) ?? 0
            if retcode != 200 {
                let msg = tmpDic[self!.msg] as? String ?? ""
                respondCallback(nil, self?.makeError(url: URLString, code: retcode, msg: msg))
                return
            }

            if let dataDic = tmpDic[self!.data] as? [String: Any],
               let jsonData = try? JSONSerialization.data(withJSONObject: dataDic, options: [])
            {
                do {
                    let object = try decoder.decode(T.self, from: jsonData)
                    respondCallback([object], nil)
                } catch let error as NSError {
                    fwDebugPrint("\(error.description)")
                    respondCallback(nil, nil)
                }

            } else if let dataAry = tmpDic[self!.data] as? NSArray,
                      let jsonData = try? JSONSerialization.data(withJSONObject: dataAry, options: [])
            {
                do {
                    let object = try decoder.decode([T].self, from: jsonData)
                    respondCallback(object, nil)
                } catch let error as NSError {
                    fwDebugPrint("\(error.description)")
                    respondCallback(nil, nil)
                }
            } else if let model = tmpDic[self!.data] as? T {
                respondCallback([model], nil)
            } else {
                respondCallback(nil, nil)
            }
        })
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
                respondCallback(0, nil, self.makeError(url: URLString, code: error.responseCode ?? -1, msg: "\(error)"))
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
                respondCallback(0, nil, self.makeError(url: URLString, code: error.responseCode ?? -1, msg: "\(error)"))
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
                if #available(iOS 13.0, *) {
                    urlRequest.allowsConstrainedNetworkAccess = true
                }
            }
        case .post:
            return AF.request(URLString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers) { urlRequest in
                urlRequest.timeoutInterval = self.timeout
                if #available(iOS 13.0, *) {
                    urlRequest.allowsConstrainedNetworkAccess = true
                }
            }
        default:
            return nil
        }
    }

    /// 打印请求日志
    private func printRequestLog(URLString: String, type: AFMethodType, parameters: [String: Any]? = nil) {
        #if DEBUG
            print(currentTime())
            print("===========<request-id:\(requestId) tag:>===========")
            print(URLString)
            if type == .post {
                print("httpBody:")
                parameters?.jsonPrint()
            }

            var headDict = [String: Any]()
            for item in headers {
                headDict[item.name] = item.value
            }
            print("Request Header:")
            headDict.jsonPrint()
        #endif
    }

    /// 打印响应日志
    private func printResponseLog(json: String) {
        #if DEBUG
            print(currentTime())
            print("===========<response-id:\(requestId) tag:>===========")
            let time = String(format: "%.2fs", elapsedTime ?? 0)
            print("Response Time:\(time)")

            if let data = json.data(using: .utf8) {
                print(data.prettyPrintedJSONString ?? json)
            } else {
                print(json)
            }
        #endif
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

    private func currentTime() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss:SSS" // 自定义时间格式
        // GMT时间 转字符串，直接是系统当前时间
        return dateformatter.string(from: Date())
    }

    /// 构造错误对象
    private func makeError(url: String, code: Int, msg: String) -> NSError {
        return NSError(domain: "\(url)", code: code, userInfo: [NSLocalizedDescriptionKey: msg])
    }

    /// 返回码解析
    private func parseRetCode(dataDic: [String: Any]) -> Int {
        var retcode = 0
        if let tmpCode = dataDic[retCode] as? Int {
            retcode = tmpCode
        } else if let tmpCode = dataDic[retCode] as? String {
            retcode = tmpCode.toInt() ?? 0
        }

        return retcode
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

    private var data: String = "data"

    private var msg: String = "msg"

    private let errorCode = 9000

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
