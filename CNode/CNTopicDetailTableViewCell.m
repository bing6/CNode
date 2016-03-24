//
//  CNTopicDetailTableViewCell.m
//  CNode
//
//  Created by bing.hao on 16/3/15.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNTopicDetailTableViewCell.h"

@implementation CNTopicDetailTableViewCell

@synthesize tabLB = _tabLB;
@synthesize titleLB = _titleLB;
@synthesize avatarIV = _avatarIV;
@synthesize nicknameLB = _nicknameLB;
@synthesize createdAtLB = _createdAtLB;
@synthesize statisticsLB = _statisticsLB;
@synthesize bodyWV = _bodyWV;
@synthesize progressAIV = _progressAIV;

- (UILabel *)tabLB {
    if (_tabLB == nil) {
        _tabLB = [UILabel new];
        _tabLB.layer.cornerRadius = 5.0f;
        _tabLB.layer.borderWidth = 1.0f;
        _tabLB.layer.borderColor = [UIColor clearColor].CGColor;
        _tabLB.layer.masksToBounds = YES;
        _tabLB.textAlignment = NSTextAlignmentCenter;
        _tabLB.font = [UIFont systemFontOfSize:14];
        _tabLB.backgroundColor = RGBA(229, 229, 229, 1);
    }
    return _tabLB;
}

- (UILabel *)titleLB {
    if (_titleLB == nil) {
        _titleLB = [UILabel new];
        _titleLB.font = [UIFont boldSystemFontOfSize:16];
        _titleLB.numberOfLines = 0;
    }
    return _titleLB;
}

- (CNAvatarView *)avatarIV {
    if (_avatarIV == nil) {
        _avatarIV = [CNAvatarView new];
    }
    return _avatarIV;
}

- (UILabel *)nicknameLB {
    if (_nicknameLB == nil) {
        _nicknameLB = [UILabel new];
        _nicknameLB.font = [UIFont systemFontOfSize:14];
    }
    return _nicknameLB;
}

- (UILabel *)createdAtLB {
    if (_createdAtLB == nil) {
        _createdAtLB = [UILabel new];
        _createdAtLB.font = [UIFont systemFontOfSize:14];
    }
    return _createdAtLB;
}

- (UILabel *)statisticsLB {
    if (_statisticsLB == nil) {
        _statisticsLB = [UILabel new];
        _statisticsLB.font = [UIFont systemFontOfSize:14];
    }
    return _statisticsLB;
}

- (UIWebView *)bodyWV {
    if (_bodyWV == nil) {
        _bodyWV = [[UIWebView alloc] init];
        _bodyWV.scrollView.scrollEnabled = NO;
        _bodyWV.backgroundColor = RGBA(255, 255, 255, 1);
        _bodyWV.scrollView.backgroundColor = RGBA(255, 255, 255, 1);
        _bodyWV.scalesPageToFit = NO;
    }
    return _bodyWV;
}

- (UIActivityIndicatorView *)progressAIV {
    if (_progressAIV == nil) {
        _progressAIV = [UIActivityIndicatorView new];
        _progressAIV.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    return _progressAIV;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.tabLB];
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.avatarIV];
        [self.contentView addSubview:self.nicknameLB];
        [self.contentView addSubview:self.createdAtLB];
        [self.contentView addSubview:self.statisticsLB];
        [self.contentView addSubview:self.bodyWV];
        [self.contentView addSubview:self.progressAIV];
        
        WS(ws);
        
        [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.contentView).offset(20);
            make.left.equalTo(ws.contentView).offset(10);
            make.right.equalTo(ws.contentView).offset(-10);
        }];
        [self.avatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.titleLB);
            make.top.equalTo(ws.titleLB.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        [self.nicknameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.avatarIV.mas_right).offset(10);
            make.top.equalTo(ws.avatarIV);
        }];
        [self.createdAtLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.avatarIV.mas_right).offset(10);
            make.top.equalTo(ws.nicknameLB.mas_bottom).offset(10);
        }];
        [self.tabLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(ws.contentView).offset(-10);
            make.top.equalTo(ws.avatarIV);
            make.size.mas_equalTo(CGSizeMake(40, 24));
        }];
        [self.statisticsLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(ws.contentView).offset(-10);
            make.top.equalTo(ws.tabLB.mas_bottom).offset(5);
        }];
        [self.bodyWV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.avatarIV.mas_bottom).offset(10);
            make.left.equalTo(ws.contentView).offset(10);
            make.right.equalTo(ws.contentView).offset(-10);
            make.bottom.equalTo(ws.contentView).offset(-10);
            make.height.mas_greaterThanOrEqualTo(30);
        }];
        [self.progressAIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(ws.bodyWV);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
    }
    return self;
}

@end
