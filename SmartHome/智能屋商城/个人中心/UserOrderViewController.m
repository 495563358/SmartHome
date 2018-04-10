//
//  UserOrderViewController.m
//  SmartMall
//
//  Created by Smart house on 2017/10/9.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "MBProgressHUD.h"

#import "UserOrderViewController.h"

#import "MyOrderTopTabBar.h"

#import "ObjectTools.h"


#import "UIView+Toast.h"

#import "TabButton.h"

#import "PaySucByPostVC.h"

#import "PaySucBySelfVC.h"

//订单详情
#import "OrderDetailVC.h"

#import "ResetCreditPaypwdVC.h"


//物流
#import "LookupExpressVC.h"

//评论
#import "CommentViewController.h"

#import <AlipaySDK/AlipaySDK.h>

#import "Order.h"

#import "WXApi.h"

#import "TXTradePasswordView.h"

//IP地址
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@interface UserOrderViewController()<MyOrderTopTabBarDelegate,UITableViewDelegate,UITableViewDataSource,TXTradePasswordViewDelegate,WXApiDelegate>{
    NSString *stat;
    
    //弹出框
    UIView *backView;
    
    UIView *surePayView;
    
    UIView *selectPaywaysView;
    
    UILabel *payways;
    
    UIImageView *checkmark1;
    UIImageView *checkmark2;
    UIImageView *checkmark3;
    
    float yueMoney;
    
    float totalMoney;
    
    NSString *currentOrdersn;
    
    int postORself;
}


@property (nonatomic,strong)UITableView *tableview;

@property(nonatomic,strong)NSMutableArray *Mdata;

@end

@implementation UserOrderViewController

//订单列表
#define requestPath @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.apporder.getlist"

//获取余额信息
#define getcredit @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.appcreate.getcredit"

//是否设置了支付密码
#define issetpayPwd @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=member.appinfo.querypay"

//余额支付
#define requestAddr @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.apppay."

//订单详情
#define orderDetail @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.apporder.detail"

//取消订单
#define cancelOrderAddr @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.apporder.cancel"

//查看物流
#define lookupexpress @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.apporder.express"

//确认收货
#define sureToachieve @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.apporder.submit"

//删除订单
#define deleteOrder @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.apporder.deleted"

//支付宝签名
#define AlipaySign @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.apppay.alisign"

//支付宝支付成功
#define AlipaySuccess @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.apppay.alipay"


//微信统一下单
#define WeChatOrder @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.apppay.createsign"

//再次获取签名,准备支付
#define WeChatPay @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.apppay.createpay"

//微信支付成功
#define WeChatPaySuccess @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.apppay.complete"

-(NSMutableArray *)Mdata{
    if (!_Mdata) {
        _Mdata = [NSMutableArray array];
    }return _Mdata;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的订单";
    self.view.backgroundColor = My_gray;
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, Sc_h - 64) style:UITableViewStyleGrouped];
    _tableview.backgroundColor = My_gray;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    _tableview.sectionHeaderHeight = 45;
    
    [self.view addSubview:_tableview];
    
    MyOrderTopTabBar *toptabBar = [[MyOrderTopTabBar alloc]initWithArray:@[@"全部",@"待付款",@"待发货",@"待收货",@"已完成",@"售后中"]];
    toptabBar.frame = CGRectMake(0,0, Sc_w, 45);
    toptabBar.backgroundColor = [UIColor whiteColor];
    toptabBar.delegate = self;
    
    UIView *backgray = [[UIView alloc] initWithFrame:CGRectMake(0,0, Sc_w, 50)];
    backgray.backgroundColor = My_gray;
    [backgray addSubview:toptabBar];
    _tableview.tableHeaderView = backgray;
    
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    
    //默认为所有订单
    //_status = @"0";
    
    int num = 0;
    if (!_status) {
        num = -1;
        stat = @"等待处理中";
        [self downLoadSource:@"-1"];
        
    }else{
        num = [_status intValue];
        for (TabButton *sender in toptabBar.subviews) {
            if (sender.tag == num + 1) {
                [toptabBar TabBtnClick:sender];
                break;
            }
        }
    }
    
}

-(void)tabBar:(MyOrderTopTabBar *)tabBar didSelectIndex:(NSInteger)index{
    
//    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSString *status = nil;
    switch (index) {
        case 1:
            status = @"0";
            stat = @"待付款";
            break;
        case 2:
            status = @"1";
            stat = @"待发货";
            break;
        case 3:
            status = @"2";
            stat = @"待收货";
            break;
        case 4:
            status = @"3";
            stat = @"已完成";
            break;
        case 5:
            status = @"4";
            stat = @"售后中";
            break;
            
        case 0:
            status = @"-1";
            stat = @"等待处理中";
            break;
            
        default:
            break;
    }
    [self downLoadSource:status];
    
    
    
}

-(void)downLoadSource:(NSString *)status{
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *timestamp = [self getNowTimeTimestamp];
    
    [_userInfo setObject:timestamp forKey:@"timestamp"];
    if ([status isEqualToString:@"0"]||[status isEqualToString:@"1"]||[status isEqualToString:@"2"]||[status isEqualToString:@"3"] ||[status isEqualToString:@"4"])
        
        [_userInfo setObject:status forKey:@"status"];
    else
        [_userInfo removeObjectForKey:@"status"];
    
    [_userInfo setObject:@"1" forKey:@"page"];
    NSLog(@"传递参数 status = %@",_userInfo[@"status"]);
    
    [[ObjectTools sharedManager] POST:requestPath parameters:self.userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"该状态下的所有订单 = %@",result);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.Mdata removeAllObjects];
        if ([result[@"status"] intValue] == 0) {
            [mainWindowss makeToast:@"暂时没有任何订单哟~"];
            [self.tableview reloadData];
            return ;
        }
        NSArray *arr = result[@"result"];
        
        if (arr.count == 0) {
            [mainWindowss makeToast:@"暂时没有任何订单哟~"];
            [self.tableview reloadData];
            return ;
        }
        
        [self.Mdata addObjectsFromArray:arr];
        
        
        [self.tableview reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
    
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100 * [[[_Mdata[indexPath.section] objectForKey:@"goods"] objectAtIndex:indexPath.row] count] + 40;
}

//组头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _Mdata.count;
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[self.Mdata[section] objectForKey:@"goods"] count];
}

//组尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    int index = [_Mdata[section][@"status"] intValue];
    
    if (index == 0 || index == 2 || index == 3) {
        return  75;
    }
    return 5 + 40;
}


