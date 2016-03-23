//
//  CNReply.h
//  CNode
//
//  Created by bing.hao on 16/3/15.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNBaseModel.h"

@interface CNReply : CNBaseModel

@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, strong) NSString *loginname;
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *create_at;
@property (nonatomic, strong) NSString *reply_id;

@end
