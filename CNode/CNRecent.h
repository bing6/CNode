//
//  CNRecent.h
//  CNode
//
//  Created by bing.hao on 16/3/22.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNBaseModel.h"

@interface CNRecent : CNBaseModel

@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, strong) NSString *loginname;
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *last_reply_at;
@property (nonatomic, assign) BOOL created;

- (instancetype)initWithDictionary:(NSDictionary *)data withCreated:(BOOL)created;

+ (NSArray *)createObjectListWithArray:(NSArray *)array withCreated:(BOOL)created;

@end
