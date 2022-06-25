//
//===--- SCUIMapViewVC.swift - Defines the SCUIMapViewVC class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/9/26.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See [高德地图开发平台](https://lbs.amap.com/api/ios-sdk/gettingstarted) information
//
//===----------------------------------------------------------------------===//

import AMapFoundationKit
import MAMapKit
import UIKit

class SCUIMapViewVC: BaseViewController, MAMapViewDelegate {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }

    @objc func injected() {
        #if DEBUG
            yxc_debugPrint("I've been injected: \(self)")
            setupUI()
            setupConstraints()
        #endif
    }

    // 执行析构过程
    deinit {}

    // MARK: - Public

    // MARK: - Protocol

    /// 没有实现不会开启定位功能
    func mapViewRequireLocationAuth(_ locationManager: CLLocationManager!) {
        locationManager.requestAlwaysAuthorization()
    }

    func mapView(_: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation _: Bool) {
        if userLocation != nil {
            yxc_debugPrint("userLocation: \(userLocation.location?.description ?? "")")
        }
    }

    func mapView(_ mapView: MAMapView!, didSingleTappedAt coordinate: CLLocationCoordinate2D) {
        // 点击地图任意位置设为新中心点
        mapView.setCenter(coordinate, animated: true)
    }

    // MARK: - IBActions

    @objc func homeButtonAction() {
        if mapView.userLocation.isUpdating, mapView.userLocation.location != nil {
            mapView.setCenter(mapView.userLocation.location.coordinate, animated: true)
            homeButton.isSelected = true
        }
    }

    // MARK: - Private

    // MARK: - UI

    func setupUI() {
        title = "MapView"
        view.addSubview(mapView)
        mapView.update(userLocationRep)
        mapView.delegate = self

        view.addSubview(homeButton)

        homeButton.addTarget(self, action: #selector(homeButtonAction), for: .touchUpInside)
    }

    // MARK: - Constraints

    func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        homeButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.right.equalTo(view).offset(-10)
            make.centerY.equalToSuperview()
        }
    }

    // MARK: - Property

    let mapView = MAMapView().then {
        $0.mapType = .standard
        // 比例尺控件
        $0.showsScale = true
        // 指南针控件
        $0.showsCompass = true
        // 地图缩放功能拓展
        $0.setZoomLevel(17.5, animated: true)
        // 旋转手势
        $0.isRotateEnabled = true
    }

    // 自定义定位小蓝点
    let userLocationRep = MAUserLocationRepresentation().then {
        // 精度圈是否显示
        $0.showsAccuracyRing = true
        // 是否显示蓝点方向指向
        $0.showsHeadingIndicator = true
        // 调整精度圈填充颜色
        // $0.fillColor = .red
        // 调整精度圈边线颜色
        $0.strokeColor = .blue

        // 调整精度圈边线宽度
        $0.lineWidth = 2
        // 精度圈是否显示律动效果
        $0.enablePulseAnnimation = true
        // 调整定位蓝点的背景颜色
        $0.locationDotBgColor = .green

        // 调整定位蓝点的颜色
        $0.locationDotFillColor = .gray
        // 调整定位蓝点的图标
        // $0.image = R.image.hightImage()
    }

    /// 用户中心位置按钮
    let homeButton = UIButton(type: .custom).then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.setImage(R.image.map_home(), for: .normal)
    }
}