//组头内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSDictionary *data = _Mdata[section];
    
    UIView *sectionHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 40)];
    sectionHeader.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *ordersnLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, Sc_w - 60, 40)];
    ordersnLab.font = [UIFont systemFontOfSize:15];
    
    ordersnLab.text = [NSString stringWithFormat:@"订单号:%@",data[@"ordersn"]];
    
    UIImageView *moreImg = [[UIImageView alloc]initWithFrame:CGRectMake(Sc_w - 18, 12.5, 8, 15)];
    moreImg.image = [UIImage imageNamed:@"gengduo-拷贝"];
    
    
    sectionHeader.tag = section;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(createtempBtn:)];
    [sectionHeader addGestureRecognizer:tap];
    
    [sectionHeader addSubview:moreImg];
    [sectionHeader addSubview:ordersnLab];
    
    return sectionHeader;
    
}

-(void)createtempBtn:(UITapGestureRecognizer *)tap{
    
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UIButton *btn = [UIButton new];
    btn.tag = tap.view.tag;
    [self lookupOrderdetil:btn];
}

//查看订单详情
-(void)lookupOrderdetil:(UIButton *)sender{
    
    NSDictionary *dic = _Mdata[sender.tag];
    NSString *ordersn = dic[@"id"];
    [_userInfo setObject:ordersn forKey:@"orderid"];
    [_userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
    
#define CLog(format, ...)  NSLog(format, ## __VA_ARGS__)
    
#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
    NSLog(@"------------test = %@",_userInfo);
    
    [[ObjectTools sharedManager] POST:orderDetail parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resuk = (NSDictionary *)responseObject;
        
        OrderDetailVC *vc = [[OrderDetailVC alloc]init];
        
        switch ([dic[@"status"] intValue]) {
            case 0:
                vc.statusInfo = @"待付款";
                break;
            case 1:
                vc.statusInfo = @"待发货";
                break;
            case 2:
                vc.statusInfo = @"待收货";
                break;
            case 3:
                vc.statusInfo = @"已完成";
            default:
                break;
        }
        
        vc.backtobefore = 1;
        
        totalMoney = [resuk[@"result"][@"parentorder"][@"price"] floatValue];
        vc.orderInfo = resuk[@"result"];
        vc.totalMoney = totalMoney;
        
        vc.userInfo = _userInfo;
        
        NSDictionary *addr =resuk[@"result"][@"parentorder"][@"address"];
        if (!addr[@"id"]) {
            vc.nameAndTele = addr;
        }
        
        [self.navigationController pushViewController:vc animated:YES];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}


//组尾内容
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    NSDictionary *data = _Mdata[section];
    
    NSLog(@"订单状态 = %i",[data[@"status"] intValue]);
    if ([data[@"status"] intValue] == 0 || [data[@"status"] intValue] == 2 || [data[@"status"] intValue] == 3) {
        UIView *sectionFooter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 75)];
        sectionFooter.backgroundColor = [UIColor whiteColor];
        
        
        UILabel *infoLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, Sc_w - 30, 40)];
        infoLab.font = [UIFont systemFontOfSize:13];
        infoLab.textAlignment = NSTextAlignmentRight;
        
        NSString *str1 = [NSString stringWithFormat:@"%i",[data[@"goodstotal"] intValue]];
        NSString *str2 = [NSString stringWithFormat:@"￥%.2f",[data[@"price"] floatValue]];
        
        infoLab.text = [NSString stringWithFormat:@"共 %@ 个商品  合计:%@",str1,str2];
        
        NSMutableAttributedString *attrstr = [[NSMutableAttributedString alloc]initWithString:infoLab.text];
        NSRange range1 = [infoLab.text rangeOfString:str1];
        NSRange range2 = [infoLab.text rangeOfString:str2];
        
        [attrstr addAttribute:NSForegroundColorAttributeName value:Color_system range:range1];
        [attrstr addAttribute:NSForegroundColorAttributeName value:Color_system range:range2];
        
        infoLab.attributedText = attrstr;
        
        
        UIView *space1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, Sc_w, 5)];
        space1.backgroundColor = My_gray;
        
        //待付款
        if ([data[@"status"] intValue] == 0) {
            UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 170, 35, 70, 25)];
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn1.layer.cornerRadius = 8.0;
            btn1.backgroundColor = My_gray;
            btn1.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn1 setTitle:@"取消订单" forState:UIControlStateNormal];
            btn1.tag = section;
            [btn1 addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
            
            
            UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 90, 35, 70, 25)];
            [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn2.layer.cornerRadius = 8.0;
            btn2.backgroundColor = My_gray;
            btn2.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn2 setTitle:@"支付订单" forState:UIControlStateNormal];
            [btn2 setTitle:@"请稍后" forState:UIControlStateSelected];
            btn2.tag = section;
            [btn2 addTarget:self action:@selector(sureTopay:) forControlEvents:UIControlEventTouchUpInside];
            
            [sectionFooter addSubview:btn1];
            [sectionFooter addSubview:btn2];
            
            space1.frame = CGRectMake(0, 70, Sc_w, 5);
            
            
            
        }
        
        //已完成订单
        else if ([data[@"status"] intValue] == 3){
            
            UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 90, 35, 70, 25)];
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn1.layer.cornerRadius = 8.0;
            btn1.backgroundColor = My_gray;
            btn1.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn1 setTitle:@"查看物流" forState:UIControlStateNormal];
            [btn1 setTitle:@"查询中" forState:UIControlStateSelected];
            btn1.tag = section;
            [btn1 addTarget:self action:@selector(lookupLogistics:) forControlEvents:UIControlEventTouchUpInside];
            
            
            UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 90 - 60, 35, 50, 25)];
            [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn2.layer.cornerRadius = 8.0;
            btn2.backgroundColor = My_gray;
            btn2.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn2 setTitle:@"评价" forState:UIControlStateNormal];
            btn2.tag = section;
            [btn2 addTarget:self action:@selector(commentOrder:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 180 - 50, 35, 70, 25)];
            [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn3.layer.cornerRadius = 8.0;
            btn3.backgroundColor = My_gray;
            btn3.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn3 setTitle:@"删除订单" forState:UIControlStateNormal];
            btn3.tag = section;
            [btn3 addTarget:self action:@selector(deleteAchieveOrder:) forControlEvents:UIControlEventTouchUpInside];
            
            [sectionFooter addSubview:btn1];
            [sectionFooter addSubview:btn2];
            [sectionFooter addSubview:btn3];
            
            space1.frame = CGRectMake(0, 70, Sc_w, 5);
            //初次评价
            if ([data[@"iscomment"] intValue] == 0) {
                
            }
            //追加评价
            else if(([data[@"iscomment"] intValue] == 1)){
                btn2.hidden = YES;
                btn3.frame = CGRectMake(Sc_w - 170 - 80, 35, 70, 25);
                
                UIButton *subBtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 90 - 80, 35, 70, 25)];
                [subBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                subBtn.layer.cornerRadius = 8.0;
                subBtn.backgroundColor = My_gray;
                subBtn.titleLabel.font = [UIFont systemFontOfSize:13];
                [subBtn setTitle:@"追加评价" forState:UIControlStateNormal];
                subBtn.tag = section;
                [subBtn addTarget:self action:@selector(subCommentOrder:) forControlEvents:UIControlEventTouchUpInside];
                
                [sectionFooter addSubview:subBtn];
            }else{
                
                btn2.hidden = YES;
                btn3.frame = CGRectMake(Sc_w - 170, 35, 70, 25);
            }
            
            
        }
        
        //待收货
        else if ([data[@"status"] intValue] == 2){
            UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 180, 35, 70, 25)];
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn1.layer.cornerRadius = 8.0;
            btn1.backgroundColor = My_gray;
            btn1.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn1 setTitle:@"查看物流" forState:UIControlStateNormal];
            [btn1 setTitle:@"查询中" forState:UIControlStateSelected];
            btn1.tag = section;
            [btn1 addTarget:self action:@selector(lookupLogistics:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 90, 35, 70, 25)];
            [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn2.layer.cornerRadius = 8.0;
            btn2.backgroundColor = My_gray;
            btn2  .titleLabel.font = [UIFont systemFontOfSize:13];
            [btn2 setTitle:@"确认收货" forState:UIControlStateNormal];
            btn2.tag = section;
            [btn2 addTarget:self action:@selector(achieveOrder:) forControlEvents:UIControlEventTouchUpInside];
            
            [sectionFooter addSubview:btn1];
            [sectionFooter addSubview:btn2];
            
            space1.frame = CGRectMake(0, 70, Sc_w, 5);
        }
        
        [sectionFooter addSubview:infoLab];
        [sectionFooter addSubview:space1];
        
        return sectionFooter;
    }
    
    
    UIView *sectionFooter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 45)];
    sectionFooter.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *infoLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, Sc_w - 30, 40)];
    infoLab.font = [UIFont systemFontOfSize:13];
    infoLab.textAlignment = NSTextAlignmentRight;
    
    NSString *str1 = [NSString stringWithFormat:@"%i",[data[@"goodstotal"] intValue]];
    NSString *str2 = [NSString stringWithFormat:@"￥%.2f",[data[@"price"] floatValue]];
    
    infoLab.text = [NSString stringWithFormat:@"共 %@ 个商品  合计:%@",str1,str2];
    
    NSMutableAttributedString *attrstr = [[NSMutableAttributedString alloc]initWithString:infoLab.text];
    NSRange range1 = [infoLab.text rangeOfString:str1];
    NSRange range2 = [infoLab.text rangeOfString:str2];
    
    [attrstr addAttribute:NSForegroundColorAttributeName value:Color_system range:range1];
    [attrstr addAttribute:NSForegroundColorAttributeName value:Color_system range:range2];
    
    infoLab.attributedText = attrstr;
    
    UIView *space1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, Sc_w, 5)];
    space1.backgroundColor = My_gray;
    
    
