//
//  AppDelegate.m
//  HanvonInput
//
//  Created by hanvon on 2017/11/3.
//  Copyright © 2017年 hanvon. All rights reserved.
//

#import "AppDelegate.h"
#import "GZGuideViewController.h"
#import "GZHomeViewController.h"
#import "GZRootNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

//ipad 禁止横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

//进入动画？
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    return YES;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIColor * tintColor = [UIColor colorWithRed:29.0/255.0 green:173.0/255.0 blue:234.0/255.0 alpha:1.0];
    [self.window setTintColor:tintColor];

    //跳转页面
    [self createRootController];

    [self.window makeKeyAndVisible];
    return YES;
}


#pragma mark -- 跳转根页面
- (void)createRootController {
    GZHomeViewController *root = [[GZHomeViewController alloc] init];
    GZRootNavigationController *rnvc = [[GZRootNavigationController alloc] initWithRootViewController:root];
    self.window.rootViewController = rnvc;
}



#pragma mark -- 区分进入app跳转至
//9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"url_new=%@", url);
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"url_old=%@", url);
    return YES;
}
//识别需要跳转的页面
- (void)recognizeWithURL:(NSString*)url {

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
