//
//  CNUserPreviewViewController.m
//  CNode
//
//  Created by bing.hao on 16/3/17.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNUserPreviewViewController.h"
#import "CNUserPreviewHeadTableViewCell.h"
#import "CNUserPreviewRecentTableViewCell.h"
#import "CNUser.h"
#import "CNRecent.h"
#import "CNWeb.h"
#import "CNStorage.h"
#import "NSDate+CN.h"
#import "UIView+CN.h"
#import "CNLocalUser.h"

#import <UITableView+FDTemplateLayoutCell.h>

@interface CNUserPreviewViewController ()

/**
 *  当前用户信息
 */
@property (nonatomic, strong) CNUser *user;
/**
 *  最近相关的话题
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, weak) UIButton *rightBTB;

@end

@implementation CNUserPreviewViewController

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //用登录名做Title
    self.title = self.loginname;
    //初始化用户信息
    self.user = [CNUser new];
    self.user.loginname = self.loginname;
    self.user.avatar_url = self.avatar;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    [self.tableView registerClass:[CNUserPreviewHeadTableViewCell class] forCellReuseIdentifier:@"HeadCell"];
    [self.tableView registerClass:[CNUserPreviewRecentTableViewCell class] forCellReuseIdentifier:@"RC"];
    //加载数据
    [self performSelector:@selector(reloadDataSource) withObject:nil afterDelay:0.5f];
}

- (void)reloadDataSource {
    
    CNUser *tmp = [CNStorage fetchUserWithLoginname:self.loginname];
    if (tmp) {
        self.user = tmp;
        [self.tableView reloadData];
    }
    API_GET_USER(self.loginname, ^(id responseObject, NSError *error) {

        if (error) {
            [self showToast:error.description callback:nil];
        } else {
            NSDictionary *result = [responseObject objectForKey:@"data"];
            
            CNUser *user = [[CNUser alloc] initWithDictionary:result];
            [CNStorage saveUserWithObject:user];
            
            self.user = user;
            
            NSArray *topics = [result objectForKey:@"recent_topics"];
            NSArray *replies = [result objectForKey:@"recent_replies"];
            
            [self.dataSource addObjectsFromArray:[CNRecent createObjectListWithArray:topics withCreated:YES]];
            [self.dataSource addObjectsFromArray:[CNRecent createObjectListWithArray:replies]];
            
            [self.dataSource sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [[(CNRecent *)obj2 last_reply_at] compare:[(CNRecent *)obj1 last_reply_at]];
            }];
            
            [self.tableView reloadData];
        }
    });
}

- (UIButton *)navigationBarRightButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:@"GitHub-1.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 44, 44)];
    return button;
}

- (void)navigationBarRightButtonHandler:(id)sender {
    if (self.user.githubUsername) {
        NSString *URLString = [NSString stringWithFormat:@"https://github.com/%@", self.user.githubUsername];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
    }
}

#pragma mark -Fill TableViewCell

- (void)fillHeadCell:(CNUserPreviewHeadTableViewCell *)cell {
    
    cell.avatarIV.URLString = self.user.avatar_url;
}

- (void)fillRecentCell:(CNUserPreviewRecentTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    CNRecent *item = [self.dataSource objectAtIndex:indexPath.row];
    cell.avatarIV.URLString = item.avatar_url;
    cell.titleLB.text = item.title;
    cell.nicknameLB.text = item.loginname;
    cell.createdAtLB.text = [item.last_reply_at toShortDatetimeString];

    if (item.created) {
        cell.sourceLB.text = @"最近创建的话题";
    } else {
        cell.sourceLB.text = @"最近参与的话题";
    }
}

#pragma mark -UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.dataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"HeadCell" forIndexPath:indexPath];
        [self fillHeadCell:(CNUserPreviewHeadTableViewCell *)cell];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"RC" forIndexPath:indexPath];
        [self fillRecentCell:(CNUserPreviewRecentTableViewCell *)cell indexPath:indexPath];
    }
    
    return cell;
}

#pragma mark -UItableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:@"HeadCell" cacheByIndexPath:indexPath configuration:^(id cell) {
            [self fillHeadCell:cell];
        }];
    } else {
        return [tableView fd_heightForCellWithIdentifier:@"RC" cacheByIndexPath:indexPath configuration:^(id cell) {
            [self fillRecentCell:cell indexPath:indexPath];
        }];
    }
}

@end
