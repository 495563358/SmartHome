//
//  ShopCarBuyViewCtr.m
//  SmartMall
//
//  Created by Smart house on 2017/9/21.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "ShopCarBuyViewCtr.h"

#import "OrderSureCell.h"

#import "PaySucByPostVC.h"

#import "PaySucBySelfVC.h"

#import <CommonCrypto/CommonDigest.h>

#import "AdressViewController.h"

#import "ObjectTools.h"

#import "UIView+Toast.h"
#import "MBProgressHUD.h"

//是否设置了支付密码
#define issetpayPwd @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=member.appinfo.querypay"


//创建订单
#define createOrder @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.appcreate.cartorder"

//获取余额信息
#define getcredit @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.appcreate.getcredit"

//余额支付
#define requestAddr @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.apppay."

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

#import <AlipaySDK/AlipaySDK.h>

#import "Order.h"

#import "WXApi.h"

#import "TXTradePasswordView.h"

#import "ResetCreditPaypwdVC.h"

//IP地址
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@interface ShopCarBuyViewCtr ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,setDefaultAddrDelegate,TXTradePasswordViewDelegate,WXApiDelegate>{
    
    //快递配送
    UIButton *expressBt;
    //门店自提
    UIButton *pickupSelf;
    
    UITableView *tableview;
    UIView *headerView;
    UIView *footerView;
    
    UILabel *totalLab;
    UILabel *postageLab;
    UILabel *discountLab;
    
    UILabel *pickupName;
    UILabel *pickupTele;
    
    UILabel *together;
    UIButton *payBtn;
    
    
    UIView *addressView;
    
    UIView *pickupView;
    
    //收货人
    UILabel *hosterName;
    
    //电话
    UILabel *teleLab;
    
    UILabel *detilAddr;
    
    UIImageView *moreImgview;
    
    UIButton *noaddr;
    
    UIImageView *locaImage;
    
    //弹出框
    UIView *backView;
    
    UIView *surePayView;
    
    UIView *selectPaywaysView;
    
    UILabel *payways;
    
    UIImageView *checkmark1;
    UIImageView *checkmark2;
    UIImageView *checkmark3;
    
    
    //data
    NSDictionary *addrDict;//地址信息
    NSMutableArray *goodsInfo;//产品信息
    
    int totalCount;
    
    float totalMoney;//实际支付价格
    
    float prodSinglePrice;//产品总价
    
    float postMoney;//邮费
    
    float discountPrice;//优惠价
    
    float yueMoney;//余额
    
    NSString *ordersn;//订单号
    
}



@property (nonatomic ,strong)NSMutableArray *Mdata;

@property (nonatomic ,strong)NSMutableDictionary *userInfo;

@end

@implementation ShopCarBuyViewCtr

-(NSMutableArray *)Mdata{
    if (!_Mdata) {
        _Mdata = [NSMutableArray array];
    }return _Mdata;
}

-(NSMutableDictionary *)userInfo{
    if (!_userInfo) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *token = [user objectForKey:@"userToken"];
        NSString *nonce = [self GetNonce];
        NSString *signStr = [NSString stringWithFormat:@"token=%@&12345",token];
        NSString *sign = [self MD5:signStr];
        NSDictionary *dic =  @{@"nonce":nonce,@"sign":sign,@"token":token};
        
        _userInfo = [NSMutableDictionary dictionaryWithDictionary:dic];
    }return _userInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    addrDict = _Mdict[@"address"];
    
    goodsInfo = [NSMutableArray array];
    goodsInfo = _Mdict[@"goods"];
    
    self.navigationItem.title = @"确认订单";
    
    self.view.backgroundColor = My_gray;
    
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Sc_w, Sc_h - 110) style:UITableViewStyleGrouped];
    
    tableview.delegate = self;
    tableview.dataSource = self;
    
    tableview.sectionHeaderHeight = 0;
    tableview.sectionFooterHeight = 1;
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    
    
    [self createView];
    
    [self.view addSubview:tableview];
    
}

