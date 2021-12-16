//
//  GlobalConstants.swift
//  TIUpDownSwipe
//
//  Created by Tomasz Iwaszek on 2/12/19.
//  Copyright © 2019 wachus77. All rights reserved.
//
import UIKit

enum IphoneType {
    case XorXs, XsMax, Xr, other
}

var iphoneType: IphoneType {
    if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
        case 2436:
            return .XorXs
        case 2688:
            return .XsMax
        case 1792:
            return .Xr
        default:
            return .other
        }
    }
    return .other
}

let screenHeight = UIScreen.main.bounds.size.height
let screenWidth = UIScreen.main.bounds.size.width
