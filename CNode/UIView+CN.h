//
//  UIView+KS.h
//  KSToolkit
//
//  Created by bing.hao on 14/11/30.
//  Copyright (c) 2014年 bing.hao. All rights reserved.
//

#import <UIKit/UIKit.h>

// View 圆角和加边框
#define VIEW_BORDER_RADIUS(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define VIEW_RADIUS(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]


@interface UIView (CN)

/**
 * @brief 位置
 */
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

/**
 * @brief 边框颜色
 */
@property (nonatomic, strong) UIColor * borderColor;
/**
 * @brief 边框宽度
 */
@property (nonatomic, assign) CGFloat   borderWidth;
/**
 * @brief 园角
 */
@property (nonatomic, assign) CGFloat   radius;

/**
 * @brief 删除所有子试图
 */
- (void)removeAllSubviews;

/**
 * @brief 添加点击事件
 */
- (void)onClick:(void(^)(void))callback;

@end
