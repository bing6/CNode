//
//  CNUserPreviewReplyTableViewCell.m
//  CNode
//
//  Created by bing.hao on 16/3/21.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNUserPreviewRecentTableViewCell.h"

@implementation CNUserPreviewRecentTableViewCell

@synthesize titleLB = _titleLB;
@synthesize avatarIV = _avatarIV;
@synthesize nicknameLB = _nicknameLB;
@synthesize createdAtLB = _createdAtLB;
@synthesize sourceLB = _sourceLB;

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

- (UILabel *)sourceLB {
    if (_sourceLB == nil) {
        _sourceLB = [UILabel new];
        _sourceLB.font = [UIFont systemFontOfSize:12];
    }
    return _sourceLB;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.avatarIV];
        [self.contentView addSubview:self.nicknameLB];
        [self.contentView addSubview:self.createdAtLB];
        [self.contentView addSubview:self.sourceLB];
        
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
        [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.avatarIV.mas_bottom).offset(10);
            make.left.equalTo(ws.avatarIV);
            make.right.equalTo(ws.contentView).offset(-10);
            make.bottom.equalTo(ws.contentView).offset(-10);
        }];
        [self.createdAtLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws.avatarIV);
            make.left.equalTo(ws.nicknameLB);
        }];
        [self.sourceLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(ws.contentView).offset(-10);
            make.centerY.equalTo(ws.nicknameLB);
        }];
    }
    return self;
}

@end
