//
//  FlutterMessageClient.m
//
//  Created by Jidong Chen on 2018/9/3.
//

#import "FlutterMessageClient.h"
#import "FlutterMessageFactory.h"

@interface FlutterMessageClient()
@property (nonatomic,strong) id<MessageClientFactory> mcFactory;
@end

@implementation FlutterMessageHost
- (NSString *)hostName
{
    return _channelName;
}
- (NSDictionary *)params
{
    return _channelParams;
}
@end

@implementation FlutterMessage

- (NSString *)name
{
    return _msgName;
}

- (NSDictionary *)params
{
    return _msgParams;
}

- (id<MCHost>)host
{
    return _msgHost;
}

@end


@implementation FlutterMessageClient

- (id<MessageClientFactory>)mcFactory
{
    if (!_mcFactory) {
        _mcFactory = [FlutterMessageFactory new];
    }
    
    return _mcFactory;
}


- (void)send:(id<MCMessage>)msg result:(MCMessageResult)result
{
    if (msg) {
        [_channelManager invoke:msg.name
                      arguments:msg.params
                  methodChannel:msg.host.hostName
                         result:result];
    }
}

- (void)listenMessageOn:(id<MCHost>)host handler:(MCMessageHandler)handler
{
    if (host && handler) {
        __weak typeof(self) weakSelf = self;
        [self.channelManager setMessagerCallHandler:^(FlutterMethodCall * _Nonnull call,
                                                      FlutterResult  _Nonnull result) {
            
            id<MCMessage> msg = [weakSelf.mcFactory makeMessageWithName:call.method
                                                             params:[weakSelf removeNSNull:call.arguments]
                                                               host:host];
            handler(msg,result);
            
        } name:host.hostName];
    }
}

- (NSArray *)removeNSNullForArray:(NSArray *)arr
{
    if(arr.count < 1) return arr;
    
    NSMutableArray *checked = [NSMutableArray new];
    
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(![obj isKindOfClass: NSNull.class]){
            if([obj isKindOfClass:NSArray.class]){
                [checked addObject:[self removeNSNullForArray:obj]];
            }else if( [obj isKindOfClass: NSDictionary.class]){
                [checked addObject:[self removeNSNull:obj]];
            }else{
                 [checked addObject:obj];
            }
        }
    }];

    return checked;
}

- (NSDictionary *)removeNSNull:(NSDictionary *)params
{
    if(params.count < 1) return params;
    
    NSMutableDictionary *checked = [NSMutableDictionary new];
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key,
                                                id  _Nonnull obj,
                                                BOOL * _Nonnull stop) {
        if(![obj isKindOfClass: NSNull.class]){
            if([obj isKindOfClass:NSArray.class]){
                checked[key] = [self removeNSNullForArray:obj];
            }else if( [obj isKindOfClass: NSDictionary.class]){
                checked[key] = [self removeNSNull:obj];
            }else{
                checked[key] = obj;
            }
        }
    }];
    
    return checked;
}

- (void)listenStreamOn:(id<MCHost>)host handler:(MCStreamHandler)handler
{
    if (host && handler) {
        [self.channelManager setEventStreamOnListenHandler:^(id arguments, FlutterEventSink eventSink) {
            handler(host,MCMessageStreamEventOnListen,arguments,eventSink);
        } onCancel:^(id arguments) {
            handler(host,MCMessageStreamEventOnCancel,arguments,nil);
        } name:host.hostName];
    }
}

- (void)connectToHost:(id<MCHost>)host result:(MCConnectionResult)result
{
    if (!host) {
        return;
    }
    
    if ([host.params[@"type"] isEqual:@"method"]) {
        [self.channelManager registerMethodChannel:host.hostName];
        if (result) {
            result(nil);
        }
    }else if([host.params[@"type"] isEqual:@"event"]){
        [self.channelManager registerEventChannel:host.hostName];
        if (result) {
            result(nil);
        }
    }
    
    NSLog(@"error host!");
}

- (NSArray<MCHost> *)availableHosts
{
    NSMutableArray *hosts = [NSMutableArray new];
    NSArray *mChannels = [self.channelManager availableMethodChannels];
    NSArray *eChannels = [self.channelManager availableEventChannels];
    for(NSString *c in mChannels){
        [hosts addObject:[self.mcFactory makeHostWithName:c params:@{@"type":@"method"}]];
    }
    
    for(NSString *c in eChannels){
        [hosts addObject:[self.mcFactory makeHostWithName:c params:@{@"type":@"event"}]];
    }
    
    return (id)hosts;
}

@end
