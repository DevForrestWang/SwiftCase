//
//===--- DesignPatternTests.swift - Defines the DesignPatternTests class ----------===//
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

import XCTest
@testable import SwiftCase

//===----------------------------------------------------------------------===//
//                              DesignPatternTests
//===----------------------------------------------------------------------===//
class DesignPatternTests: XCTestCase {

    struct ExecutionTime {
        static let max: TimeInterval = 5
        static let waiting: TimeInterval = 4
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func prepareTestEnvironment(_ execution: () -> ()) {
        /// This method tells Xcode to wait for async operations. Otherwise the
        /// main test is done immediately.
        let expectation = self.expectation(description: "Expectation for async operations")
        let deadline = DispatchTime.now() + ExecutionTime.waiting
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: {expectation.fulfill()})
        
        execution()
        
        wait(for: [expectation], timeout: ExecutionTime.max)
    }
    
    func testDelayOperationCmd() throws {
        fwPrintEnter(message:"Client: Start testDelayOperationCmd")
        
        prepareTestEnvironment {
            let siri = SiriShortcuts.shared
            
            SC.log("User: Hey Siri, I am leaving my home")
            siri.perform(.leaveHome)
            
            SC.log("User: Hey Siri, I am leaving my work in 3 minutes")
            /// for simplicity, we use seconds
            siri.perform(.leaveWork, delay: 3)
            
            SC.log("User: Hey Siri, I am still working")
            siri.cancel(.leaveWork)
        }
        
        fwPrintLine()
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
