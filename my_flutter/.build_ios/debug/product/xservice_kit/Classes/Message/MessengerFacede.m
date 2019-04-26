//
//  MessengerFacede.m
//
//  Created by Jidong Chen on 2018/9/4.
//

#import "MessengerFacede.h"
#import "FlutterMessageFactory.h"
#import "MCUtils.h"

@interface MessengerFacede()
@property (nonatomic,weak) id<FlutterBinaryMessenger> messenger;
@property (nonatomic,strong) id<MessageClientFactory> mcFactory;
@property (nonatomic,strong) id<MessageClient> mcClient;

@property (nonatomic,strong) NSMutableDictionary *pendingMethodChannles;
@property (nonatomic,strong) NSMutableDictionary *pendingEventChannels;
@property (nonatomic,strong) NSMutableDictionary *pendingMethodHandlers;
@property (nonatomic,strong) NSMutableDictionary *pendingEventHandlers ;
@end

@implementation MessengerFacede

+ (instancetype)sharedInstance
{
    static id sInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[self.class alloc] init];
    });
    
    return sInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _pendingMethodChannles = [NSMutableDictionary new];
        _pendingMethodHandlers = [NSMutableDictionary new];
        _pendingEventChannels = [NSMutableDictionary new];
        _pendingEventHandlers = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)setMessenger:(id<FlutterBinaryMessenger>)messenger
{
    if (_messenger != messenger) {
        _messenger = messenger;
        if (_messenger) {
            FlutterMessageFactory *fc = [FlutterMessageFactory new];
            fc.messenger = messenger;
            self.mcFactory = fc;
            self.mcClient = [self.mcFactory makeMessageClient];
            //Restore channels registered before messenger set.
            [self loadPendingChannels];
        }else{
            self.mcFactory = nil;
            self.mcClient = nil;
        }
    }
}

- (void)loadPendingChannels
{
    for(NSString *mKey in self.pendingMethodChannles){
        [self registerMethodChannelWithName:mKey
                                   callback:^(id result) {}];
        [self setMessageHandler:self.pendingMethodHandlers[mKey]
               forMethodChannel:mKey];
    }
    
    for(NSString *mKey in self.pendingEventChannels){
        [self registerEventChannelWithName:mKey
                                   callback:^(id result) {}];
        [self setStreamHandler:self.pendingEventHandlers[mKey]
               forEventChannel:mKey];
    }
    
    [self.pendingMethodChannles removeAllObjects];
    [self.pendingMethodHandlers removeAllObjects];
    [self.pendingEventChannels removeAllObjects];
    [self.pendingEventHandlers removeAllObjects];
}

- (void)sendMessage:(NSString *)name
               args:(NSDictionary *)args
            channel:(NSString *)channelName
             result:(MCMessageResult)result
{
    id<MCHost> host = [self.mcFactory makeHostWithName:channelName];
    id<MCMessage> msg = [self.mcFactory makeMessageWithName:name params:args host:host];
    [self.mcClient send:msg result:result];
}

- (NSError *)setMessageHandler:(MCMessageHandler)handler forMethodChannel:(NSString *)channelName
{
    if (handler && channelName.length > 0) {
        
        if (!self.mcClient && !self.mcFactory) {
            self.pendingMethodHandlers[channelName] = handler;
            return nil;
        }
        
        id<MCHost> host = [self.mcFactory makeHostWithName:channelName params:@{@"type":@"method"}];
        [self.mcClient listenMessageOn:host handler:handler];
        return nil;
    }else{
        return [MCUtils errWithDesc:@"invalid arguments!"];
    }
}

- (NSError *)setStreamHandler:(MCStreamHandler)handler forEventChannel:(NSString *)channelName
{
    if (handler && channelName.length > 0) {
        
        if (!self.mcClient && !self.mcFactory) {
            self.pendingEventHandlers[channelName] = handler;
            return nil;
        }
        
        id<MCHost> host = [self.mcFactory makeHostWithName:channelName params:@{@"type":@"event"}];
        [self.mcClient listenStreamOn:host handler:handler];
        return nil;
    }else{
        return [MCUtils errWithDesc:@"invalid arguments!"];
    }
}

- (NSError *)registerMethodChannelWithName:(NSString *)name callback:(MCConnectionResult)callback
{
    if (name.length > 0) {
        
        if (!self.mcClient && !self.mcFactory) {
            self.pendingMethodChannles[name] = name;
            return nil;
        }
        
        id<MCHost> host = [self.mcFactory makeHostWithName:name params:@{@"type":@"method"}];
        [self.mcClient connectToHost:host result:callback];
    }else{
        return [MCUtils errWithDesc:@"invalid arguments!"];
    }
    
    return nil;
}

- (NSError *)registerEventChannelWithName:(NSString *)name callback:(MCConnectionResult)callback
{
    if (name.length > 0) {
        if (!self.mcClient && !self.mcFactory) {
            self.pendingEventChannels[name] = name;
            return nil;
        }
        id<MCHost> host = [self.mcFactory makeHostWithName:name params:@{@"type":@"event"}];
        [self.mcClient connectToHost:host result:callback];
    }else{
        return [MCUtils errWithDesc:@"invalid arguments!"];
    }
    
    return nil;
}

- (NSArray *)availableMethodChannels
{
    NSArray *hosts = [_mcClient availableHosts];
    NSMutableArray *tmp = [NSMutableArray new];
    for(id<MCHost> h in hosts){
        if([h.params[@"type"] isEqual:@"method"]){
            [tmp addObject:h];
        }
    }
    
    return tmp;
}

- (NSArray *)availableEventChannels
{
    NSArray *hosts = [_mcClient availableHosts];
    NSMutableArray *tmp = [NSMutableArray new];
    for(id<MCHost> h in hosts){
        if([h.params[@"type"] isEqual:@"event"]){
            [tmp addObject:h];
        }
    }
    
    return tmp;
}

@end
