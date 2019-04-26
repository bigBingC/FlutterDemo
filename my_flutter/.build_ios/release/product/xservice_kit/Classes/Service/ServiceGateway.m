//
//  ServiceComposer.m
//
//  Created by Jidong Chen on 2018/9/6.
//

#import "ServiceGateway.h"

@interface ServiceGateway()
@property (nonatomic,strong) NSMutableDictionary<FlutterNativeService> *services;
@property (nonatomic,strong) NSMutableDictionary *pendingHandlers;
@end

@implementation ServiceGateway

//A possible place to start servics.

+ (instancetype)sharedInstance
{
    static ServiceGateway *sInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[self alloc] init];
        sInstance.services = (id)[NSMutableDictionary new];
        sInstance.pendingHandlers = [NSMutableDictionary new];
    });
    
    return sInstance;
}

- (void)addService:(id<FlutterNativeService>)service
{
    if (service.serviceName) {
        self.services[service.serviceName] = service;
        [service start];
        NSArray *hs = [self findHandlers:service];
        for(id<MessageHandler> h in hs){
            [service registerHandler:h];
        }
    }else{
        NSAssert(NO, @"nil service name not allowed!");
    }
}

- (void)insertHandler:(id<MessageHandler>)handler
{
    NSMutableArray *hs = self.pendingHandlers[handler.service];
    if(!hs){
        hs = [NSMutableArray new];
        self.pendingHandlers[handler.service] = hs;
    }
    
     [hs addObject:handler];
}

- (NSArray *)findHandlers:(id<FlutterNativeService>)service
{
    return self.pendingHandlers[service.serviceName];
}

- (void)registerHandler:(id<MessageHandler>)handler
{
    id<FlutterNativeService> service = self.services[handler.service];
    if (service) {
        [service registerHandler:handler];
    }else{
        [self insertHandler:handler];
    }
}

- (void)removeService:(id<FlutterNativeService>)service
{
    if (service.serviceName) {
        id<FlutterNativeService> svr = self.services[service.serviceName];
        [svr end];
        self.services[service.serviceName] = nil;
    }
}


@end
