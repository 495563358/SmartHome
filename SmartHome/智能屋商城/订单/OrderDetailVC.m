//
//  OrderDetailVC.m
//  SmartMall
//
//  Created by Smart house on 2017/9/14.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "OrderDetailVC.h"

#import "OrderSureCell.h"

#import "ObjectTools.h"
//物流
#import "LookupExpressVC.h"

#import "RefundViewController.h"

#import "RefundExplainVC.h"

#import "UIView+Toast.h"

//查看物流
#define lookupexpress @"r=order.apporder.express"

//确认收货
#define sureToachieve @"r=order.apporder.submit"

//取消申请
#define cancelRefund @"r=order.apprefund.cancel"

//退货申请
#define checkRefund @"r=order.apprefund"

@interface OrderDetailVC ()<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *tableview;
    
    
    UIView *addressView;
    
    UIView *headerView;
    UIView *footerView;
    
    NSArray *goods;
    NSDictionary *parentorder;
    
}


@end

@implementation OrderDetailVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = My_gray;
    self.navigationItem.title = @"订单详情";
    
    
    NSLog(@"订单详情数据 = %@",_orderInfo);
    
    //数据赋值
    goods = _orderInfo[@"goods"];
    parentorder = _orderInfo[@"parentorder"];
    
    
    
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Sc_w, Sc_h - 110) style:UITableViewStyleGrouped];
    
    tableview.delegate = self;
    tableview.dataSource = self;
    
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    
    [self createView];
    
    [self.view addSubview:tableview];
    
    [self createFoot];
}


//tableview头部视图
-(void)createView{
    
    UIView *succView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 93)];
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:succView.frame];
    backImg.image = [UIImage imageNamed:@"jianbiantiao-0"];
    [succView addSubview:backImg];
//    succView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"jianbiantiao-0"]];
    
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 28 + 5, 49, 34)];
    image1.image = [UIImage imageNamed:@"fukuai"];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(70, 28, 250, 19)];
    label1.font = [UIFont systemFontOfSize:19];
    label1.textColor = [UIColor whiteColor];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(70, 28 + 19 + 8, Sc_w - 100, 14)];
    label2.font = [UIFont systemFontOfSize:14];
    label2.textColor = [UIColor whiteColor];
    
    addressView = [[UIView alloc]initWithFrame:CGRectMake(0, 93, Sc_w, 80)];
    addressView.backgroundColor = [UIColor whiteColor];
    
    
    
    //数据显示
    label2.text = [NSString stringWithFormat:@"订单金额(含运费): ￥%.2f",_totalMoney];
    
    if ([_statusInfo isEqualToString:@"待付款"]) {
        label1.text = @"等待买家付款";
        label2.text = @"剩2天23小时自动关闭";
    } else if([_statusInfo isEqualToString:@"待发货"]){
        label1.text = @"买家已付款";
    } else if ([_statusInfo isEqualToString:@"待收货"]){
        label1.text = @"卖家已发货";
    } else{
        label1.text = @"您的订单已完成";
    }
    
    
    if (!_nameAndTele) {
        
        headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 93 + 90)];
        
        
        UIImageView *locaImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 30, 16, 20)];
        locaImage.image = [UIImage imageNamed:@"weiz"];
        
        UILabel *hosterName = [[UILabel alloc]initWithFrame:CGRectMake(46, 20, 100, 15)];
        hosterName.font = [UIFont systemFontOfSize:15];
        
        UILabel *teleLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, 100, 15)];
        teleLab.font = [UIFont systemFontOfSize:15];
        
        UILabel *detilAddr = [[UILabel alloc]initWithFrame:CGRectMake(46, 20 + 15 + 6, Sc_w - 100, 36)];
        detilAddr.font = [UIFont systemFontOfSize:13];
        
        NSDictionary *addrInfo = parentorder[@"address"];
        
        hosterName.text = addrInfo[@"realname"];
        teleLab.text = addrInfo[@"mobile"];
        detilAddr.text = [NSString stringWithFormat:@"%@%@%@%@",addrInfo[@"province"],addrInfo[@"city"],addrInfo[@"area"],addrInfo[@"address"]];
        
        
        [addressView addSubview:locaImage];
        [addressView addSubview:hosterName];
        [addressView addSubview:teleLab];
        [addressView addSubview:detilAddr];
    }else{
        
        headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 93 + 70)];
        
        
        addressView.frame = CGRectMake(0, 93, Sc_w, 60);
        
        UIImageView *locaImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 20, 21)];
        locaImage.image = [UIImage imageNamed:@"tihuoren-0"];
        
        UILabel *hosterName = [[UILabel alloc]initWithFrame:CGRectMake(40, 22.5, 100, 15)];
        hosterName.font = [UIFont systemFontOfSize:15];
        hosterName.text = _nameAndTele[@"realname"];
        
        UILabel *teleLab = [[UILabel alloc]initWithFrame:CGRectMake(90, 22.5, 100, 15)];
        teleLab.font = [UIFont systemFontOfSize:15];
        teleLab.text = _nameAndTele[@"mobile"];
        
        
        
        [addressView addSubview:locaImage];
        [addressView addSubview:hosterName];
        [addressView addSubview:teleLab];
    }
    
    
    
    
    
    
    [succView addSubview:image1];
    [succView addSubview:label1];
    [succView addSubview:label2];
    
    
    headerView.backgroundColor = My_gray;
    [headerView addSubview:succView];
    [headerView addSubview:addressView];
    
    
    tableview.tableHeaderView = headerView;
    
    [self createFootView];
}


