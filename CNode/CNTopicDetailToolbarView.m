//
//  CNTopicDetailToolbarView.m
//  CNode
//
//  Created by bing.hao on 16/3/22.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNTopicDetailToolbarView.h"

@implementation CNTopicDetailToolbarView

@synthesize contentTF = _contentTF;
@synthesize sendBTN = _sendBTN;

- (UITextField *)contentTF {
    if (_contentTF == nil) {
        _contentTF = [[UITextField alloc] init];
        _contentTF.borderStyle = UITextBorderStyleRoundedRect;
        _contentTF.borderColor = RGBA(232, 232, 232, 1);
//        _contentTF.delegate = self;
    }
    return _contentTF;
}

- (UIButton *)sendBTN {
    if (_sendBTN == nil) {
        _sendBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBTN setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _sendBTN;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = RGBA(68, 68, 68, 1);
        
        [self addSubview:self.contentTF];
        [self addSubview:self.sendBTN];
        
        WS(ws);
        
        [self.sendBTN mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(ws).offset(-5);
            make.top.equalTo(ws).offset(3);
            make.size.mas_equalTo(CGSizeMake(50, 44));
        }];
        [self.contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ws.sendBTN);
            make.left.equalTo(ws).offset(5);
            make.right.equalTo(ws.sendBTN.mas_left).offset(-5);
            make.height.mas_equalTo(40);
        }];
    }
    return self;
}

@end