//创建视图
-(void)createView{
    expressBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Sc_w/2, 45)];
    [expressBt setTitle:@"快递配送" forState:UIControlStateNormal];
    [expressBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [expressBt setTitleColor:Color_system forState:UIControlStateSelected];
    [expressBt addTarget:self action:@selector(expressClick:) forControlEvents:UIControlEventTouchUpInside];
    expressBt.titleLabel.font = [UIFont systemFontOfSize:15];
    expressBt.backgroundColor = [UIColor whiteColor];
    
    
    pickupSelf = [[UIButton alloc] initWithFrame:CGRectMake(Sc_w/2, 0, Sc_w/2, 45)];
    [pickupSelf setTitle:@"上门自提" forState:UIControlStateNormal];
    [pickupSelf setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pickupSelf setTitleColor:Color_system forState:UIControlStateSelected];
    [pickupSelf addTarget:self action:@selector(pickupSelfClick:) forControlEvents:UIControlEventTouchUpInside];
    pickupSelf.titleLabel.font = [UIFont systemFontOfSize:15];
    pickupSelf.backgroundColor = [UIColor whiteColor];
    
    
    //快递配送
    addressView = [[UIView alloc]initWithFrame:CGRectMake(0, 55, Sc_w, 89)];
    addressView.backgroundColor = [UIColor whiteColor];
    
    
    locaImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 35, 16, 20)];
    locaImage.image = [UIImage imageNamed:@"weiz"];
    
    hosterName = [[UILabel alloc]initWithFrame:CGRectMake(46, 15, 200, 15)];
    hosterName.font = [UIFont systemFontOfSize:15];
    hosterName.text = [NSString stringWithFormat:@"收货人：%@",addrDict[@"realname"]];
    
    teleLab = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 150, 15, 100, 15)];
    teleLab.font = [UIFont systemFontOfSize:15];
    teleLab.text = addrDict[@"mobile"];
    
    detilAddr = [[UILabel alloc]initWithFrame:CGRectMake(46, 10 + 15 + 20, Sc_w - 100, 36)];
    detilAddr.font = [UIFont systemFontOfSize:13];
    detilAddr.numberOfLines = 0;
    detilAddr.text = [NSString stringWithFormat:@"收货地址： %@%@%@ %@",addrDict[@"province"],addrDict[@"city"],addrDict[@"area"],addrDict[@"address"]];
    
    
    moreImgview = [[UIImageView alloc]initWithFrame:CGRectMake(Sc_w - 25, 81/2, 8, 15)];
    moreImgview.image = [UIImage imageNamed:@"gengduo-拷贝"];
    
    if ([addrDict[@"status"] integerValue] == 0) {
        hosterName.hidden = YES;
        detilAddr.hidden = YES;
        locaImage.hidden = YES;
        moreImgview.hidden = YES;
        noaddr = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 89)];
        noaddr.titleLabel.font = [UIFont systemFontOfSize:15];
        [noaddr setTitleColor:Color_system forState:UIControlStateNormal];
        [noaddr setTitle:@"您还没有设置默认收货地址,点击设置。" forState:UIControlStateNormal];
        [noaddr addTarget: self action:@selector(addAddr) forControlEvents:UIControlEventTouchUpInside];
        [addressView addSubview:noaddr];
    }
    
    //修改地址
    UITapGestureRecognizer *selectAddrTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addAddr)];
    [addressView addGestureRecognizer:selectAddrTap];
    
    
    [addressView addSubview:locaImage];
    [addressView addSubview:hosterName];
    [addressView addSubview:teleLab];
    [addressView addSubview:detilAddr];
    [addressView addSubview:moreImgview];
    
    
    //自提
    pickupView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, Sc_w, 70 + 10 + 42 * 2)];
    pickupView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *locaImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 25, 16, 20)];
    locaImage2.image = [UIImage imageNamed:@"weiz"];
    
    
    UILabel *pickupTitle = [[UILabel alloc]initWithFrame:CGRectMake(46, 13, 100, 15)];
    pickupTitle.font = [UIFont systemFontOfSize:15];
    pickupTitle.text = @"取货地址";
    
    
    UILabel *detilAddr2 = [[UILabel alloc]initWithFrame:CGRectMake(46, 10 + 15 + 15, Sc_w - 100, 13)];
    detilAddr2.font = [UIFont systemFontOfSize:13];
    
    if (![addrDict objectForKey:@"ztaddress"]) {
        detilAddr2.text = [addrDict objectForKey:@"ztaddress"];
    }else{
        detilAddr2.text = @"深圳龙华新区大浪澳华商务大厦801";
    }
    
    UIView *back1 = [[UIView alloc]initWithFrame:CGRectMake(0, 70, Sc_w, 10)];
    back1.backgroundColor = My_gray;
    
    
    pickupName = [[UILabel alloc]initWithFrame:CGRectMake(100, 70 + 10, Sc_w - 20, 41)];
    UIView *back2 = [[UIView alloc]initWithFrame:CGRectMake(0, 80 + 41, Sc_w, 1)];
    back2.backgroundColor = My_gray;
    UILabel *labs1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 70 + 10, 90, 41)];
    labs1.font = [UIFont systemFontOfSize:15];
    labs1.text = @"取货人";
    pickupName.font = [UIFont systemFontOfSize:15];
    pickupName.text = [addrDict objectForKey:@"realname"];
    
    
    
    pickupTele = [[UILabel alloc]initWithFrame:CGRectMake(100, 70 + 10 + 42, Sc_w - 20, 41)];
    UIView *back3 = [[UIView alloc]initWithFrame:CGRectMake(0, 80 + 41 + 42, Sc_w, 1)];
    back3.backgroundColor = My_gray;
    
    UILabel *labs2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 70 + 42 + 10, 90, 41)];
    labs2.font = [UIFont systemFontOfSize:15];
    labs2.text = @"联系电话";
    pickupTele.font = [UIFont systemFontOfSize:15];
    pickupTele.text = [addrDict objectForKey:@"mobile"];
    
    
    [pickupView addSubview:pickupTitle];
    [pickupView addSubview:locaImage2];
    [pickupView addSubview:detilAddr2];
    [pickupView addSubview:back1];
    [pickupView addSubview:back2];
    [pickupView addSubview:back3];
    
    [pickupView addSubview:pickupName];
    [pickupView addSubview:pickupTele];
    [pickupView addSubview:labs1];
    [pickupView addSubview:labs2];
    
    
    
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 145)];
    tableview.tableHeaderView = headerView;
    headerView.backgroundColor = My_gray;
    
    footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 126 + 64)];
    tableview.tableFooterView = footerView;
    tableview.backgroundColor = My_gray;
    
    
    [headerView addSubview:expressBt];
    [headerView addSubview:pickupSelf];
    
    
    
    
    for (NSDictionary *dict in goodsInfo) {
        float price = [dict[@"marketprice"] floatValue] * [dict[@"total"] integerValue];
        float count = [dict[@"total"] intValue];
        float yhprice = [dict[@"yhprice"] floatValue];
        
        prodSinglePrice += price;
        totalCount += count;
        discountPrice += yhprice;
        
    }
    
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 22)];
    label1.font = [UIFont systemFontOfSize:15];
    label1.text = @"购买数量";
    
    UILabel *label11 = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 60, 10, 40, 22)];
    label11.font = [UIFont systemFontOfSize:15];
    label11.textAlignment = NSTextAlignmentRight;
    label11.text = [NSString stringWithFormat:@"x%i",totalCount];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 41)];
    view1.backgroundColor = [UIColor whiteColor];
    [view1 addSubview:label1];
    [view1 addSubview:label11];