//    UIButton *statBtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 85, 0, 80, 40)];
//    [statBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    statBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    
//    [statBtn setTitle:stat forState:UIControlStateNormal];
    
    
    [sectionFooter addSubview:infoLab];
    [sectionFooter addSubview:space1];
//    [sectionFooter addSubview:statBtn];
    
    return sectionFooter;
    
}


//评价
-(void)commentOrder:(UIButton *)sender{
    
    CommentViewController *vc = [CommentViewController new];
    
    vc.data = _Mdata[sender.tag];
    
    vc.userInfo = _userInfo;
    
    vc.isSub = false;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


//追加评价
-(void)subCommentOrder:(UIButton *)sender{
    
    CommentViewController *vc = [CommentViewController new];
    
    vc.data = _Mdata[sender.tag];
    
    vc.userInfo = _userInfo;
    
    vc.isSub = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


//删除订单 删除订单事件
-(void)deleteAchieveOrder:(UIButton *)sender{
    
    NSDictionary *dic = _Mdata[sender.tag];
    NSString *ordersn = dic[@"id"];
    [_userInfo setObject:ordersn forKey:@"orderid"];
    
    
    
    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要删除这个订单吗,删除后无法恢复" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确认删除");
        [self deleteorderaction];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertCtr addAction:action1];
    [alertCtr addAction:action2];
    
    [self presentViewController:alertCtr animated:YES completion:nil];
}

-(void)deleteorderaction{
    [_userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
    
    
    [[ObjectTools sharedManager] POST:deleteOrder parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"删除订单 = %@",(NSDictionary *)responseObject);
        
        [self.view makeToast:((NSDictionary *)responseObject)[@"result"][@"message"]];
        
        for (MyOrderTopTabBar *topbar in self.tableview.tableHeaderView.subviews) {
            
            [self tabBar:topbar didSelectIndex:4];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


//取消订单 取消订单事件
-(void)cancelOrder:(UIButton *)sender{
    NSDictionary *dic = _Mdata[sender.tag];
    NSString *ordersn = dic[@"id"];
    [_userInfo setObject:ordersn forKey:@"orderid"];
    
    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要取消这个订单吗?" preferredStyle:0];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"我不想买了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"我不想买了");
        [self cancelorder:@"我不想买了"];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"信息填写错误,重新拍" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"信息填写错误,重新拍");
        [self cancelorder:@"信息填写错误,重新拍"];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"同城见面交易" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"同城见面交易");
        [self cancelorder:@"同城见面交易"];
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"其他原因" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"其他原因");
        [self cancelorder:@"其他原因"];
    }];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"不取消了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel not want5");
    }];
    
    [alertCtr addAction:action1];
    [alertCtr addAction:action2];
    [alertCtr addAction:action3];
    [alertCtr addAction:action4];
    [alertCtr addAction:action5];
    
    
    [self presentViewController:alertCtr animated:YES completion:nil];

    
}

