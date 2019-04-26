//
//  MCUtils.h
//
//  Created by Jidong Chen on 2018/9/3.
//

#import <Foundation/Foundation.h>

#define MCLog(_v_) NSLog(_v_)

@interface MCUtils : NSObject

+ (void)log:(NSString *)msg;

+ (NSError *)errWithDesc:(NSString *)msg;

@end