//    [view1 addSubview:buycount];
    
    
    
    
    
    
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 22)];
    label2.font = [UIFont systemFontOfSize:15];
    label2.text = @"商品小计";
    totalLab = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 140, 10, 120, 22)];
    totalLab.font = [UIFont systemFontOfSize:15];
    totalLab.textAlignment = NSTextAlignmentRight;
    
    
    
    totalLab.text = [NSString stringWithFormat:@"￥ %.2f",prodSinglePrice];
    
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 42, Sc_w, 41)];
    view2.backgroundColor = [UIColor whiteColor];
    [view2 addSubview:label2];
    [view2 addSubview:totalLab];
    
    
    
    
    
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 22)];
    label3.font = [UIFont systemFontOfSize:15];
    label3.text = @"会员优惠";
    discountLab = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 140, 10, 120, 22)];
    
    discountLab.textAlignment = NSTextAlignmentRight;
    
    
    discountLab.text = [NSString stringWithFormat:@"￥ -%.2f",discountPrice];
    discountLab.font = [UIFont systemFontOfSize:15];
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 84, Sc_w, 41)];
    view3.backgroundColor = [UIColor whiteColor];
    [view3 addSubview:label3];
    [view3 addSubview:discountLab];
    
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 22)];
    label4.font = [UIFont systemFontOfSize:15];
    label4.text = @"运费";
    postageLab = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 100, 10, 80, 22)];
    
    postageLab.textAlignment = NSTextAlignmentRight;
    NSString *exchange = [[goodsInfo firstObject] objectForKey:@"exchange"];
    postageLab.text = [NSString stringWithFormat:@"￥ %.2f",[exchange floatValue]];
    postageLab.font = [UIFont systemFontOfSize:15];
    
    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(0, 126, Sc_w, 41)];
    view4.backgroundColor = [UIColor whiteColor];
    [view4 addSubview:label4];
    [view4 addSubview:postageLab];
    
    [footerView addSubview:view1];
    [footerView addSubview:view2];
    [footerView addSubview:view3];
    [footerView addSubview:view4];
    
    
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, Sc_h - 64 - 48, Sc_w, 48)];
    footView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w/2 - 60, 0, 40, 48)];
    
    lab1.font = [UIFont systemFontOfSize:15];
    lab1.text = @"合计:";
    
    together = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w/2 - 20, 0, 80 + 30, 48)];
    together.textColor = color(224, 0, 0, 1);
    
    together.font = [UIFont systemFontOfSize:20];
    together.textAlignment = NSTextAlignmentRight;
    
    totalMoney = prodSinglePrice + postMoney - discountPrice;
    together.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];
    together.textAlignment = NSTextAlignmentJustified;
    
    
    payBtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 80, 0, 80, 48)];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    payBtn.backgroundColor = Color_system;
    [payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [footView addSubview:lab1];
    [footView addSubview:together];
    [footView addSubview:payBtn];
    
    [self.view addSubview:footView];
    
    [self expressClick:expressBt];
}