-(void)cancelorder:(NSString *)closereason{
    
    NSLog(@"closere = %@",closereason);
    
    [_userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
    [_userInfo setObject:closereason forKey:@"closereason"];
    
    [[ObjectTools sharedManager] POST:cancelOrderAddr parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"reason = %@",(NSDictionary *)responseObject);
        
        [self.view makeToast:((NSDictionary *)responseObject)[@"result"][@"message"]];
        
        for (MyOrderTopTabBar *topbar in self.tableview.tableHeaderView.subviews) {
            
            [self tabBar:topbar didSelectIndex:1];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


//支付订单
-(void)sureTopay:(UIButton *)sender{
    
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    
    NSLog(@"支付订单 按钮位置 %@",_Mdata[sender.tag]);
    
    NSString *ordersn = _Mdata[sender.tag][@"ordersn"];
    NSString *price = _Mdata[sender.tag][@"price"];
    
    //地址ID
    NSString *addressid = _Mdata[sender.tag][@"addressid"];
    //邮寄1 自提0
    if ([addressid intValue] == 0)
        postORself = 0;
    else
        postORself = 1;
    
    NSLog(@"%i",postORself);
    
    totalMoney = [price floatValue];
    
    currentOrdersn = ordersn;
    
    NSLog(@"总价 = %.2f,订单号 = %@",totalMoney,currentOrdersn);
    
    __block NSString *credit2 = @"0.00";//余额
    
    [_userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
    //获取余额
    
    [[ObjectTools sharedManager] POST:getcredit parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDict = (NSDictionary *)responseObject;
        
        credit2 = [resultDict[@"result"] objectForKey:@"credit2"];//设置余额 后面用
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        [self pushPays:[user objectForKey:@"MallAccount"] andPrice:price andCreadit:credit2];
        
        sender.selected = NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"余额获取失败 = %@",error);
    }];
    
}


//查看物流
-(void)lookupLogistics:(UIButton *)sender{
    
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    
    NSString *orderid = _Mdata[sender.tag][@"id"];
    
    [_userInfo setObject:orderid forKey:@"id"];
    [_userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
    
    NSLog(@"%@",_userInfo);
    
    [[ObjectTools sharedManager] POST:lookupexpress parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        LookupExpressVC *vc = [LookupExpressVC new];
        
        vc.data = dict;
        [self.navigationController pushViewController:vc animated:YES];
        
        sender.selected = NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        sender.selected = NO;
        [self.view makeToast:@"网络错误,请检查网络后重试"];
        
    }];
    
}


//完成收货
-(void)achieveOrder:(UIButton *)sender{
    
    NSString *orderid = _Mdata[sender.tag][@"id"];
    
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
    
    [[ObjectTools sharedManager] POST:sureToachieve parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSLog(@"确认收货 %@",dict);
        [self.view makeToast:((NSDictionary *)responseObject)[@"result"][@"message"]];
        
        for (MyOrderTopTabBar *topbar in self.tableview.tableHeaderView.subviews) {
            
            [self tabBar:topbar didSelectIndex:1];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:@"网络错误,请检查网络后重试"];
    }];
    
}


//cell内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@%ld%ld",stat,(long)indexPath.section,(long)indexPath.row]];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[NSString stringWithFormat:@"%@%ld%ld",stat,(long)indexPath.section,(long)indexPath.row]];
    }
    
    if (cell.contentView.subviews.count >= 2) {
        return cell;
    }
    
    NSArray *data = [[_Mdata[indexPath.section] objectForKey:@"goods"] objectAtIndex:indexPath.row];
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    imgV.image = [UIImage imageNamed:@"dianpu"];
    
    UILabel *storeName = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, Sc_w - 40, 39)];
    storeName.font = [UIFont systemFontOfSize:14];
    storeName.text = [data[0] objectForKey:@"merchname"];
    
    //状态按钮
    UIButton *statBtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 85, 0, 80, 40)];
    [statBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    statBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    switch ([_Mdata[indexPath.section][@"status"] intValue]) {
        case 0:
            stat = @"待付款";
            break;
        case 1:{
            //0为快递 1为自提
            if ( [_Mdata[indexPath.section][@"dispatchtype"] intValue] == 1) {
                stat = @"待取货";
            }else
                stat = @"待发货";
            //1为退款中
            if ([_Mdata[indexPath.section][@"refundstate"] intValue] == 1) {
                
                NSString *str = [NSString stringWithFormat:@"%@(退款中)",stat];
                stat = str;
                
                statBtn.frame = CGRectMake(Sc_w - 125, 0, 120, 40);
                
            }
            
            break;
        }
        case 2:
            stat = @"待收货";
            break;
        case 3:
            stat = @"已完成";
        default:
            break;
    }
    statBtn.tag = indexPath.section;
    [statBtn setTitle:stat forState:UIControlStateNormal];
    [statBtn addTarget:self action:@selector(lookupOrderdetil:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 39.5, Sc_w, 0.5)];
    line1.backgroundColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1.0];
    
    for (int i = 0; i<data.count; i++) {
        //    商品图片
        UIImageView *shoppingImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 40 + 14 + 100*i, 70, 70)];
        
        shoppingImgView.layer.borderWidth = 1;
        shoppingImgView.layer.borderColor = My_gray.CGColor;
        
        [cell.contentView addSubview:shoppingImgView];
        
        //    商品标题
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shoppingImgView.frame)+10, 40 + 100*i + 10, Sc_w -CGRectGetMaxX(shoppingImgView.frame)-15, 21)];
        title.font=[UIFont systemFontOfSize:14];
        title.textColor=[UIColor blackColor];
        [cell.contentView addSubview:title];
        
        //    规格
        UILabel *typeName = [[UILabel alloc] initWithFrame:CGRectMake(title.frame.origin.x, CGRectGetMaxY(title.frame) + 10, 60, 20)];
        typeName.font=[UIFont systemFontOfSize:12];
        typeName.textColor=[UIColor blackColor];
        [cell.contentView addSubview:typeName];
        
        
        NSString *typenames = data[i][@"optionname"];
        UIButton *colortype = [[UIButton alloc]initWithFrame:CGRectMake(title.frame.origin.x + 60, CGRectGetMaxY(title.frame) + 10, 14 * typenames.length, 20)];
        
        if (typenames.length <= 2) {
            colortype.frame = CGRectMake(title.frame.origin.x + 60, CGRectGetMaxY(title.frame) + 10, 18 * typenames.length, 20);
        }
        
        colortype.layer.cornerRadius = 3.0;
        colortype.titleLabel.font = [UIFont systemFontOfSize:12];
        colortype.backgroundColor = Color_system;
        [cell.contentView addSubview:colortype];
        
        UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(title.frame.origin.x, CGRectGetMaxY(typeName.frame)+12, 100, 17)];
        price.hidden =NO;
        price.font =  [UIFont systemFontOfSize:14];
