//
//  CNTopicDetailReplyTableViewCell.h
//  CNode
//
//  Created by bing.hao on 16/3/15.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNAvatarView.h"

@interface CNTopicDetailReplyTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) CNAvatarView *avatarIV;
@property (nonatomic, strong, readonly) UILabel *nicknameLB;
@property (nonatomic, strong, readonly) UILabel *createdAtLB;
@property (nonatomic, strong, readonly) UILabel *contentLB;
@property (nonatomic, strong, readonly) UIButton *commentsBTN;
@property (nonatomic, strong, readonly) UILabel *likeLB;
@property (nonatomic, strong, readonly) UIButton *likeBTN;

@end
