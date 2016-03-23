//
//  CNBaseModel.m
//  CNode
//
//  Created by bing.hao on 16/3/15.
//  Copyright © 2016年 Tsingda. All rights reserved.
//

#import "CNBaseModel.h"

@implementation CNBaseModel

- (instancetype)initWithDictionary:(NSDictionary *)data {
    self = [super init];
    if (self) {
    }
    return self;
}

+ (NSArray *)createObjectListWithArray:(NSArray *)array {
    NSMutableArray *tmp = [NSMutableArray new];
    for (NSDictionary *entry in array) {
        [tmp addObject:[[self alloc] initWithDictionary:entry]];
    }
    return tmp;
}

@end