//        price.textColor = Color_system;
        [cell.contentView addSubview:price];
        
        
        UILabel *countLab = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 60, 40 + 100*i + 60, 40, 20)];
        countLab.font = [UIFont systemFontOfSize:14];
        countLab.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:countLab];
        
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AddressPath,data[i][@"thumb"]]]]];
            NSLog(@"%@%@",AddressPath,data[i][@"thumb"]);
            dispatch_async(dispatch_get_main_queue(), ^{
                shoppingImgView.image = img;
            });
        });
        
        title.text = data[i][@"title"];
        typeName.text = [NSString stringWithFormat:@"所选规格 : "];
        
        [colortype setTitle:typenames forState:UIControlStateNormal];
        
        price.text = [NSString stringWithFormat:@"￥%@",data[i][@"price"]];
        countLab.text = [NSString stringWithFormat:@"x%@",data[i][@"total"]];
    }
    
    [cell.contentView addSubview:imgV];
    [cell.contentView addSubview:storeName];
    [cell.contentView addSubview:line1];
    [cell.contentView addSubview:statBtn];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

//创建弹出视图  调用下面两个方法
-(void)pushPays:(NSString *)acc andPrice:(NSString *)totalPrice andCreadit:(NSString *)creaditMoney{
    
    backView = [[UIView alloc]initWithFrame:Sc_bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    [self.view addSubview:backView];
    
    [self createSurePayView:acc andPrice:totalPrice];
    [self createPaywaysView:creaditMoney];
}

//弹出视图的第一个视图 确认付款
-(void)createSurePayView:(NSString *)acc andPrice:(NSString *)totalPrice{
    surePayView = [[UIView alloc]initWithFrame:CGRectMake(0, Sc_h - 464, Sc_w, 400)];
    
    surePayView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 45)];
    titleLab.text = @"确认付款";
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 33, 11, 23, 23)];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"chanc"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 45, Sc_w, 1)];
    view1.backgroundColor = My_gray;
    
    
    UILabel *priceLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 46, Sc_w, 80)];
    priceLab.textAlignment = NSTextAlignmentCenter;
    priceLab.text = [@"￥" stringByAppendingString:totalPrice];
    priceLab.font = [UIFont systemFontOfSize:20];
    
    UILabel *accLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 126, 80, 41)];
    accLab.text = @"账号";
    accLab.font = [UIFont systemFontOfSize:14];
    accLab.textColor = [UIColor grayColor];
    
    UILabel *accLab1 = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 150, 126, 140, 41)];
    accLab1.text = acc;
    accLab1.font = [UIFont systemFontOfSize:14];
    accLab1.textAlignment = NSTextAlignmentRight;
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 167, Sc_w, 1)];
    view2.backgroundColor = My_gray;
    
    
    UILabel *paywaysTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 168, 100, 41)];
    paywaysTitle.text = @"付款方式";
    paywaysTitle.font = [UIFont systemFontOfSize:14];
    paywaysTitle.textColor = [UIColor grayColor];
    
    
    payways = [[UILabel alloc]initWithFrame:CGRectMake(0, 168, Sc_w - 22, 41)];
    payways.text = @"请选择付款方式";
    payways.font = [UIFont systemFontOfSize:14];
    payways.textAlignment = NSTextAlignmentRight;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPayways)];
    payways.userInteractionEnabled = YES;
    
    [payways addGestureRecognizer:tap];
    
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(Sc_w - 18, 168 + 13, 8, 15)];
    imgView.image = [UIImage imageNamed:@"gengduo-拷贝"];
    
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 209, Sc_w, 1)];
    view3.backgroundColor = My_gray;
    
    
    UIButton *surePay = [[UIButton alloc]initWithFrame:CGRectMake(10, 400 - 40 - 20, Sc_w - 20, 40)];
    [surePay setTitle:@"立即付款" forState:UIControlStateNormal];
    surePay.titleLabel.font = [UIFont systemFontOfSize:14];
    surePay.layer.cornerRadius = 10.0;
    surePay.layer.masksToBounds = YES;
    surePay.backgroundColor = Color_system;
    [surePay addTarget:self action:@selector(surePayClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [surePayView addSubview:titleLab];
    [surePayView addSubview:cancelBtn];
    [surePayView addSubview:view1];
    
    
    [surePayView addSubview:priceLab];
    [surePayView addSubview:accLab];
    [surePayView addSubview:accLab1];
    [surePayView addSubview:view2];
    
    [surePayView addSubview:paywaysTitle];
    [surePayView addSubview:payways];
    [surePayView addSubview:imgView];
    [surePayView addSubview:view3];
    
    [surePayView addSubview:surePay];
    
    [self.view addSubview:surePayView];
}

//弹出视图第二个视图 选择付款方式
-(void)createPaywaysView:(NSString *)creaditMoney{
    
    selectPaywaysView = [[UIView alloc]initWithFrame:CGRectMake(Sc_w, Sc_h - 464, Sc_w, 400)];
    selectPaywaysView.backgroundColor = [UIColor whiteColor];
    selectPaywaysView.tag = 0;
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 45)];
    titleLab.text = @"选择付款方式";
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 45)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui-hui"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backtoFirst) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 45, Sc_w, 1)];
    view1.backgroundColor = My_gray;
    
    
    
    UIImageView *payimg1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 46 + 12, 30, 25)];
    payimg1.image = [UIImage imageNamed:@"weixin"];
    
    UILabel *nameLab1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 46 , Sc_w - 60, 49)];
    nameLab1.font = [UIFont systemFontOfSize:14];
    nameLab1.text = @"微信";
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 46 + 49, Sc_w, 1)];
    view2.backgroundColor = My_gray;
    
    checkmark1 = [[UIImageView alloc]initWithFrame:CGRectMake(Sc_w - 20 - 14, 46 + 17, 19, 14)];
    checkmark1.image = [UIImage imageNamed:@"zhuanz"];
    checkmark1.hidden = YES;
    
    [selectPaywaysView addSubview:payimg1];
    [selectPaywaysView addSubview:nameLab1];
    [selectPaywaysView addSubview:view2];
    [selectPaywaysView addSubview:checkmark1];
    
    UIImageView *payimg2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 46 + 12 + 50, 30, 25)];
    payimg2.image = [UIImage imageNamed:@"jifubao"];
    
    UILabel *nameLab2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 46 + 50, Sc_w - 60, 49)];
    nameLab2.font = [UIFont systemFontOfSize:14];
    nameLab2.text = @"支付宝";
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 46 + 49 + 50, Sc_w, 1)];
    view3.backgroundColor = My_gray;
    
    checkmark2 = [[UIImageView alloc]initWithFrame:CGRectMake(Sc_w - 20 - 14, 46 + 17 + 50, 19, 14)];
    checkmark2.image = [UIImage imageNamed:@"zhuanz"];
    checkmark2.hidden = YES;
    
    [selectPaywaysView addSubview:checkmark2];
    [selectPaywaysView addSubview:payimg2];
    [selectPaywaysView addSubview:nameLab2];
    [selectPaywaysView addSubview:view3];
    
    UIImageView *payimg3 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 46 + 12 + 50 + 50, 30, 25)];
    payimg3.image = [UIImage imageNamed:@"qianbao"];
    
    UILabel *nameLab3 = [[UILabel alloc]initWithFrame:CGRectMake(60, 46 + 50 + 50, Sc_w - 60, 49)];
    nameLab3.font = [UIFont systemFontOfSize:14];
    nameLab3.text = @"钱包";
    
    UILabel *creadLab = [[UILabel alloc]initWithFrame:CGRectMake(110, 146, 150, 49)];
    creadLab.font = [UIFont systemFontOfSize:14];
    creadLab.textColor = Color_system;
    creadLab.text = [NSString stringWithFormat:@"当前余额:%@",creaditMoney];
    yueMoney = [creaditMoney floatValue];
    
    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(0, 46 + 49 + 50 + 50, Sc_w, 1)];
    view4.backgroundColor = My_gray;
    
    checkmark3 = [[UIImageView alloc]initWithFrame:CGRectMake(Sc_w - 20 - 14, 46 + 17 + 100, 19, 14)];
    checkmark3.image = [UIImage imageNamed:@"zhuanz"];
    checkmark3.hidden = YES;
    
    [selectPaywaysView addSubview:checkmark3];
    [selectPaywaysView addSubview:payimg3];
    [selectPaywaysView addSubview:nameLab3];
    [selectPaywaysView addSubview:creadLab];
    [selectPaywaysView addSubview:view4];
    
    
    
    [selectPaywaysView addSubview:titleLab];
    [selectPaywaysView addSubview:backBtn];
    [selectPaywaysView addSubview:view1];
    
    
    [self.view addSubview:selectPaywaysView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick1)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick2)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick3)];
    
    
    nameLab1.userInteractionEnabled = YES;
    nameLab2.userInteractionEnabled = YES;
    nameLab3.userInteractionEnabled = YES;
    
    [nameLab1 addGestureRecognizer:tap1];
    [nameLab2 addGestureRecognizer:tap2];
    [nameLab3 addGestureRecognizer:tap3];
}

