//
//  CNLocalUser.m
//  CNode
//
//  Created by bing.hao on 16/3/17.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNLocalUser.h"
#import "CNStorage.h"

static CNLocalUser *__user;

@implementation CNLocalUser
@synthesize info = _info;

- (CNUser *)info {
    if (_info == nil && _loginname) {
        _info = [CNStorage fetchUserWithLoginname:_loginname];
    }
    return _info;
}

- (instancetype)initWithAccesstoken:(NSString *)accesstoken loginname:(NSString *)loginname userId:(NSString *)userId {
    self = [super self];
    if (self) {
        _accesstoken = accesstoken;
        _loginname = loginname;
        _userId = userId;
    }
    return self;
}

+ (instancetype)defaultUser {
    return __user;
}

+ (void)autoSignIn {
    
    if (__user) { return; }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *accesstoken = [ud stringForKey:@"accesstoken"];
    NSString *loginname = [ud stringForKey:@"loginname"];
    NSString *userId = [ud stringForKey:@"userId"];
    
    if (accesstoken && loginname) {
        __user = [[CNLocalUser alloc] initWithAccesstoken:accesstoken loginname:loginname userId:userId];
    }
}

+ (void)singInWithAccessToken:(NSString *)token loginname:(NSString *)loginname userId:(NSString *)userId {
    
    if (__user) {
        return;
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setObject:userId forKey:@"userId"];
    [ud setObject:token forKey:@"accesstoken"];
    [ud setObject:loginname forKey:@"loginname"];
    [ud synchronize];
    
    __user = [[CNLocalUser alloc] initWithAccesstoken:token loginname:loginname userId:userId];
}

+ (void)singOut {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"userId"];
    [ud removeObjectForKey:@"accesstoken"];
    [ud removeObjectForKey:@"loginname"];
    [ud synchronize];
    
    __user = nil;
}

- (void)saveChange {
    
    
}

@end
