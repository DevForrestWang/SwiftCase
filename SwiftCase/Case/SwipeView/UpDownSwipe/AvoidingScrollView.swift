//
//  AvoidingScrollView.swift
//  TIUpDownSwipe
//
//  Created by Tomasz Iwaszek on 3/7/19.
//

import UIKit

class AvoidingScrollView: UIScrollView {
    public var avoidingViews: [UIView]?

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let avoidingViews = avoidingViews, touches.count == 1, let touch = touches.first else {
            return super.touchesBegan(touches, with: event)
        }

        isScrollEnabled = true

        for avoidingView in avoidingViews {
            let location = touch.location(in: avoidingView)
            if avoidingView.bounds.contains(location) {
                isScrollEnabled = false
                return
            }
        }
        return super.touchesBegan(touches, with: event)
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isScrollEnabled = true
        return super.touchesEnded(touches, with: event)
    }

    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isScrollEnabled = true
        return super.touchesCancelled(touches, with: event)
    }

    override public func touchesShouldBegin(_ touches: Set<UITouch>, with event: UIEvent?, in view: UIView) -> Bool {
        guard let avoidingViews = avoidingViews, touches.count == 1, let touch = touches.first else {
            return super.touchesShouldBegin(touches, with: event, in: view)
        }

        isScrollEnabled = true

        for avoidingView in avoidingViews {
            let location = touch.location(in: avoidingView)
            if avoidingView.bounds.contains(location) {
                isScrollEnabled = false
                return true
            }
        }
        return super.touchesShouldBegin(touches, with: event, in: view)
    }
}
