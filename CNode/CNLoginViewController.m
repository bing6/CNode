//
//  CNLoginViewController.m
//  CNode
//
//  Created by bing.hao on 16/3/17.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNLoginViewController.h"
#import "CNLocalUser.h"
#import "CNQRCodeViewController.h"
#import "NSString+CN.h"
#import "CNWeb.h"
#import "CNStorage.h"

#import <SVGKit/SVGKit.h>

@interface CNLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *tokenTF;
@property (nonatomic, strong) UIButton *loginBTN;
@property (nonatomic, strong) UIButton *qrcodeBTN;
//@property (nonatomic, strong) UIView *logoVW;
//@property (nonatomic, strong) UIImageView *logoIV;

@property (nonatomic, strong) SVGKImageView *logoIV;

@end

@implementation CNLoginViewController

+ (BOOL)showLoginViewControllerWithParent:(UIViewController *)parentViewController {
    
    if ([CNLocalUser defaultUser] == nil) {
        CNLoginViewController *vc = [CNLoginViewController new];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [parentViewController presentViewController:nav animated:YES completion:nil];
        return YES;
    }
    return NO;
}

- (SVGKImageView *)logoIV {
    if (_logoIV == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cnodejs" ofType:@"svg"];
        SVGKImage *img = [SVGKImage imageWithContentsOfFile:path];
        _logoIV = [[SVGKFastImageView alloc] initWithSVGKImage:img];
    }
    return _logoIV;
}

- (UITextField *)tokenTF {
    if (_tokenTF == nil) {
        _tokenTF = [[UITextField alloc] init];
        _tokenTF.delegate = self;
        _tokenTF.borderStyle = UITextBorderStyleRoundedRect;
        _tokenTF.placeholder = @"Access Token:";
    }
    return _tokenTF;
}

- (UIButton *)qrcodeBTN {
    if (_qrcodeBTN == nil) {
        _qrcodeBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qrcodeBTN setTitle:@"二维码扫描" forState:UIControlStateNormal];
        [_qrcodeBTN setTitleColor:RGBA(128, 189, 1, 1) forState:UIControlStateNormal];
        [_qrcodeBTN setBorderColor:RGBA(128, 189, 1, 1)];
        [_qrcodeBTN setBorderWidth:SINGLE_LINE_WIDTH];
        [_qrcodeBTN setRadius:5.0f];
        [_qrcodeBTN addTarget:self action:@selector(qrcodeBTNHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qrcodeBTN;
}

- (UIButton *)loginBTN {
    if (_loginBTN == nil) {
        _loginBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBTN setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBTN setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
        [_loginBTN setBackgroundColor:RGBA(128, 189, 1, 1)];
        [_loginBTN setBorderColor:RGBA(128, 189, 1, 1)];
        [_loginBTN setBorderWidth:SINGLE_LINE_WIDTH];
        [_loginBTN setRadius:5.0f];
        [_loginBTN addTarget:self action:@selector(loginBTNHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBTN;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.logoIV];
    [self.view addSubview:self.tokenTF];
    [self.view addSubview:self.qrcodeBTN];
    [self.view addSubview:self.loginBTN];

    WS(ws);

    [self.logoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.top.equalTo(ws.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(427.3/2, 100.4/2));
    }];
    [self.tokenTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view);
        make.top.equalTo(ws.logoIV.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(240, 44));
    }];
    [self.qrcodeBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.tokenTF);
        make.top.equalTo(ws.tokenTF.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(115, 40));
    }];
    [self.loginBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.tokenTF);
        make.top.equalTo(ws.tokenTF.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(115, 40));
    }];
}

- (void)navigationBarLeftButtonHandler:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *)registerNotifications {
    return @[ @"QR_Success" ];
}

- (void)receiveNotificationHandler:(NSNotification *)notice {
    if ([notice.name isEqualToString:@"QR_Success"]) {
        [self testToken:notice.object];
    }
}

#pragma mark - Button click.

- (void)qrcodeBTNHandler:(id)sender {
    [self presentViewController:[CNQRCodeViewController new] animated:NO completion:nil];
}

- (void)loginBTNHandler:(id)sender {
    [self.tokenTF resignFirstResponder];
    if (![NSString isNullOrEmpty:self.tokenTF.text]) {
        [self testToken:self.tokenTF.text];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (SCREEN_HEIGHT <= 480) {
        WS(ws);
        [self.logoIV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.view).offset(-50);
        }];
        [UIView animateWithDuration:0.3f animations:^{
            [ws.view layoutIfNeeded];
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (SCREEN_HEIGHT <= 480) {
        WS(ws);
        [self.logoIV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.view).offset(20);
        }];
        [UIView animateWithDuration:0.3f animations:^{
            [ws.view layoutIfNeeded];
        }];
    }
}

- (void)testToken:(NSString *)token {
    
    [self.hud show:YES];
    //验证Token
    API_POST_ACCESSTOKEN(token, ^(id responseObject, NSError *error) {

        if (error) {
            if (error.code == 403) {
                [self showToast:[responseObject objectForKey:@"error_msg"] callback:nil];
            } else {
                [self showToast:error.description callback:nil];
            }
        } else {
            NSString *loginname = [responseObject objectForKey:@"loginname"];
            NSString *accesstoken = token;
            NSString *userId = [responseObject objectForKey:@"id"];
            //本地登录并缓存登录状态
            [CNLocalUser singInWithAccessToken:accesstoken loginname:loginname userId:userId];
            //读取用户信息并缓存
            API_GET_USER(loginname, ^(id responseObject, NSError *error) {
                CNUser *user = [[CNUser alloc] initWithDictionary:[responseObject objectForKey:@"data"]];
                [CNStorage saveUserWithObject:user];
                [self.hud hide:YES];
                //发送通知登录完成
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:loginname];
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }
    });
}

@end
