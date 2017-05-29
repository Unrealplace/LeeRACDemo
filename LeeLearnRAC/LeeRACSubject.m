//
//  LeeRACSubject.m
//  LeeLearnRAC
//
//  Created by LiYang on 17/5/29.
//  Copyright © 2017年 LiYang. All rights reserved.
//

#import "LeeRACSubject.h"

@interface LeeRACSubject ()

@end

@implementation LeeRACSubject

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    6.2.RACSubject
//    
//    信号提供者，自己可以充当信号，又能发送信号。rac中热信号的源头，继承于RACSignal
//    
//    RACSubject的使用步骤：
//    
//    1.创建信号 [RACSubject subject]，跟RACSignal不一样，创建信号时没有block。
//    
//    2.订阅信号- (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
//    
//    3.发送信号- (void)sendNext:(id)value
//    
//    RACSubject底层实现和RACSignal不一样：
//    
//    1.调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值。
//    
//    2.调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock
    
    //创建信号
    RACSubject * subject = [RACSubject subject];
    //订阅信号
    [subject subscribeNext:^(id x) {
        NSLog(@"第一个订阅者数据：%@",x);
    }];
    //发送信号数据
    [subject  sendNext:@"oliver lee"];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"第二个订阅者数据：%@",x);

    }];
    [subject sendNext:@"two oliver lee"];
//    看log可以看出racsubject和racsignal有本质的区别，不关心历史值，错过就错过了
//    ，当发出第二个信号时，第一个订阅者收到的数据会相对于发生更新，所以不用去考虑历史值。
    
    
    
}



@end
