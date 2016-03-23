//
//  UIScrollView+KS.h
//  KSRefresh
//
//  Created by bing.hao on 15/4/6.
//  Copyright (c) 2015年 bing.hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSDefaultHeadRefreshView.h"
#import "KSDefaultFootRefreshView.h"
#import "KSAutoFootRefreshView.h"

//Demo
//- (void)refreshViewDidLoading:(id)view
//{
//    if ([view isEqual:self.tableView.header]) {
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            [self.dataSource removeAllObjects];
//            [self addData];
//            
//            if (self.tableView.footer) {
//                if (self.dataSource.count >= 30) {
//                    self.tableView.footer.isLastPage = YES;
//                } else {
//                    self.tableView.footer.isLastPage = NO;
//                }
//            }
//            
//            [self.tableView reloadData];
//            [self.tableView.header setState:RefreshViewStateDefault];
//            [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
//        });
//        
//        return;
//    }
//    
//    if ([view isEqual:self.tableView.footer]) {
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            if (self.dataSource.count >= 30) {
//                
//                [self.tableView.footer setIsLastPage:YES];
//                [self.tableView reloadData];
//            } else {
//                [self addData];
//                [self.tableView.footer setState:RefreshViewStateDefault];
//                [self.tableView reloadData];
//            }
//        });
//    }
//}

@interface UIScrollView (KS)

@property (nonatomic, strong) KSHeadRefreshView * header;
@property (nonatomic, strong) KSFootRefreshView * footer;

- (void)headerFinishedLoading;
- (void)footerFinishedLoading;

@end