//取消支付按钮
-(void)cancelClick{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"取消支付" message:@"您确认要取消支付吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) if (buttonIndex == 1) {
        [surePayView removeFromSuperview];
        surePayView = nil;
        [backView removeFromSuperview];
        backView = nil;
        
    }
}

//确认支付
-(void)surePayClick{
    
    switch (selectPaywaysView.tag) {
        case 0:
            [self.view makeToast:@"请先选择付款方式"];
            break;
        case 1:
            [self WechatPay];
            
            break;
        case 2:
            [self alipayuser];
            break;
        case 3:{
            
            [self creaditPay];
            
            break;
        }
        default:
            break;
    }
    
    
    
}

-(void)onResp:(BaseResp *)resp{
    
    NSLog(@"sad");
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                
            {
                NSLog(@"支付成功");
                [_userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
                
                [[ObjectTools sharedManager] POST:WeChatPaySuccess parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *orderInfoSuc = (NSDictionary *)responseObject;
                    
                    NSLog(@"支付成功信息 %@",orderInfoSuc);
                    
                    //支付成功
                    if (postORself == 1) {
                        PaySucByPostVC *vc = [PaySucByPostVC new];
                        
                        vc.totalMoney = totalMoney;
                        vc.addrInfo = [orderInfoSuc[@"parentorder"] objectForKey:@"address"];
                        vc.orderInfo = orderInfoSuc;
                        
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{
                        PaySucBySelfVC *vc = [PaySucBySelfVC new];
                        
                        vc.totalMoney = totalMoney;
                        vc.addrInfo = [orderInfoSuc[@"parentorder"] objectForKey:@"address"];
                        vc.orderInfo = orderInfoSuc;
                        vc.nameAndTele = [orderInfoSuc[@"parentorder"] objectForKey:@"address"];
                        
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self.view makeToast:@"网络错误,请检查网络后重试"];
                }];
            }
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                if (resp.errCode == -2) {
                    
                    [self.view makeToast:@"您取消了支付"];
                }else if (resp.errCode == -1){
                    [self.view makeToast:@"可能的原因：签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等"];
                }
                break;
        }
    }
}

-(void) onReq:(BaseReq*)req{
    NSLog(@"req------------------------");
    
}

//微信支付

