//
//  AppDelegate.m
//  FlutterNative
//
//  Created by 崔冰smile on 2019/4/12.
//  Copyright © 2019 Ziwutong. All rights reserved.
//

#import "AppDelegate.h"
#import "FlutterRouter.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    ViewController *viewController = [[ViewController alloc] init];

    FLBFlutterViewContainer *fvc = FLBFlutterViewContainer.new;
    [fvc setName:@"tab" params:@{}];
    fvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"flutter_tab" image:nil tag:1];
    
    UINavigationController *rvc = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    FlutterRouter *router = [FlutterRouter sharedRouter];
    router.navigationController = rvc;
    
    [FlutterBoostPlugin.sharedInstance startFlutterWithPlatform:router
                                                        onStart:^(FlutterViewController *fvc) {
                                                            
                                                        }];
    
    
    self.window.rootViewController = rvc;

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
