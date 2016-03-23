//
//  CNReply.m
//  CNode
//
//  Created by bing.hao on 16/3/15.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNReply.h"


@implementation CNReply

- (instancetype)initWithDictionary:(NSDictionary *)data {
    self = [super init];
    if (self) {

        self.pid = [data objectForKey:@"id"];
        self.reply_id = [data objectForKey:@"reply_id"];
        self.content = [data objectForKey:@"content"];
        self.loginname = [data valueForKeyPath:@"author.loginname"];
        self.avatar_url = [data valueForKeyPath:@"author.avatar_url"];
        self.create_at = CN_MODEL_DATE_CONVERT([data objectForKey:@"create_at"]);

    }
    return self;
}

+ (NSString *)primaryKeyFieldName {
    return @"pid";
}

@end
