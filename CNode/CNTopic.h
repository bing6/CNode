//
//  CNTopic.h
//  CNode
//
//  Created by bing.hao on 16/3/15.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNBaseModel.h"

@interface CNTopic : CNBaseModel

@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, strong) NSString *author_id;
@property (nonatomic, strong) NSString *tab;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *last_reply_at;
@property (nonatomic, assign) NSInteger is_good;
@property (nonatomic, assign) NSInteger is_top;
@property (nonatomic, assign) NSInteger reply_count;
@property (nonatomic, assign) NSInteger visit_count;
@property (nonatomic, strong) NSDate *create_at;
@property (nonatomic, strong) NSString *loginname;
@property (nonatomic, strong) NSString *avatar_url;


@end
