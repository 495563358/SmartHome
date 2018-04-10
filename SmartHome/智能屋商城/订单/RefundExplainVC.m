//
//  RefundExplainVC.m
//  SmartMall
//
//  Created by Smart house on 2017/10/23.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "RefundExplainVC.h"

#import "RefundViewController.h"

#import "ObjectTools.h"

#import "UIView+Toast.h"
//修改申请
#define requestRefund @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.apprefund.submit"

//取消申请
#define cancelRefund @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.apprefund.cancel"

@interface RefundExplainVC ()



@end

@implementation RefundExplainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = My_gray;
    //    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.title = @"退款申请进度";
    
    NSLog(@"退款申请进度xinxi = %@",_orderInfo);
    
    
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    [self createHead];
    
    [self createFoot];
}

-(void)createHead{
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Sc_w, 110)];
    view1.backgroundColor = [UIColor whiteColor];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, Sc_w - 20, 20)];
    label1.font = [UIFont systemFontOfSize:14];
    label1.text = @"正在等待商家处理退款申请";
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, Sc_w - 40, 80)];
    label2.textColor = [UIColor grayColor];
    label2.font = [UIFont systemFontOfSize:13];
    label2.text = @"退款申请流程：\n  1、发起退款申请\n  2、商家确认后退款到您的账户,如果商家未处理,请及时与商家联系";
    label2.numberOfLines = 4;
    
    [view1 addSubview:label1];
    [view1 addSubview:label2];
    
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 130, Sc_w, 240 + 30)];
//    view2.backgroundColor = [UIColor whiteColor];
    
    
    NSArray *arr1 = @[@"协商详情",@"处理方式",@"退款原因",@"退款说明",@"退款金额",@"申请时间"];
    NSString *timestr =  _refundSchedule[@"createtime"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestr integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [formatter stringFromDate:date];
    
    NSString *refundExplain = _refundSchedule[@"content"];
    
    if (!refundExplain || refundExplain.length == 0) {
        refundExplain = @"无";
    }
    NSLog(@"%@",_refundSchedule);
    NSArray *arr2 = @[@"",@"仅退款",_refundSchedule[@"reason"],refundExplain,_refundSchedule[@"applyprice"],dateStr];
    
    for (int i = 0; i<6; i++) {
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 45 * i, Sc_w, 44)];
        backView.backgroundColor = [UIColor whiteColor];
        
        UILabel *labels = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, Sc_w - 20, 44)];
        labels.font = [UIFont systemFontOfSize:13];
        [backView addSubview:labels];
        
        labels.text = [NSString stringWithFormat:@"%@    %@",arr1[i],arr2[i]];
        
        
        [view2 addSubview:backView];
    }
    [self.view addSubview:view2];
    
}


-(void)createFoot{
    
    UIView *selfFoot = [[UIView alloc]initWithFrame:CGRectMake(0, Sc_h - 64 - 52, Sc_w, 52)];
    selfFoot.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 10 - 65, 11, 65, 30)];
    btn1.layer.cornerRadius = 8.0;
    btn1.backgroundColor = My_gray;
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 setTitle:@"取消申请" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn1 addTarget:self action:@selector(cancelRefundrequest:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 10 - 65 - 85, 11, 65, 30)];
    btn2.layer.cornerRadius = 8.0;
    btn2.backgroundColor = My_gray;
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 setTitle:@"修改申请" forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn2 addTarget:self action:@selector(refund) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [selfFoot addSubview:btn1];
    [selfFoot addSubview:btn2];
    
    [self.view addSubview:selfFoot];
}

//退款
-(void)refund{
    
    RefundViewController *vc = [RefundViewController new];
    vc.userInfo = _userInfo;
    vc.orderInfo = _orderInfo;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

//取消退款
-(void)cancelRefundrequest:(UIButton *)sender{
    
    if (sender.selected) {
        return;
    }
    
    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:nil message:@"您确定要取消申请?" preferredStyle:UIAlertControllerStyleAlert];
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sender.selected = YES;
        //订单ID
        [self.userInfo setObject:_orderInfo[@"parentorder"][@"id"] forKey:@"id"];
        //时间
        [self.userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
        
        [[ObjectTools sharedManager] POST:cancelRefund parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"取消申请 = %@",responseObject);
            [self.view makeToast:@"取消成功"];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }]];
    
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertCtr animated:YES completion:nil];
}

- (NSString *)getNowTimeTimestamp{
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
    
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
