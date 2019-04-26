//
//  FlutterMessageFactory.m
//
//  Created by Jidong Chen on 2018/9/3.
//

#import "FlutterMessageFactory.h"
#import "FlutterMessageClient.h"

@implementation FlutterMessageFactory

- (id<MessageClient>)makeMessageClient
{
    return [self p_makeMessageClient:_messenger];
}

- (id<MessageClient>)p_makeMessageClient:(id<FlutterBinaryMessenger>)messenger
{
    FlutterMessageClient *client = FlutterMessageClient.new;
    client.channelManager = [[FlutterChannelManager alloc] initWithDefaultConfigMessenger:messenger];
    return client;
}

- (id<MCHost>)makeHostWithName:(NSString *)name
{
    return [self makeHostWithName:name params:nil];
}

- (id<MCHost>)makeHostWithName:(NSString *)name params:(NSDictionary *)params
{
    FlutterMessageHost *host = FlutterMessageHost.new;
    host.channelName = name;
    host.channelParams = params;
    return host;
}

- (id<MCMessage>)makeMessageWithName:(NSString *)name
                              params:(NSDictionary *)params
                                host:(id<MCHost>)host;
{
    FlutterMessage *msg = FlutterMessage.new;
    msg.msgName = name;
    msg.msgParams = params;
    msg.msgHost = host;
    return msg;
}


@end