//添加地址
-(void)addAddr{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    
    NSString *token = [user objectForKey:@"userToken"];
    
    NSString *nonce = [self GetNonce];
    NSString *timestamp = [self getNowTimeTimestamp];
    NSString *signStr = [NSString stringWithFormat:@"token=%@&12345",token];
    NSString *sign = [self MD5:signStr];
    
    NSDictionary *dict = @{@"nonce":nonce,@"timestamp":timestamp,@"token":token,@"sign":sign};
    
    AdressViewController *vc = [[AdressViewController alloc]init];
    vc.dict = dict;
    
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
}


//代理方法
-(void) setDefaultAddr:(NSDictionary *)defaultAddrInfo{
    if (defaultAddrInfo) {
        addrDict = defaultAddrInfo;
        hosterName.text = [NSString stringWithFormat:@"收货人：%@",defaultAddrInfo[@"realname"]];
        
        teleLab.text = defaultAddrInfo[@"mobile"];
        detilAddr.text = [NSString stringWithFormat:@"收货地址： %@%@%@ %@",defaultAddrInfo[@"province"],defaultAddrInfo[@"city"],defaultAddrInfo[@"area"],defaultAddrInfo[@"address"]];
        
        hosterName.hidden = NO;
        detilAddr.hidden = NO;
        locaImage.hidden = NO;
        moreImgview.hidden = NO;
        noaddr.hidden = YES;
        
        //修改自提信息
        pickupName.text = [addrDict objectForKey:@"realname"];
        pickupTele.text = [addrDict objectForKey:@"mobile"];
        
        NSLog(@"changeaddrDict = %@",addrDict);
        
    }
}



