//
//  CNUserPreviewReplyTableViewCell.h
//  CNode
//
//  Created by bing.hao on 16/3/21.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNAvatarView.h"

@interface CNUserPreviewRecentTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *titleLB;
@property (nonatomic, strong, readonly) CNAvatarView *avatarIV;
@property (nonatomic, strong, readonly) UILabel *nicknameLB;
@property (nonatomic, strong, readonly) UILabel *createdAtLB;
@property (nonatomic, strong, readonly) UILabel *sourceLB;

@end
