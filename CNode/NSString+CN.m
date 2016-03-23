//
//  NSString+KS.m
//  KSToolkit
//
//  Created by bing.hao on 14/12/5.
//  Copyright (c) 2014年 bing.hao. All rights reserved.
//

#import "NSString+CN.h"
#import <CommonCrypto/CommonCrypto.h>


@implementation NSString (TS)

+ (BOOL)isNullOrEmpty:(NSString *)str
{
    if (str == nil || [str isEqual:[NSNull null]]) {
        return YES;
    }
    if (!str) {
        // null object
        return YES;
    } else {
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            // empty string
            return YES;
        } else {
            // is neither empty nor null
            return NO;
        }
    }
}

+ (NSString *)GUID
{
    CFUUIDRef   uuid_ref        = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref = CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    
    CFRelease(uuid_string_ref);
    
    return uuid;
}

#pragma mark -

+ (id)MD5EncryptionWithString:(NSString *)str
{
    if (str == nil) {
        return nil;
    }
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)str.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

- (NSString *)toMD5Encryption
{
    return [NSString MD5EncryptionWithString:self];
}




@end
