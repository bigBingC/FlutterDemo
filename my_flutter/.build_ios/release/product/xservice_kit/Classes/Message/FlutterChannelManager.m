//
//  FlutterChannelsManager.m
//
//  Created by Jidong Chen on 2018/9/3.
//

#import "FlutterChannelManager.h"
#import "MCUtils.h"

@interface FlutterEventChannelHandler : NSObject<FlutterStreamHandler>
@property (nonatomic,weak) FlutterEventChannel *eventChannel;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) void (^onListenBlock)(NSString *,id,FlutterEventSink);
@property (nonatomic,copy) void (^onCancelBlock)(NSString *,id);
@end
@implementation FlutterEventChannelHandler

- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events
{
    if (_onListenBlock) {
        _onListenBlock(_name,arguments,events);
    }
    
    return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments
{
    if (_onCancelBlock) {
        _onCancelBlock(_name,arguments);
    }
    
    return nil;
}

@end

@interface FlutterChannelManager()
@property (nonatomic,strong) NSDictionary *config;
@property (nonatomic,weak) id<FlutterBinaryMessenger> messenger;

@property (nonatomic,strong) NSMutableDictionary *methodCallHandlers;
@property (nonatomic,strong) NSMutableDictionary *onListenHandlers;
@property (nonatomic,strong) NSMutableDictionary *onCancelHandlers;

@property (nonatomic,strong) NSMutableDictionary *methodChannels;
@property (nonatomic,strong) NSMutableDictionary *eventChannels;

@end

@implementation FlutterChannelManager

- (instancetype)initWithDefaultConfigMessenger:(id<FlutterBinaryMessenger>)messenger
{
    return [self initWithConfig:[self.class defaultConfig] messenger:messenger];
}

+ (NSDictionary *)defaultConfig
{
    return @{};
}

- (instancetype)initWithConfig:(NSDictionary *)config
                     messenger:(id<FlutterBinaryMessenger>)messenger
{
    if (self = [super init]) {
        _messenger = messenger;
        _config = config;
        _methodCallHandlers = [NSMutableDictionary new];
        _onListenHandlers = [NSMutableDictionary new];
        _onCancelHandlers = [NSMutableDictionary new];
        _methodChannels = [NSMutableDictionary new];
        _eventChannels = [NSMutableDictionary new];
    }
    
    return self;
}


- (void)addMethodChannelWithName:(NSString *)name
{
    if (_methodChannels[name]) {
        return;
    }
    FlutterMethodChannel *mChannel = [FlutterMethodChannel methodChannelWithName:name binaryMessenger:_messenger];
    _methodChannels[name] = mChannel;
}

- (void)addEventChannelWithName:(NSString *)name
{
    if (_eventChannels[name]) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    FlutterEventChannel *eChannel = [FlutterEventChannel eventChannelWithName:name binaryMessenger:_messenger];
    FlutterEventChannelHandler *handler = [FlutterEventChannelHandler new];
    handler.onListenBlock = ^(NSString *name,id params,FlutterEventSink sink){
        FlutterStreamOnListenHandler block = weakSelf.onListenHandlers[name];
        if (block) {
            block(params,sink);
        }
    };
    
    handler.onCancelBlock = ^(NSString *name,id params){
        FlutterStreamOnCancelHandler block = weakSelf.onCancelHandlers[name];
        if (block) {
            block(params);
        }
    };
    handler.eventChannel = eChannel;
    handler.name = name;
    [eChannel setStreamHandler:handler];
    _eventChannels[name] = eChannel;
}

- (NSError *)invoke:(NSString *)name
     arguments:(NSDictionary *)arguments
 methodChannel:(NSString *)channelName
             result:(FlutterResult)result
{
    if (name && channelName) {
        FlutterMethodChannel *channel = [self methodChannelForName:channelName];
        if (channel) {
            [channel invokeMethod:name arguments:arguments result:result];
            return nil;
        }else{
            return [MCUtils errWithDesc:@"no such channel!"];
        }
    }else{
        return [MCUtils errWithDesc:@"invalid arguments!"];
    }
}


- (FlutterMethodChannel *)methodChannelForName:(NSString *)name
{
    if(name){
        return _methodChannels[name];
    }
    
    return nil;
}

- (FlutterEventChannel *)eventChannelForName:(NSString *)name
{
    if (name) {
        return _eventChannels[name];
    }
    
    return nil;
}

- (NSError *)setEventStreamOnListenHandler:(FlutterStreamOnListenHandler)onListenHandler
                             onCancel:(FlutterStreamOnCancelHandler)onCancel
                                 name:(NSString *)eventName
{
    if (eventName) {
        _onListenHandlers[eventName] = onListenHandler;
        _onCancelHandlers[eventName] = onCancel;
        return nil;
    }else{
        return [MCUtils errWithDesc:@"nil event channel key"];
    }
}

- (NSError *)setMessagerCallHandler:(FlutterMethodCallHandler)handler
                          name:(NSString *)name
{
    FlutterMethodChannel *channel = [self methodChannelForName:name];
    if (channel) {
        [channel setMethodCallHandler:handler];
        _methodCallHandlers[name] = handler;
        return nil;
    }else{
        return [MCUtils errWithDesc:@"nil method channel key"];
    }
}

- (NSError *)registerEventChannel:(NSString *)name
{
    if (name) {
        if (!_eventChannels[name]) {
            [self addEventChannelWithName:name];
            return nil;
        }else{
            return [MCUtils errWithDesc:@"channel already exists."];
        }
    }else{
        return [MCUtils errWithDesc:@"nil event channel key"];
    }
}

- (NSError *)registerMethodChannel:(NSString *)name
{
    if (name) {
        if (!_methodChannels[name]) {
            [self addMethodChannelWithName:name];
            return nil;
        }else{
            return [MCUtils errWithDesc:@"channel already exists."];
        }
    }else{
        return [MCUtils errWithDesc:@"nil method channel key"];
    }
    
}

- (NSArray *)availableMethodChannels
{
    return _methodChannels.allKeys;
}

- (NSArray *)availableEventChannels
{
    return _eventChannels.allKeys;
}


@end
