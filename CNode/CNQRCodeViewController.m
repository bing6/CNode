//
//  CNQRCodeViewController.m
//  CNode
//
//  Created by bing.hao on 16/3/16.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CNQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) UIButton *cancelBTN;
@property (nonatomic, strong) UILabel *descLB;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPL;

@end

@implementation CNQRCodeViewController

- (UIButton *)cancelBTN {
    if (_cancelBTN == nil) {
        _cancelBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_cancelBTN setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBTN setTitleColor:RGBA(68, 68, 68, 1) forState:UIControlStateNormal];
        [_cancelBTN setBackgroundColor:RGBA(255, 255, 255, 1)];
        [_cancelBTN addTarget:self action:@selector(cancelButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        
        VIEW_BORDER_RADIUS(_cancelBTN, 5, SINGLE_LINE_WIDTH, RGBA(235, 235, 235, 1));
    }
    return _cancelBTN;
}

- (UILabel *)descLB {
    if (_descLB == nil) {
        _descLB = [UILabel new];
        _descLB.text = @"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
        _descLB.textColor = RGBA(255, 255, 255, 1);
        _descLB.backgroundColor = [UIColor clearColor];
        _descLB.numberOfLines = 0;
        _descLB.textAlignment = NSTextAlignmentCenter;
        _descLB.font = [UIFont systemFontOfSize:14];
    }
    return _descLB;
}

- (AVCaptureVideoPreviewLayer *)videoPL {
    if (_videoPL == nil) {
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input;
        AVCaptureMetadataOutput *output;
        AVCaptureSession *session;
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            output = [[AVCaptureMetadataOutput alloc] init];
            
            session = [[AVCaptureSession alloc] init];
            session.sessionPreset = AVCaptureSessionPresetHigh;
            
            if ([session canAddInput:input]) {
                [session addInput:input];
            }
            
            if ([session canAddOutput:output]) {
                [session addOutput:output];
            }
            
            [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
        }
        
        if (session) {
            _videoPL = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
        } else {
            _videoPL = [[AVCaptureVideoPreviewLayer alloc] init];
        }
        
        _videoPL.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _videoPL.frame = CGRectMake(0, 0, 200, 200);
        _videoPL.position = CGPointMake(SCREEN_WIDTH / 2, 190);
        _videoPL.borderColor = [UIColor greenColor].CGColor;
        _videoPL.borderWidth = SINGLE_LINE_WIDTH;
    }
    return _videoPL;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGBA(68, 68, 68, 1);
    
    [self.view addSubview:self.descLB];
    [self.view addSubview:self.cancelBTN];
    
    [self.view.layer addSublayer:self.videoPL];
    [self.videoPL.session startRunning];
    
    WS(ws);
    
    [self.descLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(310);
        make.left.equalTo(ws.view).offset(20);
        make.right.equalTo(ws.view).offset(-20);
    }];
    [self.cancelBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.descLB.mas_bottom).offset(10);
        make.centerX.equalTo(ws.view);
        make.size.mas_equalTo(CGSizeMake(100, 44));
    }];
}

- (void)cancelButtonHandler:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    NSString *str;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        str = metadataObject.stringValue;
    }
    
    [self.videoPL.session stopRunning];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QR_Success" object:str];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
