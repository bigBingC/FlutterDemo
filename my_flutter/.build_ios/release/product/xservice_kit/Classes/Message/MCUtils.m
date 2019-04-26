//
//  MCUtils.m
//
//  Created by Jidong Chen on 2018/9/3.
//

#import "MCUtils.h"

@implementation MCUtils

+ (void)log:(NSString *)msg
{
#if DEBUG
    NSLog(@"%@",msg);
#endif
}

+ (NSError *)errWithDesc:(NSString *)msg
{
    if (!msg) {
        return nil;
    }
#if DEBUG
    NSLog(@"%@",msg);
#endif
    return [NSError errorWithDomain:@"FlutterMessageBase" code:-1 userInfo:@{@"reason":msg}];
}

@end
