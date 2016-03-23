//
//  CNAvatarView.m
//  CNode
//
//  Created by bing.hao on 16/3/21.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNAvatarView.h"
#import <UIImageView+WebCache.h>

@implementation CNAvatarView

- (void)setURLString:(NSString *)URLString {
    _URLString = URLString;
    if (_URLString == nil) {
        self.image = [UIImage imageNamed:@"Icon-60.png"];
    } else {
        [self sd_setImageWithURL:[NSURL URLWithString:_URLString] placeholderImage:[UIImage imageNamed:@"Icon-60.png"]];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.borderColor = RGBA(233, 233, 233, 1);
        self.borderWidth = SINGLE_LINE_WIDTH;
    }
    return self;
}

@end
