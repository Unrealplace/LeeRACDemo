//
//  LeeRACTupleAndRACSequence.m
//  LeeLearnRAC
//
//  Created by LiYang on 17/5/29.
//  Copyright © 2017年 LiYang. All rights reserved.
//

#import "LeeRACTupleAndRACSequence.h"
#import "Person.h"

@interface LeeRACTupleAndRACSequence ()

@end

@implementation LeeRACTupleAndRACSequence

- (void)viewDidLoad {
    [super viewDidLoad];
//    RACTuple：元组类，类似NSArray，用来包装值
//    
//    RACSequence：RAC中的集合类，用来代替NSArray、NSDictionary，可以使用它来快速遍历数组和字典。
//    
//    使用场景：字典转模型
//    
//    RACSequence和RACTuple的简单使用
//    
//    主要有3个步骤 （numbers为数组）
//    
//    1.把数组转化成集合RACSequence    ->numbers.rac_sequence
//    
//    2.把集合RACSequence转化成RACSignal信号类      ->numbers.rac_sequence.signal
//    
//    3.订阅信号，激活信号，会自动把集合中的所有值遍历出来  ->subscribeNext
    
    NSArray * numbers = @[@1,@2,@3,@4,@5];
    NSDictionary * dic = @{@"name":@"oliver lee",@"sex":@"boy"};
    
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
       
        NSLog(@"arrray:%@",x);
    }];
    
    [dic.rac_sequence.signal subscribeNext:^(id x) {
//        NSLog(@"dic:%@",x);
//        NSString * key = x[0];
//        NSString * value = x[1];
//        NSLog(@"%@:%@",key,value);
        //可以通过宏来方便的解析元组
        RACTupleUnpack(NSString * key,NSString * value) = x;
        NSLog(@"%@--->%@",key,value);
        
    }];
    
//    字典转模型
//    
//    通过map（映射）将数组遍历的集合映射成一个新值（模型）
//    
//    步骤：
//    
//    1. map：映射的意思，目的：把原始值value映射成一个新值
//    
//    2.toArray：把集合转成数组
//    
//    底层实现：当信号被订阅，会遍历集合中的原始值，映射成新值，并保存到数组中
    
    
   
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"Test" ofType:@"plist"];
    NSArray * arr = [NSArray arrayWithContentsOfFile:filePath];
    NSArray * dataArr = [arr firstObject];
    //map :映射的意思，目的：把原始的value 映射成一个新值
    //toArray ：把集合转成数组
    //底层实现，当信号被订阅，会遍历集合中的原始值，映射成新值，并保存到数组中
    NSArray * newArr = [[dataArr.rac_sequence.signal map:^id(id value) {
        NSLog(@"%@",value);
        return [Person personWith:value];
    }] toArray];
    NSLog(@"%@",newArr);
    
    
    
}


@end