//tableview尾部视图
-(void)createFootView{
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 11, 100, 15)];
    label1.font = [UIFont systemFontOfSize:15];
    label1.text = @"商品小计";
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 110, 11, 100, 15)];
    label2.textAlignment = NSTextAlignmentRight;
    label2.font = [UIFont systemFontOfSize:14];
    
    
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 11 + 15 + 19, 100, 15)];
    label3.font = [UIFont systemFontOfSize:15];
    label3.text = @"运费";
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 110, 11 + 34, 100, 15)];
    label4.textAlignment = NSTextAlignmentRight;
    label4.font = [UIFont systemFontOfSize:14];
    
    
    
    
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(10, 11 + 68, 130, 15)];
    label5.font = [UIFont systemFontOfSize:15];
    label5.text = @"实付款(含运费)";
    
    UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 110, 11 + 68, 100, 15)];
    label6.textAlignment = NSTextAlignmentRight;
    label6.font = [UIFont systemFontOfSize:14];
    label6.textColor = Color_system;
    
    UIView *viewF1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 110)];
    viewF1.backgroundColor = [UIColor whiteColor];
    
    [viewF1 addSubview:label1];
    [viewF1 addSubview:label2];
    [viewF1 addSubview:label3];
    [viewF1 addSubview:label4];
    [viewF1 addSubview:label5];
    [viewF1 addSubview:label6];
    
    
    //商品小计 邮费 实付款
    float goodsmoney = [parentorder[@"goodsprice"] floatValue] - [parentorder[@"couponprice"] floatValue];
    label2.text = [NSString stringWithFormat:@"￥%.2f",goodsmoney];
    
    float exchangeprice = [parentorder[@"exchangeprice"] floatValue];
    
    if (_issendFree == 1) {
        exchangeprice = 0.00;
    }
    
    label4.text = [NSString stringWithFormat:@"￥%.2f",exchangeprice];
    float totalmoney = goodsmoney + exchangeprice;
    label6.text = [NSString stringWithFormat:@"￥%.2f",totalmoney];
    
    UILabel *bianhao = [[UILabel alloc]initWithFrame:CGRectMake(10, 12, Sc_w - 40, 15)];
    bianhao.font = [UIFont systemFontOfSize:15];
    bianhao.textColor = color(113, 113, 113, 1);
    
    UILabel *createTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 12 + 31, Sc_w - 40, 15)];
    createTime.font = [UIFont systemFontOfSize:15];
    createTime.textColor = color(113, 113, 113, 1);
    
    UILabel *payTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 12 + 62, Sc_w - 40, 15)];
    payTime.font = [UIFont systemFontOfSize:15];
    payTime.textColor = color(113, 113, 113, 1);
    
    
    
    //订单编号 创建时间 支付时间
    bianhao.text = [NSString stringWithFormat:@"订单编号: %@",parentorder[@"ordersn"]];
    
    NSString *timesStr = parentorder[@"createtime"];
    NSTimeInterval time = [timesStr doubleValue];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd  HH:mm:ss"];
    NSString *showTime = [formatter stringFromDate:detaildate];
    
    createTime.text = [NSString stringWithFormat:@"创建时间: %@",showTime];
    
    
    NSString *paytimeStr = parentorder[@"paytime"];
    NSTimeInterval time2 = [paytimeStr doubleValue];
    NSDate *detaildate2 = [NSDate dateWithTimeIntervalSince1970:time2];
    NSString *showTime2 = [formatter stringFromDate:detaildate2];
    payTime.text = [NSString stringWithFormat:@"支付时间: %@",showTime2];
    
    
    UIView *viewF2 = [[UIView alloc]initWithFrame:CGRectMake(0, 120, Sc_w, 100)];
    viewF2.backgroundColor = [UIColor whiteColor];
    [viewF2 addSubview:bianhao];
    [viewF2 addSubview:createTime];
    [viewF2 addSubview:payTime];
    
    if ([_statusInfo isEqualToString:@"待付款"]) {
        [payTime removeFromSuperview];
        viewF2.frame = CGRectMake(0, 120, Sc_w, 70);
    }
    
    footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 120 + 100)];
    [footerView addSubview:viewF1];
    [footerView addSubview:viewF2];
    
    //自提
    if ([parentorder[@"dispatchtype"] integerValue]==1) {
        
        
        UIView *verifyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 110)];
        verifyView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label1a = [[UILabel alloc]initWithFrame:CGRectMake(10, 11, 100, 15)];
        label1a.font = [UIFont systemFontOfSize:15];
        label1a.text = @"取货地址";
        
        UILabel *label2a = [[UILabel alloc]initWithFrame:CGRectMake(120, 11, Sc_w - 130, 15)];
        label2a.textAlignment = NSTextAlignmentRight;
        label2a.font = [UIFont systemFontOfSize:14];
        
        
        
        UILabel *label3a = [[UILabel alloc]initWithFrame:CGRectMake(10, 11 + 15 + 19, 100, 15)];
        label3a.font = [UIFont systemFontOfSize:15];
        label3a.text = @"联系方式";
        
        UILabel *label4a = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 110, 11 + 34, 100, 15)];
        label4a.textAlignment = NSTextAlignmentRight;
        label4a.font = [UIFont systemFontOfSize:14];
        
        
        
        
        UILabel *label5a = [[UILabel alloc]initWithFrame:CGRectMake(10, 11 + 68, 130, 15)];
        label5a.font = [UIFont systemFontOfSize:15];
        label5a.text = @"取货码";
        
        UILabel *label6a = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 110, 11 + 68, 100, 15)];
        label6a.textAlignment = NSTextAlignmentRight;
        label6a.font = [UIFont systemFontOfSize:14];
        label6a.textColor = Color_system;
        
        [verifyView addSubview:label1a];
        [verifyView addSubview:label2a];
        [verifyView addSubview:label3a];
        [verifyView addSubview:label4a];
        [verifyView addSubview:label5a];
        [verifyView addSubview:label6a];
        
        NSDictionary *verifyAddr = parentorder[@"carrier"];
        
        label2a.text = verifyAddr[@"address"];
        label4a.text = verifyAddr[@"mobile"];
        label6a.text = parentorder[@"verifycode"];
        
        [footerView addSubview:verifyView];
        
        viewF1.frame = CGRectMake(0, 120, Sc_w, 110);
        CGSize viewSize = viewF2.frame.size;
        
        viewF2.frame = CGRectMake(0, 240, Sc_w, viewSize.height);
        footerView.frame = CGRectMake(0, 0, Sc_w, 240 + viewSize.height);
        
    }
    
    tableview.tableFooterView = footerView;
}

