//
//  CNWeb.h
//  CNode
//
//  Created by bing.hao on 16/3/16.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^T)(id responseObject, NSError * error);

@interface CNWeb : NSObject

@property (nonatomic, assign) BOOL mdrender;

+ (instancetype)shared;

- (void)POST:(NSString *)path params:(NSDictionary *)params callback:(T)callback;

- (void)GET:(NSString *)path params:(NSDictionary *)params callback:(T)callback;

@end

#pragma mark -主题

/**
 *  get /topics 主题首页
 *
 *  @param page 页数
 *  @param size 每一页的主题数量
 *  @param tab  主题分类。目前有 ask share job good
 *  @param t    回调方法
 */
void API_GET_TOPICS(NSInteger page, NSInteger size, NSString *tab, T t);

/**
 *  get /topic/:id 主题详情
 *
 *  @param topicId 唯一ID
 *  @param t       回调方法
 */
void API_GET_TOPIC_BY_ID(NSString *topicId, T t);

/**
 *  post /topics 新建主题
 *
 *  @param title   标题
 *  @param tab     目前有 ask share job
 *  @param content 主体内容
 *  @param t       回调方法
 */
void API_POST_TOPIC(NSString *title, NSString *tab, NSString *content, T t);

#pragma mark -用户

/**
 *  get /user/:loginname 用户详情
 *
 *  @param loginname 登录名
 *  @param t         回调方法
 */
void API_GET_USER(NSString *loginname, T t);

/**
 *  post /accesstoken 验证 accessToken 的正确性
 *
 *  @param token 用户的 accessToken
 *  @param t     回调方法
 */
void API_POST_ACCESSTOKEN(NSString *token, T t);

#pragma mark -消息通知

/**
 *  get /message/count 获取未读消息数
 *
 *  @param t 回调方法
 */
void API_GET_MESSAGE_COUNT(T t);

/**
 *  get /messages 获取已读和未读消息
 *
 *  @param t 回调方法
 */
void API_GET_MESSAGES(T t);

/**
 *  post /message/mark_all 标记全部已读
 *
 *  @param t 回调方法
 */
void API_POST_MESSAGE_MARK(T t);

#pragma mark -主题收藏

/**
 *  post /topic_collect/collect 收藏主题
 *
 *  @param topicId 主题的id
 *  @param t       回调方法
 */
void API_POST_TOPIC_COLLECT(NSString *topicId, T t);

/**
 *  post /topic_collect/de_collect 取消主题
 *
 *  @param topicId 主题的id
 *  @param t       回调方法
 */
void API_POST_TOPIC_COLLECT_DE(NSString *topicId, T t);

/**
 *  get /topic_collect/:loginname 用户所收藏的主题
 *
 *  @param loginname 登录名
 *  @param t         回调方法
 */
void API_GET_TOPIC_COLLLECT(NSString *loginname, T t);


#pragma mark -评论

/**
 *  post /topic/:topic_id/replies 新建评论
 *
 *  @param topicId 话题ID
 *  @param content 评论的主体
 *  @param replyId 如果这个评论是对另一个评论的回复，请务必带上此字段。这样前端就可以构建出评论线索图。
 *  @param t       回调方法
 */
void API_POST_TOPIC_REPLY(NSString *topicId, NSString *content, NSString *replyId, T t);

/**
 *  post /reply/:reply_id/ups 为评论点赞
 *  接口会自动判断用户是否已点赞，如果否，则点赞；如果是，则取消点赞。点赞的动作反应在返回数据的 action 字段中，up or down。
 *  @param replyId 评论ID
 *  @param t       回调方法
 */
void API_POST_REPLY_UPS(NSString *replyId, T t);




