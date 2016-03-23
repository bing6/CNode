//
//  ItemCell.m
//  CNode
//
//  Created by bing.hao on 16/3/14.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNTopicListItemTableViewCell.h"

@implementation CNTopicListItemTableViewCell

@synthesize tabLB = _tabLB;
@synthesize titleLB = _titleLB;
@synthesize avatarIV = _avatarIV;
@synthesize nicknameLB = _nicknameLB;
@synthesize createdAtLB = _createdAtLB;
@synthesize statisticsLB = _statisticsLB;
@synthesize replyAtLB = _replyAtLB;

- (UILabel *)tabLB {
    if (_tabLB == nil) {
        _tabLB = [UILabel new];
        _tabLB.layer.cornerRadius = 5.0f;
        _tabLB.layer.borderWidth = 1.0f;
        _tabLB.layer.borderColor = [UIColor clearColor].CGColor;
        _tabLB.layer.masksToBounds = YES;
        _tabLB.textAlignment = NSTextAlignmentCenter;
        _tabLB.font = [UIFont systemFontOfSize:12];
        _tabLB.backgroundColor = RGBA(229, 229, 229, 1);
    }
    return _tabLB;
}

- (UILabel *)titleLB {
    if (_titleLB == nil) {
        _titleLB = [UILabel new];
        _titleLB.font = [UIFont systemFontOfSize:15];
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
        _nicknameLB.font = [UIFont systemFontOfSize:12];
    }
    return _nicknameLB;
}

- (UILabel *)createdAtLB {
    if (_createdAtLB == nil) {
        _createdAtLB = [UILabel new];
        _createdAtLB.font = [UIFont systemFontOfSize:12];
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

- (UILabel *)replyAtLB {
    if (_replyAtLB == nil) {
        _replyAtLB = [UILabel new];
        _replyAtLB.font = [UIFont systemFontOfSize:14];
    }
    return _replyAtLB;
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
        [self.contentView addSubview:self.replyAtLB];
 
        WS(ws);

        [self.avatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.contentView).offset(10);
            make.left.equalTo(ws.contentView).offset(10);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        [self.nicknameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.avatarIV);
            make.left.equalTo(ws.avatarIV.mas_right).offset(10);
        }];
        [self.tabLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.avatarIV);
            make.right.equalTo(ws.contentView).offset(-10);
            make.size.mas_equalTo(CGSizeMake(40, 20));
        }];
        [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.avatarIV.mas_bottom).offset(10);
            make.left.equalTo(ws.avatarIV);
            make.right.equalTo(ws.contentView).offset(-10);
            make.bottom.equalTo(ws.contentView).offset(-20).priorityHigh();
        }];
        [self.createdAtLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws.avatarIV);
            make.left.equalTo(ws.nicknameLB);
        }];
        
        UIView *sp = [UIView new];
        sp.backgroundColor = RGBA(235, 235, 235, 1);
        [self addSubview:sp];
        [sp mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws);
            make.left.equalTo(ws);
            make.right.equalTo(ws);
            make.height.mas_equalTo(10);
        }];
    }
    return self;
}

@end
