//
//  KSRefreshView.h
//  KSRefresh
//
//  Created by bing.hao on 15/4/4.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KS_SCREEN_BOUNDS [[UIScreen mainScreen] bounds]
#define KS_SCREEN_WIDTH  KS_SCREEN_BOUNDS.size.width
#define KS_SCREEN_HEIGHT KS_SCREEN_BOUNDS.size.height

#define KSRefreshView_Height 60.0f

/**
 * @brief 刷新状态
 */
typedef enum {
    KSRefreshViewStateDefault = 1,    //默认
    KSRefreshViewStateVisible,        //刷新视图已被显示到界面
    KSRefreshViewStateTriggered,      //已经可以出发刷新委托事件
    KSRefreshViewStateLoading         //正在加载
} KSRefreshViewState;

/**
 * @brief 刷新委托
 */
@protocol KSRefreshViewDelegate <NSObject>

@optional
/**
 * @brief 刷新状态改变调用
 */
- (void)refreshView:(id)view didChangeState:(KSRefreshViewState)state;
/**
 * @brief 加载数据调用
 */
- (void)refreshViewDidLoading:(id)view;

@end

@protocol KSRefreshView <NSObject>

/**
 * @brief 宿主View
 */
@property (nonatomic, weak) UIScrollView * targetView;
/**
 * @brief 宿主原来的外边距
 */
@property (nonatomic, assign) UIEdgeInsets targetViewOriginalEdgeInsets;
/**
 * @brief 刷新视图状态
 */
@property (nonatomic, assign) KSRefreshViewState state;
/**
 * @brief 委托
 */
@property (nonatomic, weak) id<KSRefreshViewDelegate> delegate;

/**
 * @brief 完成加载状态
 */
- (void)finishedLoading;

@end


@interface KSHeadRefreshView : UIView<KSRefreshView>

- (instancetype)initWithDelegate:(id<KSRefreshViewDelegate>)delegate;

@end

@interface KSFootRefreshView : UIView<KSRefreshView>

/**
 * @brief 是否最后一页
 */
@property (nonatomic, assign) BOOL isLastPage;

- (instancetype)initWithDelegate:(id<KSRefreshViewDelegate>)delegate;

@end

