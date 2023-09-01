//
//  AppDelegateOC.m
//  surveySDK-example
//
//  Created by Winston on 2023/8/31.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegateOC.h"
#import "DemoViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
//    [self.window makeKeyAndVisible];
//
//    NSMutableArray *tabItems = [[NSMutableArray alloc] initWithCapacity:2];
//
//    UIViewController *dvc = [[DemoViewController alloc] init];
//    UINavigationController *dvc_nc = [[UINavigationController alloc] initWithRootViewController:dvc];
//    dvc_nc.tabBarItem.title = @"Default";
//    [tabItems addObject:dvc_nc];
//
//    UIViewController *ovc = [[UIViewController alloc] init];
//    UINavigationController *ovc_nc = [[UINavigationController alloc] initWithRootViewController:ovc];
//    ovc_nc.tabBarItem.title = @"Option";
//
//    [tabItems addObject:ovc_nc];
//
//    UITabBarController *tbc = [[UITabBarController alloc] init];
//    tbc.viewControllers = tabItems;
////    self.tabController = tbc;
//
//    [self.window addSubview:tbc.view];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
