//
//  UIScrollView+KS.m
//  KSRefresh
//
//  Created by bing.hao on 15/4/6.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import "UIScrollView+KS.h"
#import <objc/runtime.h>

static void * MyKey1 = (void *)@"HeadRefreshView";
static void * MyKey2 = (void *)@"FootRefreshView";

@implementation UIScrollView (KS)
@dynamic header;
@dynamic footer;

- (KSHeadRefreshView *)header
{
    return objc_getAssociatedObject(self, MyKey1);
}

- (void)setHeader:(KSHeadRefreshView *)header
{
    id curr = [self header];
    if (curr) {
        [curr removeFromSuperview];
    }
    if (header) {
        [self addSubview:header];
    }
    objc_setAssociatedObject(self, MyKey1, header, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (KSFootRefreshView *)footer
{
    return objc_getAssociatedObject(self, MyKey2);
}

- (void)setFooter:(KSFootRefreshView *)footer
{
    id curr = [self footer];
    if (curr) {
        [curr removeFromSuperview];
    }
    if (footer) {
        [self addSubview:footer];
    }
    objc_setAssociatedObject(self, MyKey2, footer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)headerFinishedLoading
{
    if ([self header]) {
        [self.header finishedLoading];
    }
}

- (void)footerFinishedLoading
{
    if ([self footer]) {
        [self.footer finishedLoading];
    }
}
@end
