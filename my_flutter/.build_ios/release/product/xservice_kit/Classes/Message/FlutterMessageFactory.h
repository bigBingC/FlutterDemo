//
//  FlutterMessageFactory.h
//
//  Created by Jidong Chen on 2018/9/3.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

#import "MessageClient.h"

@interface FlutterMessageFactory : NSObject<MessageClientFactory>

@property (nonatomic,weak) id<FlutterBinaryMessenger> messenger;


@end
