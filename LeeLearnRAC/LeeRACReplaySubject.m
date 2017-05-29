//
//  LeeRACReplaySubject.m
//  LeeLearnRAC
//
//  Created by LiYang on 17/5/29.
//  Copyright © 2017年 LiYang. All rights reserved.
//

#import "LeeRACReplaySubject.h"

@interface LeeRACReplaySubject ()

@end

@implementation LeeRACReplaySubject

- (void)viewDidLoad {
    [super viewDidLoad];

//    重复提供信号类，RACSubject的子类。
//    
//    使用场景：
//    
//    1.如果一个信号每被订阅一次，就需要把之前的值重新发送一遍，使用重复提供信号类。
//    
//    2.可以设置capcity数量来限制缓存的value的数量，即只缓存最新的几个值
//    
//    RACReplaySubject的简单使用：
    
    
    RACReplaySubject * subject = [RACReplaySubject subject];
    [subject subscribeNext:^(id x) {
        NSLog(@"first subscribel:%@",x);
    }];
    [subject subscribeNext:^(id x) {
        NSLog(@"second subscribel:%@",x);
    }];
    
    
    [subject sendNext:@"first oliver lee"];
    [subject sendNext:@"second oliver lee"];

    
}


@end
