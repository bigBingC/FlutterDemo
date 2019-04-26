//
//  MCService.h
//
//  Created by Jidong Chen on 2018/9/6.
//

#import <Foundation/Foundation.h>
#import "MessageDispatcher.h"

@protocol FlutterServiceEventListner <NSObject>
@required
- (void)onEvent:(NSString *)event params:(NSString *)params;
@end

@protocol FlutterNativeService <NSObject>
@required
- (NSString *)serviceName;
- (NSString *)methodChannelName;
- (NSString *)eventChannelName;

- (void)invoke:(NSString *)name args:(NSDictionary *)args result:(MCMessageResult)result;
- (void)registerHandler:(id<MessageHandler>)handler;

#pragma mark - broadcast event support.
- (void)emitEvent:(NSString *)event params:(NSDictionary *)params;
- (void)addListener:(id<FlutterServiceEventListner>)listner forEvent:(NSString *)name;
- (void)removeListener:(id<FlutterServiceEventListner>)listner forEvent:(NSString *)name;
- (void)emitEvent:(NSDictionary *)obj;

- (void)didRecieveEventSink:(void (^)(id))eventSink arguments:(id)arguments;
- (void)didCancleEvent:(id)arguments;
#pragma mark - status control
- (void)start;
- (void)end;
@end
