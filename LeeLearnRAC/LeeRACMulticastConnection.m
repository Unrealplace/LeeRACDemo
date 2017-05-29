//
//  LeeRACMulticastConnection.m
//  LeeLearnRAC
//
//  Created by LiYang on 17/5/29.
//  Copyright © 2017年 LiYang. All rights reserved.
//

#import "LeeRACMulticastConnection.h"

@interface LeeRACMulticastConnection ()

@end

@implementation LeeRACMulticastConnection

- (void)viewDidLoad {
    [super viewDidLoad];

//    6.6.RACMulticastConnection
//    
//    用于当一个信号，被多次订阅时，为了保证创建信号时，避免多次调用创建信号中的block，造成副作用，可以使用这个类处理。
//    
//    使用注意：RACMulticastConnection通过RACSignal的-publish或者-muticast:方法创建
//    
//    使用步骤：
//    
//    1.创建信号+ (RACSignal *)createSignal:(RACDisposable * (^)(idsubscriber))didSubscribe;
//    
//    2.创建连接RACMulticastConnection *connect = [signal publish];
//    
//    3.订阅信号，注意：订阅的信号不是之前的信号，而是连接的信号[connection.signal subscribeNext:nextBlock]
//    
//    4.连接 [connect connect];
//    
//    底层原理：
//    
//    1.创建connect，通过publish(multicast:)创建sourceSignal(指向原信号），connect.signal ->RACSubject
//                                                
//    2.订阅connect，会调用RACSubject的subscribeNext，创建订阅者，并把订阅者保存起来，并不会去去执行，也就是说现在的 connect.signal信号是冷信号。
//                                                
//    3.[connect connect]内部会订阅RACSignal（原始信号），并且订阅者就是RACSubject，调用了此方法才能将信号变成热信号。
//                                                
//    3.订阅原始信号，就会调用didSubscribe
//                                                
//    3.didSubscribe后，拿到订阅者调用sendNext，其实就是调用RACSubjec的sendNext
//                                                
//   4.sendNext后，就会遍历所有订阅者发送信号
//                                                
//    使用场景：
//                                                
//    如果一个信号发出请求，每次订阅一次都会发出请求，这样导致多次请求，就可以利用RACMulticastConnection来解决
//                                                
//    简单使用：

    RACSignal * signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"发出网络请求");
        [subscriber sendNext:@"网络数据"];
        return nil;
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"接收的:%@",x);
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"接收的:%@",x);
    }];
//    如果不使用连接，可以发现，每次去订阅一次信号，就会去重复调NSLog()，这个也就是副作用。
    
    
    
    RACSignal * signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"发出网络请求2");
        [subscriber sendNext:@"网络数据2"];
        return nil;
    }];
    
    RACMulticastConnection * connection = [signal2 publish];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);

    }];
    [connection connect];
    
    
    
    
}

@end
