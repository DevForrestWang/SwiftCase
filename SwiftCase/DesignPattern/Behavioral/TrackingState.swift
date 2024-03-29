//
//===--- TrackingState.swift - Defines the TrackingState class ----------===//
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

import Foundation
/*:
  ### 状态模式是一种行为设计模式，让你能在一个对象的内部状态变化时改变其行为，使其看上去就像改变了自身所属的类一样。
  ### 理论：
    1、 如果对象需要根据自身当前状态进行不同行为，同时状态的数量非常多且与状态相关的代码会频繁变更的话，可使用状态模式。
    2、如果某个类需要根据成员变量的当前值改变自身行为，从而需要使用大量的条件语句时，可使用该模式。
    3、当相似状态和基于条件的状态机转换中存在许多重复代码时，可使用状态模式。

 ### 用法
     testTrackingState()
 */

class LocationTracker {
    private lazy var trackingState: TrackingState = EnabledTrackingState(tracker: self)

    func startTracking() {
        trackingState.startTracking()
    }

    func stopTracking() {
        trackingState.stopTracking()
    }

    func pauseTracking(for time: TimeInterval) {
        trackingState.pauseTracking(for: time)
    }

    func makeCheckIn() {
        trackingState.makeCheckIn()
    }

    func findMyChildren() {
        trackingState.findMyChildren()
    }

    func update(state: TrackingState) {
        trackingState = state
    }
}

protocol TrackingState {
    func startTracking()
    func stopTracking()
    func pauseTracking(for time: TimeInterval)

    func makeCheckIn()
    func findMyChildren()
}

class EnabledTrackingState: TrackingState {
    private weak var tracker: LocationTracker?

    init(tracker: LocationTracker?) {
        self.tracker = tracker
    }

    func startTracking() {
        SC.log("EnabledTrackingState: startTracking is invoked")
        SC.log("EnabledTrackingState: tracking location....1")
        SC.log("EnabledTrackingState: tracking location....2")
        SC.log("EnabledTrackingState: tracking location....3")
    }

    func stopTracking() {
        SC.log("EnabledTrackingState: Received 'stop tracking'")
        SC.log("EnabledTrackingState: Changing state to 'disabled'...")
        tracker?.update(state: DisabledTrackingState(tracker: tracker))
        tracker?.stopTracking()
    }

    func pauseTracking(for time: TimeInterval) {
        SC.log("EnabledTrackingState: Received 'pause tracking' for \(time) seconds")
        SC.log("EnabledTrackingState: Changing state to 'disabled'...")
        tracker?.update(state: DisabledTrackingState(tracker: tracker))
        tracker?.pauseTracking(for: time)
    }

    func makeCheckIn() {
        SC.log("EnabledTrackingState: performing check-in at the current location")
    }

    func findMyChildren() {
        SC.log("EnabledTrackingState: searching for children...")
    }
}

class DisabledTrackingState: TrackingState {
    private weak var tracker: LocationTracker?

    init(tracker: LocationTracker?) {
        self.tracker = tracker
    }

    func startTracking() {
        SC.log("DisabledTrackingState: Received 'start tracking'")
        SC.log("DisabledTrackingState: Changing state to 'enabled'...")
        tracker?.update(state: EnabledTrackingState(tracker: tracker))
    }

    func stopTracking() {
        SC.log("DisabledTrackingState: Received 'stop tracking'")
        SC.log("DisabledTrackingState: Do nothing...")
    }

    func pauseTracking(for time: TimeInterval) {
        SC.log("DisabledTrackingState: Pause tracking for \(time) seconds")

        for i in 0 ... Int(time) {
            SC.log("DisabledTrackingState: pause...\(i)")
        }

        SC.log("DisabledTrackingState: Time is over")
        SC.log("DisabledTrackingState: Returing to 'enabled state'...\n")
        tracker?.update(state: EnabledTrackingState(tracker: tracker))
        tracker?.startTracking()
    }

    func makeCheckIn() {
        SC.log("DisabledTrackingState: Received 'make check-in'")
        SC.log("DisabledTrackingState: Changing state to 'enabled'...")
        tracker?.update(state: EnabledTrackingState(tracker: tracker))
        tracker?.makeCheckIn()
    }

    func findMyChildren() {
        SC.log("DisabledTrackingState: Received 'find my children'")
        SC.log("DisabledTrackingState: Changing state to 'enabled'...")
        tracker?.update(state: EnabledTrackingState(tracker: tracker))
        tracker?.findMyChildren()
    }
}
