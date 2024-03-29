//
//===--- SCommunicationVC.swift - Defines the SCommunicationVC class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/9/26.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import GRPC
// import Logging
import Moya
import NIO
import RxSwift
import SnapKit
import UIKit

class SCommunicationVC: ItemListViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Communication"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    override func itemDataSource() -> [ItemListViewController.SCItemModel]? {
        return [
            SCItemModel(title: "gRPC - sayHelloRPCAction", controllerName: "runSayHelloRPC", action: #selector(sayHelloRPCAction)),
            SCItemModel(title: "gRPC - requestDataAction", controllerName: "requestDataRPC", action: #selector(requestDataAction)),
            SCItemModel(title: "Rest - restRequestAction", controllerName: "gradeInfoRest", action: #selector(restRequestAction)),
            SCItemModel(title: "WebSocket", controllerName: "gradeInfoRest", action: #selector(joinChatRoom)),
            SCItemModel(title: "AlamofireUtil", controllerName: "", action: #selector(alamofireDemo)),
        ]
    }

    // MARK: - IBActions

    @objc func joinChatRoom() {
        let alertController = UIAlertController(title: "WebSocket", message: "Please enter a name:", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        let OKAction = UIAlertAction(title: "OK", style: .default) { _ in

            guard let textFields = alertController.textFields else {
                return
            }

            let textfield = textFields[0]

            if textfield.text?.count == 0 {
                self.joinChatRoom()
            } else {
                guard let nickName = textfield.text else {
                    return
                }
                SocketHelper.shared.reConnection()
                SocketHelper.shared.joinChatRoom(nickname: nickName) { [weak self] in
                    guard let nickName = textfield.text,
                          let self = self
                    else {
                        return
                    }
                    self.moveToChartList(nickName)
                }
            }
        }

        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }

    @objc func sayHelloRPCAction() {
        if isRunSayHello {
            SC.log("The SayHello is runing.")
            return
        }

        // 异步执行回主线程写法
        DispatchQueue.global().async {
            self.runSayHelloRPC()
            DispatchQueue.main.async {
                SC.log("Come back to main thread\(Thread.current)")
                self.isRunSayHello = false
            }
        }
    }

    @objc func requestDataAction() {
        if isRunRequestData {
            SC.log("The requestDataAction is runing.")
            return
        }

        DispatchQueue.global().async {
            self.requestDataRPC()
            DispatchQueue.main.async {
                SC.log("Come back to main thread\(Thread.current)")
                self.isRunRequestData = false
            }
        }
    }

    @objc func restRequestAction() {
        SC.log("Run restRequestAction")
        let startTime = CFAbsoluteTimeGetCurrent()
        // sayHelloRest()
        for index in 1 ... runTimes {
            gradeInfoRest(index)
        }

        let endTime = CFAbsoluteTimeGetCurrent()
        SC.log("End restRequestAction, runTimes: \(runTimes), 执行时长： \((endTime - startTime) * 1000) 毫秒")
    }

    @objc func alamofireDemo() {
        // GET 请求
        let strURL = "https://mobi.hsxt.cn:9446/refactor/lcs/queryProvinceTree"
        let parameter: [String: Any] = [
            "countryNo": "156",
        ]

        AFNetRequest()
            .updateHead(headInfo: ["custId": "init custId", "token": "init token"])
            .requestData(URLString: strURL, parameters: parameter) { responseObject, _ in
                if let _ = responseObject {}
            }

        AFNetRequest(isParse: true, retCode: "retCode", msg: "msg", timeout: 30).requestData(URLString: strURL, parameters: parameter) { responseObject, error in
            if error != nil {
                print("Error: \(error?.description ?? "")")
                return
            }

            if let _ = responseObject {}
        }

        // 返回数据解析成指定的Model, 指定解码规则
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        AFNetRequest().requestDecodableArray(of: ProvincesModel.self, URLString: strURL, parameters: parameter, decoder: decoder) { items, error in

            if error != nil {
                print("Error: \(error?.description ?? "")")
                return
            }

            if let model = items?.first as? ProvincesModel {
                model.prettyPrint()
            }
        }

        // 接口返回json数组字符串
        AFNetRequest(isParse: false).requestData(URLString: "https://jsonplaceholder.typicode.com/posts") { responseObject, _ in
            if let _ = responseObject {}
        }

        // 文件下载
        AFNetRequest().download(URLString: "https://www.runoob.com/try/demo_source/mov_bbb.mp4",
                                fileName: "mov_bbb.mp4",
                                directory: .cachesDirectory)
        { progress, fileURL, error in

            debugPrint("progress: \(String(format: "%.2fs", progress))")
            if error != nil {
                print("Error: \(error?.description ?? "")")
                return
            }

            if let path = fileURL?.path {
                debugPrint("file path:\(path)")
            }
        }

        // 文件上传
        let fileURL = Bundle.main.url(forResource: "pig", withExtension: "png")
        AFNetRequest().upload(fileURL: fileURL, URLString: "https://httpbin.org/post") { progress, responseObject, error in

            debugPrint("progress: \(String(format: "%.2fs", progress))")
            if error != nil {
                print("Error: \(error?.description ?? "")")
                return
            }

            if let responseObject = responseObject {
                debugPrint("responseObject count:\(responseObject.count)")
            }
        }
    }

    // MARK: - Private

    private func runSayHelloRPC() {
        SC.log("Start GRPC Client.")
        isRunSayHello = true

        // See: https://github.com/apple/swift-nio#eventloops-and-eventloopgroups
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        // Make sure the group is shutdown when we're done with it.
        defer {
            try! group.syncShutdownGracefully()
        }

        // Configure the channel, we're not using TLS so the connection is `insecure`.
        let channel = ClientConnection.insecure(group: group).connect(host: rpcURL, port: rpcPort)
        // Close the connection when we're done with it.
        defer {
            try! channel.close().wait()
        }

        let client = Grpc_GreeterClient(channel: channel)
        let startTime = CFAbsoluteTimeGetCurrent()

        for index in 1 ... runTimes {
            sayHelloRPC(client: client, index: index)
        }

        let endTime = CFAbsoluteTimeGetCurrent()
        SC.log("End runSayHelloRPC, runTimes: \(runTimes), 执行时长： \((endTime - startTime) * 1000) 毫秒")
        /*
         End runSayHelloRPC, runTimes: 10000, 执行时长： 97133.64005088806 毫秒 1
         End runSayHelloRPC, runTimes: 10000, 执行时长： 78360.21292209625 毫秒 10
         End runSayHelloRPC, runTimes: 10000, 执行时长： 91646.01409435272 毫秒 100
         */
    }

    private func sayHelloRPC(client: Grpc_GreeterClient, index: Int) {
        var request = Grpc_HelloRequest()
        request.name = "Forrest"
        request.sex = "Man"

        // 设置超时时间否则会一直等待
        let options = CallOptions(timeLimit: .timeout(.seconds(5)))
        let sayHello = client.sayHello(request, callOptions: options)
        do {
            // wait() on the response to stop the program from exiting before the response is received.
            let response = try sayHello.response.wait()
            SC.log("Index:\(index), Greeter received: \(response.message)")
        } catch {
            SC.log("Greeter failed: \(error)")
        }
    }

    private func requestDataRPC() {
        SC.log("Start requestDataRPC")
        isRunRequestData = true

        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        defer {
            try! group.syncShutdownGracefully()
        }

        let channel = ClientConnection.insecure(group: group).connect(host: rpcURL, port: rpcPort)
        defer {
            try! channel.close().wait()
        }

        let client = Grpc_RequestBodyClient(channel: channel)
        let startTime = CFAbsoluteTimeGetCurrent()

        for index in 1 ... runTimes {
            requestData(client: client, index: index)
        }

        let endTime = CFAbsoluteTimeGetCurrent()
        SC.log("End requestDataRPC, runTimes: \(runTimes), 执行时长： \((endTime - startTime) * 1000) 毫秒")

        /*
         End requestDataRPC, runTimes: 10000, 执行时长： 78737.40696907043 毫秒 1
         End requestDataRPC, runTimes: 10000, 执行时长： 76496.34099006653 毫秒 10
         End requestDataRPC, runTimes: 10000, 执行时长： 87033.5260629654 毫秒  100
         End requestDataRPC, runTimes: 10000, 执行时长： 88287.03808784485 毫秒  5
         */
    }

    private func requestData(client: Grpc_RequestBodyClient, index: Int) {
        SC.log("Run requestData")
        var header = Grpc_Header()
        header.appName = "hsAPP"
        header.token = "aaabbbccccccdddddddd"
        header.custid = "0500108123520210819"
        header.version = "5.5.2"
        header.appType = "40"

        var request = Grpc_Request()
        request.header = header
        request.params = getParams(index: index)

        let options = CallOptions(timeLimit: .timeout(.seconds(5)))
        let requestData = client.requestData(request, callOptions: options)

        do {
            let response: Grpc_Response? = try requestData.response.wait()
            SC.log("Index:\(index), Greeter received: \(response!)")

            if let tResponse = response {
                if tResponse.retCode != 200 {
                    SC.log("The retCode is not 200.")
                    return
                }

                // Json 字符串转对象
                let jsonStr = tResponse.data
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonStr, options: []) {
                    do {
                        let grade = try JSONDecoder().decode(Grade.self, from: jsonData)
                        SC.log("gradeObj = \(grade)")
                    } catch {
                        SC.log("gradeObj nil")
                    }
                }
            }
        } catch {
            SC.log("requestData failed: \(error)")
        }
    }

    private func getParams(index: Int) -> String {
        // 对象转JSON字符串
        let params = Params(id: 100 + index, name: "Forrest", sex: "Man")
        let jsonStr = params.toJsonString()
        if let tmpObj = jsonStr {
            return tmpObj
        }

        return "No Data"
    }

    private func sayHelloRest() {
        grpcProvider.rx.request(.restTest).subscribe { event in
            switch event {
            case let .success(response):
                let jsonString = try? response.mapString()
                let message = jsonString ?? "Couldn't access API"
                // self.showAlert("restTest: ", message:message)
                SC.log("Response: \(message)")
            case let .failure(error):
                let message = error.localizedDescription
                // self.showAlert("restTest: ", message: message)
                SC.log("Error: \(message)")
            }
        }.disposed(by: disposeBag)
    }

    private func gradeInfoRest(_ index: Int) {
        grpcMultiProvider.rx.request(MultiTarget(GrpcModuleAPI.restGradeInfo(101, "Forrest", "Man")))
            .mapObject(Grade.self, dataName: SCResponseName())
            .subscribe { event in
                switch event {
                case let .success(response):
                    SC.log("index:\(index), gradeObj: \(response)")
                case let .failure(error):
                    let message = error.localizedDescription
                    // self.showAlert("restTest: ", message: message)
                    SC.log("index:\(index), Error: \(message)")
                }
            }.disposed(by: disposeBag)
    }

    private func moveToChartList(_ name: String) {
        let vc = ChatListViewController()
        vc.nickName = name
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Protocol

    // MARK: - UI

    // MARK: - Constraints

    // MARK: - Property

    private let rpcURL = GlobalConfig.gRpcUrl
    private let rpcPort = 9099
    private let runTimes = 1

    private var isRunSayHello = false
    private var isRunRequestData = false

    // 页面销毁时，使用的资源会释放
    private let disposeBag = DisposeBag()
}