-(void)createFoot{
    
    UIView *selfFoot = [[UIView alloc]initWithFrame:CGRectMake(0, Sc_h - 64 - 52, Sc_w, 52)];
    selfFoot.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 10 - 65, 11, 65, 30)];
    btn1.layer.cornerRadius = 8.0;
    btn1.backgroundColor = My_gray;
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 setTitle:@"申请退款" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn1 addTarget:self action:@selector(refund) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 10 - 65 - 85, 11, 65, 30)];
    btn2.layer.cornerRadius = 8.0;
    btn2.backgroundColor = My_gray;
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 setTitle:@"确认收货" forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn2 addTarget:self action:@selector(achieveOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 10 - 65 - 85 * 2, 11, 65, 30)];
    btn3.layer.cornerRadius = 8.0;
    btn3.backgroundColor = My_gray;
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn3 setTitle:@"查看物流" forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn3 addTarget:self action:@selector(lookupLogistics:) forControlEvents:UIControlEventTouchUpInside];
    
    [selfFoot addSubview:btn1];
    [selfFoot addSubview:btn2];
    [selfFoot addSubview:btn3];
    
    [self.view addSubview:selfFoot];
    
    if ([_statusInfo isEqualToString:@"待付款"]) {
        btn1.hidden = YES;
        btn2.hidden = YES;
        btn3.hidden = YES;
//        selfFoot.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0];
        tableview.frame = CGRectMake(0, 0, Sc_w, Sc_h - 64);
        
        [selfFoot removeFromSuperview];
        
    } else if ([_statusInfo isEqualToString:@"待发货"]){
        btn2.hidden = YES;
        btn3.hidden = YES;
    } else if ([_statusInfo isEqualToString:@"待收货"]){
        btn1.hidden = YES;
        btn3.frame = btn2.frame;
        btn2.frame = btn1.frame;
    } else{//已完成
        btn2.hidden = YES;
        btn3.frame = btn2.frame;
    }
    
    if ([parentorder[@"refundstate"] integerValue] == 1) {
        btn1.hidden = YES;
        
        UIButton *btn4 = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 10 - 65, 11, 65, 30)];
        btn4.layer.cornerRadius = 8.0;
        btn4.backgroundColor = My_gray;
        [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn4 setTitle:@"取消申请" forState:UIControlStateNormal];
        btn4.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn4 addTarget:self action:@selector(cancelRefundrequest:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn5 = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 10 - 115 - 85, 11, 115, 30)];
        btn5.layer.cornerRadius = 8.0;
        btn5.backgroundColor = My_gray;
        [btn5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn5 setTitle:@"查看申请退款进度" forState:UIControlStateNormal];
        [btn5 setTitle:@"查询中" forState:UIControlStateSelected];
        btn5.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn5 addTarget:self action:@selector(cheakRefundSchedule:) forControlEvents:UIControlEventTouchUpInside];
        
        [selfFoot addSubview:btn4];
        [selfFoot addSubview:btn5];
    }
    
}

