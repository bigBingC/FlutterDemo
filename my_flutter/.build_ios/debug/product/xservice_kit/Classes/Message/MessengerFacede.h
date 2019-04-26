//
//  MessengerFacede.h
//
//  Created by Jidong Chen on 2018/9/4.
//

#import <Foundation/Foundation.h>
#import "MessageClient.h"
#import <Flutter/Flutter.h>

@interface MessengerFacede : NSObject

@property (nonatomic,weak,readonly) id<FlutterBinaryMessenger> messenger;

+ (instancetype)sharedInstance;


- (void)setMessenger:(id<FlutterBinaryMessenger>)messenger;

- (void)sendMessage:(NSString *)name
               args:(NSDictionary *)args
            channel:(NSString *)channelName
             result:(MCMessageResult)result;

- (NSError *)setMessageHandler:(MCMessageHandler)handler forMethodChannel:(NSString *)channelName;

- (NSError *)setStreamHandler:(MCStreamHandler)handler forEventChannel:(NSString *)channelName;

- (NSError *)registerMethodChannelWithName:(NSString *)name callback:(MCConnectionResult)callback;

- (NSError *)registerEventChannelWithName:(NSString *)name callback:(MCConnectionResult)callback;

- (NSArray *)availableMethodChannels;

- (NSArray *)availableEventChannels;


@end
