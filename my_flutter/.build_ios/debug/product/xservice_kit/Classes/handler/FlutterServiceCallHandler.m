//
//  FlutterServiceCallHandler.m
//
//  Created by Jidong Chen on 2018/6/20.
//

#import "FlutterServiceCallHandler.h"

#import <objc/runtime.h>

@interface FlutterServiceCallHandler(){
    __weak id _context;
}
@property (nonatomic,strong) NSMutableDictionary *callHandlers;
@property (nonatomic,strong) NSMutableArray *methodNames;
@end

@implementation FlutterServiceCallHandler

- (instancetype)init{
    if (self = [super init]) {
        _callHandlers = [NSMutableDictionary new];
        _methodNames = NSMutableArray.new;
        [self registerHandlers];
    }
    return self;
}

- (void)registerHandlers
{
    unsigned int mc = 0;
    Method * mlist = class_copyMethodList(object_getClass(self), &mc);
    NSLog(@"%d methods", mc);
    for(int i=0;i<mc;i++){
        NSString *name = [NSString stringWithUTF8String:sel_getName(method_getName(mlist[i]))];
        if ([name hasPrefix:Flutter_Plugin_Handler_Name_Prefix_Str]) {
            [self bindMethodName:NSSelectorFromString(name)];
            NSRange aRange = [name rangeOfString:Flutter_Plugin_Handler_Name_Prefix_Str];
            NSRange bRange = [name rangeOfString:@":"];
            NSUInteger loc = aRange.location + aRange.length;
            NSUInteger len = bRange.location - loc;
            NSString *callName = [name substringWithRange:NSMakeRange(loc,len)];
            [self.methodNames addObject:callName];
        }
    }
    
    //需要手动释放内存
    if (mlist != NULL) {
        free(mlist);
    }
}

#pragma mark - method handling logic.
//Farward this msg to old entry.
- (BOOL)handle:(id<MCMessage>)msg result:(MCMessageResult)result
{
    return [self handleMethodCall:msg.name args:msg.params result:result];
}

- (NSArray *)handledMessageNames
{
    return _methodNames;
}

- (bool)handleMethodCall:(NSString*)call
                    args:(NSDictionary *)args
                  result:(SendResult)result
{
    void (^handler)(NSDictionary *,SendResult) = [self findHandler:call];
    if (handler) {
        handler(args,result);
        return YES;
    }
    
    return NO;
}

- (id)findHandler:(NSString *)call
{
    NSString *selName = [NSString stringWithFormat:@"%@%@:result:",Flutter_Plugin_Handler_Name_Prefix_Str,call];
    return _callHandlers[selName];
}

- (void)bindMethodName:(SEL)method
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    if (_callHandlers[NSStringFromSelector(method)]) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    _callHandlers[NSStringFromSelector(method)] = ^(NSDictionary *args,SendResult result){
        id resultBlock = [weakSelf getHanlderBlockForType:weakSelf.returnType result:result];
        if (resultBlock && result) {
            [weakSelf performSelector:method withObject:args withObject:resultBlock];
        }else{
#if DEBUG
            [NSException raise:@"invalid call" format:@"missing handler and result!"];
#endif
        }
    };
#pragma clang diagnostic pop
}

- (id)getHanlderBlockForType:(NSString *)type result:(SendResult)result
{
    if ([type isEqual:@"int64_t"]) {
        return ^(int64_t value){
            result(@(value));
        };
    }
    
    if ([type isEqual:@"double"]) {
        return ^(double value){
            result(@(value));
        };
    }
    
    if ([type isEqual:@"BOOL"]) {
        return ^(BOOL value){
            result(@(value));
        };
    }
    
    if ([type hasPrefix:@"NSString"]) {
        return ^(NSString *value){
            if ([value isKindOfClass:NSNumber.class]) {
#if DEBUG
                [NSException raise:@"invalid type" format:@"require NSString!"];
#endif
                value = ((NSNumber *)value).stringValue;
            }
            result(value);
        };
    }
    
    if ([type hasPrefix:@"NSArray"]) {
        return ^(NSArray *value){
            result(value);
        };
    }
    
    if ([type hasPrefix:@"NSDictionary"]) {
        return ^(NSDictionary *value){
            result(value);
        };
    }
    
    if ([type isEqual:@"id"]) {
        return result;
    }

    /*
     @"int":@"int64_t",
     @"double":@"double",
     @"bool":@"BOOL",
     @"String":@"NSString *",
     
     */
    
    return nil;
}


- (id)context
{
    return _context;
}

- (void)setContext:(id)context
{
    _context = context;
}

- (NSString *)returnType
{
    return @"id";
}

- (NSString *)service
{
    return @"root";
}

- (id)nonNSNullValue:(id)value
{
    if([value isKindOfClass: NSNull.class]){
        return nil;
    }else{
        return value;
    }
}

@end
