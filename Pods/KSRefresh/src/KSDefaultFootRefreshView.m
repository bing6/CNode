//
//  KSDefaultFootRefreshView.m
//  KSRefresh
//
//  Created by bing.hao on 15/4/6.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "KSDefaultFootRefreshView.h"

#define KSFootRefreshView_T_1 @"加载更多数据"
#define KSFootRefreshView_T_2 @"松开刷新"
#define KSFootRefreshView_T_3 @""
#define KSFootRefreshView_T_4 @"已无更新的数据"

@interface KSDefaultFootRefreshView ()

@property (nonatomic, strong) UIActivityIndicatorView * indicatorView;
@property (nonatomic, strong) UILabel                 * titleLabel;

@end

@implementation KSDefaultFootRefreshView
@synthesize isLastPage = _isLastPage;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.indicatorView        = [[UIActivityIndicatorView alloc] init];
        self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.indicatorView.center = CGPointMake(KS_SCREEN_WIDTH / 2, KSRefreshView_Height / 2);
//        self.indicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        self.titleLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KS_SCREEN_WIDTH, KSRefreshView_Height)];
        self.titleLabel.font            = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor       = [UIColor darkGrayColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment   = NSTextAlignmentCenter;
        self.titleLabel.text            = KSFootRefreshView_T_1;
//        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.indicatorView];
        
        self.hidden = YES;
    }
    return self;
}

- (void)setIsLastPage:(BOOL)isLastPage
{
    if (isLastPage) {
        
        [self setValue:@(KSRefreshViewStateDefault) forKeyPath:@"_state"];
        [self.titleLabel setText:KSFootRefreshView_T_4];
        [self.indicatorView stopAnimating];
        
        UIEdgeInsets ei = self.targetView.contentInset;
        
        ei.bottom = self.targetViewOriginalEdgeInsets.bottom + KSRefreshView_Height;
        
        self.targetView.contentInset = ei;
        
    } else {
        [self.titleLabel setText:KSFootRefreshView_T_1];
    }
    
    _isLastPage = isLastPage;
}

- (void)setState:(KSRefreshViewState)state
{
    if (_isLastPage) {
        return;
    }
    
    [super setState:state];
    
    switch (state) {
        case KSRefreshViewStateDefault:
        {
            [self.titleLabel setText:KSFootRefreshView_T_1];
            [self.indicatorView stopAnimating];
            [self setScrollViewContentInset:self.targetViewOriginalEdgeInsets];
            
            break;
        }
        case KSRefreshViewStateVisible:
        {
            [self.titleLabel setText:KSFootRefreshView_T_1];
            [self.indicatorView stopAnimating];
            [self setScrollViewContentInset:self.targetViewOriginalEdgeInsets];
            
            break;
        }
        case KSRefreshViewStateTriggered:
        {
            [self.titleLabel setText:KSFootRefreshView_T_2];
            break;
        }
        case  KSRefreshViewStateLoading:
        {
            [self.titleLabel setText:KSFootRefreshView_T_3];
            [self.indicatorView startAnimating];
            
            UIEdgeInsets ei = self.targetView.contentInset;
            
            ei.bottom = self.targetViewOriginalEdgeInsets.bottom + KSRefreshView_Height;
            
            [self setScrollViewContentInset:ei];
            
            if ([self.delegate respondsToSelector:@selector(refreshViewDidLoading:)]) {
                [self.delegate refreshViewDidLoading:self];
            }
            
            break;
        }
    }
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.targetView.contentInset = contentInset;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.indicatorView.center = CGPointMake(KS_SCREEN_WIDTH / 2, KSRefreshView_Height / 2);
    self.titleLabel.frame = CGRectMake(0, 0, KS_SCREEN_WIDTH, KSRefreshView_Height);
}

@end
