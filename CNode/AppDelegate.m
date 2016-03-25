//
//  AppDelegate.m
//  CNode
//
//  Created by bing.hao on 16/3/14.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "AppDelegate.h"
#import <MobClick.h>
#import <AFNetworking/AFNetworking.h>

@interface AppDelegate ()<UIAlertViewDelegate>

@end

@implementation AppDelegate

- (void)umengSetup {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
    NSDictionary *configer = [NSDictionary dictionaryWithContentsOfFile:path];
    if (configer) {
        [MobClick startWithAppkey:[configer objectForKey:@"umeng_appid"] reportPolicy:BATCH channelId:[configer objectForKey:@"umeng_channel"]];
    }
}

- (void)checkUpdate {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
    NSDictionary *configer = [NSDictionary dictionaryWithContentsOfFile:path];
    if (configer) {
        NSString *appid = [configer objectForKey:@"fir_id"];
        NSString *token = [configer objectForKey:@"fir_token"];
        NSString *idUrlString = [NSString stringWithFormat:@"http://api.fir.im/apps/latest/%@?api_token=%@", appid, token];
        NSURL *requestURL = [NSURL URLWithString:idUrlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
        
        AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] init];
        
        
        NSURLSessionDataTask *dataTask = [sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

            NSString *currVersion = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleVersion"];
            NSString *dataVersion = [responseObject objectForKey:@"version"];
            NSString *uv = [[NSUserDefaults standardUserDefaults] objectForKey:@"updateVersion"];
            
            if ([uv isEqualToString:dataVersion]) {
                return;
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:dataVersion forKey:@"updateVersion"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            if ([dataVersion compare:currVersion] == NSOrderedDescending) {
                UIAlertView *aler = [[UIAlertView alloc] initWithTitle:nil message:@"有新版本啦!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                [aler show];
            }
        }];
        [dataTask resume];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://fir.im/rutx"]];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //集成友盟统计
    [self umengSetup];
    //检测更新
    [self checkUpdate];
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
