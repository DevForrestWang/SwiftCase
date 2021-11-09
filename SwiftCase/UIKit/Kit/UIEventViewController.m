//
//===--- UIEventViewController.m - Defines the UIEventViewController class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/11/4.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//
    

#import "UIEventViewController.h"
#import <SwiftCase-Swift.h>

@interface UIEventViewController ()<SCUIEventViewVCDelegate>

@end

@implementation UIEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void) setupUI {
    self.title = @"UI Event";
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIButton *closureBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 80, 200, 40)];
    closureBtn.backgroundColor = UIColor.orangeColor;
    [closureBtn setTitle:@"Closure" forState: UIControlStateNormal];
    [closureBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [closureBtn addTarget:self action:@selector(closureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closureBtn];
    
    UIButton *delegateBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 150, 200, 40)];
    delegateBtn.backgroundColor = UIColor.orangeColor;
    [delegateBtn setTitle:@"Delegate" forState:UIControlStateNormal];
    [delegateBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [delegateBtn addTarget:self action:@selector(delegateAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delegateBtn];
}

- (void) closureAction {
    SCUIEventViewVC *vc = [SCUIEventViewVC new];
    [vc closureTest:^{
        NSLog(@"Run OC closure method.");
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) delegateAction {
    NSLog(@"delegate");
    SCUIEventViewVC *vc = [SCUIEventViewVC new];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SCUIEventViewVCDelegate
- (void) delecageMethod {
    NSLog(@"Run OC delegate method");
}

@end
