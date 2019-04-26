//
//  MessageDispatcher.h
//
//  Created by Jidong Chen on 2018/9/6.
//

#import <Foundation/Foundation.h>

#import <xservice_kit/MessageClient.h>

@protocol MessageHandler <NSObject>
@required
- (BOOL)handle:(id<MCMessage>)msg result:(MCMessageResult)result;
- (id)context;
- (void)setContext:(id)context;
- (NSArray *)handledMessageNames;
- (NSString *)service;
@end


@protocol MessageDispatcher <NSObject>
@required
- (void)dispatch:(id<MCMessage>)msg result:(MCMessageResult)result;
- (void)registerHandler:(id<MessageHandler>) handler;
- (void)removeHandler:(id<MessageHandler>) handler;
- (void)removeAll;

- (id)context;
- (void)setContext:(id)context;
@end
