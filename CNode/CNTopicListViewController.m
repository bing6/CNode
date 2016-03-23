//
//  ViewController.m
//  CNode
//
//  Created by bing.hao on 16/3/14.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNTopicListViewController.h"

#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import <UIImageView+WebCache.h>

#import "CNTopicDetailViewController.h"
#import "CNTopicListItemTableViewCell.h"
#import "CNTopic.h"
#import "CNWeb.h"
#import "CNStorage.h"
#import "NSDate+CN.h"
#import <KSRefresh/UIScrollView+KS.h>

@interface CNTopicListViewController ()<KSRefreshViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger page; //页数
@property (nonatomic, assign) NSInteger size; //每一页的主题数量


@end

@implementation CNTopicListViewController

+ (instancetype)create:(NSString *)tab {
    CNTopicListViewController *vc = [CNTopicListViewController new];
    vc.title = tab;
    return vc;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.page = 1;
    self.size = 20;
    //设置TableView
    [self.view addSubview:self.tableView];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerClass:[CNTopicListItemTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    [self.tableView setHeader:[[KSDefaultHeadRefreshView alloc] initWithDelegate:self]];
    [self.tableView setFooter:[[KSAutoFootRefreshView alloc] initWithDelegate:self]];
    //加载数据
    [self performSelector:@selector(reloadDataSource) withObject:nil afterDelay:0.3f];
}

#pragma mark - 加载数据

- (void)reloadDataSource {
    [self reloadLocalDataSource];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.header setState:KSRefreshViewStateLoading];
        [UIView animateWithDuration:0.3f animations:^{
            [self.tableView setContentOffset:CGPointMake(0, -60)];
        }];
    });
}

- (NSString *)getTab {
    NSString *tab = nil;
    if ([self.title isEqualToString:@"精华"]) {
        tab = @"good";
    } else if ([self.title isEqualToString:@"分享"]) {
        tab = @"share";
    } else if ([self.title isEqualToString:@"问答"]) {
        tab = @"ask";
    } else if ([self.title isEqualToString:@"招聘"]) {
        tab = @"job";
    }
    return tab;
}

- (void)reloadOnlineDataSource:(void(^)())callback {

    API_GET_TOPICS(self.page, self.size, [self getTab], ^(id responseObject, NSError *error) {
        if ([[responseObject allKeys] containsObject:@"data"]) {
            NSArray *result = [responseObject objectForKey:@"data"];
            if (result.count > 0) {
                NSArray *datas = [CNTopic createObjectListWithArray:result];
                if (self.page == 1) {
                    [self.dataSource removeAllObjects];
                    [CNStorage saveTopic:datas];
                }
                [self.dataSource addObjectsFromArray:datas];
                [self.tableView reloadData];
            }
            if (callback) {
                callback();
            }
        }
    });
}

- (void)reloadLocalDataSource {
    
    [CNStorage fetchTopicWithPage:self.page
                         withSize:self.size
                              tab:[self getTab]
                         callback:^(NSArray *result) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:result];
        [self.tableView reloadData];
    }];
}

#pragma mark - KSRefreshViewDelegate

- (void)refreshViewDidLoading:(id)view {
    
    WS(ws);
    
    if ([view isEqual:self.tableView.header]) {
        ws.page = 1;
        [ws.tableView.footer setIsLastPage:NO];
        [ws reloadOnlineDataSource:^{
            [ws.tableView.header setState:KSRefreshViewStateDefault];
        }];
    } else {
        ws.page++;
        [ws reloadOnlineDataSource:^{
            [ws.tableView.footer setState:KSRefreshViewStateDefault];
            if ([self.dataSource count] % 20 != 0) {
                [ws.tableView.footer setIsLastPage:YES];
            }
        }];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CNTopicListItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [self fillCell:cell index:indexPath.row];
    return cell;
}

- (void)fillCell:(CNTopicListItemTableViewCell *)cell index:(NSInteger)row{
    
    CNTopic *dataItem = [self.dataSource objectAtIndex:row];
    
    if (dataItem.is_top) {
        cell.tabLB.text = @"置顶";
        cell.tabLB.backgroundColor = RGBA(128, 189, 1, 1);
        cell.tabLB.textColor = RGBA(255, 255, 255, 1);
    } else if (dataItem.is_good) {
        cell.tabLB.text = @"精华";
        cell.tabLB.backgroundColor = RGBA(128, 189, 1, 1);
        cell.tabLB.textColor = RGBA(255, 255, 255, 1);
    } else {
        if ([dataItem.tab isEqualToString:@"ask"]) {
            cell.tabLB.text = @"问答";
        } else if ([dataItem.tab isEqualToString:@"share"]) {
            cell.tabLB.text = @"分享";
        } else if ([dataItem.tab isEqualToString:@"job"]) {
            cell.tabLB.text = @"招聘";
        } else {
            cell.tabLB.text = @"其他";
        }
        
        cell.tabLB.backgroundColor = RGBA(229, 229, 229, 1);
        cell.tabLB.textColor = RGBA(153, 153, 153, 1);
    }
    
    cell.titleLB.text = dataItem.title;
//    cell.statisticsLB.text = [NSString stringWithFormat:@"%@ / %@", @(dataItem.reply_count), @(dataItem.visit_count)];
    cell.nicknameLB.text = dataItem.loginname;
    cell.createdAtLB.text = [dataItem.create_at toShortDatetimeString];
    cell.avatarIV.URLString = dataItem.avatar_url;
    
    WS(ws);
    
    [cell.avatarIV onClick:^{
        [ws pushWithName:@"CNUserPreviewViewController" params:@{ @"avatar" : dataItem.avatar_url, @"loginname" : dataItem.loginname}];
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CNTopic *dataItem = [self.dataSource objectAtIndex:indexPath.row];

    [self pushWithName:@"CNTopicDetailViewController" params:@{ @"dataItem" : dataItem }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"Cell" cacheByIndexPath:indexPath configuration:^(id cell) {
        [self fillCell:cell index:indexPath.row];
    }];
}

@end
