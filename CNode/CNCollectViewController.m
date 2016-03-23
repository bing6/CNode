//
//  CNCollectViewController.m
//  CNode
//
//  Created by bing.hao on 16/3/23.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNCollectViewController.h"
#import "CNTopicListItemTableViewCell.h"
#import "CNWeb.h"
#import "CNLocalUser.h"
#import "CNStorage.h"

#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>

@interface CNCollectViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation CNCollectViewController

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    //设置TableView
    [self.view addSubview:self.tableView];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerClass:[CNTopicListItemTableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    //加载数据
    [self reloadDataSource];
}

- (void)reloadDataSource {
    
    [self.hud show:YES];
    
    API_GET_TOPIC_COLLLECT([CNLocalUser defaultUser].loginname, ^(id responseObject, NSError *error) {
        if ([[responseObject allKeys] containsObject:@"data"]) {
            [self.hud hide:YES];
            NSArray *result = [responseObject objectForKey:@"data"];
            if (result.count > 0) {
                NSArray *datas = [CNTopic createObjectListWithArray:result];
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:datas];
                [self.tableView reloadData];
            }
        }
    });
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
