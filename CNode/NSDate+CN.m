//
//  NSDate+CN.m
//  CNode
//
//  Created by bing.hao on 16/3/15.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "NSDate+CN.h"

@implementation NSDate (CN)

+ (NSDate *)dateWithString:(NSString *)str
{
    return [self dateWithString:str withFormat:NSDate_STR_FORMAT];
}

+ (NSDate *)dateWithString:(NSString *)str withFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:str];
}

- (NSString *)toString
{
    return [self toString:NSDate_STR_FORMAT];
}

- (NSString *)toString:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

- (NSString *)toShortDatetimeString {
    
    NSDate *currDate = [NSDate date];
    NSCalendar *calendar= [NSCalendar currentCalendar];
    NSUInteger flags = NSYearCalendarUnit |NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit;
    
    NSDateComponents *components = [calendar components:flags fromDate:self toDate:currDate options:0];
    
    if (components.year >= 1) {
        return [NSString stringWithFormat:@"%d年之前", (int)components.year];
    }
    if (components.month >= 1) {
        return [NSString stringWithFormat:@"%d个月前", (int)components.month];
    }
    if (components.day >= 1) {
        return [NSString stringWithFormat:@"%d天前", (int)components.day];
    }
    if (components.hour >= 1) {
        return [NSString stringWithFormat:@"%d小时前", (int)components.hour];
    }
    if (components.minute >= 1) {
        return [NSString stringWithFormat:@"%d分钟前", MAX((int)components.minute, 1)];
    }
    return nil;
}

@end
