//
//  NSDate+CN.h
//  CNode
//
//  Created by bing.hao on 16/3/15.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSDate_STR_FORMAT @"yyyy-MM-dd HH:mm:ss"

@interface NSDate (CN)

/**
 *  将字符串转换为时间对象
 *
 *  @param str 字符串
 *
 *  @return NSDate
 */
+ (NSDate *)dateWithString:(NSString *)str;

/**
 *  将字符串转换为时间对象
 *
 *  @param str    字符串
 *  @param format 格式
 *
 *  @return NSDate
 */
+ (NSDate *)dateWithString:(NSString *)str withFormat:(NSString *)format;

/**
 *  将时间转换为字符串
 *
 *  @return NSString
 */
- (NSString *)toString;

/**
 *  自定义输出时间格式
 *
 *  @return
 */
- (NSString *)toShortDatetimeString;

@end
