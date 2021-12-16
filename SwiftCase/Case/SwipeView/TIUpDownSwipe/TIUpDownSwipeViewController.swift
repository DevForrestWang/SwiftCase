//
//  TIUpDownSwipeViewController.swift
//  TIUpDownSwipe
//
//  Created by Tomasz Iwaszek on 2/12/19.
//  Copyright © 2019 wachus77. All rights reserved.
//

import UIKit

public protocol TIUpDownSwipeDataSource {
    var upDownSwipeTopViewController: TIUpDownSwipeController { get }
    var upDownSwipeMiddleViewController: TIUpDownSwipeController { get }
    var upDownSwipeBottomViewController: TIUpDownSwipeController { get }
}

func != (lhs: TIUpDownSwipeApperanceProtocol?, rhs: TIUpDownSwipeApperanceProtocol?) -> Bool {
    guard let lhs = lhs, let rhs = rhs else { return true }
    return !(lhs == rhs)
}

public protocol TIUpDownSwipeApperanceProtocol: UIViewController {
    func controllerHasAppeared()
}

public typealias TIUpDownSwipeController = TIUpDownSwipeApperanceProtocol

open class TIUpDownSwipeViewController: UIViewController {
    public var datasource: TIUpDownSwipeDataSource! {
        didSet {
            setupInitialState()
        }
    }

    private let scrollView = AvoidingScrollView()

    var topSafeArea: CGFloat {
        return iphoneType == .other ? 0.0 : view.safeAreaInsets.top
    }

    var bottomSafeArea: CGFloat {
        return iphoneType == .other ? 0.0 : view.safeAreaInsets.bottom
    }

    // MARK: Gripper properties

    private var topGripperView: GripperView!
    private var bottomGripperView: GripperView!

    private var currentVisibleController: TIUpDownSwipeController? {
        didSet {
            if oldValue != currentVisibleController {
                currentVisibleController!.controllerHasAppeared()
            }
        }
    }

    public var hideGripperViews: Bool = true {
        didSet {
            topGripperView.isHidden = hideGripperViews
            bottomGripperView.isHidden = hideGripperViews
            topTextLayer.isHidden = hideGripperViews
            bottomTextLayer.isHidden = hideGripperViews
        }
    }

    public var gripperColor: UIColor = .white {
        didSet {
            topGripperView.strokeColor = gripperColor
        }
    }

    private let gripperSizeWidth: CGFloat = 30
    private let gripperSizeHeight: CGFloat = 10
    private let gripperSizeHeightRatio: CGFloat = 12
    private let gripperLineWidth: CGFloat = 5

    // MARK: Text properties

    private var topTextLayer: UILabel!
    private var bottomTextLayer: UILabel!

    public var avoidingViewsForScroll: [UIView]? {
        didSet {
            scrollView.avoidingViews = avoidingViewsForScroll
            scrollView.delaysContentTouches = false
        }
    }

    public var textColor: UIColor = .white {
        didSet {
            topTextLayer?.textColor = textColor
            bottomTextLayer?.textColor = textColor
        }
    }

    public var textFont = UIFont.systemFont(ofSize: 19) {
        didSet {
            topTextLayer?.font = textFont
            bottomTextLayer?.font = textFont
            topTextLayer?.sizeToFit()
            bottomTextLayer?.sizeToFit()
            updateInitialLabelsFrame()
        }
    }

    public var topText: String = "top" {
        didSet {
            topTextLayer?.text = topText
            topTextLayer?.sizeToFit()
            updateInitialLabelsFrame()
        }
    }

    public var bottomText: String = "bottom" {
        didSet {
            bottomTextLayer?.text = bottomText
            bottomTextLayer?.sizeToFit()
            updateInitialLabelsFrame()
        }
    }

    private let textTopBottomSpace: CGFloat = 10
    private let textLayerHeight: CGFloat = 20

    // MARK: Controllers properties

    private var controllers: [TIUpDownSwipeController] = []

    public var topControllerColor = UIColor(red: 0.640, green: 0.810, blue: 0.890, alpha: 1.0)
    public var middleControllerColor = UIColor(red: 0.130, green: 0.350, blue: 0.520, alpha: 1.0)
    public var bottomControllerColor = UIColor(red: 0.190, green: 0.290, blue: 0.390, alpha: 1.0)

    override open var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: Lifecycle

