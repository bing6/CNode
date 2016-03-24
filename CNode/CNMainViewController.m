//
//  UIMainViewController.m
//  CNode
//
//  Created by bing.hao on 16/3/17.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNMainViewController.h"
#import "CNTopicListViewController.h"
#import "CNLocalUser.h"
#import "CNWeb.h"
#import "CNLoginViewController.h"

#import <HTHorizontalSelectionList/HTHorizontalSelectionList.h>

static NSString *identifier = @"Page";

@interface CNMainViewController ()
<
    HTHorizontalSelectionListDataSource,
    HTHorizontalSelectionListDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout,
    UIScrollViewDelegate
>

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) HTHorizontalSelectionList *selectionList;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataSource;

//@property (nonatomic, weak) UIView *badgeNV;

@end

@implementation CNMainViewController

- (HTHorizontalSelectionList *)selectionList {
    if (_selectionList == nil) {
        _selectionList = [[HTHorizontalSelectionList alloc] init];
        _selectionList.dataSource = self;
        _selectionList.delegate = self;
        
//        _selectionList.selectionIndicatorColor = RGBA(68, 68, 68, 1);
////        _selectionList.selectionIndicatorStyle = HTHorizontalSelectionIndicatorStyleButtonBorder;
//        _selectionList.selectionIndicatorAnimationMode = HTHorizontalSelectionIndicatorAnimationModeLightBounce;
//        _selectionList.showsEdgeFadeEffect = YES;
//        
////        self.textSelectionList.selectionIndicatorColor = [UIColor redColor];
//        [_selectionList setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//        [_selectionList setTitleFont:[UIFont systemFontOfSize:13] forState:UIControlStateNormal];
//        [_selectionList setTitleFont:[UIFont boldSystemFontOfSize:13] forState:UIControlStateSelected];
//        [_selectionList setTitleFont:[UIFont boldSystemFontOfSize:13] forState:UIControlStateHighlighted];
    }
    return _selectionList;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
    }
    return _collectionView;
}

- (NSArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = @[ [CNTopicListViewController create:@"全部"],
                         [CNTopicListViewController create:@"精华"],
                         [CNTopicListViewController create:@"分享"],
                         [CNTopicListViewController create:@"问答"],
                         [CNTopicListViewController create:@"招聘"] ];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"CNode";
    
    [self.view addSubview:self.selectionList];
    [self.view addSubview:self.collectionView];
    
    WS(ws);
    
    [self.selectionList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view);
        make.right.equalTo(ws.view);
        make.top.equalTo(ws.view);
        make.height.mas_equalTo(40);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.selectionList.mas_bottom);
        make.left.equalTo(ws.view);
        make.right.equalTo(ws.view);
        make.bottom.equalTo(ws.view);
    }];
    
    for (int i = 0; i < self.dataSource.count; i++) {
        [self addChildViewController:self.dataSource[i]];
    }
    
    [self autoSignIn];
//    [self newMessage];
}

/**
 *  自动登录
 */
- (void)autoSignIn {
    [CNLocalUser autoSignIn];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    //消息提醒
//    if ([CNLocalUser defaultUser]) {
//        if ([CNLocalUser defaultUser].unreadMessageCount > 0) {
//            self.badgeNV.hidden = NO;
//        } else {
//            self.badgeNV.hidden = YES;
//        }
//    }
//}
//
///**
// *  轮询读取消息
// */
//- (void)newMessage {
//    if ([CNLocalUser defaultUser] && _timer == nil) {
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(timeHandler) userInfo:nil repeats:YES];
//    }
//}
//
//- (void)timeHandler {
//    
//    API_GET_MESSAGE_COUNT(^(id responseObject, NSError *error) {
//        //这里判断是否有用户登录是因为,有时网络慢请求没回来,
//        //但是用户已经退出
//        if ([CNLocalUser defaultUser]) {
//            [CNLocalUser defaultUser].unreadMessageCount = [[responseObject objectForKey:@"data"] integerValue];
//            if ([CNLocalUser defaultUser].unreadMessageCount > 0) {
//                self.badgeNV.hidden = NO;
//            } else {
//                self.badgeNV.hidden = YES;
//            }
//        }
//    });
//}

#pragma mark - override BaseViewController

- (NSArray *)registerNotifications {
    return @[ @"LoginSuccess", @"LogOutSuccess" ];
}

- (void)receiveNotificationHandler:(NSNotification *)notice {
    if ([notice.name isEqualToString:@"LoginSuccess"]) {
//        [self newMessage];
        return;
    }
    if ([notice.name isEqualToString:@"LogOutSuccess"]) {
//        [_timer invalidate];
//        [self setTimer:nil];
    }
}

- (UIButton *)navigationBarLeftButton {
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    //消息提醒
//    UIView *badgeNumberView = [UIView new];
//    badgeNumberView.backgroundColor = [UIColor redColor];
//    badgeNumberView.frame = CGRectMake(17, 10, 10, 10);
//    badgeNumberView.radius = 5;
//    badgeNumberView.hidden = YES;
//    self.badgeNV = badgeNumberView;
//    
//    [backButton addSubview:badgeNumberView];
    [backButton setFrame:CGRectMake(0, 0, 22, 44)];
    [backButton setImage:[UIImage imageNamed:@"chakan.png"] forState:UIControlStateNormal];
    return backButton;
}

- (UIButton *)navigationBarRightButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setFrame:CGRectMake(0, 0, 32, 32)];
    [button setImage:[UIImage imageNamed:@"reolayImage.png"] forState:UIControlStateNormal];
    return button;
}

- (void)navigationBarLeftButtonHandler:(id)sender {
    if (![CNLoginViewController showLoginViewControllerWithParent:self]) {
        [self pushWithName:@"CNUserProfileViewController"];
    }
}

- (void)navigationBarRightButtonHandler:(id)sender {
    if (![CNLoginViewController showLoginViewControllerWithParent:self]) {
        [self pushWithName:@"CNTopicEditViewController"];
    }
}

#pragma mark - HTHorizontalSelectionListDataSource Protocol Methods

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList {
    return self.dataSource.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index {
    return [self.dataSource[index] title];
}

#pragma mark - HTHorizontalSelectionListDelegate Protocol Methods

- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    // update the view for the corresponding index
    
    [self.collectionView setContentOffset:CGPointMake(self.selectionList.selectedButtonIndex * SCREEN_WIDTH, 0)];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIViewController *vc = [self.dataSource objectAtIndex:indexPath.row];
    
    vc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 104);
    [cell addSubview:vc.view];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 104);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = (scrollView.contentOffset.x / SCREEN_WIDTH);
    
    [self.selectionList setSelectedButtonIndex:index animated:YES];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointMake(self.selectionList.selectedButtonIndex * SCREEN_HEIGHT, 0)];
}

@end
