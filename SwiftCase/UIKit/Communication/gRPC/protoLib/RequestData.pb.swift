// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: RequestData.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
private struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
    struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
    typealias Version = _2
}

/// 请求头
struct Grpc_Header {
    // SwiftProtobuf.Message conformance is added in an extension below. See the
    // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
    // methods supported on all messages.

    var token = String()

    var custid = String()

    var version = String()

    var appType = String()

    var appName = String()

    var unknownFields = SwiftProtobuf.UnknownStorage()

    init() {}
}

/// 请求参数
struct Grpc_Request {
    // SwiftProtobuf.Message conformance is added in an extension below. See the
    // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
    // methods supported on all messages.

    var header: Grpc_Header {
        get { return _header ?? Grpc_Header() }
        set { _header = newValue }
    }

    /// Returns true if `header` has been explicitly set.
    var hasHeader: Bool { return self._header != nil }
    /// Clears the value of `header`. Subsequent reads from it will return its default value.
    mutating func clearHeader() { _header = nil }

    /// "{k:v,k2:v2}"
    var params = String()

    var unknownFields = SwiftProtobuf.UnknownStorage()

    init() {}

    fileprivate var _header: Grpc_Header?
}

/// 响应参数
struct Grpc_Response {
    // SwiftProtobuf.Message conformance is added in an extension below. See the
    // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
    // methods supported on all messages.

    var retCode: Int32 = 0

    /// "{k:v,k2:v2}"
    var data = String()

    var msg = String()

    var totalPage: UInt32 = 0

    var currentPage: UInt32 = 0

    var rows: UInt32 = 0

    var unknownFields = SwiftProtobuf.UnknownStorage()

    init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

private let _protobuf_package = "grpc"

extension Grpc_Header: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
    static let protoMessageName: String = _protobuf_package + ".Header"
    static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
        1: .same(proto: "token"),
        2: .same(proto: "custid"),
        3: .same(proto: "version"),
        4: .same(proto: "appType"),
        5: .same(proto: "appName"),
    ]

    mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
        while let fieldNumber = try decoder.nextFieldNumber() {
            // The use of inline closures is to circumvent an issue where the compiler
            // allocates stack space for every case branch when no optimizations are
            // enabled. https://github.com/apple/swift-protobuf/issues/1034
            switch fieldNumber {
            case 1: try try decoder.decodeSingularStringField(value: &token)
            case 2: try try decoder.decodeSingularStringField(value: &custid)
            case 3: try try decoder.decodeSingularStringField(value: &version)
            case 4: try try decoder.decodeSingularStringField(value: &appType)
            case 5: try try decoder.decodeSingularStringField(value: &appName)
            default: break
            }
        }
    }

    func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
        if !token.isEmpty {
            try visitor.visitSingularStringField(value: token, fieldNumber: 1)
        }
        if !custid.isEmpty {
            try visitor.visitSingularStringField(value: custid, fieldNumber: 2)
        }
        if !version.isEmpty {
            try visitor.visitSingularStringField(value: version, fieldNumber: 3)
        }
        if !appType.isEmpty {
            try visitor.visitSingularStringField(value: appType, fieldNumber: 4)
        }
        if !appName.isEmpty {
            try visitor.visitSingularStringField(value: appName, fieldNumber: 5)
        }
        try unknownFields.traverse(visitor: &visitor)
    }

    static func == (lhs: Grpc_Header, rhs: Grpc_Header) -> Bool {
        if lhs.token != rhs.token { return false }
        if lhs.custid != rhs.custid { return false }
        if lhs.version != rhs.version { return false }
        if lhs.appType != rhs.appType { return false }
        if lhs.appName != rhs.appName { return false }
        if lhs.unknownFields != rhs.unknownFields { return false }
        return true
    }
}

extension Grpc_Request: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
    static let protoMessageName: String = _protobuf_package + ".Request"
    static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
        1: .same(proto: "header"),
        2: .same(proto: "params"),
    ]

    mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
        while let fieldNumber = try decoder.nextFieldNumber() {
            // The use of inline closures is to circumvent an issue where the compiler
            // allocates stack space for every case branch when no optimizations are
            // enabled. https://github.com/apple/swift-protobuf/issues/1034
            switch fieldNumber {
            case 1: try try decoder.decodeSingularMessageField(value: &_header)
            case 2: try try decoder.decodeSingularStringField(value: &params)
            default: break
            }
        }
    }

    func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
        if let v = _header {
            try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
        }
        if !params.isEmpty {
            try visitor.visitSingularStringField(value: params, fieldNumber: 2)
        }
        try unknownFields.traverse(visitor: &visitor)
    }

    static func == (lhs: Grpc_Request, rhs: Grpc_Request) -> Bool {
        if lhs._header != rhs._header { return false }
        if lhs.params != rhs.params { return false }
        if lhs.unknownFields != rhs.unknownFields { return false }
        return true
    }
}

extension Grpc_Response: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
    static let protoMessageName: String = _protobuf_package + ".Response"
    static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
        1: .same(proto: "retCode"),
        2: .same(proto: "data"),
        3: .same(proto: "msg"),
        4: .same(proto: "totalPage"),
        5: .same(proto: "currentPage"),
        6: .same(proto: "rows"),
    ]

    mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
        while let fieldNumber = try decoder.nextFieldNumber() {
            // The use of inline closures is to circumvent an issue where the compiler
            // allocates stack space for every case branch when no optimizations are
            // enabled. https://github.com/apple/swift-protobuf/issues/1034
            switch fieldNumber {
            case 1: try try decoder.decodeSingularInt32Field(value: &retCode)
            case 2: try try decoder.decodeSingularStringField(value: &data)
            case 3: try try decoder.decodeSingularStringField(value: &msg)
            case 4: try try decoder.decodeSingularUInt32Field(value: &totalPage)
            case 5: try try decoder.decodeSingularUInt32Field(value: &currentPage)
            case 6: try try decoder.decodeSingularUInt32Field(value: &rows)
            default: break
            }
        }
    }

    func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
        if retCode != 0 {
            try visitor.visitSingularInt32Field(value: retCode, fieldNumber: 1)
        }
        if !data.isEmpty {
            try visitor.visitSingularStringField(value: data, fieldNumber: 2)
        }
        if !msg.isEmpty {
            try visitor.visitSingularStringField(value: msg, fieldNumber: 3)
        }
        if totalPage != 0 {
            try visitor.visitSingularUInt32Field(value: totalPage, fieldNumber: 4)
        }
        if currentPage != 0 {
            try visitor.visitSingularUInt32Field(value: currentPage, fieldNumber: 5)
        }
        if rows != 0 {
            try visitor.visitSingularUInt32Field(value: rows, fieldNumber: 6)
        }
        try unknownFields.traverse(visitor: &visitor)
    }

    static func == (lhs: Grpc_Response, rhs: Grpc_Response) -> Bool {
        if lhs.retCode != rhs.retCode { return false }
        if lhs.data != rhs.data { return false }
        if lhs.msg != rhs.msg { return false }
        if lhs.totalPage != rhs.totalPage { return false }
        if lhs.currentPage != rhs.currentPage { return false }
        if lhs.rows != rhs.rows { return false }
        if lhs.unknownFields != rhs.unknownFields { return false }
        return true
    }
}
