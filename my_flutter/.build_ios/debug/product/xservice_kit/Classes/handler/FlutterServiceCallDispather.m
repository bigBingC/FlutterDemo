//
//  FlutterServiceCallDispather.m
//
//  Created by Jidong Chen on 2018/9/6.
//

#import "FlutterServiceCallDispather.h"

@interface FlutterServiceCallDispather(){
    __weak id _context;
}
@property (nonatomic,strong) NSMutableDictionary *handlerMap;
@property (nonatomic,strong) NSMutableArray *hanlderOldSchool;//For those hanledMessageNames is not well implemented
@end

@implementation FlutterServiceCallDispather

- (instancetype)init
{
    if (self = [super init]) {
        _handlerMap = NSMutableDictionary.new;
        _hanlderOldSchool = NSMutableArray.new;
    }
    
    return self;
}

- (void)dispatch:(id<MCMessage>)msg result:(MCMessageResult)result
{
    if (msg) {
        id<MessageHandler> handler = _handlerMap[msg.name];
        if (![handler handle:msg result:result]) {
            
            for(id<MessageHandler> oHandler in self.hanlderOldSchool){
                if ([oHandler handle:msg result:result]) {
                    return;
                }
            }
            
            //TODO:log unhandled message
        }
    }else{
        //TODO:log unhandled message
    }
}

- (void)registerHandler:(id<MessageHandler>)handler
{
    if(!handler) return;
    
    [handler setContext:self.context];
    
    NSArray *methods = handler.handledMessageNames;
    for(NSString *name in methods){
        if(_handlerMap[name]){
            NSAssert(NO, @"Conflicted method call name results in undefined error!");
        }else{
            _handlerMap[name] = handler;
        }
    }
    
    //For those hanledMessageNames is not well implemented
    if (methods.count < 1) {
        [self.hanlderOldSchool addObject:handler];
    }
    
}

- (void)removeHandler:(id<MessageHandler>)handler
{
    NSArray *methods = handler.handledMessageNames;
    [_handlerMap removeObjectsForKeys:methods];
}

- (void)removeAll
{
    [_handlerMap removeAllObjects];
}

- (id)context
{
    return _context;
}

- (void)setContext:(id)context
{
    _context = context;
}


@end
