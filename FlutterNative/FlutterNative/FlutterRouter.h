//
//  FlutterRouter.h
//  FlutterNative
//
//  Created by 崔冰smile on 2019/4/16.
//  Copyright © 2019 Ziwutong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <flutter_boost/FLBPlatform.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlutterRouter : NSObject<FLBPlatform>

@property (nonatomic, strong) UINavigationController *navigationController;

+ (FlutterRouter *)sharedRouter;

@end

NS_ASSUME_NONNULL_END
