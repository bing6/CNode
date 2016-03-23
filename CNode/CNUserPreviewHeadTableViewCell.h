//
//  CNUserPreviewHeadTableViewCell.h
//  CNode
//
//  Created by bing.hao on 16/3/21.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNAvatarView.h"

@interface CNUserPreviewHeadTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) CNAvatarView *avatarIV;
@property (nonatomic, strong, readonly) UILabel *loginnameLB;
@property (nonatomic, strong, readonly) UILabel *scoreLB;
@property (nonatomic, strong, readonly) UILabel *collectLB;

@end
