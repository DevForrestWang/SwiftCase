//
//  GrpcModuleAPI.swift
//  GrpcDemo
//
//  Created by wangfd on 2021/7/1.
//

import Foundation
import Moya
import RxSwift

// 支持多进程
let grpcMultiProvider = MoyaProvider<MultiTarget>(plugins: [SCNetworkLoggerPlugin()])
let grpcProvider = MoyaProvider<GrpcModuleAPI>()

public enum GrpcModuleAPI {
    case restTest
    case restGradeInfo(Int, String, String)
    case uploadImage(Data, String, SCImageType)
}

extension GrpcModuleAPI: TargetType {
    public var baseURL: URL { return getBaseURL()! }

    public var path: String {
        switch self {
        case .restTest:
            return "/rest/test"
        case .restGradeInfo:
            return "/rest/gradeInfo"
        case .uploadImage:
            return "/fileController/fileUploadNotCheck"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .restTest:
            return .get
        case .restGradeInfo, .uploadImage:
            return .post
        }
    }

    public var task: Task {
        switch self {
        case let .restGradeInfo(id, name, sex):
            // Get 带参数：URLEncoding.queryString
            // Post 带参数：JSONEncoding.default
            return .requestParameters(parameters: ["id": id, "name": name, "sex": sex], encoding: JSONEncoding.default)
        case let .uploadImage(data, description, type):
            let gifData = MultipartFormData(provider: .data(data), name: "file", fileName: "111.\(type.valueName)", mimeType: "image/\(type.valueName)")
            let descriptionData = MultipartFormData(provider: .data(description.data(using: .utf8)!), name: "description")
            let multipartData = [gifData, descriptionData]
            return .uploadMultipart(multipartData)
        default:
            return .requestPlain
        }
    }

    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }

    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    private func getBaseURL() -> URL? {
        var strURL = ""
        switch self {
        case .uploadImage:
            strURL = "https://dc.aadv.net:10443/mobile/reconsitution"
        default:
            strURL = GlobalConfig.gRestUrl
        }

        return URL(string: strURL)
    }
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}
