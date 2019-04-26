//
//  FlutterRouter.m
//  FlutterNative
//
//  Created by 崔冰smile on 2019/4/16.
//  Copyright © 2019 Ziwutong. All rights reserved.
//

#import "FlutterRouter.h"
#import <flutter_boost/FlutterBoost.h>

@implementation FlutterRouter

+ (FlutterRouter *)sharedRouter {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)openPage:(NSString *)name
          params:(NSDictionary *)params
        animated:(BOOL)animated
      completion:(void (^)(BOOL))completion {
    if([params[@"present"] boolValue]) {
        FLBFlutterViewContainer *vc = FLBFlutterViewContainer.new;
        [vc setName:name params:params];
        [self.navigationController presentViewController:vc animated:animated completion:^{}];
    } else {
        FLBFlutterViewContainer *vc = FLBFlutterViewContainer.new;
        [vc setName:name params:params];
        [self.navigationController pushViewController:vc animated:animated];
    }
}

- (void)closePage:(NSString *)uid animated:(BOOL)animated params:(NSDictionary *)params completion:(void (^)(BOOL))completion {
    FLBFlutterViewContainer *vc = (id)self.navigationController.presentedViewController;
    if ([vc isKindOfClass:FLBFlutterViewContainer.class] && [vc.uniqueIDString isEqual: uid]) {
        [vc dismissViewControllerAnimated:animated completion:^{}];
    } else {
        [self.navigationController popViewControllerAnimated:animated];
    }
}
@end