//查看退款进度
-(void)cheakRefundSchedule:(UIButton *)sender{
    
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    
    //订单ID
    [self.userInfo setObject:parentorder[@"id"] forKey:@"id"];
    //时间
    [self.userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
    
    [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:checkRefund] parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"退款进度 = %@",responseObject);
        RefundExplainVC *vc = [RefundExplainVC new];
        
        vc.userInfo = _userInfo;
        vc.orderInfo = _orderInfo;
        vc.refundSchedule = ((NSDictionary *)responseObject)[@"result"][@"refund"];
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
        sender.selected = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
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
        [self.userInfo setObject:parentorder[@"id"] forKey:@"id"];
        //时间
        [self.userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
        
        [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:cancelRefund] parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
                
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

//退款
-(void)refund{
    
    RefundViewController *vc = [RefundViewController new];
    vc.userInfo = _userInfo;
    vc.orderInfo = _orderInfo;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

//查看物流
-(void)lookupLogistics:(UIButton *)sender{
    
    if (sender.selected) {
        return;
    }
    [sender setTitle:@"查询中" forState:UIControlStateSelected];
    
//    sender.selected = YES;
    [UIView animateWithDuration:2.0 animations:^{
        sender.selected = YES;
    }];
    
    NSString *orderid = _orderInfo[@"parentorder"][@"id"];
    
    [_userInfo setObject:orderid forKey:@"id"];
    [_userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
    
    NSLog(@"%@",_userInfo);
    
    [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:lookupexpress] parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        LookupExpressVC *vc = [LookupExpressVC new];
        
        vc.data = dict;
        [self.navigationController pushViewController:vc animated:YES];
        sender.selected = NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//完成收货
-(void)achieveOrder:(UIButton *)sender{
    
    NSString *orderid = _orderInfo[@"parentorder"][@"id"];
    
    [_userInfo setObject:orderid forKey:@"orderid"];
    
    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认已经收到货了吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定收货" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self submitAchieve];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"还未收到" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"还未收到");
    }];
    
    [alertCtr addAction:action1];
    [alertCtr addAction:action2];
    
    
    [self presentViewController:alertCtr animated:YES completion:nil];
    
    
}


-(void)submitAchieve{
    
    [_userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
    [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:sureToachieve] parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSLog(@"确认收货 %@",dict);
        [self.view makeToast:((NSDictionary *)responseObject)[@"result"][@"message"]];
        
//        for (MyOrderTopTabBar *topbar in self.tableview.tableHeaderView.subviews) {
//            
//            [self tabBar:topbar didSelectIndex:1];
//        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return goods.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [goods[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary *goodsInfoDict = goods[indexPath.section][indexPath.row];
    
    OrderSureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pool"];
    if (!cell) {
        cell = [[OrderSureCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"pool"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.shoppingImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AddressPath,goodsInfoDict[@"thumb"]]]]];
    cell.title.text = goodsInfoDict[@"title"];
    
    NSString *typenames = goodsInfoDict[@"optionname"];
    cell.typeName.text = @"所选规格 : ";
    [cell.colortype setTitle:typenames forState:UIControlStateNormal];
    
    cell.colortype.frame = CGRectMake(cell.title.frame.origin.x + 60, CGRectGetMaxY(cell.title.frame) + 10, 14 * typenames.length, 20);
    if (typenames.length <= 2) {
        cell.colortype.frame = CGRectMake(cell.title.frame.origin.x + 60, CGRectGetMaxY(cell.title.frame) + 10, 18 * typenames.length, 20);
    }
    
    cell.price.text = [NSString stringWithFormat:@"￥%@",goodsInfoDict[@"price"]];
    cell.countLab.text = [NSString stringWithFormat:@"x%@",goodsInfoDict[@"total"]];
    return cell;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 40)];
    sectionHeaderView.backgroundColor = [UIColor whiteColor];
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 9.5, 22, 21)];
    imgV.image = [UIImage imageNamed:@"dianpu"];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, Sc_w - 50, 40)];
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.text = [[goods[section] firstObject] objectForKey:@"merchname"];
    
    [sectionHeaderView addSubview:imgV];
    [sectionHeaderView addSubview:titleLab];
    
    return sectionHeaderView;
}


-(void)backClick{
    if (_backtobefore == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (NSString *)getNowTimeTimestamp{
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
    
}


@end
