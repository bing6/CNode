//
//  CNBaseViewController.h
//  CNode
//
//  Created by bing.hao on 16/3/16.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface CNBaseViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong, readonly) UITableView *tableView;


#pragma mark - 自定义导航

/**
 * @brief 子类重写方法->导航栏目左边按钮
 */
- (UIButton *)navigationBarLeftButton;
/**
 * @brief 子类重写方法->导航栏目右边按钮
 */
- (UIButton *)navigationBarRightButton;
/**
 * 子类重写方法->导航栏左侧按钮事件
 */
- (void)navigationBarLeftButtonHandler:(id)sender;
/**
 * 子类重写方法->导航栏右侧按钮事件
 */
- (void)navigationBarRightButtonHandler:(id)sender;

#pragma mark - 通知

/**
 * @brief 注册通知,在viewDidLoad方法中启动, dealloc方法销毁
 */
- (NSArray *)registerNotifications;
/**
 * @brief 接收通知
 */
- (void)receiveNotificationHandler:(NSNotification *)notice;

#pragma mark - 扩展

/**
 * @brief 横向滑动转换在当前导航内
 */
- (void)pushWithName:(NSString *)name;
- (void)pushWithName:(NSString *)name params:(NSDictionary *)params;

#pragma mark - MBProgressHUD

@property (nonatomic, strong) MBProgressHUD *hud;

/**
 * @brief 显示HUD并在XX秒后自动隐藏,并触发回调函数,默认1.5秒
 */
- (void)showToast:(NSString *)text callback:(void(^)())cb;
- (void)showToast:(NSString *)text duration:(NSTimeInterval)duration callback:(void (^)())cb;

@end
