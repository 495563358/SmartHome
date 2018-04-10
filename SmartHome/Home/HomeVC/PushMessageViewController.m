//
//  PushMessageViewController.m
//  SmartHome
//
//  Created by Smart house on 2018/3/6.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import "PushMessageViewController.h"

@interface PushMessageViewController ()

@end

@implementation PushMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的消息";
    self.view.backgroundColor = My_gray;
    self.navigationController.navigationBarHidden = NO;
    
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(Sc_w/2 - 30, 60, 60, 60)];
    imgV.image = [UIImage imageNamed:@"shangctsxx"];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake((Sc_w - 300)/2, 120, 300, 50)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor grayColor];
    lab.font = [UIFont systemFontOfSize:14];
    lab.text = @"您暂时还没有收到任何消息哟~";
    
    [self.view addSubview:imgV];
    [self.view addSubview:lab];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
