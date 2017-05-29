//
//  Person.m
//  LeeLearnRAC
//
//  Created by LiYang on 17/5/29.
//  Copyright © 2017年 LiYang. All rights reserved.
//

#import "Person.h"

@implementation Person
+(instancetype)personWith:(NSDictionary*)dic{

    Person * one = [[Person alloc] init];
    one.name = dic[@"name"];
    one.sex     = dic[@"sex"];
    return one;
}
@end
