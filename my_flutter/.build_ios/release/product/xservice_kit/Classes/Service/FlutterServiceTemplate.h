//
//  FlutterServiceTemplate.h
//
//  Created by Jidong Chen on 2018/9/6.
//

#import <Foundation/Foundation.h>
#import "FlutterNativeService.h"

@interface FlutterServiceTemplate : NSObject<FlutterNativeService>

@property (nonatomic,copy) NSString *name;

- (instancetype)initWithName:(NSString *)name;

@end
