//
//  CNRecent.m
//  CNode
//
//  Created by bing.hao on 16/3/22.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNRecent.h"

@implementation CNRecent

- (instancetype)initWithDictionary:(NSDictionary *)data {
    self = [super self];
    if (self) {
        
        self.topicId = [data objectForKey:@"id"];
        self.loginname = [[data objectForKey:@"author"] objectForKey:@"loginname"];
        self.avatar_url = [[data objectForKey:@"author"] objectForKey:@"avatar_url"];
        self.title = [data objectForKey:@"title"];
        self.last_reply_at = CN_MODEL_DATE_CONVERT([data objectForKey:@"last_reply_at"]);
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)data withCreated:(BOOL)created {
    self = [self initWithDictionary:data];
    if (self) {
        self.created = created;
    }
    return self;
}

+ (NSString *)primaryKeyFieldName {
    return @"topicId";
}

+ (NSArray *)createObjectListWithArray:(NSArray *)array withCreated:(BOOL)created {
    NSMutableArray *tmp = [NSMutableArray new];
    for (NSDictionary *entry in array) {
        [tmp addObject:[[CNRecent alloc] initWithDictionary:entry withCreated:created]]; 
    }
    return tmp;
}

@end
