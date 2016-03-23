//
//  NSString+KS.h
//  KSToolkit
//
//  Created by bing.hao on 14/12/5.
//  Copyright (c) 2014年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CN)

/**
 * @brief 判断是否为一个可用的字符串
 */
+ (BOOL)isNullOrEmpty:(NSString *)str;

/**
 * @brief 获取一个GUID
 */
+ (NSString *)GUID;

/**
 * @brief MD5加密
 */
+ (id)MD5EncryptionWithString:(NSString *)str;

/**
 * @brief MD5加密
 */
- (NSString *)toMD5Encryption;

@end
