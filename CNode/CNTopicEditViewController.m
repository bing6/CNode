//
//  CNTopicEditViewController.m
//  CNode
//
//  Created by bing.hao on 16/3/23.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNTopicEditViewController.h"
#import "NSString+CN.h"
#import "CNWeb.h"

@interface CNTopicEditViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UIButton *sharedBTN;
@property (nonatomic, strong) UIButton *askBTN;
@property (nonatomic, strong) UIButton *jobBTN;
@property (nonatomic, strong) UITextField *titleTF;
@property (nonatomic, strong) UITextView *contentTV;

@end

@implementation CNTopicEditViewController

- (UIButton *)sharedBTN {
    if (_sharedBTN == nil) {
        _sharedBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sharedBTN setTitle:@"分享" forState:UIControlStateNormal];
        [_sharedBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sharedBTN setBackgroundColor:RGBA(128, 189, 1, 1)];
        [_sharedBTN addTarget:self action:@selector(buttonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [_sharedBTN setRadius:5];
        [_sharedBTN.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return _sharedBTN;
}

- (UIButton *)askBTN {
    if (_askBTN == nil) {
        _askBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_askBTN setTitle:@"问答" forState:UIControlStateNormal];
        [_askBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_askBTN setBackgroundColor:RGBA(128, 189, 1, 1)];
        [_askBTN addTarget:self action:@selector(buttonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [_askBTN setRadius:5];
        [_askBTN.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return _askBTN;
}

- (UIButton *)jobBTN {
    if (_jobBTN == nil) {
        _jobBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_jobBTN setTitle:@"招聘" forState:UIControlStateNormal];
        [_jobBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_jobBTN setBackgroundColor:RGBA(128, 189, 1, 1)];
        [_jobBTN addTarget:self action:@selector(buttonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [_jobBTN setRadius:5];
        [_jobBTN.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return _jobBTN;
}

- (UITextField *)titleTF {
    if (_titleTF == nil) {
        _titleTF = [[UITextField alloc] init];
        _titleTF.placeholder = @"标题,字数要大于10以上";
        _titleTF.borderStyle = UITextBorderStyleNone;
        _titleTF.delegate = self;
        _titleTF.font = [UIFont systemFontOfSize:14];
    }
    return _titleTF;
}

- (UITextView *)contentTV {
    if (_contentTV == nil) {
        _contentTV = [[UITextView alloc] init];
        _contentTV.delegate = self;
        _contentTV.font = [UIFont systemFontOfSize:14];
        _contentTV.contentInset = UIEdgeInsetsZero;
        _contentTV.textContainerInset = UIEdgeInsetsZero;
        _contentTV.textContainer.lineFragmentPadding = 0;
    }
    return _contentTV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"发布新话题";
    
    [self.view addSubview:self.sharedBTN];
    [self.view addSubview:self.askBTN];
    [self.view addSubview:self.jobBTN];
    [self.view addSubview:self.titleTF];
    [self.view addSubview:self.contentTV];
    
    UIView *sp1 = [UIView new];
    UIView *sp2 = [UIView new];
    
    sp1.backgroundColor = RGBA(232, 232, 232, 1);
    sp2.backgroundColor = RGBA(232, 232, 232, 1);
    
    [self.view addSubview:sp1];
    [self.view addSubview:sp2];
    
    WS(ws);
    
    [self.sharedBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view).offset(10);
        make.top.equalTo(ws.view).offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    [self.askBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.sharedBTN);
        make.centerX.equalTo(ws.sharedBTN).offset(80);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    [self.jobBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(ws.askBTN);
        make.centerX.equalTo(ws.askBTN).offset(80);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    [sp1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.sharedBTN.mas_bottom).offset(10);
        make.left.equalTo(ws.view);
        make.right.equalTo(ws.view);
        make.height.mas_equalTo(SINGLE_LINE_WIDTH);
    }];
    [self.titleTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sp1).offset(5);
        make.left.equalTo(ws.view).offset(10);
        make.right.equalTo(ws.view).offset(-10);
        make.height.mas_equalTo(40);
    }];
    [sp2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.titleTF.mas_bottom).offset(5);
        make.left.equalTo(ws.view);
        make.right.equalTo(ws.view);
        make.height.mas_equalTo(SINGLE_LINE_WIDTH);
    }];
    [self.contentTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sp2).offset(5);
        make.left.equalTo(ws.view).offset(10);
        make.right.equalTo(ws.view).offset(-10);
        make.bottom.equalTo(ws.view).offset(-10);
    }];
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

#pragma mark - BaseViewController

- (UIButton *)navigationBarRightButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 44, 44)];
    return button;
}

