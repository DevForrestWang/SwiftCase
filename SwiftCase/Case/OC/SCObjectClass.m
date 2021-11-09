//
//===--- SCObjectClass.m - Defines the SCObjectClass class ----------===//
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

#import "SCObjectClass.h"
#import <SwiftCase-Swift.h>

@implementation SCObjectClass

-(void)sayHello{
    // OC 调用swift对象
    SwiftObj *swiftObj = [[SwiftObj alloc] init];
    [swiftObj sayhello];
}

@end
