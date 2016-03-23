//
//  CNWeb.m
//  CNode
//
//  Created by bing.hao on 16/3/16.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNWeb.h"
#import <AFNetworking/AFNetworking.h>
#import "CNLocalUser.h"

#define kHOST @"https://cnodejs.org"

@interface CNWeb ()

@property (nonatomic, strong) AFURLSessionManager *manager;

@end

@implementation CNWeb

+ (instancetype)shared {
    static id __staticObject;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __staticObject = [CNWeb new];
    });
    return __staticObject;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.manager = [[AFURLSessionManager alloc] init];
        self.mdrender = true;
    }
    return self;
}

- (void)POST:(NSString *)path params:(NSDictionary *)params callback:(T)callback {
    [self send:path mehtod:@"POST" params:params callback:callback];
}

- (void)GET:(NSString *)path params:(NSDictionary *)params callback:(T)callback {
    [self send:path mehtod:@"GET" params:params callback:callback];
}

- (void)send:(NSString *)path mehtod:(NSString *)mehtod params:(NSDictionary *)params callback:(T)callback {
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@", kHOST, path];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    if ([CNLocalUser defaultUser]) {
        [parameters setObject:[CNLocalUser defaultUser].accesstoken forKey:@"accesstoken"];
    }
    if (params) {
        [parameters addEntriesFromDictionary:params];
    }
    
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:mehtod
                                                                          URLString:URLString
                                                                         parameters:parameters
                                                                              error:nil];
    
    NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (callback) {
            callback(responseObject, error);
        }
    }];
    [dataTask resume];
}

@end


void API_GET_TOPICS(NSInteger page, NSInteger size, NSString *tab, T t) {
    
    NSMutableDictionary *tmp = [NSMutableDictionary new];
    [tmp setObject:@(page) forKey:@"page"];
    [tmp setObject:@(size) forKey:@"limit"];
    if (tab) {
        [tmp setObject:tab forKey:@"tab"];
    }
    [[CNWeb shared] GET:@"/api/v1/topics" params:tmp callback:t];
}


void API_GET_TOPIC_BY_ID(NSString *topicId, T t) {
    
    NSString *path = [NSString stringWithFormat:@"/api/v1/topic/%@", topicId];
    [[CNWeb shared] GET:path params:@{ @"mdrender" : @"false"} callback:t];
}

/**
 *  post /topics 新建主题
 *
 *  @param title   标题
 *  @param tab     目前有 ask share job
 *  @param content 主体内容
 *  @param t       回调方法
 */
void API_POST_TOPIC(NSString *title, NSString *tab, NSString *content, T t) {
    NSMutableDictionary *tmp = [NSMutableDictionary new];
    [tmp setObject:title forKey:@"title"];
    [tmp setObject:tab forKey:@"tab"];
    [tmp setObject:content forKey:@"content"];
    [[CNWeb shared] POST:@"/api/v1/topics" params:tmp callback:t];
}

void API_GET_USER(NSString *loginname, T t) {
    NSString *path = [NSString stringWithFormat:@"/api/v1/user/%@", loginname];
    [[CNWeb shared] GET:path params:nil callback:t];
}


void API_POST_ACCESSTOKEN(NSString *token, T t) {
    [[CNWeb shared] POST:@"/api/v1/accesstoken" params:@{ @"accesstoken" : token } callback:t];
}


/**
 *  get /message/count 获取未读消息数
 *
 *  @param t 回调方法
 */
void API_GET_MESSAGE_COUNT(T t) {
    [[CNWeb shared] GET:@"/api/v1/message/count" params:nil callback:t];
}

/**
 *  get /messages 获取已读和未读消息
 *
 *  @param t 回调方法
 */
void API_GET_MESSAGES(T t) {
    [[CNWeb shared] GET:@"/api/v1/messages" params:nil callback:t];
}

/**
 *  post /message/mark_all 标记全部已读
 *
 *  @param t 回调方法
 */
void API_POST_MESSAGE_MARK(T t) {
    [[CNWeb shared] POST:@"/api/v1/message/mark_all" params:nil callback:t];
}

#pragma mark -主题收藏

/**
 *  post /topic_collect/collect 收藏主题
 *
 *  @param topicId 主题的id
 *  @param t       回调方法
 */
void API_POST_TOPIC_COLLECT(NSString *topicId, T t) {
    [[CNWeb shared] POST:@"/api/v1/topic_collect/collect" params:@{ @"topic_id" : topicId } callback:t];
}

/**
 *  post /topic_collect/de_collect 取消主题
 *
 *  @param topicId 主题的id
 *  @param t       回调方法
 */
void API_POST_TOPIC_COLLECT_DE(NSString *topicId, T t) {
    [[CNWeb shared] POST:@"/api/v1/topic_collect/de_collect" params:@{ @"topic_id" : topicId } callback:t];
}

/**
 *  get /topic_collect/:loginname 用户所收藏的主题
 *
 *  @param loginname 登录名
 *  @param t         回调方法
 */
void API_GET_TOPIC_COLLLECT(NSString *loginname, T t){\
    NSString *path = [NSString stringWithFormat:@"/api/v1/topic_collect/%@", loginname];
    [[CNWeb shared] GET:path params:nil callback:t];
}


#pragma mark -评论

/**
 *  post /topic/:topic_id/replies 新建评论
 *
 *  @param topicId 话题ID
 *  @param content 评论的主体
 *  @param replyId 如果这个评论是对另一个评论的回复，请务必带上此字段。这样前端就可以构建出评论线索图。
 *  @param t       回调方法
 */
void API_POST_TOPIC_REPLY(NSString *topicId, NSString *content, NSString *replyId, T t) {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (replyId) {
        [params setObject:replyId forKey:@"reply_id"];
    }
    [params setObject:content forKey:@"content"];
    NSString *path = [NSString stringWithFormat:@"/api/v1/topic/%@/replies", topicId];
    [[CNWeb shared] POST:path params:params callback:t];
}

/**
 *  post /reply/:reply_id/ups 为评论点赞
 *  接口会自动判断用户是否已点赞，如果否，则点赞；如果是，则取消点赞。点赞的动作反应在返回数据的 action 字段中，up or down。
 *  @param replyId 评论ID
 *  @param t       回调方法
 */
void API_POST_REPLY_UPS(NSString *replyId, T t) {
    NSString *path = [NSString stringWithFormat:@"/api/v1/reply/%@/ups", replyId];
    [[CNWeb shared] POST:path params:nil callback:t];
}
