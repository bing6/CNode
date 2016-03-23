//
//  CNUser.m
//  CNode
//
//  Created by bing.hao on 16/3/17.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNUser.h"

@implementation CNUser

- (instancetype)initWithDictionary:(NSDictionary *)data {
    self = [super self];
    if (self) {
        self.loginname = [data objectForKey:@"loginname"];
        self.avatar_url = [data objectForKey:@"avatar_url"];
        self.githubUsername = [data objectForKey:@"githubUsername"];
        self.create_at = CN_MODEL_DATE_CONVERT([data objectForKey:@"create_at"]);
        self.score = [[data objectForKey:@"score"] integerValue];
    }
    return self;
}

+ (NSString *)primaryKeyFieldName {
    return @"loginname";
}

@end