-(void)WechatPay{
    NSString *addressIP = [self getIPAddress:YES];
    [_userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
    [_userInfo setObject:currentOrdersn forKey:@"ordersn"];
    [_userInfo setObject:[NSString stringWithFormat:@"%.2f",totalMoney] forKey:@"price"];
    [_userInfo setObject:addressIP forKey:@"ip"];
    
    
    
    NSString *homepath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)lastObject];
    
    NSString *path = [homepath stringByAppendingString:@"/orderinfo.plist"];
    
    [_userInfo setObject:@"dd" forKey:@"flag"];
    [_userInfo writeToFile:path atomically:YES];
    
    NSLog(@"%@",_userInfo);
    
    [[ObjectTools sharedManager] POST:WeChatOrder parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSLog(@"获取预付单签名返回 = %@",dict);
        
        NSString *sign = dict[@"result"];
        NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
        
        [mdict removeObjectForKey:@"result"];
        [mdict removeObjectForKey:@"status"];
        [mdict setObject:sign forKey:@"sign"];
        [mdict setObject:@"APP" forKey:@"trade_type"];
        [mdict setObject:@"http://mall.znhomes.com/app/back.php" forKey:@"notify_url"];
        
        NSString *nonce_str = mdict[@"nonce"];
        [mdict removeObjectForKey:@"nonce"];
        [mdict setObject:nonce_str forKey:@"nonce_str"];
        
        
        [mdict setObject:addressIP forKey:@"spbill_create_ip"];
        
        NSLog(@"提交给微信端的数据 = \n%@",mdict);
        
        //        NSString *xmlwriter = [XMLWriter XMLStringFromDictionary:mdict withHeader:YES];
        
        NSMutableString *mstr = [NSMutableString new];
        
        [mstr appendString:@"<xml>\n"];
        
        
        
        for (NSString *key in mdict.allKeys) {
            [mstr appendString:[NSString stringWithFormat:@"<%@>%@</%@>\n",key,[mdict objectForKey:key],key]];
        }
        [mstr appendString:@"</xml>\n"];
        
        
        NSLog(@"mstr = %@\n",mstr);
        
        
        
        
        //1.创建会话对象
        NSURLSession *session = [NSURLSession sharedSession];
        //2.根据会话对象创建task
        NSURL *url = [NSURL URLWithString:@"https://api.mch.weixin.qq.com/pay/unifiedorder"];
        //3.创建可变的请求对象
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        //4.修改请求方法为POST
        request.HTTPMethod = @"POST";
        //        [request setValue:@"application/json;encoding=utf-8" forHTTPHeaderField:@"Content-Type"];
        //5.设置请求体
        NSString *prame = mstr;
        request.HTTPBody = [prame dataUsingEncoding:NSUTF8StringEncoding];
        //6.根据会话对象创建一个Task(发送请求）
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
            //8.解析数据
            //根据后端数据解析
            NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            //NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"微信返回xml数据 = %@",str);
            
            NSRange range = [str rangeOfString:@"<prepay_id><![CDATA["];
            range.location += range.length;
            range.length = [str length] - range.location;
            
            
            NSRange range2 = [str rangeOfString:@"]]></prepay_id>" options:NSCaseInsensitiveSearch range:range];
            range.length = range2.location - range.location;
            NSString *subStr = [str substringWithRange:range];
            NSLog(@"预付单ID = %@",subStr);
            //
            
            
            [_userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
            [_userInfo setObject:subStr forKey:@"prepayid"];
            
            [[ObjectTools sharedManager] POST:WeChatPay parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@",responseObject);
                
                NSDictionary *orderInfo = (NSDictionary *)responseObject;
                
                PayReq *request = [[PayReq alloc] init];
                //商户号
                request.partnerId = orderInfo[@"partnerid"];
                
                request.prepayId= subStr;
                
                request.package = @"Sign=WXPay";
                
                request.nonceStr= orderInfo[@"nonce"];
                
                request.timeStamp = [orderInfo[@"timestamp"] intValue];
                
                request.sign= orderInfo[@"result"];
                
                BOOL returnResult = [WXApi sendReq:request];
                
                if (!returnResult) {
                    [self.view makeToast:@"无法打开微信客户端"];
                }else{
                    [self.view makeToast:@"正在与微信客户端连接,请稍后"];
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self.view makeToast:@"网络错误,请检查网络后重试"];
            }];
            
            
            /* dispatch_async(dispatch_get_main_queue(), ^{
             网络请求自动开启在子线程，UI刷新的代码需要回到主线程操作
             });
             */
        }];
        //7.执行任务
        [dataTask resume];
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:@"网络错误,请检查网络后重试"];
    }];
    
    
}

//获取设备当前网络IP地址
- (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

//获取所有相关IP信息
- (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                    
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}


//支付宝支付
-(void)alipayuser{
    
    [_userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
    [_userInfo setObject:currentOrdersn forKey:@"ordersn"];
    [_userInfo setObject:[NSString stringWithFormat:@"%.2f",totalMoney] forKey:@"price"];
    
    NSLog(@"_info = %f",totalMoney);
    
    NSString *homepath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)lastObject];
    
    NSString *path = [homepath stringByAppendingString:@"/orderinfo.plist"];
    [_userInfo writeToFile:path atomically:YES];
    
    [[ObjectTools sharedManager] POST:AlipaySign parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",(NSDictionary *)responseObject);
        
        NSDictionary *result = (NSDictionary *)responseObject;
        
        NSString *signedString = result[@"orderinfo"];
        
        NSDictionary *conInfo = result[@"con"];
        
        /*
         *生成订单信息及签名
         */
        //将商品信息赋予AlixPayOrder的成员变量
        Order* order = [Order new];
        
        // NOTE: app_id设置
        order.app_id = @"2017082808429788";
        
        // NOTE: 支付接口名称
        order.method = @"alipay.trade.app.pay";
        
        // NOTE: 参数编码格式
        order.charset = @"utf-8";
        
        // NOTE: 当前时间点
        NSDateFormatter* formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        order.timestamp = [formatter stringFromDate:[NSDate date]];
        
        // NOTE: 支付版本
        order.version = @"1.0";
        
        // NOTE: sign_type 根据商户设置的私钥来决定
        order.sign_type = @"RSA2";
        
        // NOTE: 商品数据
        order.biz_content = [BizContent new];
        order.biz_content.body = conInfo[@"body"];
        order.biz_content.subject = conInfo[@"subject"];
        order.biz_content.out_trade_no = conInfo[@"out_trade_no"]; //订单ID（由商家自行制定）
        order.biz_content.timeout_express = conInfo[@"timeout_express"]; //超时时间设置
        order.biz_content.total_amount = conInfo[@"total_amount"]; //商品价格
        
        //将商品信息拼接成字符串
        NSString *orderInfo = [order orderInfoEncoded:NO];
        NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
        NSLog(@"orderSpec = %@",orderInfo);
        
        // NOTE: 如果加签成功，则继续执行支付
        if (signedString != nil) {
            //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
            NSString *appScheme = @"SmerHomer2016";
            
            // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                     orderInfoEncoded, signedString];
            
            // NOTE: 调用支付结果开始支付
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                
                NSLog(@"支付回调 = %@",resultDic);
                
                if ([resultDic[@"resultStatus"] integerValue] == 9000) {
                    
                    [_userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
                    
                    [[ObjectTools sharedManager] POST:AlipaySuccess parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
                        
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSDictionary *orderInfoSuc = [(NSDictionary *)responseObject objectForKey:@"result"];
                        
                        NSLog(@"支付成功信息 %@",orderInfoSuc);
                        [surePayView removeFromSuperview];
                        surePayView = nil;
                        [backView removeFromSuperview];
                        backView = nil;
                        //支付成功
                        if (postORself == 1) {
                            PaySucByPostVC *vc = [PaySucByPostVC new];
                            
                            vc.totalMoney = totalMoney;
                            vc.addrInfo = [orderInfoSuc[@"parentorder"] objectForKey:@"address"];
                            vc.orderInfo = orderInfoSuc;
                            
                            [self.navigationController pushViewController:vc animated:YES];
                        }else{
                            PaySucBySelfVC *vc = [PaySucBySelfVC new];
                            
                            vc.totalMoney = totalMoney;
                            vc.addrInfo = [orderInfoSuc[@"parentorder"] objectForKey:@"address"];
                            vc.orderInfo = orderInfoSuc;
                            vc.nameAndTele = [orderInfoSuc[@"parentorder"] objectForKey:@"address"];
                            
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [self.view makeToast:@"网络错误,请检查网络后重试"];
                    }];
                }
                else
                    [self.view makeToast:@"支付失败,您取消了支付"];
                
            }];
            
            [[AlipaySDK defaultService]processOrderWithPaymentResult:[NSURL URLWithString:appScheme] standbyCallback:^(NSDictionary *resultDic) {
                
                NSLog(@"支付回调 = %@",resultDic);
                
                if ([resultDic[@"resultStatus"] integerValue] == 9000) {
                    
                    [_userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
                    
                    [[ObjectTools sharedManager] POST:AlipaySuccess parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
                        
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSDictionary *orderInfoSuc = [(NSDictionary *)responseObject objectForKey:@"result"];
                        
                        NSLog(@"支付成功信息 %@",orderInfoSuc);
                        [surePayView removeFromSuperview];
                        surePayView = nil;
                        [backView removeFromSuperview];
                        backView = nil;
                        //支付成功
                        if (postORself == 1) {
                            PaySucByPostVC *vc = [PaySucByPostVC new];
                            
                            vc.totalMoney = totalMoney;
                            vc.addrInfo = [orderInfoSuc[@"parentorder"] objectForKey:@"address"];
                            vc.orderInfo = orderInfoSuc;
                            
                            [self.navigationController pushViewController:vc animated:YES];
                        }else{
                            PaySucBySelfVC *vc = [PaySucBySelfVC new];
                            
                            vc.totalMoney = totalMoney;
                            vc.addrInfo = [orderInfoSuc[@"parentorder"] objectForKey:@"address"];
                            vc.orderInfo = orderInfoSuc;
                            vc.nameAndTele = [orderInfoSuc[@"parentorder"] objectForKey:@"address"];
                            
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [self.view makeToast:@"网络错误,请检查网络后重试"];
                    }];
                }
                else
                    [self.view makeToast:@"支付失败,您取消了支付"];
                
            }];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:@"网络错误,请检查网络后重试"];
    }];
    
    
}