    override open func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
    }

    override open func viewDidAppear(_: Bool) {
        guard let _ = datasource else {
            return
        }

        scrollView.contentOffset = CGPoint(x: 0, y: 1 * screenHeight)
    }

    override open func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

        guard let _ = datasource else {
            return
        }

        updateInitialGrippersFrame()
        updateInitialLabelsFrame()
    }

    // MARK: Setup views

    private func setupInitialState() {
        guard let datasource = datasource else {
            return
        }

        scrollView.contentInsetAdjustmentBehavior = .never

        controllers = [datasource.upDownSwipeTopViewController, datasource.upDownSwipeMiddleViewController, datasource.upDownSwipeBottomViewController]

        view.layoutIfNeeded()

        addGripperViews()
        addLabels()
        setupScrollView()

        scrollView.delegate = self
        scrollView.backgroundColor = middleControllerColor
    }

    private func setupScrollView() {
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false

        view.addSubview(scrollView)

        scrollView.frame = view.frame
        scrollView.contentSize = CGSize(width: 0, height: CGFloat(controllers.count) * screenHeight)

        let uiViewController = controllers.map { controller -> UIViewController in
            controller as UIViewController
        }
        _ = uiViewController.map { addViewToScrollView($0) }
        _ = uiViewController.map { $0.view.frame.origin = CGPoint(x: 0, y: CGFloat(uiViewController.index(of: $0)!) * screenHeight) }
    }

    private func addViewToScrollView(_ viewController: UIViewController) {
        scrollView.addSubview(viewController.view)
        viewController.willMove(toParent: self)
        addChild(viewController)
    }

    // MARK: Setup views - gripper, labels

    private func addGripperViews() {
        topGripperView = GripperView()
        topGripperView.setup(center: CGPoint(x: gripperSizeWidth / 2, y: gripperSizeHeight / 2), size: gripperSizeWidth, heightRatio: gripperSizeHeightRatio, offset: CGPoint.zero, lineWidth: gripperLineWidth, type: .caretDown)

        topGripperView.strokeColor = gripperColor

        scrollView.addSubview(topGripperView)

        bottomGripperView = GripperView()
        bottomGripperView.setup(center: CGPoint(x: gripperSizeWidth / 2, y: gripperSizeHeight / 2), size: gripperSizeWidth, heightRatio: gripperSizeHeightRatio, offset: CGPoint.zero, lineWidth: gripperLineWidth, type: .caretUp)

        bottomGripperView.strokeColor = gripperColor

        scrollView.addSubview(bottomGripperView)

        updateInitialGrippersFrame()
    }

    private func addLabels() {
        topTextLayer = UILabel()
        topTextLayer.textColor = textColor
        topTextLayer.text = topText
        topTextLayer.font = textFont
        topTextLayer.sizeToFit()

        scrollView.addSubview(topTextLayer)

        bottomTextLayer = UILabel()
        bottomTextLayer.textColor = textColor
        bottomTextLayer.text = bottomText
        bottomTextLayer.font = textFont
        bottomTextLayer.sizeToFit()

        scrollView.addSubview(bottomTextLayer)

        updateInitialLabelsFrame()
    }

    private func updateInitialGrippersFrame() {
        topGripperView.frame = CGRect(x: screenWidth / 2 - gripperSizeWidth / 2, y: screenHeight + topSafeArea + (textTopBottomSpace * 2 + textLayerHeight), width: gripperSizeWidth, height: gripperSizeHeight)

        bottomGripperView.frame = CGRect(x: screenWidth / 2 - gripperSizeWidth / 2, y: (screenHeight * 2) - gripperSizeHeight - bottomSafeArea - (textTopBottomSpace * 2 + textLayerHeight), width: gripperSizeWidth, height: gripperSizeHeight)
    }

    private func updateInitialLabelsFrame() {
        var topTextFrame = topTextLayer.frame
        topTextFrame.origin.x = screenWidth / 2 - topTextLayer.frame.width / 2
        topTextFrame.origin.y = topGripperView.frame.origin.y - topTextLayer.frame.height - textTopBottomSpace
        topTextLayer.frame = topTextFrame

        var bottomTextFrame = bottomTextLayer.frame
        bottomTextFrame.origin.x = screenWidth / 2 - bottomTextLayer.frame.width / 2
        bottomTextFrame.origin.y = bottomGripperView.frame.origin.y + gripperSizeHeight + textTopBottomSpace
        bottomTextLayer.frame = bottomTextFrame
    }

    // MARK: Color, gripper animations

    // This function calculates a new color by blending the two colors.
    // A percent of 0.0 gives the "from" color
    // A percent of 1.0 gives the "to" color
    // Any other percent gives an appropriate color in between the two

    private func blend(from: UIColor, to: UIColor, percent: Double) -> UIColor {
        var fR: CGFloat = 0.0
        var fG: CGFloat = 0.0
        var fB: CGFloat = 0.0
        var tR: CGFloat = 0.0
        var tG: CGFloat = 0.0
        var tB: CGFloat = 0.0

        from.getRed(&fR, green: &fG, blue: &fB, alpha: nil)
        to.getRed(&tR, green: &tG, blue: &tB, alpha: nil)

        let dR = tR - fR
        let dG = tG - fG
        let dB = tB - fB

        let rR = fR + dR * CGFloat(percent)
        let rG = fG + dG * CGFloat(percent)
        let rB = fB + dB * CGFloat(percent)

        return UIColor(red: rR, green: rG, blue: rB, alpha: 1.0)
    }

    // Pass in the scroll percentage to get the appropriate color

    private func scrollColor(percent: Double) -> UIColor {
        var start: UIColor
        var end: UIColor
        var perc = percent

        if percent < 0.5 {
            // If the scroll percentage is 0.0..<0.5 blend between top and middle
            start = topControllerColor
            end = middleControllerColor
        } else {
            // If the scroll percentage is 0.5..1.0 blend between middle and bottom
            start = middleControllerColor
            end = bottomControllerColor
            perc -= 0.5
        }

        return blend(from: start, to: end, percent: perc * 2.0)
    }

    // MARK: Customization at scrolling

    private func changeTopGripperPosition(percent: Double) {
        if percent >= 0.0, percent < 0.5 {
            let textHeight = topTextLayer.frame.height
            let textWidth = topTextLayer.frame.width
            let newHeight = CGFloat(percent * 2 * Double(gripperSizeHeight + topSafeArea + bottomSafeArea + (textTopBottomSpace * 3 + textHeight)))
            let y = screenHeight - (gripperSizeHeight + bottomSafeArea + textTopBottomSpace) + newHeight

            topGripperView?.frame = CGRect(x: screenWidth / 2 - gripperSizeWidth / 2, y: y, width: gripperSizeWidth, height: gripperSizeHeight)
            topTextLayer?.frame = CGRect(x: screenWidth / 2 - textWidth / 2, y: y - textHeight - textTopBottomSpace, width: textWidth, height: textHeight)

            let animateValue = percent * 2 * Double(gripperSizeWidth / gripperSizeHeightRatio) * 2
            let value = Double(gripperSizeWidth / gripperSizeHeightRatio) * 2 - animateValue

            topGripperView.animate(minusHeight: CGFloat(value))

            topTextLayer.alpha = CGFloat(percent * 2)
        }
    }

    private func changeBottomGripperPosition(percent: Double) {
        if percent > 0.5 {
            let textHeight = bottomTextLayer.frame.height
            let textWidth = bottomTextLayer.frame.width
            let newHeight = CGFloat(percent * 2 * Double(gripperSizeHeight + bottomSafeArea + topSafeArea + (textTopBottomSpace * 3 + textHeight)))
            let y = (screenHeight * 2) - (gripperSizeHeight * 2 + bottomSafeArea * 2 + topSafeArea + textTopBottomSpace + (textTopBottomSpace * 2 + textHeight) * 2) + newHeight

            bottomGripperView.frame = CGRect(x: screenWidth / 2 - gripperSizeWidth / 2, y: y, width: gripperSizeWidth, height: gripperSizeHeight)
            bottomTextLayer.frame = CGRect(x: screenWidth / 2 - textWidth / 2, y: y + gripperSizeHeight + textTopBottomSpace, width: textWidth, height: textHeight)

            let animateValue = percent * 2 * Double(gripperSizeWidth / gripperSizeHeightRatio) * 2
            let value = Double(gripperSizeWidth / gripperSizeHeightRatio) * 2 - animateValue

            bottomGripperView.animate(minusHeight: CGFloat(value))

            bottomTextLayer.alpha = 2 - CGFloat(2 * percent)
        }
    }
}

extension TIUpDownSwipeViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset

        let scolor = scrollColor(percent: Double(percentageVerticalOffset))
        scrollView.backgroundColor = scolor
        changeTopGripperPosition(percent: Double(percentageVerticalOffset))
        changeBottomGripperPosition(percent: Double(percentageVerticalOffset))

        // find out current controller
        switch percentageVerticalOffset {
        case 0.0:
            currentVisibleController = controllers[0]
        case 0.5:
            currentVisibleController = controllers[1]
        case 1.0:
            currentVisibleController = controllers[2]
        default:
            break
        }
    }
}
