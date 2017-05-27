//
//  LeeTableViewController.m
//  LeeLearnRAC
//
//  Created by MacBook on 2017/5/27.
//  Copyright © 2017年 LiYang. All rights reserved.
//

#import "LeeTableViewController.h"
 
@interface LeeTableViewController ()
@property (nonatomic,strong)NSArray * dataArray;

@end

@implementation LeeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = @[@"LeeRACSignal",@""];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"iddd"];
   
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellid = @"iddd";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    
    cell.textLabel.text = _dataArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.navigationController pushViewController:[NSClassFromString(_dataArray[indexPath.row]) new] animated:YES];
    
    
}

@end
