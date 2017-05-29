//
//  RACSignal.m
//  LeeLearnRAC
//
//  Created by MacBook on 2017/5/27.
//  Copyright © 2017年 LiYang. All rights reserved.
//

#import "LeeRACSignal.h"

@interface LeeRACSignal ()

@end

@implementation LeeRACSignal

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
//    RACSignal：信号类，一般表示将来有数据传递，只要有数据改变，信号内部接收到数据，就会马上发出数据。
//    
//    信号类（RACSignal），只是表示数据改变时，信号内部会发出数据，它本身不具备发送信号的能力，而是交给内部一个订阅者去发出。
//    
//    默认一个信号都是冷信号，也就是值改变了，也不会触发，只有订阅了这个信号，这个信号才会变为热信号，值改变了才会触发。
//    
//    如何订阅信号：调用信号RACSignal的subscribeNext就能订阅。
    
    
//    1.创建信号：+ (RACSignal *)createSignal:(RACDisposable * (^)(id subscriber))didSubscribe
//    
//    2.发送信号：- (void)sendNext:(id)value (这步不一定有）
//                                       
//    3.订阅信号，才能激活信号：- (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    
    
    
//    RACSignal底层实现：
//    
//    1.创建信号，首先把didSubscribe保存到信号中，还不会触发
//    
//    2.当信号被订阅，也就是调用signal的subscribeNext:nextBlock
//    
//    2.subscribeNext内部会创建订阅者subscriber，并把nextBlock保存到subscriber中
//    
//    2.subscribeNext内部会调用signal的didSubscribe
//    
//    3.signal的didSubscribe中调用[subscriber sendNext:@1];
//    
//    3.1 sendNext底层其实就是执行了subscriber的nextBlock
    
    
    //热信号
    RACSignal * signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"订阅者0发出信号");
        //传数据出去
        [subscriber sendNext:@11];
        
        return nil;
        
    }] subscribeNext:^(id x) {
        //接受订阅者发出的数据，前提是订阅者内部发出数据，不发的话，不会触发
        NSLog(@"订阅了信号后发生的改变%@",x);
    }];
   
    
    //冷信号
    RACSignal * signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        NSLog(@"订阅者1发出信号");
        //传数据出去
        [subscriber sendNext:@11];

         return nil;
    }];
    
    //订阅了信号，但是没有值改变也不会触发任何东西
    RACSignal * signal2 = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"订阅者2发出信号");
        [subscriber sendNext:nil];
        return nil;
    }] subscribeNext:^(id x) {
        
        //接受订阅者发出的数据
        NSLog(@"订阅了信号2后发生的改变%@",x);
    }];
    
    
    
    
}



@end
