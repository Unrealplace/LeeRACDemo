//
//  LeeRACCommand.m
//  LeeLearnRAC
//
//  Created by LiYang on 17/5/29.
//  Copyright © 2017年 LiYang. All rights reserved.
//

#import "LeeRACCommand.h"

@interface LeeRACCommand ()

@end

@implementation LeeRACCommand

- (void)viewDidLoad {
    [super viewDidLoad];
 
//    6.5.RACCommand
//    
//    RAC中用于处理事件的类，可以把事件如何处理，事件中的数据如何传递，包装到这个类中，可以很方便的监控事件的执行过程。
//    
//    使用场景：监听按钮点击，网络请求
//    
//    使用步骤：
//    
//    1.创建命令- (id)initWithSignalBlock:(RACSignal * (^)(InputType input))signalBlock;
//    
//    2.在signalBlock中，创建RACSignal，并作为signalBlock的返回值。
//    
//    3.执行命令- (RACSignal *)execute:(InputType)input;
//    
//    注意事项：
//    
//    1.signalBlock必须返回一个信号，不能传nil
//    
//    2.如果不想传递信号，直接创建空的信号[RACSignal empty]
//    
//    3.RACCommand中信号如果数据传递完，调用[subscriber sendCompeted]来保证发送信号完毕，不会有更多的信号发送。
//    
//    4.RACCommand需要被强引用，否则接受不到RACCommand中的信号，因此RACCommand的信号是延迟发送的。
    
    
    RACCommand * command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
       
        NSLog(@"the input:::%@",input);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
            [subscriber sendNext:@"oliver 1111"];
            [subscriber sendNext:@"oliver  2222"];
            return nil;
        }];
        
    }];

//    从上代码，可以看出，创建命令返回的是一个信号RACSignal，我们也知道信号可以发信号，所以，就有executionSignals信号源的概念
//    
//    executionSignals 信号源，包含事件处理的所有的信号
//    
//    定义：信号中发信号，也就是信号发出的数据也是信号。
    [self signalOfSignals];
    
    
//    从上图，可以看出，创建命令返回的是一个信号RACSignal，我们也知道信号可以发信号，所以，就有executionSignals信号源的概念
//    
//    executionSignals 信号源，包含事件处理的所有的信号
//    
//    定义：信号中发信号，也就是信号发出的数据也是信号。
    [command.executionSignals subscribeNext:^(id x) {
    
        NSLog(@"%@",x);
        [x subscribeNext:^(id x) {
            NSLog(@"command in :%@",x);
        }];
        
    }];
    
    [command execute:@"lee oliver"];
    
    
    
    
}

-(void)signalOfSignals{

    //第一层信号
    RACSubject * signalOfsignals = [RACSubject subject];
    //第二层信号
    RACSubject * signal = [RACSubject subject];
    //外层信号接收数据
    [signalOfsignals subscribeNext:^(id x) {
       //内层信号接收数据
        NSLog(@"out:%@",x);
        [x subscribeNext:^(id x) {
            NSLog(@"in::%@",x);
        }];
    }];
    //信号发送信号数据
    [signalOfsignals sendNext:signal];
    
    [signal sendNext:@"subsignal send message"];
    
    
}



@end
