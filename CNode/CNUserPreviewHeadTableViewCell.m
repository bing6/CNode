//
//  CNUserPreviewHeadTableViewCell.m
//  CNode
//
//  Created by bing.hao on 16/3/21.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNUserPreviewHeadTableViewCell.h"

@interface CNUserPreviewHeadTableViewCell ()

@property (nonatomic, strong) UIImageView *backgroundIV;

@end

@implementation CNUserPreviewHeadTableViewCell
@synthesize avatarIV = _avatarIV;
@synthesize loginnameLB = _loginnameLB;

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

- (UIImageView *)backgroundIV {
    if (_backgroundIV == nil) {
        _backgroundIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    }
    return _backgroundIV;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView addSubview:self.backgroundIV];
        [self.contentView addSubview:self.avatarIV];
//        [self.contentView addSubview:self.loginnameLB];
        
        WS(ws);
        
        [self.avatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.contentView).offset(40);
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.centerX.equalTo(ws.contentView);
            make.bottom.equalTo(ws.contentView).offset(-40);
        }];
        [self.backgroundIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(ws.contentView).insets(UIEdgeInsetsMake(-300, 0, 0, 0));
        }];
    }
    return self;
}

@end