- (void)navigationBarRightButtonHandler:(id)sender {
    
    [self.contentTV resignFirstResponder];
    [self.titleTF resignFirstResponder];
    
    NSString *title = self.titleTF.text;
    NSString *content = self.contentTV.text;
    
    title = [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([NSString isNullOrEmpty:title]) {
        [self showToast:@"请输入标题" callback:nil];
        return;
    }
    if ([NSString isNullOrEmpty:content]) {
        [self showToast:@"请输入内容" callback:nil];
        return;
    }
    
    NSArray *buttons = @[ self.sharedBTN, self.askBTN, self.jobBTN ];
    NSString *category = nil;
    for (UIButton *entry in buttons) {
        if (entry.selected) {
            category = entry.titleLabel.text;
            break;
        }
    }
    if (category == nil) {
        [self showToast:@"请选择分类" callback:nil];
        return;
    }
    if ([category isEqualToString:@"分享"]) {
        category = @"shared";
    } else if ([category isEqualToString:@"问答"]) {
        category = @"ask";
    } else {
        category = @"job";
    }
    
    [self.hud show:YES];
    
    API_POST_TOPIC(title, category, content, ^(id responseObject, NSError *error) {
        if (error) {
            [self showToast:[responseObject objectForKey:@"error_msg"] callback:nil];
        } else {
            [self showToast:@"发布完成" callback:^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
    });
}

- (void)receiveNotificationHandler:(NSNotification *)notice {
    
    WS(ws);
    
    if ([notice.name isEqualToString:UIKeyboardWillShowNotification]) {
        
        NSDictionary * userInfo = notice.userInfo;
        
        CGRect  frameEndUserInfo = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat duration         = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGFloat cure             = [userInfo[UIKeyboardAnimationCurveUserInfoKey] floatValue];
        
        
        
        [self.contentTV mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(50 + frameEndUserInfo.size.height);
            make.bottom.equalTo(ws.view).offset(-frameEndUserInfo.size.height);
        }];
        
        [UIView animateWithDuration:duration animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationCurve:cure];
            [self.contentTV layoutIfNeeded];
        }];
    }
    if ([notice.name isEqualToString:UIKeyboardWillHideNotification]) {
        
        NSDictionary * userInfo = notice.userInfo;
        
        CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGFloat cure     = [userInfo[UIKeyboardAnimationCurveUserInfoKey] floatValue];
        
        [self.contentTV mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(50);
            make.bottom.equalTo(ws.view).offset(-10);
        }];
        
        [UIView animateWithDuration:duration animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationCurve:cure];
            [self.contentTV layoutIfNeeded];
        }];
    }
}

#pragma mark - 分类按钮点击

- (void)buttonHandler:(UIButton *)sender {
    
    NSArray *buttons = @[ self.sharedBTN, self.askBTN, self.jobBTN ];
    
    for (UIButton *entry in buttons) {
        if ([entry isEqual:sender]) {
            entry.selected = YES;
            entry.backgroundColor = RGBA(68, 68, 68, 1);
        } else {
            entry.selected = NO;
            entry.backgroundColor = RGBA(128, 189, 1, 1);
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    return YES;
}

@end
