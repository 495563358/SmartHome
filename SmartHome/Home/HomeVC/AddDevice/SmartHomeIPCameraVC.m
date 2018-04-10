//
//  SmartHomeIPCameraVC.m
//  SmartHome
//
//  Created by Smart house on 2017/9/24.
//  Copyright © 2017年 sunzl. All rights reserved.
//

#import "SmartHomeIPCameraVC.h"

#import "OnekeyViewController.h"

#import "Wrapper.h"

@interface SmartHomeIPCameraVC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *tableview;
}

@end

@implementation SmartHomeIPCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = My_gray;
    self.navigationItem.title = @"智能屋摄像头";
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 88) style:UITableViewStylePlain];
    tableview.sectionHeaderHeight = 0.1;
    tableview.sectionFooterHeight = 0.1;
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, Sc_h - 100 - 64 - 40, Sc_w - 60, 50)];
    label.textColor = Color_system;
    label.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:label];
    label.text = @"    温馨提示:如果您使用的摄像头还未进行摄像头WIFI配置,请先配置WIFI后,再添加摄像头！";
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    label.layer.cornerRadius = 5.0;
    label.layer.masksToBounds = YES;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pool"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"pool"];
    }
    NSLog(@"%f",cell.frame.size.height);
    if (indexPath.row == 0) {
        cell.textLabel.text = @"添加智能屋摄像头";
    }else
    cell.textLabel.text = @"摄像头WiFi配置";
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        Wrapper *vc = [Wrapper new];
        [vc push:self roomCode:self.roomcode];
    }
    else{
        OnekeyViewController *vc = [OnekeyViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
        
    
}

@end
