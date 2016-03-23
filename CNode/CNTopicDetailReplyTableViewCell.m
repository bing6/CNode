//
//  CNTopicDetailReplyTableViewCell.m
//  CNode
//
//  Created by bing.hao on 16/3/15.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNTopicDetailReplyTableViewCell.h"

@implementation CNTopicDetailReplyTableViewCell

@synthesize avatarIV = _avatarIV;
@synthesize nicknameLB = _nicknameLB;
@synthesize createdAtLB = _createdAtLB;
@synthesize contentLB = _contentLB;
@synthesize commentsBTN = _commentsBTN;
@synthesize likeBTN = _likeBTN;
@synthesize likeLB = _likeLB;

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
        _createdAtLB.font = [UIFont systemFontOfSize:12];
    }
    return _createdAtLB;
}

- (UILabel *)contentLB {
    if (_contentLB == nil) {
        _contentLB = [UILabel new];
        _contentLB.font = [UIFont systemFontOfSize:15];
        _contentLB.numberOfLines = 0;
    }
    return _contentLB;
}

- (UILabel *)likeLB {
    if (_likeLB == nil) {
        _likeLB = [UILabel new];
        _likeLB.font = [UIFont systemFontOfSize:12];
    }
    return _likeLB;
}

- (UIButton *)likeBTN {
    if (_likeBTN == nil) {
        _likeBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBTN setImage:[UIImage imageNamed:@"Like.png"] forState:UIControlStateNormal];
        [_likeBTN setImage:[UIImage imageNamed:@"Like_s.png"] forState:UIControlStateSelected];
    }
    return _likeBTN;
}

- (UIButton *)commentsBTN {
    if (_commentsBTN == nil) {
        _commentsBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentsBTN setImage:[UIImage imageNamed:@"comments.png"] forState:UIControlStateNormal];
    }
    return _commentsBTN;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        

        [self.contentView addSubview:self.avatarIV];
        [self.contentView addSubview:self.nicknameLB];
        [self.contentView addSubview:self.createdAtLB];
        [self.contentView addSubview:self.contentLB];
        [self.contentView addSubview:self.likeLB];
        [self.contentView addSubview:self.likeBTN];
        [self.contentView addSubview:self.commentsBTN];
        
        WS(ws);
        
        [self.avatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.contentView).offset(10);
            make.top.equalTo(ws.contentView).offset(10);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        [self.nicknameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.avatarIV.mas_right).offset(10);
            make.top.equalTo(ws.contentView).offset(10);
        }];
        [self.createdAtLB mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(ws.contentView).offset(-10);
            make.left.equalTo(ws.nicknameLB);
            make.top.equalTo(ws.nicknameLB.mas_bottom).offset(5);
        }];
        [self.contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.createdAtLB);
            make.top.equalTo(ws.createdAtLB.mas_bottom).offset(5);
            make.right.equalTo(ws.contentView).offset(-10);
            make.bottom.equalTo(ws.contentView).offset(-10);
        }];
        [self.commentsBTN mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.nicknameLB);
            make.right.equalTo(ws.contentView).offset(-5);
            make.size.mas_equalTo(CGSizeMake(30, 40));
        }];
        [self.likeBTN mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.nicknameLB);
            make.right.equalTo(ws.commentsBTN.mas_left).offset(-5);
            make.size.mas_equalTo(CGSizeMake(30, 40));
        }];
//        [self.likeLB mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(ws.nicknameLB);
//            make.right.equalTo(ws.likeLB.mas_left).offset(-5);
//        }];
    }
    return self;
}

@end
