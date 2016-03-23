//
//  CNUser.h
//  CNode
//
//  Created by bing.hao on 16/3/17.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNBaseModel.h"

@interface CNUser : CNBaseModel

@property (nonatomic, strong) NSString *loginname;
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *githubUsername;
@property (nonatomic, strong) NSDate *create_at;
@property (nonatomic, assign) NSInteger score;

@end
