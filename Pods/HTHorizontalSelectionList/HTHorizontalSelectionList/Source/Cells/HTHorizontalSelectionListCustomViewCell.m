//
//  HTHorizontalSelectionListCustomViewCell.m
//  HTHorizontalSelectionList Example
//
//  Created by Erik Ackermann on 2/27/15.
//  Copyright (c) 2015 Hightower. All rights reserved.
//

#import "HTHorizontalSelectionListCustomViewCell.h"

#import <M13BadgeView/M13BadgeView.h>

@interface HTHorizontalSelectionListCustomViewCell ()

@property (nonatomic, strong) M13BadgeView *badgeView;

@end

@implementation HTHorizontalSelectionListCustomViewCell

@synthesize state = _state, badgeValue = _badgeValue;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _state = UIControlStateNormal;

        _badgeView = [[M13BadgeView alloc] initWithFrame:CGRectMake(0, 0, 8, 14)];
        _badgeView.font = [UIFont systemFontOfSize:10];
        _badgeView.horizontalAlignment = M13BadgeViewHorizontalAlignmentRight;
        _badgeView.hidesWhenZero = YES;
        [self.contentView addSubview:_badgeView];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];

    for (UIView *subview in [self.contentView subviews]) {
        [subview removeFromSuperview];
    }

    self.state = UIControlStateNormal;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.contentView layoutSubviews];
    [self.customView layoutSubviews];

    self.badgeView.text = self.badgeValue ?: @"0";
    [self.contentView bringSubviewToFront:self.badgeView];
}

#pragma mark - Custom Getters and Setters

- (void)setCustomView:(UIView *)customView insets:(UIEdgeInsets)insets {
    _customView = customView;
    customView.translatesAutoresizingMaskIntoConstraints = NO;

    if (customView) {
        [self.contentView addSubview:customView];

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftInset-[customView]-rightInset-|"
                                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                 metrics:@{@"leftInset" : @(insets.left),
                                                                                           @"rightInset" : @(insets.right)}
                                                                                   views:NSDictionaryOfVariableBindings(customView)]];

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topInset-[customView]-bottomInset-|"
                                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                 metrics:@{@"topInset" : @(insets.top),
                                                                                           @"bottomInset" : @(insets.bottom)}
                                                                                   views:NSDictionaryOfVariableBindings(customView)]];
    }

    self.badgeView.alignmentShift = CGSizeMake(-insets.right, insets.top);
}

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;

    [self setNeedsLayout];
}

@end
