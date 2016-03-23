//
//  CNTopicDetailViewController.m
//  CNode
//
//  Created by bing.hao on 16/3/15.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNTopicDetailViewController.h"
#import "CNTopicDetailTableViewCell.h"
#import "CNTopicDetailReplyTableViewCell.h"
#import "CNStorage.h"
#import "CNWeb.h"
#import "CNLocalUser.h"
#import "CNLoginViewController.h"
#import "CNTopicDetailToolbarView.h"
#import "NSDate+CN.h"
#import "NSString+CN.h"

#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import <AFNetworking/AFNetworking.h>
#import <UIImageView+WebCache.h>

#import <AttributedMarkdown/markdown_lib.h>
#import <AttributedMarkdown/markdown_peg.h>

@interface CNTopicDetailViewController ()<UIWebViewDelegate>

/**
 *  评论数据
 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/**
 *  是否加载过话题内容
 */
@property (nonatomic, assign) BOOL isLoadContent;
/**
 *  话题内容的高度
 */
@property (nonatomic, assign) CGFloat bodyHeight;

/**
 *  收藏按钮
 */
@property (nonatomic, weak) UIButton *favoriteBTN;
/**
 *  评论工具条
 */
@property (nonatomic, strong) CNTopicDetailToolbarView *replyTV;
/**
 *  取消编辑手势
 */
@property (nonatomic, strong) UITapGestureRecognizer *cancelEditTGR;
/**
 *  选中要回复的评论ID
 */
@property (nonatomic, strong) NSString *tempReplyId;

@end

@implementation CNTopicDetailViewController

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (CNTopicDetailToolbarView *)replyTV {
    if (_replyTV == nil) {
        _replyTV = [CNTopicDetailToolbarView new];
        [_replyTV.sendBTN addTarget:self action:@selector(replyButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _replyTV;
}

- (UITapGestureRecognizer *)cancelEditTGR {
    if (_cancelEditTGR == nil) {
        _cancelEditTGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelEditTGRHandler:)];
    }
    return _cancelEditTGR;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"话题";
    //设置布局
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.replyTV];
    
    WS(ws);
    
    [self.view addGestureRecognizer:self.cancelEditTGR];
    
    [self.replyTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.view);
        make.left.equalTo(ws.view);
        make.right.equalTo(ws.view);
        make.height.mas_equalTo(50);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(ws.view).insets(UIEdgeInsetsZero);
        make.left.equalTo(ws.view);
        make.right.equalTo(ws.view);
        make.top.equalTo(ws.view);
        make.bottom.equalTo(ws.replyTV.mas_top);
    }];
    
    [self.tableView registerClass:[CNTopicDetailReplyTableViewCell class] forCellReuseIdentifier:@"RC"];
    [self.tableView registerClass:[CNTopicDetailTableViewCell class] forCellReuseIdentifier:@"DC"];
    
    [self reloadDataSource];
    
    /**
     *  判断用户是否收藏了这个话题
     */
    if ([CNLocalUser defaultUser]) {
        [CNStorage fetchFavoriteWithLoginname:[CNLocalUser defaultUser].loginname
                                  withTopicId:self.dataItem.topicId
                                     callback:^(id result) {
                                         if (result) {
                                             [self.favoriteBTN setSelected:YES];
                                         }
                                  }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(receiveNotificationHandler:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(receiveNotificationHandler:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -Override BaseViewController

- (UIButton *)navigationBarRightButton {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setFrame:CGRectMake(0, 0, 26, 26)];
    [button setImage:[UIImage imageNamed:@"shoucang.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"shoucang-.png"] forState:UIControlStateSelected];
    
    self.favoriteBTN = button;
    
    return button;
}

- (void)navigationBarRightButtonHandler:(UIButton *)sender {
    
    WS(ws);
    
    if (![CNLoginViewController showLoginViewControllerWithParent:self]) {
        if (sender.selected) {
            API_POST_TOPIC_COLLECT_DE(self.dataItem.topicId, ^(id responseObject, NSError *error) {
                [CNStorage removeFavoriteWithLoginname:[CNLocalUser defaultUser].loginname
                                           withTopicId:ws.dataItem.topicId
                                              callback:^{
                                                  
                                              }];
            });
        } else {
            API_POST_TOPIC_COLLECT(self.dataItem.topicId, ^(id responseObject, NSError *error) {
                [CNStorage saveFavoriteWithLoginname:[CNLocalUser defaultUser].loginname
                                         withTopicId:ws.dataItem.topicId
                                            callback:^{
                                                
                                            }];
            });
        }
        sender.selected = !sender.selected;
    }
}

- (void)receiveNotificationHandler:(NSNotification *)notice {
    
    if ([notice.name isEqualToString:UIKeyboardWillShowNotification]) {
        
        NSDictionary * userInfo = notice.userInfo;
        
        CGRect  frameEndUserInfo = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat duration         = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGFloat cure             = [userInfo[UIKeyboardAnimationCurveUserInfoKey] floatValue];
     
        [self.replyTV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50 + frameEndUserInfo.size.height);
        }];
        
        [UIView animateWithDuration:duration animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationCurve:cure];
            [self.replyTV layoutIfNeeded];
        }];
    }
    if ([notice.name isEqualToString:UIKeyboardWillHideNotification]) {
        
        NSDictionary * userInfo = notice.userInfo;
        
        CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGFloat cure     = [userInfo[UIKeyboardAnimationCurveUserInfoKey] floatValue];
        
        [self.replyTV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
        }];
        
        [UIView animateWithDuration:duration animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationCurve:cure];
            [self.replyTV layoutIfNeeded];
        }];
    }
}

