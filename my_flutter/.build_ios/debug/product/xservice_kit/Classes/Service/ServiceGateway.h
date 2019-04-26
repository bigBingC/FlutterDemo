//
//  ServiceComposer.h
//
//  Created by Jidong Chen on 2018/9/6.
//

#import <Foundation/Foundation.h>
#import <xservice_kit/FlutterNativeService.h>

@interface ServiceGateway : NSObject

+ (instancetype)sharedInstance;

- (void)registerHandler:(id<MessageHandler>)handler;
- (void)addService:(id<FlutterNativeService>)service;
- (void)removeService:(id<FlutterNativeService>)service;

@end
