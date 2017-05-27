//
//  ViewController.m
//  LeeLearnRAC
//
//  Created by LiYang on 17/5/23.
//  Copyright © 2017年 LiYang. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa.h>

@interface ViewController ()

@property (nonatomic,copy)NSString * userName;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property(nonatomic,assign)BOOL createEnabled;
@property(nonatomic,copy)NSString * password;
@property(nonatomic,copy)NSString * passwordConfirmation;
@property(nonatomic,strong)RACCommand *loginCommand;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // 当self.username变化时,在控制台打印新的名字.
    // RACObserve(self, username) 创建一个新的 RACSignal 信号对象,它将会发送self.username当前的值,和以后 self.username 发生变化时 的所有新值.
    // -subscribeNext: 无论signal信号对象何时发送消息,此block回调都将会被执行.
    
    [RACObserve(self, userName) subscribeNext:^(id x) {
        NSLog(@"***----->>%@",x);
    }];
    
    
    // 只打印以"oliver"开头的名字.
    // -filter: 当其bock方法返回YES时,才会返回一个新的RACSignal 信号对象;即如果其block方法返回NO,信号不再继续往下传播.
    [[RACObserve(self, userName) filter:^BOOL(id value) {
        return [value hasPrefix:@"oliver"];
    } ] subscribeNext:^(id x) {
        NSLog(@"------>>>>%@",x);
    }];
    
    
    
//    Signals信号也可以用于派生属性(即那些由其他属性的值决定的属性,如Person可能有一个属性为 age年龄 和一个属性 isYong是否年轻,
//    isYong 是由 age 属性的值推断而来,由age本身的值决定).不再需要来监测某个属性的值,然后来对应更新其他受此属性的新值影响的属性的值.RAC 可以支持以signales信号和操作的方式来表达派生属性.
    
    // 创建一个单向绑定, self.password和self.passwordConfirmation 相等
    // 时,self.createEnabled 会自动变为true.
    //
    // RAC() 是一个宏,使绑定看起来更NICE.
    //
    // +combineLatest:reduce:  使用一个 signals 信号的数组;
    // 在任意signal变化时,使用他们的最后一次的值来执行block;
    // 并返回一个新的 RACSignal信号对象来将block的值用作属性的新值来发送;
    // 简单说,类似于重写createEnabled 属性的 getter 方法.

    RAC(self,createEnabled) = [RACSignal combineLatest:@[RACObserve(self, password),RACObserve(self, passwordConfirmation)]  reduce:^id{
       
        return @([self.passwordConfirmation isEqualToString:self.password]);
    }];
    [RACObserve(self, createEnabled) subscribeNext:^(id x) {
       
        NSLog(@"value:::::::%@",x);
    }];
    
    
 
    RAC(self, userName) = [[[RACSignal interval:3 onScheduler:[RACScheduler currentScheduler]] startWith:[NSDate date]] map:^id (NSDate *value) {
        NSLog(@"value:%@", value);
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit |
                                            NSMinuteCalendarUnit |
                                            NSSecondCalendarUnit fromDate:value];
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)dateComponents.hour, (long)dateComponents.minute, (long)dateComponents.second];
    }];
    
    // 任意时间点击按钮,都会打印一条消息.
    // RACCommand 创建代表UI事件的signals信号.例如,单个信号都可以代表一个按钮被点击,
    // 然后会有一些额外的操作与处理.
    // -rac_command 是NSButton的一个扩展.按钮被点击时,会将会把自身发送给rac_command
    self.button.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"button click");
        return [RACSignal empty];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] subscribeNext:^(id x) {
        
        NSLog(@"键盘改变了");
    }];
    
    [[self rac_signalForSelector:@selector(viewWillAppear:) ] subscribeNext:^(id x) {
       
        NSLog(@"viewwillappear %@",x);
        
    }];
    
    
    
    
    
    //异步网络请求
    // 监听"登陆"按钮,并记录网络请求成功的消息.
    // 这个block会在来任意开始登陆步骤,执行登陆命令时调用.
    
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // 这是一个假想中的 -logIn 方法, 返回一个 signal信号对象,这个对象在网络对象完成时发送 值.
        // 可以使用 -filter 方法来保证当且仅当网络请求完成时,才返回一个 signal 对象.
        return [self login];
    }];
    // 当按钮被点击时,执行login命令.
    self.loginBtn.rac_command = self.loginCommand;
    
    // -executionSignals 返回一个signal对象,这个signal对象就是每次执行命令时通过上面的block返回的那个signal对象.
   [ self.loginCommand.executionSignals  subscribeNext:^(id x) {
       //打印信息。不论何时我们登陆成功
        [x subscribeCompleted:^{
            NSLog(@"logged in successfully");
        }];
        
    }];
 
    
    // 执行两个网络操作,并在它们都完成后在控制台打印信息.
    // +merge: 传入一组signal信号,并返回一个新的RACSignal信号对象.这个新返回的RACSignal信号对象,传递所有请求的值,
    // 并在所有的请求完成时完成.即:新返回的RACSignal信号,在每个请求完成时,都会发送个消息;在所有消息完成时,除了发送消息外,还会触发"完成"相关的block.
    // -subscribeCompleted: signal信号完成时,将会执行block.
    [[RACSignal
      merge:@[ [self fetchUserRepos], [self fetchOrgRepos] ]]
     subscribeCompleted:^{
         NSLog(@"They're both done!");
     }];
    
}
-(RACSignal*)login{
    
    return arc4random() % 100  > 30 ? [RACSignal empty]:nil;
                                   
//    return  [RACSignal empty];
}
-(RACSignal*)fetchUserRepos{
    return  [RACSignal empty];

}
-(RACSignal*)fetchOrgRepos{
    return  [RACSignal empty];
}



- (IBAction)btnClick:(id)sender {
    
    self.userName = [NSString stringWithFormat:@"oliver--%u",arc4random()];
    self.password = self.userName;
    self.passwordConfirmation = self.userName;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
