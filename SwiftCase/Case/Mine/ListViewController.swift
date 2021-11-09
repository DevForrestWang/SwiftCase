//
//===--- ListViewController.swift - Defines the ListViewController class ----------===//
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
import Toast_Swift
import UIKit

class ListViewController: BaseViewController, CommonListDelegate {
    var productList: CommonList<Product, ProductCell>!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // 执行析构过程
    deinit {}

    // MARK: - IBActions

    func didSelectItem<Item>(_ item: Item) {
        if let product = item as? Product {
            view.makeToast("Product Name: \(product.name)", duration: 2.0, position: .bottom)
        }
    }

    // MARK: - Public

    // MARK: - Private

    // MARK: - Protocol

    // MARK: - UI

    func setupUI() {
        title = "List"

        productList = CommonList<Product, ProductCell>(frame: .zero)
        productList.items = FakeData.createProducts()
        productList.delegate = self
        view.addSubview(productList)
    }

    // MARK: - Constraints

    func setupConstraints() {
        productList.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - 懒加载
}

/*
 struct Grade : Codable {
      var id : Int
      var name : String
      var stus : [Student]
  }

  struct Student : Codable {
      var id : Int
      var name : String
      var age : Int
  }

  // 1.对象转JSON字符串
 let encoder = JSONEncoder()
 do {
     let data = try encoder.encode(student)
     let jsonStr = String(data: data, encoding: .utf8)!
     return jsonStr
 } catch {
     yxc_debugPrint("getParams failed: \(error)")
 }

  // 2.Json 字符串转对象
  let jsonData = tResponse.data.data(using: .utf8)!
  let decoder = JSONDecoder()

  do {
       let grade = try decoder.decode(Grade.self, from: jsonData)
  } catch {
      yxc_debugPrint("JSONDecoder failed: \(error)")
  }
 */
