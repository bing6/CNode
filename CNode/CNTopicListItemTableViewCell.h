//
//  ItemCell.h
//  CNode
//
//  Created by bing.hao on 16/3/14.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNAvatarView.h"

@interface CNTopicListItemTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *tabLB;
@property (nonatomic, strong, readonly) UILabel *titleLB;
@property (nonatomic, strong, readonly) CNAvatarView *avatarIV;
@property (nonatomic, strong, readonly) UILabel *nicknameLB;
@property (nonatomic, strong, readonly) UILabel *createdAtLB;
@property (nonatomic, strong, readonly) UILabel *statisticsLB;
@property (nonatomic, strong, readonly) UILabel *replyAtLB;

@end
