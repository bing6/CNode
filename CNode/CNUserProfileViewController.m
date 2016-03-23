//
//  CNUserProfileViewController.m
//  CNode
//
//  Created by bing.hao on 16/3/16.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNUserProfileViewController.h"
#import "CNLoginViewController.h"
#import "CNLocalUser.h"
#import "CNStorage.h"

#import <UIImageView+WebCache.h>

#define CN_USER_AVATAR 101
#define CN_USER_GITHUB 102
#define CN_USER_SCORE 103
#define CN_USER_COLLECT 104
#define CN_MESSAGE 201
#define CN_SETTINGS_EXIT 301
#define CN_SETTINGS_CLEAR 302

@interface CNUserProfileViewController ()

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation CNUserProfileViewController

- (NSArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = @[ @(CN_USER_AVATAR),
                         @(CN_USER_GITHUB),
                         @(CN_USER_SCORE),
                         @(CN_USER_COLLECT),
//                         @(CN_MESSAGE),
                         @(CN_SETTINGS_CLEAR),
                         @(CN_SETTINGS_EXIT) ];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [CNLocalUser defaultUser].loginname;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([CNLocalUser defaultUser]) {
        return [self.dataSource count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([[self.dataSource objectAtIndex:indexPath.row] integerValue]) {
        case CN_USER_AVATAR: return 100.0f;
        case CN_SETTINGS_EXIT: return 80.0f;
        default:
            return 60.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch ([[self.dataSource objectAtIndex:indexPath.row] integerValue]) {
        case CN_USER_AVATAR:
        {
            UIImageView *iv = [UIImageView new];
            
            NSString *avatar_url = [CNLocalUser defaultUser].info.avatar_url;
            NSURL *URL = [NSURL URLWithString:avatar_url];
            
            [cell.contentView addSubview:iv];
            [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(cell.contentView);
                make.size.mas_equalTo(CGSizeMake(50, 50));
            }];
            [iv sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"icon-50.png"]];
            break;
        }
        case CN_USER_GITHUB:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"GitHub:%@", [CNLocalUser defaultUser].info.githubUsername];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case CN_USER_SCORE:
        {
            cell.textLabel.text = [NSString stringWithFormat:@"积分:%d", (int)[CNLocalUser defaultUser].info.score];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            break;
        }
        case CN_MESSAGE:
        {
            UIView *badgeNumberView = [UIView new];
            badgeNumberView.backgroundColor = [UIColor redColor];
            badgeNumberView.radius = 5;
            badgeNumberView.hidden = YES;
            
            [cell.contentView addSubview:badgeNumberView];
            [badgeNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView).offset(-10);
                make.centerY.equalTo(cell.contentView);
                make.size.mas_equalTo(CGSizeMake(10, 10));
            }];
            cell.textLabel.text = @"消息";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case CN_USER_COLLECT:
        {
            cell.textLabel.text = @"我的收藏";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case CN_SETTINGS_CLEAR:
        {
            cell.textLabel.text = @"清除缓存";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            break;
        }
        case CN_SETTINGS_EXIT:
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            
            [button setBackgroundColor:[UIColor redColor]];
            [button setTitle:@"退出登录" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [cell.contentView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(30);
                make.right.equalTo(cell.contentView).offset(-30);
                make.height.mas_equalTo(44);
            }];
            break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([[self.dataSource objectAtIndex:indexPath.row] integerValue]) {
        case CN_USER_GITHUB: {
            NSString *github = [CNLocalUser defaultUser].info.githubUsername;
            NSString *URLString = [NSString stringWithFormat:@"https://github.com/%@", github];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
            break;
        }
        case CN_USER_COLLECT: {
            
            [self pushWithName:@"CNCollectViewController"];
            break;
        }
        case CN_SETTINGS_CLEAR: {
            
            [self.hud show:YES];
            [CNStorage clearLocaldata:^{
                [self.hud hide:YES];
            }];
            break;
        }
        case CN_SETTINGS_EXIT: {
            
            [CNLocalUser singOut];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LogOutSuccess" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }
}

@end