#pragma mark -数据加载 

- (void)reloadDataSource {
    
    API_GET_TOPIC_BY_ID(self.dataItem.topicId, ^(id responseObject, NSError *error) {
        if ([[responseObject allKeys] containsObject:@"data"]) {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            NSArray *reply = [data objectForKey:@"replies"];
            CNTopic *topic = [[CNTopic alloc] initWithDictionary:data];
            self.dataItem.visit_count = topic.visit_count;
            self.dataItem.reply_count = topic.reply_count;
            if (reply.count > 0) {
                NSArray *results = [CNReply createObjectListWithArray:reply];
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:results];
                [CNStorage saveReply:results];
            }
            if ([data.allKeys containsObject:@"is_collect"] && [[data objectForKey:@"is_collect"] boolValue]) {
                [CNStorage saveFavoriteWithLoginname:[CNLocalUser defaultUser].loginname
                                         withTopicId:self.dataItem.topicId
                                            callback:^{
                                                
                                            }];
                [self.favoriteBTN setSelected:YES];
            }
            [self.tableView reloadData];
        }
    });
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    CGFloat height = [height_str floatValue];
    self.bodyHeight = height;
    [webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height).priorityHigh();
    }];
    [self.tableView reloadData];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DC"];
        [self fillCell:(CNTopicDetailTableViewCell *)cell];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"RC"];
        [self fillReplyCell:(CNTopicDetailReplyTableViewCell *)cell indexPath:indexPath];
    }
    
    return cell;
}

- (void)fillReplyCell:(CNTopicDetailReplyTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    CNReply *item = [self.dataSource objectAtIndex:indexPath.row];
    
    cell.nicknameLB.text = item.loginname;
    cell.createdAtLB.text = [item.create_at toShortDatetimeString];
    cell.contentLB.attributedText = markdown_to_attr_string(item.content, 0, nil);
    cell.avatarIV.URLString = item.avatar_url;
    
    WS(ws);
    [cell.nicknameLB onClick:^{
        [ws pushWithName:@"CNUserPreviewViewController" params:@{ @"avatar" : item.avatar_url, @"loginname" : item.loginname}];
    }];
    [cell.avatarIV onClick:^{
        [ws pushWithName:@"CNUserPreviewViewController" params:@{ @"avatar" : item.avatar_url, @"loginname" : item.loginname}];
    }];
    [cell.commentsBTN onClick:^{
        ws.replyTV.contentTF.placeholder = [NSString stringWithFormat:@"@%@", item.loginname];
        ws.tempReplyId = item.pid;
    }];
    
}

