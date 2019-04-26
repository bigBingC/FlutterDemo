//
//  FlutterChannelsManager.h
//
//  Created by Jidong Chen on 2018/9/3.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>


typedef void (^FlutterStreamOnListenHandler)(id arguments,FlutterEventSink);
typedef void (^FlutterStreamOnCancelHandler)(id arguments);

@interface FlutterChannelManager : NSObject

@property (nonatomic,weak,readonly) id<FlutterBinaryMessenger> messenger;
@property (nonatomic,strong,readonly) NSDictionary *config;

- (instancetype)initWithDefaultConfigMessenger:(id<FlutterBinaryMessenger>)messenger;

- (instancetype)initWithConfig:(NSDictionary *)config
                     messenger:(id<FlutterBinaryMessenger>)messenger;

- (NSError *)invoke:(NSString *)name
          arguments:(NSDictionary *)arguments
      methodChannel:(NSString *)channelName
             result:(FlutterResult)result;


- (NSError *)setEventStreamOnListenHandler:(FlutterStreamOnListenHandler)onListenHandler
                                  onCancel:(FlutterStreamOnCancelHandler)onCancel
                                      name:(NSString *)eventName;

- (NSError *)setMessagerCallHandler:(FlutterMethodCallHandler)handler
                               name:(NSString *)name;

- (NSError *)registerMethodChannel:(NSString *)name;

- (NSError *)registerEventChannel:(NSString *)name;

- (NSArray *)availableMethodChannels;

- (NSArray *)availableEventChannels;

@end
