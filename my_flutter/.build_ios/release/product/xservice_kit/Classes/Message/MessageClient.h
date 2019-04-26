//
//  MessageClient.h
//
//  Created by Jidong Chen on 2018/9/3.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,MCMessageStreamEvent){
    MCMessageStreamEventOnListen = 0,
    MCMessageStreamEventOnCancel,
};

@protocol MCMessage;

@protocol MCHost
@required
- (NSString *)hostName;
- (NSDictionary *)params;
@end

typedef void (^MCMessageResult)(id result);
typedef void (^MCStreamEventSink)(id result);
typedef void (^MCConnectionResult)(id result);
typedef void (^MCMessageHandler)(id<MCMessage>msg , MCMessageResult);
typedef void (^MCStreamHandler)(id<MCHost> host,
                                MCMessageStreamEvent event ,
                                id arguments,
                                MCStreamEventSink sink);
typedef void (^MCEventSink)(id result);


@protocol MCEventSource
@required
- (void)didRecieveEventSink:(MCEventSink *)eventSink;
- (void)didCancleEvent;
- (id<MCHost>)host;
@end


@protocol MCMessage <NSObject>
@required
- (NSString *)name;
- (NSDictionary *)params;
- (id<MCHost>)host;
@end

@protocol MessageClient <NSObject>
@required
- (void)send:(id<MCMessage>)msg result:(MCMessageResult)result;
- (void)listenMessageOn:(id<MCHost>)host handler:(MCMessageHandler)handler;
- (void)listenStreamOn:(id<MCHost>)host handler:(MCStreamHandler)handler;
- (void)connectToHost:(id<MCHost>)host result:(MCConnectionResult)result;
- (NSArray<MCHost> *)availableHosts;
@end


@protocol MessageClientFactory <NSObject>
@required
- (id<MCHost>)makeHostWithName:(NSString *)name;
- (id<MCHost>)makeHostWithName:(NSString *)name params:(NSDictionary *)params;
- (id<MCMessage>)makeMessageWithName:(NSString *)name
                              params:(NSDictionary *)params
                                host:(id<MCHost>)host;
- (id<MessageClient>)makeMessageClient;
@end
