//
//  FlutterServiceCallHandler.h
//
//  Created by Jidong Chen on 2018/6/20.
//

#import <Foundation/Foundation.h>

#import "MessageDispatcher.h"
typedef void (^SendResult)(NSObject *result);

/*Helper maros*/
#define Flutter_Plugin_Handler_Name_Prefix_Str @"__flutter_p_handler_"
#define Flutter_Plugin_Concat(_a_,_b_) _a_ ## _b_
#define Flutter_Plugin_Handler_Name(_call_) Flutter_Plugin_Concat(__flutter_p_handler_,_call_)

#define Flutter_Plugin_Handler(_methodname_,_args_,_result_) \
-(void)Flutter_Plugin_Handler_Name(_methodname_):(NSDictionary *)_args_ result:(SendResult)_result_

#define Flutter_Plugin_Handler_ResultType(_methodname_,_args_,_result_,_type_) \
-(void)Flutter_Plugin_Handler_Name(_methodname_):(NSDictionary *)_args_ typedResult:(void (^)(_type_))_result_

#define no_NSNull(_v_)    [self nonNSNullValue: _v_]


@interface FlutterServiceCallHandler : NSObject<MessageHandler>

- (NSString *)returnType;

- (id)nonNSNullValue:(id)value;

@end
