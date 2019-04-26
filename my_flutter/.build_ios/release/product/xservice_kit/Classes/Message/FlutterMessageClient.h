//
//  FlutterMessageClient.h
//
//  Created by Jidong Chen on 2018/9/3.
//

#import <Foundation/Foundation.h>
#import "MessageClient.h"
#import "FlutterChannelManager.h"

#define kFlutterMessageHostTypeMethod @"method"
#define kFlutterMessageHostTypeEvent @"event"

@interface MCFlutterEventSource<MCEventSource>
@end

@interface FlutterMessageHost : NSObject<MCHost>
@property (nonatomic,copy) NSString *channelName;
@property (nonatomic,strong) NSDictionary *channelParams;
@end

@interface FlutterMessage : NSObject<MCMessage>
@property (nonatomic,copy) NSString *msgName;
@property (nonatomic,strong) NSDictionary *msgParams;
@property (nonatomic,strong) id<MCHost> msgHost;

@end

@interface FlutterMessageClient : NSObject<MessageClient>

@property (nonatomic,strong) FlutterChannelManager *channelManager;

@end
