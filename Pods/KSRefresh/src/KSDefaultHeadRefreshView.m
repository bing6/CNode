//
//  KSDefaultHeadRefreshView.m
//  KSRefresh
//
//  Created by bing.hao on 15/4/6.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "KSDefaultHeadRefreshView.h"

#define KSHeadRefreshView_T_1 @"下拉刷新"
#define KSHeadRefreshView_T_2 @"松开刷新"
#define KSHeadRefreshView_T_3 @"加载中..."

@interface KSDefaultHeadRefreshView ()

@property (nonatomic, strong) UIActivityIndicatorView * indicatorView;
@property (nonatomic, strong) UIImageView             * arrowImageView;
@property (nonatomic, strong) UILabel                 * titleLabel;

@end

@implementation KSDefaultHeadRefreshView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.arrowImageView       = [[UIImageView alloc] initWithFrame:CGRectMake(20, (KSRefreshView_Height - 40) / 2, 18, 36)];
        self.arrowImageView.image = [UIImage imageNamed:@"KSRefresh.bundle/arrow.png"];
        
        self.indicatorView        = [[UIActivityIndicatorView alloc] init];
        self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.indicatorView.center = self.arrowImageView.center;
//        self.indicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        self.titleLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KS_SCREEN_WIDTH, KSRefreshView_Height)];
        self.titleLabel.font            = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor       = [UIColor darkGrayColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment   = NSTextAlignmentCenter;
        self.titleLabel.text            = KSHeadRefreshView_T_1;

        [self addSubview:self.titleLabel];
        [self addSubview:self.arrowImageView];
        [self addSubview:self.indicatorView];
    }
    return self;
}

- (void)setState:(KSRefreshViewState)state
{
    [super setState:state];
    
    switch (state) {
        case KSRefreshViewStateDefault:
        {
            UIEdgeInsets curInsets = self.targetView.contentInset;
            curInsets.top = self.targetViewOriginalEdgeInsets.top;
            
            [self.titleLabel setText:KSHeadRefreshView_T_1];
            [self.indicatorView stopAnimating];
            [self setScrollViewContentInset:curInsets];
            [self rotateArrow:0 hide:YES];
            
            break;
        }
        case KSRefreshViewStateVisible:
        {
            UIEdgeInsets curInsets = self.targetView.contentInset;
            curInsets.top = self.targetViewOriginalEdgeInsets.top;
            
            [self.titleLabel setText:KSHeadRefreshView_T_1];
            [self.indicatorView stopAnimating];
            [self setScrollViewContentInset:curInsets];
            [self rotateArrow:0 hide:NO];
            
            break;
        }
        case KSRefreshViewStateTriggered:
        {
            [self.titleLabel setText:KSHeadRefreshView_T_2];
            [self rotateArrow:M_PI hide:NO];
            break;
        }
        case  KSRefreshViewStateLoading:
        {
            [self.titleLabel setText:KSHeadRefreshView_T_3];
            [self.arrowImageView setAlpha:0];
            [self.indicatorView startAnimating];
            
            UIEdgeInsets ei = self.targetView.contentInset;
            
            ei.top = fabs(self.frame.origin.y) + self.targetViewOriginalEdgeInsets.top;
            
            [self setScrollViewContentInset:ei];
            [self rotateArrow:0 hide:YES];
            
            if ([self.delegate respondsToSelector:@selector(refreshViewDidLoading:)]) {
                [self.delegate refreshViewDidLoading:self];
            }
            
            break;
        }
    }
}

- (void)rotateArrow:(float)degrees hide:(BOOL)hide
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.arrowImageView.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
        self.arrowImageView.layer.opacity = !hide;
    } completion:NULL];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.targetView.contentInset = contentInset;
    } completion:^(BOOL finished) {
        if(self.state == KSRefreshViewStateDefault && contentInset.top == self.targetViewOriginalEdgeInsets.top)
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                self.arrowImageView.alpha = 0;
            } completion:NULL];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, 0, KS_SCREEN_WIDTH, KSRefreshView_Height);
}

@end
