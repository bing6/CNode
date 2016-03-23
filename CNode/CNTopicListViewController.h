//
//  ViewController.h
//  CNode
//
//  Created by bing.hao on 16/3/14.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNBaseViewController.h"

@interface CNTopicListViewController : CNBaseViewController

//@property (nonatomic, strong) NSString *tab; //主题分类。目前有 ask share job good

+ (instancetype)create:(NSString *)tab;

- (void)reloadDataSource;

@end

