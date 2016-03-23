//
//  CNTopicDetailTableViewCell.h
//  CNode
//
//  Created by bing.hao on 16/3/15.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNAvatarView.h"

@interface CNTopicDetailTableViewCell : UITableViewCell<UIWebViewDelegate>

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) CNAvatarView *avatarIV;
@property (nonatomic, strong) UILabel *nicknameLB;
@property (nonatomic, strong) UILabel *createdAtLB;
@property (nonatomic, strong) UILabel *tabLB;
@property (nonatomic, strong) UILabel *statisticsLB;
@property (nonatomic, strong) UILabel *contentLB;
@property (nonatomic, strong) UIWebView *bodyWV;

@end