//余额支付
-(void)creaditPay{
    
    [self.view makeToast:@"请求支付中,请稍后"];
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (yueMoney < totalMoney) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%f",totalMoney);
        [self.view makeToast:@"余额不足,请充值"];
        return;
    }
    
    
    [_userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
    
    
    [[ObjectTools sharedManager] POST:issetpayPwd parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *backresult = (NSDictionary *)responseObject;
        if ([backresult[@"status"] intValue] == 0) {
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有设置支付密码,请先设置支付密码再进行支付,点击确定为您跳转到设置支付密码页面" preferredStyle:UIAlertControllerStyleAlert];
            
            [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ResetCreditPaypwdVC *vc = [ResetCreditPaypwdVC new];
                
                //            vc.moblie = _moblie;
                //            vc.headImg = _headImg;
                
                [self.navigationController pushViewController:vc animated:YES];
            }]];
            
            [self presentViewController:alertVC animated:YES completion:nil];
        }else{
            TXTradePasswordView *TXView = [[TXTradePasswordView alloc]initWithFrame:CGRectMake(0, 100,SCREEN_WIDTH, 200) WithTitle:@"请输入支付密码"];
            TXView.TXTradePasswordDelegate = self;
            if (![TXView.TF becomeFirstResponder])
            {
                //成为第一响应者。弹出键盘
                [TXView.TF becomeFirstResponder];
            }
            
            UIView *backview = [[UIView alloc]initWithFrame:Sc_bounds];
            backview.backgroundColor = [UIColor whiteColor];
            backview.alpha = 1;
            
            [backview addSubview:TXView];
            
            [[UIApplication sharedApplication].keyWindow addSubview:backview];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:@"网络错误,请检查网络后重试"];
    }];
    
}


#pragma mark  密码输入结束后调用此方法
-(void)TXTradePasswordView:(TXTradePasswordView *)view WithPasswordString:(NSString *)Password
{
    [_userInfo setObject:Password forKey:@"payment"];
    [_userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
    [_userInfo setObject:currentOrdersn forKey:@"ordersn"];
    
    NSLog(@"密码 = %@",Password);
    
    [view.superview removeFromSuperview];
    [[ObjectTools sharedManager] POST:[requestAddr stringByAppendingString:@"creditpay"] parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"支付成功返回信息 = %@",result);
        
        if ([result[@"status"] intValue] == 0) {
            [self.view makeToast:result[@"result"][@"message"]];
        }else{
            
            [surePayView removeFromSuperview];
            surePayView = nil;
            [backView removeFromSuperview];
            backView = nil;
            NSDictionary *dict = [(NSDictionary *)responseObject objectForKey:@"result"];
            //支付成功
            if (postORself == 1) {
                PaySucByPostVC *vc = [PaySucByPostVC new];
                
                vc.totalMoney = totalMoney;
                vc.addrInfo = [dict[@"parentorder"] objectForKey:@"address"];
                vc.orderInfo = dict;
                
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                PaySucBySelfVC *vc = [PaySucBySelfVC new];
                
                vc.totalMoney = totalMoney;
                vc.addrInfo = [dict[@"parentorder"] objectForKey:@"address"];
                vc.orderInfo = dict;
                vc.nameAndTele = [dict[@"parentorder"] objectForKey:@"address"];
                
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"余额支付失败");
        
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        [self.view makeToast:@"支付失败"];
    }];
    
}


-(void)tapClick1{
    selectPaywaysView.tag = 1;
    checkmark1.hidden = NO;
    checkmark2.hidden = YES;
    checkmark3.hidden = YES;
    [self backtoFirst];
}
-(void)tapClick2{
    selectPaywaysView.tag = 2;
    checkmark1.hidden = YES;
    checkmark2.hidden = NO;
    checkmark3.hidden = YES;
    [self backtoFirst];
}
-(void)tapClick3{
    selectPaywaysView.tag = 3;
    checkmark1.hidden = YES;
    checkmark2.hidden = YES;
    checkmark3.hidden = NO;
    [self backtoFirst];
}

//选择支付方式
-(void)selectPayways{
    [UIView animateWithDuration:0.5 animations:^{
        surePayView.frame = CGRectMake(-Sc_w, Sc_h - 464, Sc_w, 400);
        selectPaywaysView.frame = CGRectMake(0, Sc_h - 464, Sc_w, 400);
    }];
    
}

//选择完返回
-(void)backtoFirst{
    
    switch (selectPaywaysView.tag) {
        case 1:
            payways.text = @"微信";
            break;
        case 2:
            payways.text = @"支付宝";
            break;
        case 3:
            payways.text = @"钱包";
        default:
            break;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        surePayView.frame = CGRectMake(0, Sc_h - 464, Sc_w, 400);
        selectPaywaysView.frame = CGRectMake(Sc_w, Sc_h - 464, Sc_w, 400);
        
    }];
}
- (NSString *)getNowTimeTimestamp{
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
