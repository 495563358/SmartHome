//
//  OrderDetailVC.h
//  SmartMall
//
//  Created by Smart house on 2017/9/14.
//  Copyright © 2017年 verb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailVC : UIViewController

//订单所有信息
@property (nonatomic ,strong)NSDictionary *orderInfo;
//总价
@property (nonatomic ,assign)float totalMoney;

//自提信息
@property (nonatomic ,strong)NSDictionary *nameAndTele;

//包邮
@property (nonatomic ,assign)int issendFree;

//返回上一页还是首页
@property (nonatomic ,assign)int backtobefore;
//身份验证
@property (nonatomic ,strong)NSMutableDictionary *userInfo;
//状态信息 待付款 待发货 待收货 已完成
@property (nonatomic ,copy)NSString *statusInfo;
@end
