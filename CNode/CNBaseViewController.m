//
//  CNBaseViewController.m
//  CNode
//
//  Created by bing.hao on 16/3/16.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNBaseViewController.h"

@interface CNBaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation CNBaseViewController

@synthesize tableView = _tableView;

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 60.0f;
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBA(255, 255, 255, 1);
    
    //设置导航栏
    if (self.navigationController) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        
        UIButton *left  = [self navigationBarLeftButton];
        UIButton *right = [self navigationBarRightButton];
        
        if (left) {
            [left addTarget:self action:@selector(navigationBarLeftButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
        }
        if (right) {
            [right addTarget:self action:@selector(navigationBarRightButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
        }
        
        self.navigationController.navigationBar.barTintColor = RGBA(68, 68, 68, 1);
        self.navigationController.navigationBar.barStyle    = UIBarStyleBlackOpaque;
        self.navigationController.navigationBar.opaque      = YES;
        self.navigationController.navigationBar.translucent = NO;
    }
    
    //注册通知
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    for (NSString *entry in self.registerNotifications) {
        [center addObserver:self selector:@selector(receiveNotificationHandler:) name:entry object:nil];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_hud) {
        [_hud setHidden:YES];
    }
}

#pragma mark - 自定义导航

/**
 * @brief 导航栏目左边按钮
 */
- (UIButton *)navigationBarLeftButton
{
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backButton setFrame:CGRectMake(0, 0, 22, 44)];
    [backButton setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    return backButton;
}
/**
 * @brief 导航栏目右边按钮
 */
- (UIButton *)navigationBarRightButton
{
    return nil;
}
/**
 * 导航栏左侧按钮事件
 */
- (void)navigationBarLeftButtonHandler:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 * 导航栏右侧按钮事件
 */
- (void)navigationBarRightButtonHandler:(id)sender
{
    
}

#pragma mark - 通知

/**
 * @brief 注册通知,在viewDidLoad方法中启动, dealloc方法销毁
 */
- (NSArray *)registerNotifications
{
    return nil;
}
/**
 * @brief 接收通知
 */
- (void)receiveNotificationHandler:(NSNotification *)notice
{
    
}

#pragma mark - 扩展

- (void)pushWithName:(NSString *)name
{
    [self pushWithName:name params:nil];
}

- (void)pushWithName:(NSString *)name params:(NSDictionary *)params
{
    UIViewController * vc = [NSClassFromString(name) new];
    if (params) {
        for (NSString * key in params.allKeys) {
            [vc setValue:[params objectForKey:key] forKeyPath:key];
        }
    }
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    return cell;
}

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

#pragma mark - MBProgressHUD

- (MBProgressHUD *)hud
{
    if (_hud == nil) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
    }
    return _hud;
}

- (void)showToast:(NSString *)text callback:(void (^)())cb {
    [self showToast:text duration:1.5f callback:cb];
}

- (void)showToast:(NSString *)text duration:(NSTimeInterval)duration callback:(void (^)())cb {
    
    [self.hud setMode:MBProgressHUDModeText];
    [self.hud setLabelText:text];
    [self.hud showAnimated:YES whileExecutingBlock:^{
        usleep(1000000 * duration);
    } completionBlock:^{
        [self.hud setLabelText:nil];
        [self.hud setMode:MBProgressHUDModeIndeterminate];
        if (cb) {
            cb();
        }
    }];
}

@end
