//
//  CNTopic.m
//  CNode
//
//  Created by bing.hao on 16/3/15.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNTopic.h"
#import "NSDate+CN.h"

@implementation CNTopic

- (instancetype)initWithDictionary:(NSDictionary *)data {
    self = [super init];
    if (self) {
        
        self.topicId = [data objectForKey:@"id"];
        self.author_id = [data objectForKey:@"author_id"];
        self.tab = [data objectForKey:@"tab"];
        self.content = [data objectForKey:@"content"];
        self.title = [data objectForKey:@"title"];
        self.is_good = [[data objectForKey:@"good"] boolValue];
        self.is_top = [[data objectForKey:@"top"] boolValue];
        self.reply_count = [[data objectForKey:@"reply_count"] integerValue];
        self.visit_count = [[data objectForKey:@"visit_count"] integerValue];
        self.loginname = [data valueForKeyPath:@"author.loginname"];
        self.avatar_url = [data valueForKeyPath:@"author.avatar_url"];
        self.create_at = CN_MODEL_DATE_CONVERT([data objectForKey:@"create_at"]);
        self.last_reply_at = CN_MODEL_DATE_CONVERT([data objectForKey:@"last_reply_at"]);
        
    }
    return self;
}

+ (NSString *)primaryKeyFieldName {
    return @"topicId";
}

@end
