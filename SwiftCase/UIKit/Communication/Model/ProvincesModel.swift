//
//===--- ProvincesModel.swift - Defines the ProvincesModel class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by applem1 on 2023/5/4.
// Copyright © 2023 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

/*
 请求返回的JSON格式
 // json 工具： https://app.quicktype.io/
 // https://www.vfun.fun/pages/tools-page/JsonToFile/index.html

 "data" : [
   {
     "citys" : [
       {
         "cityNameCn" : "北京市",
         "cityNo" : "110000",
         "cityFullName" : "中国-北京",
         "delFlag" : 0,
         "population" : 0,
         "postCode" : "",
         "countryNo" : "156",
         "version" : 1,
         "phonePrefix" : "",
         "provinceNo" : "11",
         "cityName" : "北京市"
       }
     ],
     "province" : {
       "delFlag" : 0,
       "provinceNameCn" : "北京市",
       "countryNo" : "156",
       "version" : 1,
       "directedCity" : 1,
       "provinceName" : "北京",
       "provinceNo" : "11"
     }
   }
 ]
 */

import UIKit

/// 城市的数据模型
struct CityItemModel: AFBaseModel {
    var cityNameCn: String?
    var cityNo: String?
    var cityFullName: String?
    var delFlag: String?
    var population: String?
    var postCode: String?
    var countryNo: String?
    var version: String?
    var phonePrefix: String?
    var provinceNo: String?
    var cityName: String?
}

/// 省份数据模型
struct ProvinceItemModel: AFBaseModel {
    var delFlag: String?
    var provinceNameCn: String?
    var countryNo: String?
    var version: String?
    var directedCity: String?
    var provinceName: String?
    var provinceNo: String?
}

/// 省份、城市数据模型
struct ProvincesModel: AFBaseModel {
    var province: ProvinceItemModel?

    var citys: [CityItemModel]?
}
