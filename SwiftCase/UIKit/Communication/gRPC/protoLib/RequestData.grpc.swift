//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: proto/RequestData.proto
//

//
// Copyright 2018, gRPC Authors All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import GRPC
import NIO
import SwiftProtobuf

/// 服务端接口类
///
/// Usage: instantiate `Grpc_RequestBodyClient`, then call methods of this protocol to make API calls.
protocol Grpc_RequestBodyClientProtocol: GRPCClient {
    var serviceName: String { get }
    var interceptors: Grpc_RequestBodyClientInterceptorFactoryProtocol? { get }

    func requestData(
        _ request: Grpc_Request,
        callOptions: CallOptions?
    ) -> UnaryCall<Grpc_Request, Grpc_Response>
}

extension Grpc_RequestBodyClientProtocol {
    var serviceName: String {
        return "grpc.RequestBody"
    }

    /// Unary call to RequestData
    ///
    /// - Parameters:
    ///   - request: Request to send to RequestData.
    ///   - callOptions: Call options.
    /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
    func requestData(
        _ request: Grpc_Request,
        callOptions: CallOptions? = nil
    ) -> UnaryCall<Grpc_Request, Grpc_Response> {
        return makeUnaryCall(
            path: "/grpc.RequestBody/RequestData",
            request: request,
            callOptions: callOptions ?? defaultCallOptions,
            interceptors: interceptors?.makeRequestDataInterceptors() ?? []
        )
    }
}

protocol Grpc_RequestBodyClientInterceptorFactoryProtocol {
    /// - Returns: Interceptors to use when invoking 'requestData'.
    func makeRequestDataInterceptors() -> [ClientInterceptor<Grpc_Request, Grpc_Response>]
}

final class Grpc_RequestBodyClient: Grpc_RequestBodyClientProtocol {
    let channel: GRPCChannel
    var defaultCallOptions: CallOptions
    var interceptors: Grpc_RequestBodyClientInterceptorFactoryProtocol?

    /// Creates a client for the grpc.RequestBody service.
    ///
    /// - Parameters:
    ///   - channel: `GRPCChannel` to the service host.
    ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
    ///   - interceptors: A factory providing interceptors for each RPC.
    init(
        channel: GRPCChannel,
        defaultCallOptions: CallOptions = CallOptions(),
        interceptors: Grpc_RequestBodyClientInterceptorFactoryProtocol? = nil
    ) {
        self.channel = channel
        self.defaultCallOptions = defaultCallOptions
        self.interceptors = interceptors
    }
}
