//
//  CNTopicDetailToolbarView.h
//  CNode
//
//  Created by bing.hao on 16/3/22.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CNTopicDetailToolbarView : UIView<UITextFieldDelegate>

@property (nonatomic, strong, readonly) UITextField *contentTF;
@property (nonatomic, strong, readonly) UIButton *sendBTN;

@end
