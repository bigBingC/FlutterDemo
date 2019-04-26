//
//  ViewController.m
//  FlutterNative
//
//  Created by 崔冰smile on 2019/4/12.
//  Copyright © 2019 Ziwutong. All rights reserved.
//

#import "ViewController.h"
#import <Flutter/Flutter.h>
#import "FlutterRouter.h"
#import "Masonry.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createBaseView];
}

- (void)createBaseView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"原生页面";
    
    UIButton *btnFlutter = [[UIButton alloc] init];
    [btnFlutter setTitle:@"跳转flutter页面" forState:UIControlStateNormal];
    [btnFlutter setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btnFlutter addTarget:self action:@selector(gotoFlutter) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnFlutter];
    [btnFlutter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

- (void)gotoFlutter {
    [FlutterRouter.sharedRouter openPage:@"sample://firstPage" params:@{} animated:YES completion:^(BOOL f){}];
}

@end
