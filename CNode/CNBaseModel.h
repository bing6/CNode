//
//  CNBaseModel.h
//  CNode
//
//  Created by bing.hao on 16/3/15.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import <FMDBDataTable/FMDTObject.h>
#import "NSDate+CN.h"

#define CN_MODEL_DATE_CONVERT(n) [NSDate dateWithString:n withFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"]

@interface CNBaseModel : FMDTObject

- (instancetype)initWithDictionary:(NSDictionary *)data;

+ (NSArray *)createObjectListWithArray:(NSArray *)array;

@end