//立即支付 生成订单 跳出支付方式
-(void)payBtnClick{
    
    //如果地址为空 返回
    if ([addrDict[@"id"] integerValue] <= 0) {
        [self.view.superview makeToast:@"请先完善个人收货信息"];
        return;
    }
    
    
    //提示创建订单中
    [[UIApplication sharedApplication].keyWindow makeToast:@"正在为您创建订单,请稍后"];
     [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    
    
    //4个身份验证
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:@"userToken"];
    NSString *nonce = [self GetNonce];
    NSString *timestamp = [self getNowTimeTimestamp];
    NSString *signStr = [NSString stringWithFormat:@"token=%@&12345",token];
    NSString *sign = [self MD5:signStr];
    
    
    //商品信息 传过去生成订单用
    
    
//    NSMutableArray *orderInfo = [NSMutableArray array];
//    
//    for (NSDictionary *dicc in goodsInfo) {
////        NSString *marketprice = dicc[@"marketprice"];
//        
//        NSDictionary *diccc = @{@"goodsid":dicc[@"goodsid"],@"optionid":dicc[@"optionid"],@"total":dicc[@"total"],@"marketprice":dicc[@"marketprice"],@"id":dicc[@"cartid"]};
//        [orderInfo addObject:diccc];
//    }
    
    
    
    NSData *goodsData = [NSJSONSerialization dataWithJSONObject:goodsInfo options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *dataStr = [[NSString alloc]initWithData:goodsData encoding:NSUTF8StringEncoding];
    
    
    NSString *addressid = [_Mdict[@"address"] objectForKey:@"id"];
    
    __block NSString *credit2 = @"0.00";//余额
    
    //获取余额
    [[ObjectTools sharedManager] POST:getcredit parameters:@{@"nonce":nonce,@"timestamp":timestamp,@"sign":sign,@"token":token} progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDict = (NSDictionary *)responseObject;
        
        credit2 = [resultDict[@"result"] objectForKey:@"credit2"];
        
        //快递配送
        if (expressBt.selected) {
            
            NSString *quickid = @"0";
            
            NSDictionary *dict = @{@"nonce":nonce,@"timestamp":timestamp,@"token":token,@"sign":sign,@"quickid":quickid,@"addressid":addressid,@"goodsdata":dataStr};
            [[ObjectTools sharedManager] POST:createOrder parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *resultDict = (NSDictionary *)responseObject;
                
                NSLog(@"快递配送生成订单返回信息 = %@",resultDict);
                
                
                //账号 成交价 订单号
                NSString *acc = [user objectForKey:@"MallAccount"];
                NSString *totalprice = [NSString stringWithFormat:@"￥%.2f",totalMoney];
                ordersn = [resultDict[@"result"] objectForKey:@"ordersn"];
                
                
                //弹出框
                [self pushPays:acc andPrice:totalprice andCreadit:credit2];
                 [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"快递配送生成订单失败 = %@",error);
                 [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            }];
        }
        
        //门店自提
        else{
            NSString *quickid = @"1";
            NSDictionary *dict = @{@"nonce":nonce,@"timestamp":timestamp,@"token":token,@"sign":sign,@"quickid":quickid,@"addressid":addressid,@"goodsdata":dataStr};
            
            [[ObjectTools sharedManager] POST:createOrder parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *resultDict = (NSDictionary *)responseObject;
                
                NSLog(@"result = %@",resultDict);
                NSString *acc = [user objectForKey:@"MallAccount"];
                
                NSString *totalprice = [NSString stringWithFormat:@"￥%.2f",totalMoney];
                
                ordersn = [resultDict[@"result"] objectForKey:@"ordersn"];
                
                
                //弹出框
                [self pushPays:acc andPrice:totalprice andCreadit:credit2];
                
                 [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"门店自提生成订单失败 = %@",error);
                 [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            }];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"余额获取失败 = %@",error);
         [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    }];
    
}

//创建弹出视图  调用下面两个方法
-(void)pushPays:(NSString *)acc andPrice:(NSString *)totalPrice andCreadit:(NSString *)creaditMoney{
    
    backView = [[UIView alloc]initWithFrame:Sc_bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    [self.view addSubview:backView];
    
    selectPaywaysView = [UIView new];
    selectPaywaysView.tag = 1;
    [self createSurePayView:acc andPrice:totalPrice andCreaditMoney:creaditMoney];
}

#pragma mark 选择付款方式
-(void)createSurePayView:(NSString *)acc andPrice:(NSString *)totalPrice andCreaditMoney:(NSString *)creaditMoney{
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
    priceLab.text = totalPrice;
    priceLab.font = [UIFont systemFontOfSize:30];
    
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
    
    [surePayView addSubview:surePay];
    
    [self.view addSubview:surePayView];
    
    //付款方式
    UIImageView *payimg1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 168 + 12, 30, 25)];
    payimg1.image = [UIImage imageNamed:@"weixin"];
    
    UILabel *nameLab1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 168 , Sc_w - 60, 49)];
    nameLab1.font = [UIFont systemFontOfSize:14];
    nameLab1.text = @"微信";
    
    UIView *space1 = [[UIView alloc]initWithFrame:CGRectMake(0, 217, Sc_w, 1)];
    space1.backgroundColor = My_gray;
    
    checkmark1 = [[UIImageView alloc]initWithFrame:CGRectMake(Sc_w - 20 - 14, 168 + 17, 19, 14)];
    checkmark1.image = [UIImage imageNamed:@"zhuanz"];
    checkmark1.hidden = NO;
    
    [surePayView addSubview:payimg1];
    [surePayView addSubview:nameLab1];
    [surePayView addSubview:space1];
    [surePayView addSubview:checkmark1];
    
    UIImageView *payimg2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 218 + 12, 30, 25)];
    payimg2.image = [UIImage imageNamed:@"jifubao"];
    
    UILabel *nameLab2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 218, Sc_w - 60, 49)];
    nameLab2.font = [UIFont systemFontOfSize:14];
    nameLab2.text = @"支付宝";
    
    UIView *space2 = [[UIView alloc]initWithFrame:CGRectMake(0, 217 + 50, Sc_w, 1)];
    space2.backgroundColor = My_gray;
    
    checkmark2 = [[UIImageView alloc]initWithFrame:CGRectMake(Sc_w - 20 - 14, 218 + 17, 19, 14)];
    checkmark2.image = [UIImage imageNamed:@"zhuanz"];
    checkmark2.hidden = YES;
    
    [surePayView addSubview:checkmark2];
    [surePayView addSubview:payimg2];
    [surePayView addSubview:nameLab2];
    [surePayView addSubview:space2];
    
    UIImageView *payimg3 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 218 + 12 + 50, 30, 25)];
    payimg3.image = [UIImage imageNamed:@"qianbao"];
    
    UILabel *nameLab3 = [[UILabel alloc]initWithFrame:CGRectMake(60, 218 + 50, Sc_w - 60, 49)];
    nameLab3.font = [UIFont systemFontOfSize:14];
    nameLab3.text = @"钱包";
    
    UILabel *creadLab = [[UILabel alloc]initWithFrame:CGRectMake(110, 218 + 50, 150, 49)];
    creadLab.font = [UIFont systemFontOfSize:14];
    creadLab.textColor = Color_system;
    creadLab.text = [NSString stringWithFormat:@"当前余额:%@",creaditMoney];
    yueMoney = [creaditMoney floatValue];
    
    UIView *space3 = [[UIView alloc]initWithFrame:CGRectMake(0, 267 + 50, Sc_w, 1)];
    space3.backgroundColor = My_gray;
    
    checkmark3 = [[UIImageView alloc]initWithFrame:CGRectMake(Sc_w - 20 - 14, 218 + 50 + 17, 19, 14)];
    checkmark3.image = [UIImage imageNamed:@"zhuanz"];
    checkmark3.hidden = YES;
    
    [surePayView addSubview:checkmark3];
    [surePayView addSubview:payimg3];
    [surePayView addSubview:nameLab3];
    [surePayView addSubview:creadLab];
    [surePayView addSubview:space3];
    
    
    
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
    if (buttonIndex == 1) {
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
                [self.userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
                
                [[ObjectTools sharedManager] POST:WeChatPaySuccess parameters:self.userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *orderInfoSuc = (NSDictionary *)responseObject;
                    
                    NSLog(@"支付成功信息 %@",orderInfoSuc);
                    
                    //支付成功
                    if (expressBt.selected) {
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
    NSLog(@"微信req---");
    
}
//微信支付
-(void)WechatPay{
    
    
    NSString *addressIP = [self getIPAddress:YES];
    [self.userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
    [self.userInfo setObject:ordersn forKey:@"ordersn"];
    [self.userInfo setObject:[NSString stringWithFormat:@"%.2f",totalMoney] forKey:@"price"];
    [self.userInfo setObject:addressIP forKey:@"ip"];
    
    
    
    NSString *homepath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)lastObject];
    
    NSString *path = [homepath stringByAppendingString:@"/orderinfo.plist"];
    
    [self.userInfo setObject:@"dd" forKey:@"flag"];
    [self.userInfo writeToFile:path atomically:YES];
    
    NSLog(@"%@",self.userInfo);
    
    
    [[ObjectTools sharedManager] POST:WeChatOrder parameters:self.userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
                
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
        
        
        NSData *data = [NSPropertyListSerialization dataWithPropertyList:mdict format:NSPropertyListXMLFormat_v1_0 options:1 error:NULL];
        
        NSString *passStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"mstr = %@\npss = %@",mstr,passStr);
        
        
        
        
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
            NSLog(@"%@",subStr);
            //
            
            
            [self.userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
            [self.userInfo setObject:subStr forKey:@"prepayid"];
            
            
            [[ObjectTools sharedManager] POST:WeChatPay parameters:self.userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
                
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
                
                [WXApi sendReq:request];
                
                BOOL returnResult = [WXApi sendReq:request];
                
                if (!returnResult) {
                    [self.view makeToast:@"无法打开微信客户端"];
                }else{
                    
                    [self.view makeToast:@"正在与微信客户端连接,请稍后"];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
            /* dispatch_async(dispatch_get_main_queue(), ^{
             网络请求自动开启在子线程，UI刷新的代码需要回到主线程操作
             });
             */
        }];
        //7.执行任务
        [dataTask resume];
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
    
    [self.userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
    [self.userInfo setObject:ordersn forKey:@"ordersn"];
    [self.userInfo setObject:[NSString stringWithFormat:@"%.2f",totalMoney] forKey:@"price"];
    
    NSLog(@"_info = %f",totalMoney);
    
    NSString *homepath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)lastObject];
    
    NSString *path = [homepath stringByAppendingString:@"/orderinfo.plist"];
    [self.userInfo writeToFile:path atomically:YES];
    
    [[ObjectTools sharedManager] POST:AlipaySign parameters:self.userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
                
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
                    
                    [self.userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
                    
                    [[ObjectTools sharedManager] POST:AlipaySuccess parameters:self.userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSDictionary *orderInfoSuc = [(NSDictionary *)responseObject objectForKey:@"result"];
                        
                        NSLog(@"支付成功信息 %@",orderInfoSuc);
                        [surePayView removeFromSuperview];
                        surePayView = nil;
                        [backView removeFromSuperview];
                        backView = nil;
                        //支付成功
                        if (expressBt.selected) {
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
                        
                    }];
                }
                else
                    [self.view makeToast:@"支付失败,您取消了支付"];
                
            }];
            
            [[AlipaySDK defaultService]processOrderWithPaymentResult:[NSURL URLWithString:appScheme] standbyCallback:^(NSDictionary *resultDic) {
                
                
                NSString *memo = resultDic[@"memo"];
                if (memo.length < 2) {
                    memo = @"支付失败";
                }
                [self.view makeToast:memo];
                NSLog(@"支付回调 = %@",memo);
                
                if ([resultDic[@"resultStatus"] integerValue] == 9000) {
                    
                    [self.userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
                    
                    [[ObjectTools sharedManager] POST:AlipaySuccess parameters:self.userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSDictionary *orderInfoSuc = [(NSDictionary *)responseObject objectForKey:@"result"];
                        
                        NSLog(@"支付成功信息 %@",orderInfoSuc);
                        [surePayView removeFromSuperview];
                        surePayView = nil;
                        [backView removeFromSuperview];
                        backView = nil;
                        //支付成功
                        if (expressBt.selected) {
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
                        
                    }];
                }else
                    [self.view makeToast:@"支付失败,您取消了支付"];
                
            }];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}


//余额支付
-(void)creaditPay{
    
    [self.view makeToast:@"请求支付中,请稍后"];
    
    if (yueMoney < totalMoney) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        NSLog(@"%f",totalMoney);
        [self.view makeToast:@"余额不足,请充值"];
        return;
    }
    
    NSLog(@"userinfo = %@",self.userInfo);
    [self.userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
    
    
    [[ObjectTools sharedManager] POST:issetpayPwd parameters:self.userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
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
        
    }];
}


#pragma mark  密码输入结束后调用此方法
-(void)TXTradePasswordView:(TXTradePasswordView *)view WithPasswordString:(NSString *)Password
{
    [self.userInfo setObject:Password forKey:@"payment"];
    [self.userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
    [self.userInfo setObject:ordersn forKey:@"ordersn"];
    
    NSLog(@"密码 = %@",Password);
    
    [view.superview removeFromSuperview];
    [[ObjectTools sharedManager] POST:[requestAddr stringByAppendingString:@"creditpay"] parameters:self.userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
                
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
            if (expressBt.selected) {
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
}
-(void)tapClick2{
    selectPaywaysView.tag = 2;
    checkmark1.hidden = YES;
    checkmark2.hidden = NO;
    checkmark3.hidden = YES;
}
-(void)tapClick3{
    selectPaywaysView.tag = 3;
    checkmark1.hidden = YES;
    checkmark2.hidden = YES;
    checkmark3.hidden = NO;
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






//快递配送
-(void)expressClick:(UIButton *)sender{
    
    if (sender.selected) {
        return;
    }
    sender.selected = !sender.selected;
    
    
    [pickupView removeFromSuperview];
    [headerView addSubview:addressView];
    
    headerView.frame = CGRectMake(0, 0, Sc_w, 145);
    [tableview beginUpdates];
    
    [tableview setTableHeaderView:headerView];
    
    [tableview endUpdates];
    
    if (pickupSelf.selected) {
        pickupSelf.selected = !pickupSelf.selected;
    }
    
//    [self getPostMoney];
    postMoney = [[goodsInfo[0] objectForKey:@"exchange"] floatValue];
    postageLab.text = [NSString stringWithFormat:@"￥ %.2f",postMoney];
    
    totalMoney = prodSinglePrice + postMoney - discountPrice;
    together.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];
}


//上门自提
-(void)pickupSelfClick:(UIButton *)sender{
    
    
    if (!_isZT) {
        [self.view makeToast:@"您所选中的商品暂不支持自提"];
        return;
    }
    
    if (sender.selected) {
        return;
    }
    sender.selected = !sender.selected;
    
    
    
    
    [addressView removeFromSuperview];
    [headerView addSubview:pickupView];
    
    
    headerView.frame = CGRectMake(0, 0, Sc_w, 145 - 9 + 84);
    [tableview beginUpdates];
    
    [tableview setTableHeaderView:headerView];
    
    [tableview endUpdates];
    
    
    
    if (expressBt.selected) {
        expressBt.selected = !expressBt.selected;
    }
    
    postMoney = 0.00;
    postageLab.text = [NSString stringWithFormat:@"￥%.2f",postMoney];
    totalMoney = prodSinglePrice - discountPrice;
    together.text = [NSString stringWithFormat:@"￥%.2f",totalMoney];
    
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return goodsInfo.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderSureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pool"];
    if (!cell) {
        cell = [[OrderSureCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"pool"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *infoDict = goodsInfo[indexPath.row];
    
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AddressPath,infoDict[@"thumb"]]]];
    
    cell.shoppingImgView.image = [UIImage imageWithData:imgData];
    
    cell.title.text = infoDict[@"gtitle"];
    
    NSString *typenames = infoDict[@"title"];
    cell.typeName.text = @"所选规格 : ";
    [cell.colortype setTitle:typenames forState:UIControlStateNormal];
    
    if (!typenames) {
        typenames = @"无";
    }
    
    cell.colortype.frame = CGRectMake(cell.title.frame.origin.x + 60, CGRectGetMaxY(cell.title.frame) + 10, 14 * typenames.length, 20);
    if (typenames.length <= 2) {
        cell.colortype.frame = CGRectMake(cell.title.frame.origin.x + 60, CGRectGetMaxY(cell.title.frame) + 10, 18 * typenames.length, 20);
    }
    
    cell.price.text = [NSString stringWithFormat:@"￥%@",infoDict[@"marketprice"]];
    
    cell.countLab.text = [NSString stringWithFormat:@"x %@",infoDict[@"total"]];
    
    
    
    return cell;
    
}



-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}


-(NSString *)GetNonce{
    NSArray *arr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    
    NSMutableString *mStr = [[NSMutableString alloc]init];
    for (int i = 0; i < 16; i++) {
        int x = arc4random()%36;
        [mStr appendString:arr[x]];
    }
    //    NSLog(@"mStr = %@",mStr);
    return mStr;
}


- (NSString *)MD5:(NSString *)mdStr
{
    const char *original_str = [mdStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (int)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

- (NSString *)getNowTimeTimestamp{
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
    
}

@end
