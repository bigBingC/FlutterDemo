#import "XserviceKitPlugin.h"
#import "MessengerFacede.h"

@implementation XserviceKitPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"xservice_kit"
            binaryMessenger:[registrar messenger]];
  XserviceKitPlugin* instance = [[XserviceKitPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    //Set messenger.
    [[MessengerFacede sharedInstance] setMessenger:registrar.messenger];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
