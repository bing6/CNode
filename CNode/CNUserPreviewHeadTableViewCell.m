//
//  CNUserPreviewHeadTableViewCell.m
//  CNode
//
//  Created by bing.hao on 16/3/21.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNUserPreviewHeadTableViewCell.h"

@interface CNUserPreviewHeadTableViewCell ()

//@property (nonatomic, strong) UIImageView *backgroundIV;



@end

@implementation CNUserPreviewHeadTableViewCell
@synthesize avatarIV = _avatarIV;
@synthesize loginnameLB = _loginnameLB;
@synthesize githubIV = _githubIV;

- (CNAvatarView *)avatarIV {
    if (_avatarIV == nil) {
        _avatarIV = [CNAvatarView new];
    }
    return _avatarIV;
}

- (UILabel *)loginnameLB {
    if (_loginnameLB == nil) {
        _loginnameLB = [UILabel new];
        _loginnameLB.textAlignment = NSTextAlignmentCenter;
        _loginnameLB.textColor = [UIColor whiteColor];
        _loginnameLB.font = [UIFont systemFontOfSize:14];
    }
    return _loginnameLB;
}

- (UIImageView *)githubIV {
    if (_githubIV == nil) {
        _githubIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GitHub.png"]];
    }
    return _githubIV;
}

//- (UIImageView *)backgroundIV {
//    if (_backgroundIV == nil) {
//        _backgroundIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
//    }
//    return _backgroundIV;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:RGBA(68, 68, 68, 1)];
        [self.contentView addSubview:self.avatarIV];
        [self.contentView addSubview:self.loginnameLB];
        [self.contentView addSubview:self.githubIV];
        
        WS(ws);
        
        [self.avatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.contentView).offset(40);
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.centerX.equalTo(ws.contentView);
        }];
        [self.loginnameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.avatarIV.mas_bottom).offset(10);
            make.bottom.equalTo(ws.contentView).offset(-30);
            make.centerX.equalTo(ws.contentView).offset(13);
        }];
        [self.githubIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.loginnameLB);
            make.right.equalTo(ws.loginnameLB.mas_left).offset(-5);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
    }
    return self;
}

@end
