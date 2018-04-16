//
//  MessageViewController.m
//  SmartMall
//
//  Created by Smart house on 2017/8/28.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "MessageViewController.h"
#import "LoadingView.h"
#import <CommonCrypto/CommonDigest.h>
#import "CABasicAnimation+Category.h"
#import "ObjectTools.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "MessageTableViewCell.h"
#import "UserOrderViewController.h"
#import "LookupExpressVC.h"

#import "OrderDetailVC.h"

#import "ProductViewControll.h"

//查看物流
#define lookupexpress @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.apporder.express"

//订单详情
#define orderDetail @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.apporder.detail"

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *dataArr;
}

@property(nonatomic,strong) UITableView *tableview;

@end

@implementation MessageViewController

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
    
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, Sc_h) style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = [UIColor whiteColor];
    _tableview.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 0.01)];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

-(void)viewWillAppear:(BOOL)animated{
    [self downLoadSource];
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//NSString *userToken = [user objectForKey:@"userToken"];
//MessageViewController *mess = [[MessageViewController alloc]init];
//self.hidesBottomBarWhenPushed = YES;
//[self.navigationController pushViewController:mess animated:YES];

//个人中心数据源
- (void)downLoadSource{
    
    NSString *LoadPath = @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=message";
    
    NSDictionary *dict1 = [self getUserInfo];
    
    //    获取token
    [[ObjectTools sharedManager] POST:LoadPath parameters:dict1 progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
#define CLog(format, ...)  NSLog(format, ## __VA_ARGS__)
        
#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
        
        NSDictionary *returnInfo = (NSDictionary *)responseObject;
        
        
        if ([returnInfo[@"status"] intValue] == 0) {
            [self.view makeToast:@"请确定您的登录信息后重试"];
        }else{
            
            dataArr = returnInfo[@"result"];
            if(dataArr.count > 0){
                [self.view addSubview:_tableview];
            }
        }
        
        NSLog(@"消息列表 = %@",returnInfo);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [self.view makeToast:@"请检查网络后重试"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 76;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messagecell"];
    if (!cell) {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"messagecell"];
        NSDictionary *infoDict = dataArr[indexPath.row];
        if ([infoDict[@"messagetype"] intValue] == 2) {
            cell.imageview.image = [UIImage imageNamed:@"dindanxx"];
        }else{
            cell.imageview.image = [UIImage imageNamed:@"shangctsxx"];
        }
        cell.titleL.text = infoDict[@"title"];
        cell.subtitleL.text = infoDict[@"desc"];
        cell.timeL.text = infoDict[@"createtime"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *infoDict = dataArr[indexPath.row];
    int ordertype = [infoDict[@"ordertype"] intValue];
    switch (ordertype) {
        case 2:{
            UserOrderViewController *vc = [UserOrderViewController new];
            vc.userInfo = [NSMutableDictionary dictionaryWithDictionary:[self getUserInfo]];
            vc.status = [NSString stringWithFormat:@"%d",4];
            
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:{
            NSString *orderid = infoDict[@"id"];
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[self getUserInfo]];
            [userInfo setObject:orderid forKey:@"id"];
            [[ObjectTools sharedManager] POST:lookupexpress parameters:userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *dict = (NSDictionary *)responseObject;
                LookupExpressVC *vc = [LookupExpressVC new];
                
                vc.data = dict;
                [self.navigationController pushViewController:vc animated:YES];
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self.view makeToast:@"网络错误,请检查网络后重试"];
                
            }];
            break;
        }
        case 5:{
            
            NSString *ordersn = infoDict[@"id"];
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[self getUserInfo]];
            [userInfo setObject:ordersn forKey:@"orderid"];
            
            
            
            [[ObjectTools sharedManager] POST:orderDetail parameters:userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *resuk = (NSDictionary *)responseObject;
                NSLog(@"res = 13 %@",resuk);
                OrderDetailVC *vc = [[OrderDetailVC alloc]init];
                
                switch ([infoDict[@"status"] intValue]) {
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
                
                float totalMoney = [resuk[@"result"][@"parentorder"][@"price"] floatValue];
                vc.orderInfo = resuk[@"result"];
                vc.totalMoney = totalMoney;
                
                vc.userInfo = userInfo;
                
                NSDictionary *addr =resuk[@"result"][@"parentorder"][@"address"];
                if (!addr[@"id"]) {
                    vc.nameAndTele = addr;
                }
                
                [self.navigationController pushViewController:vc animated:YES];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
            break;
        }
        case 3:{
            ProductViewControll *vc = [[ProductViewControll alloc]init];
            vc.productID = infoDict[@"url"];
            
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            break;
        }
        case 4:{
            NSString *app_url = @"itms-apps://itunes.apple.com/app/id1216518997";
            [UIApplication.sharedApplication openURL:[NSURL URLWithString:app_url]];
            break;
        }
        default:
            break;
    }
    
}

-(NSDictionary *)getUserInfo{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userToken = [user objectForKey:@"userToken"];
    
    NSString *nonce = [self GetNonce];
    NSString *timestamp = [self getNowTimeTimestamp];
    NSString *signStr = [NSString stringWithFormat:@"token=%@&12345",userToken];
    NSString *sign = [self MD5:signStr];
    
    NSDictionary *dict1 = @{@"nonce":nonce,@"timestamp":timestamp,@"token":userToken,@"sign":sign};
    return dict1;
}

-(NSString *)GetNonce{
    NSArray *arr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    
    NSMutableString *mStr = [[NSMutableString alloc]init];
    for (int i = 0; i < 16; i++) {
        int x = arc4random()%36;
        [mStr appendString:arr[x]];
    }
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
