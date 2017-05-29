//
//  Person.h
//  LeeLearnRAC
//
//  Created by LiYang on 17/5/29.
//  Copyright © 2017年 LiYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property (nonatomic,copy)NSString * name;
@property (nonatomic,copy)NSString * sex;
+(instancetype)personWith:(NSDictionary*)dic;

@end
