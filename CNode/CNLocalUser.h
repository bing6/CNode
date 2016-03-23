//
//  CNLocalUser.h
//  CNode
//
//  Created by bing.hao on 16/3/17.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNUser.h"

@interface CNLocalUser : NSObject

@property (nonatomic, strong, readonly) NSString *userId;
@property (nonatomic, strong, readonly) NSString *loginname;
@property (nonatomic, strong, readonly) NSString *accesstoken;
@property (nonatomic, assign) NSInteger unreadMessageCount;

@property (nonatomic, strong, readonly) CNUser *info;

/**
 *  当前登录用户
 *
 *  @return
 */
+ (instancetype)defaultUser;

/**
 *  自动登录
 */
+ (void)autoSignIn;

/**
 *  本地登录
 *
 *  @param token
 *  @param loginname 
 */
+ (void)singInWithAccessToken:(NSString *)token loginname:(NSString *)loginname userId:(NSString *)userId;

/**
 *  退出登录
 */
+ (void)singOut;

/**
 *  构造函数
 *
 *  @param accesstoken token
 *  @param loginname   loginname
 *
 *  @return
 */
- (instancetype)initWithAccesstoken:(NSString *)accesstoken loginname:(NSString *)loginname userId:(NSString *)userId;

- (void)saveChange;

@end
