//
//  LeeRACDisposable.m
//  LeeLearnRAC
//
//  Created by LiYang on 17/5/29.
//  Copyright © 2017年 LiYang. All rights reserved.
//

#import "LeeRACDisposable.h"

@interface LeeRACDisposable ()

@end

@implementation LeeRACDisposable

- (void)viewDidLoad {
    [super viewDidLoad];

//    RACDisposable：用于取消订阅者或者清理资源，当信号发送完毕或者发送错误的时候，
//        就会自动释放它。一般使用的地方：不想监听某个信号时，可以通过它来主动取消订阅者号。

    
//    1.需要在信号被取消的时候，返回一个RACDisposable，才能取消信号。
    RACSignal * signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        //当信号被调用的时候会调用这个block，描述当前信号的哪些数据需要发送
        [subscriber sendNext:@"oliver lee"];//调取订阅者的nextBlock
        
        //想要取消订阅的信号，需要返回一个RACDispoable
        return [RACDisposable disposableWithBlock:^{
        // 信号被取消订阅，可以在这里取消一些操作，释放一些资源。
            NSLog(@"取消订阅信号了");
        }];
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"接受的数据变化：%@",x);
    }];
    
//      2.只要订阅信号，就会返回一个取消信号的对象，通过subscribeNext订阅，返回来RACDisposable对象，再通过dispose来主动取消信号
    
    RACSignal * signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        [subscriber sendNext:@"lee oliver"];
        return nil;
    }];
    RACDisposable * disposable = [signal2 subscribeNext:^(id x) {
        NSLog(@"数据：%@",x);
    }];
    [disposable dispose];
    
    
}




@end
