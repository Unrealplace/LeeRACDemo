//
//  LeeReactiveCocoausage.m
//  LeeLearnRAC
//
//  Created by LiYang on 17/5/29.
//  Copyright © 2017年 LiYang. All rights reserved.
//

#import "LeeReactiveCocoausage.h"
#import "RACDelegateProxy.h"

@interface LeeReactiveCocoausage ()
@property (nonatomic,strong)UIButton * testBtn;
@property (nonatomic,strong)UITextField * textF1;
@property (nonatomic,strong)UITextField * textF2;
@property (nonatomic,assign)NSInteger  age;

@end

@implementation LeeReactiveCocoausage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    1.代替代理：
//    rac_signalForSelector：用于代替代理
//    
//    场景：在控制器设置一个btn,然后点击button，让控制器知道按钮被点了。
    self.testBtn = [UIButton new];
    [self.view addSubview:self.testBtn];
    [self.testBtn setTitle:@"test racMethod" forState:UIControlStateNormal];
    self.testBtn.backgroundColor = [UIColor redColor];
    [self.testBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(74);
        
    }];
    [self.testBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    
    [[self.testBtn rac_signalForSelector:@selector(btnClick:) ] subscribeNext:^(id x) {
       
        NSLog(@"控制器知道按钮点击了btn:%@",x);
    }];
    
    
    
    
    
//  2.  拓展：RACDelegateProxy 代理类
//    
//    这个类通常用在多个对象，但各种在代理方法中处理的事件不同，或者说实现不同的需求（注：RACDelegateProxy可能会被无缘无故地crash，所以需要强引用保留住）

    [self setText];
    
    //这种方法通常用在多个对象，各种代理方法中处理的事件不同，或者实现不同的需求
    static RACDelegateProxy * proxy   = nil;
    static RACDelegateProxy * proxy1 = nil;
   //创建代理，需要传入协议
    proxy   = [[RACDelegateProxy alloc] initWithProtocol:@protocol(UITextFieldDelegate)];
    proxy1 = [[RACDelegateProxy alloc] initWithProtocol:@protocol(UITextFieldDelegate)];
    self.textF1.delegate = (id<UITextFieldDelegate>)proxy;
    self.textF2.delegate = (id<UITextFieldDelegate>)proxy1;
    //订阅信号
    [[proxy signalForSelector:@selector(textFieldShouldReturn:)] subscribeNext:^(id x) {
       
        NSLog(@"监听点击了return:%@",x);
    }];
    [[proxy1 rac_signalForSelector:@selector(textFieldDidBeginEditing:)] subscribeNext:^(id x) {
        NSLog(@"监听开始了编辑:%@",x);
    }];
//    订阅信号返回block参数x就是当前操作的textField。这样写代理，符合了高内聚的思想，不必去到处找代理方法位置。
    
    
    
    
//    3.代替KVO：
//    
//    rac_valuesAndChangesForKeyPath：用于监听某个对象的属性改变
//    
//    场景：点击屏幕，年龄age++，来监听age变化值
    
    /**
     KVO
     监听对象属性的改变
     @param x 把监听的内容转成信号
     @return 销毁信号值
     */
    [[self rac_valuesForKeyPath:@"age" observer:nil] subscribeNext:^(id x) {
        NSLog(@"age:::%@",x);
    }];
    
    
    
    
//    4.监听事件：
//    
//    rac_signalForControlEvents：用于监听某个事件
   
    [[self.testBtn rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(id x) {
       
        NSLog(@"监听了事件：：%@",x);
        
    }];
    [[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
       
        NSLog(@"监听了事件：：%@",x);
 
    }];
    
    
    
    
//    5.代替通知：
//    
//    rac_addObserverForName：用于监听某个通知
//    
//    场景：监听键盘弹出
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"键盘弹出：：%@",x);
    }];
    
 
    
    
//    6.监听文本框文字改变：
//    
//    rac_textSignal：只要文本框发出改变就会发出这个信号
    
    [[self.textF2 rac_textSignal] subscribeNext:^(id x) {
        NSLog(@"text change::%@",x);
        
    }];
    
    
    
    
//    6.处理当界面有多次请求时，需要都获取到数据时，才能显示界面：
//    
//    rac_liftSelector:withSignalsFromArray:Signals：当传入的Signals(信号数组)，每一 个signal(都至少sendNext过一次，就会去触发第一个selector参数的方法)。
//    
//    场景：一个页面里，有2个不同的请求（分别是热门商品的请求和最新商品的请求），只有当2个请求都请求完毕后才更新界面。
    
    RACSignal * signalHot = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"请求热门商品数据");
        [subscriber sendNext:@"hot data"];
        
        return nil;
    }];
    
    RACSignal * signalNew = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"请求最新的商品数据");
        sleep(2);
        [subscriber sendNext:@"new data"];
        return nil;
    }];
   
    
    
    /**
     可以判断两个信号有没有发出内容，
      监听信号数组中信号的内容
     当信号数组中的所有的信号都发出了sendNext就会触发updateUI
      注意，updateUI参数不能乱写，有几个信号写几个参数
     不需要主动订阅信号，方法内部已经自动订阅了
     @param updateUI:new: 更新ui
     */
    [self rac_liftSelector:@selector(updateUI:new:) withSignalsFromArray:@[signalNew,signalHot]];
    
    
    

}

-(void)updateUI:(NSString*)hot new:(NSString*)new{

    self.view.backgroundColor = [UIColor blueColor];

    
}

-(void)setText{

    self.textF1 = [UITextField new];
    self.textF2 = [UITextField new];
    [self.view addSubview:self.textF1];
    [self.view addSubview:self.textF2];
    self.textF1.layer.borderWidth = 0.5;
    self.textF1.layer.borderColor = [UIColor orangeColor].CGColor;
    self.textF2.layer.borderWidth = 0.5;
    self.textF2.layer.borderColor = [UIColor orangeColor].CGColor;
    [self.textF1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.testBtn.mas_bottom).offset(10);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(44);
        
    }];
    [self.textF2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.textF1.mas_bottom).offset(10);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(44);
        
    }];

}
-(void)btnClick:(UIButton*)btn{

    btn.backgroundColor = [UIColor orangeColor];
    NSLog(@"click btn");
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    self.age++;
    
}

@end