- (void)fillCell:(CNTopicDetailTableViewCell *)cell {
 
    if (self.dataItem.is_top) {
        cell.tabLB.text = @"置顶";
        cell.tabLB.backgroundColor = RGBA(128, 189, 1, 1);
        cell.tabLB.textColor = RGBA(255, 255, 255, 1);
    } else if (self.dataItem.is_good) {
        cell.tabLB.text = @"精华";
        cell.tabLB.backgroundColor = RGBA(128, 189, 1, 1);
        cell.tabLB.textColor = RGBA(255, 255, 255, 1);
    } else {
        if ([self.dataItem.tab isEqualToString:@"ask"]) {
            cell.tabLB.text = @"问答";
        } else if ([self.dataItem.tab isEqualToString:@"share"]) {
            cell.tabLB.text = @"分享";
        } else if ([self.dataItem.tab isEqualToString:@"job"]) {
            cell.tabLB.text = @"招聘";
        } else {
            cell.tabLB.text = @"其他";
        }
        
        cell.tabLB.backgroundColor = RGBA(229, 229, 229, 1);
        cell.tabLB.textColor = RGBA(153, 153, 153, 1);
    }

    cell.titleLB.text = self.dataItem.title;
    cell.statisticsLB.text = [NSString stringWithFormat:@"浏览量:%@", @(self.dataItem.visit_count)];
    cell.nicknameLB.text = [NSString stringWithFormat:@"%@", self.dataItem.loginname];
    cell.createdAtLB.text = [self.dataItem.create_at toString];
    cell.avatarIV.URLString = self.dataItem.avatar_url;

    WS(ws);
    
    [cell.avatarIV onClick:^{
        [ws pushWithName:@"CNUserPreviewViewController" params:@{ @"avatar" : self.dataItem.avatar_url, @"loginname" : self.dataItem.loginname}];
    }];
    
    if (!self.isLoadContent) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"t" ofType:@"html"];
        NSString *temp = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSString *cnt  = [self.dataItem.content stringByReplacingOccurrencesOfString:@"src=\"//" withString:@"src=\"http://"];
        NSString *html = [NSString stringWithFormat:temp, cnt];
        
        [cell.bodyWV setDelegate:self];
        [cell.bodyWV loadHTMLString:html baseURL:nil];
        self.isLoadContent = YES;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.bodyHeight + [tableView fd_heightForCellWithIdentifier:@"DC" configuration:^(id cell) {
            [self fillCell:(CNTopicDetailTableViewCell *)cell];
        }];
    } else {
        return [tableView fd_heightForCellWithIdentifier:@"RC" cacheByIndexPath:indexPath configuration:^(id cell) {
            [self fillReplyCell:(CNTopicDetailReplyTableViewCell *)cell indexPath:indexPath];
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10.0f;
    }
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [UIView new];
        view.backgroundColor = RGBA(230, 230, 230, 1);
        return view;
    }
    return [UIView new];
}

#pragma mark - 评论按钮事件

- (void)replyButtonHandler:(UIButton *)sender {
    
    [self.replyTV.contentTF resignFirstResponder];
    
    if (![CNLoginViewController showLoginViewControllerWithParent:self]) {
        NSString *content = self.replyTV.contentTF.text;
        //去左右空格
        content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([NSString isNullOrEmpty:content]) {
            self.replyTV.contentTF.text = @"";
            [self showToast:@"请输入评论内容" callback:nil];
            return;
        }
        
        CNReply *reply = [CNReply new];
        
        reply.pid = nil;
        reply.topicId = self.dataItem.topicId;
        reply.loginname = [CNLocalUser defaultUser].loginname;
        reply.avatar_url = [CNLocalUser defaultUser].info.avatar_url;
        reply.content = content;
        reply.create_at = [NSDate date];
        reply.reply_id = self.tempReplyId;
        
        [self.dataSource addObject:reply];
        [self.tableView reloadData];
        
        NSString *tid = [self.dataItem.topicId copy];
        NSString *rid = [self.tempReplyId copy];
        
        WS(ws);
        
        API_POST_TOPIC_REPLY(tid, content, rid, ^(id responseObject, NSError *error) {
            if (error) {
                [ws.dataSource removeObject:reply];
                [ws.tableView reloadData];
                [ws showToast:[responseObject objectForKey:@"error_msg"] callback:nil];
            } else {
                if ([[responseObject objectForKey:@"success"] boolValue]) {
                    reply.pid = [responseObject objectForKey:@"reply_id"];
                    [CNStorage saveReply:@[ reply ]];
                }
            }
        });
        
        self.tempReplyId = nil;
        self.replyTV.contentTF.text = @"";
        self.replyTV.contentTF.placeholder = @"";
    }
}


#pragma mark - 取消编辑

- (void)cancelEditTGRHandler:(UITapGestureRecognizer *)recognizer {
    if ([self.replyTV.contentTF canResignFirstResponder]) {
        [self.replyTV.contentTF resignFirstResponder];
    }
}

@end
