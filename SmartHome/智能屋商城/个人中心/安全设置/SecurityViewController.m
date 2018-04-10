//
//  SecurityViewController.m
//  SmartMall
//
//  Created by Smart house on 2017/10/26.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "SecurityViewController.h"

#import "ResetPWDViewController.h"

#import "ResetCreditPaypwdVC.h"

@interface SecurityViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"安全设置";
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = My_gray;
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    UITableView *tableview = [[UITableView alloc]initWithFrame:Sc_bounds style:UITableViewStylePlain];
    tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Sc_w, 0.01)];
    
    tableview.delegate = self;
    tableview.dataSource = self;
    
    [self.view addSubview:tableview];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userPool"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"userPool"];
    }
    if (indexPath.row == 0)
        cell.textLabel.text = @"修改商城登录密码";
    else
        cell.textLabel.text = @"修改商城支付密码";
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        ResetPWDViewController *vc = [ResetPWDViewController new];
        
        vc.moblie = _moblie;
        vc.headImg = _headImg;
        
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    else{
        ResetCreditPaypwdVC *vc = [ResetCreditPaypwdVC new];
        
        vc.moblie = _moblie;
        vc.headImg = _headImg;
        
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}




-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
