//
//  CNLocalStorage.h
//  CNode
//
//  Created by bing.hao on 16/3/15.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import <FMDBDataTable/FMDTManager.h>
#import "CNTopic.h"
#import "CNReply.h"
#import "CNUser.h"
#import "CNFavorite.h"
#import "CNRecent.h"

@interface CNStorage : FMDTManager

/**
 *  话题
 */
@property (nonatomic, strong, readonly) FMDTContext *topic;
/**
 *  话题相关评论
 */
@property (nonatomic, strong, readonly) FMDTContext *reply;
/**
 *  用户
 */
@property (nonatomic, strong, readonly) FMDTContext *user;
/**
 *  动近有关系的话题
 */
@property (nonatomic, strong, readonly) FMDTContext *recent;
/**
 *  收藏话题
 */
@property (nonatomic, strong, readonly) FMDTContext *favorite;

/**
 *  保存话题
 *
 *  @param datas
 */
+ (void)saveTopic:(NSArray *)datas;

/**
 *  保存评论
 *
 *  @param datas
 */
+ (void)saveReply:(NSArray *)datas;

/**
 *  保存用户信息
 *
 *  @param data cnuser
 */
+ (void)saveUserWithObject:(CNUser *)data;

/**
 *  获取话题列表
 *
 *  @param page     分页
 *  @param size     数量
 *  @param tab      频道
 *  @param callback 回调方法
 */
+ (void)fetchTopicWithPage:(NSInteger)page withSize:(NSInteger)size tab:(NSString *)tab callback:(void (^)(NSArray *))callback;

/**
 *  获取评论
 *
 *  @param topicId  话题ID
 *  @param callback 回调方法
 */
+ (void)fetchReplyWithTopicId:(NSString *)topicId callback:(void (^)(NSArray *))callback;

/**
 *  获取本地缓存的用户信息
 *
 *  @param loginname 登录名
 *
 *  @return 用户信息
 */
+ (CNUser *)fetchUserWithLoginname:(NSString *)loginname;

/**
 *  是否收藏了这个话题
 *
 *  @param loginname 登录名
 *  @param topicId   话题ID
 *  @param callback  回调方法
 */
+ (void)fetchFavoriteWithLoginname:(NSString *)loginname withTopicId:(NSString *)topicId callback:(void (^)(id res))callback;

/**
 *  保存收藏状态
 *
 *  @param loginname 登录名
 *  @param topicId   话题ID
 *  @param callback  回调方法
 */
+ (void)saveFavoriteWithLoginname:(NSString *)loginname withTopicId:(NSString *)topicId callback:(void (^)())callback;

/**
 *  删除收藏状态
 *
 *  @param loginname 登录名
 *  @param topicId   话题ID
 *  @param callback  回调方法
 */
+ (void)removeFavoriteWithLoginname:(NSString *)loginname withTopicId:(NSString *)topicId callback:(void (^)())callback;

/**
 *  清除本地缓存
 *
 *  @param callback 回调方法
 */
+ (void)clearLocaldata:(FMDT_CALLBACK_RESULT_NOT)callback;

@end
