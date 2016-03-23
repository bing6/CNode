//
//  CNLocalStorage.m
//  CNode
//
//  Created by bing.hao on 16/3/15.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNStorage.h"

@implementation CNStorage

- (FMDTContext *)topic {
    return [self cacheWithClass:[CNTopic class]];
}

- (FMDTContext *)reply {
    return [self cacheWithClass:[CNReply class]];
}

- (FMDTContext *)user {
    return [self cacheWithClass:[CNUser class]];
}

- (FMDTContext *)recent {
    return [self cacheWithClass:[CNRecent class]];
}

- (FMDTContext *)favorite {
    return [self cacheWithClass:[CNFavorite class]];
}


+ (void)saveTopic:(NSArray *)datas {
    
    FMDTInsertCommand *cmd = FMDT_INSERT([CNStorage shared].topic);
    
    [cmd setRelpace:YES];
    [cmd addWithArray:datas];
    [cmd saveChangesInBackground:nil];
}

+ (void)saveReply:(NSArray *)datas {
    
    FMDTInsertCommand *cmd = FMDT_INSERT([CNStorage shared].reply);
    
    [cmd setRelpace:YES];
    [cmd addWithArray:datas];
    [cmd saveChangesInBackground:nil];
}

+ (void)saveUserWithObject:(CNUser *)data {
    
    FMDTInsertCommand *cmd = FMDT_INSERT([CNStorage shared].user);
    
    [cmd setRelpace:YES];
    [cmd add:data];
    [cmd saveChanges];
}

+ (void)fetchTopicWithPage:(NSInteger)page withSize:(NSInteger)size tab:(NSString *)tab callback:(void (^)(NSArray *))callback{
    
    FMDTSelectCommand *cmd = FMDT_SELECT([CNStorage shared].topic);
    
    cmd.limit = size;
    cmd.skip = (page - 1) * size;
    
    if (tab && [tab isEqualToString:@"good"]) {
        [cmd where:@"is_good" equalTo:@(1)];
    } else if (tab) {
        [cmd where:@"tab" equalTo:tab];
    }
    [cmd orderByDescending:@"is_top"];
    [cmd orderByDescending:@"last_reply_at"];
    [cmd fetchArrayInBackground:callback];
    
}

+ (void)fetchReplyWithTopicId:(NSString *)topicId callback:(void (^)(NSArray *))callback {
    
    FMDTSelectCommand *cmd = FMDT_SELECT([CNStorage shared].reply);
    
    [cmd where:@"topicId" equalTo:topicId];
    [cmd fetchArrayInBackground:callback];
}

+ (CNUser *)fetchUserWithLoginname:(NSString *)loginname {
    
    FMDTSelectCommand *cmd = FMDT_SELECT([CNStorage shared].user);
    [cmd where:@"loginname" equalTo:loginname];
    return [cmd fetchObject];
}

/**
 *  是否收藏了这个话题
 *
 *  @param loginname 登录名
 *  @param topicId   话题ID
 *  @param callback  回调方法
 */
+ (void)fetchFavoriteWithLoginname:(NSString *)loginname withTopicId:(NSString *)topicId callback:(void (^)(id))callback {
    
    FMDTSelectCommand *cmd = FMDT_SELECT([CNStorage shared].favorite);
    
    [cmd where:@"loginname" equalTo:loginname];
    [cmd where:@"topicId" equalTo:topicId];
    [cmd fetchObjectInBackground:callback];
}

/**
 *  保存收藏状态
 *
 *  @param loginname 登录名
 *  @param topicId   话题ID
 *  @param callback  回调方法
 */
+ (void)saveFavoriteWithLoginname:(NSString *)loginname withTopicId:(NSString *)topicId callback:(void (^)())callback {
    
    FMDTSelectCommand *scmd = FMDT_SELECT([CNStorage shared].favorite);

    [scmd where:@"loginname" equalTo:loginname];
    [scmd where:@"topicId" equalTo:topicId];
    
    id result = [scmd fetchObject];
    
    if (!result) {
        
        FMDTInsertCommand *icmd = FMDT_INSERT([CNStorage shared].favorite);
        
        CNFavorite *obj = [CNFavorite new];
    
        obj.loginname = loginname;
        obj.topicId = topicId;
        
        [icmd add:obj];
        [icmd saveChangesInBackground:callback];
    }
}

/**
 *  删除收藏状态
 *
 *  @param loginname 登录名
 *  @param topicId   话题ID
 *  @param callback  回调方法
 */
+ (void)removeFavoriteWithLoginname:(NSString *)loginname withTopicId:(NSString *)topicId callback:(void (^)())callback {
    
    FMDTDeleteCommand *cmd = FMDT_DELETE([CNStorage shared].favorite);
    
    [cmd where:@"loginname" equalTo:loginname];
    [cmd where:@"topicId" equalTo:topicId];
    [cmd saveChangesInBackground:callback];
}

@end
