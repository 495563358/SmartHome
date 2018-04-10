//
//  WifiViewController.m
//  DeliBaoxiang
//
//  Created by SunZlin on 25/8/13.
//  Copyright (c) 2015年 SunZlin. All rights reserved.
//

#import "WifiVC.h"
#import "MBProgressHUD.h"
#import "smartlinklib_7x.h"
#import "HFSmartLink.h"
#import "HFSmartLinkDeviceInfo.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "SmartHome-Swift.h"


@interface WifiVC ()<UIAlertViewDelegate>
{
    BOOL isShow;
    int time;
   
    NSTimer *timer;
    HFSmartLink * smtlk;
    BOOL isconnecting;
}





@end

@implementation WifiVC

-(void)dealloc
{
    NSLog(@"dealloc!!!!");
    NSLog(@"视图释放了");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    smtlk = [HFSmartLink shareInstence];
    smtlk.isConfigOneDevice = true;
    smtlk.waitTimers = 30;
    isconnecting=false;
    
    //_tishi.text = NSLocalizedString(@"点击WIFI配置按键一下，当看到底部黄灯快速闪烁时，点击“确认连接“", nil);
    [self.btn setTitle:NSLocalizedString(@"确认连接", nil) forState:UIControlStateNormal];
    self.pass.text = NSLocalizedString(@"显示密码", nil);
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    _label1.layer.cornerRadius=8;
    _label1.layer.masksToBounds = YES;
    _label2.layer.cornerRadius=8;
    _label2.layer.masksToBounds = YES;
    
    _btn.layer.cornerRadius=8;
    _btn.layer.masksToBounds = YES;

    self.navigationItem.title=NSLocalizedString(@"WIFI配置", nil);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];

// UIImage(named: "导航栏L")
    //self.navigationController!.navigationBar.setBackgroundImage(navBgImage, forBarMetrics: UIBarMetrics.Default);
   //  self.navigationController?.navigationBarHidden=true
    self.navigationController.navigationBarHidden = false;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏L"] forBarMetrics:UIBarMetricsDefault];
    UIBarButtonItem *lItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui(b)"] style:UIBarButtonItemStylePlain target:self action:@selector(handleL)];
    lItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItems:@[lItem]];
    
    //新用户有跳过按钮
    if (self.isFirst) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"跳过" style:UIBarButtonItemStylePlain target:self action:@selector(turnTabbar)];
    }
    isShow =NO;
    if (isShow) {
        [_showbtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
        [_pwd setSecureTextEntry:NO];
    }else{
        [_showbtn setImage:[UIImage imageNamed:@"不选中"] forState:UIControlStateNormal];
        [_pwd setSecureTextEntry:YES];
    }
    
}

-(void)turnTabbar{
    [[UIApplication sharedApplication].delegate window].rootViewController = [TabbarC new];
}

-(void)viewWillDisappear:(BOOL)animated
{

        [smtlk stopWithBlock:^(NSString *stopMsg, BOOL isOk) {
            if(isOk){
                isconnecting  = false;
             
            }
        }];

}
#pragma mark -- 返回菜单
-(void)handleL
{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[MainDeviceManager class]]) {
            [self.navigationController popToViewController:temp animated:YES];
            return;
        }
    }
    MainDeviceManager *mainManager = [MainDeviceManager new];
    [self.navigationController pushViewController:mainManager animated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self showWifiSsid];
   _pwd.text = [self getspwdByssid:_ssid.text];
   
}


- (void)showWifiSsid
{
    BOOL wifiOK= FALSE;
    NSDictionary *ifs;
    NSString *ssid;
  
    if (!wifiOK)
    {
        ifs = [self fetchSSIDInfo];
        ssid = [ifs objectForKey:@"SSID"];
        if (ssid!= nil)
        {
            wifiOK= TRUE;
            _ssid.text=ssid;
            
        }
        else
        {
             [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"请连接Wi-Fi"] delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil] show];

        }
    }
}

- (id)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return info;
}


- (IBAction)nextTap:(id)sender {
    [_ssid resignFirstResponder];
    [_pwd becomeFirstResponder];
}

- (IBAction)goTap:(id)sender {

    if (!(_ssid.text.length>0 && _pwd.text.length>7)) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请确认您的WiFi信息" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil] show];
        return;
    }
    
    [self savePswd];
    NSString * ssidStr= _ssid.text;
    NSString * pswdStr = _pwd.text;
    if(!isconnecting){
        NSLog(@"开始配置");
        isconnecting = true;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES]; //@"WIFI配置中";
        __weak typeof(self) weakSelf=self;
        [smtlk startWithSSID:ssidStr Key:pswdStr withV3x:true
                processblock: ^(NSInteger pro) {
                    
//                    [SVProgressHUD showProgress:(float)(pro)/18.0 status:@"WIFI配置中" ];
                   
                } successBlock:^(HFSmartLinkDeviceInfo *dev) {
                  [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                    
                    [[[UIAlertView alloc] initWithTitle:@"配置成功" message:[NSString stringWithFormat:@"主机地址:%@\n设备IP:%@",dev.mac,dev.ip] delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil] show];
                    
                    if (weakSelf.isFirst) {
                        [weakSelf turnTabbar];
                    }else{
                        [weakSelf handleL];
                    }
                   
                    
                } failBlock:^(NSString *failmsg) {
                    NSLog(@"%@",failmsg);
                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                    [[[UIAlertView alloc] initWithTitle:@"配置失败" message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"我知道了", nil) otherButtonTitles:nil] show];
                   
                 
                } endBlock:^(NSDictionary *deviceDic) {
                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                    isconnecting  = false;
                    
                }];
    }


   
   
}
-(void)savePswd{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    [def setObject:_pwd.text forKey:_ssid.text];
}
-(NSString *)getspwdByssid:(NSString * )mssid{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:mssid];
}




- (IBAction)hideKeyTap:(id)sender {
    [_ssid resignFirstResponder];
    [_pwd resignFirstResponder];
}







- (IBAction)showTap:(id)sender {
    UIButton *btn=(UIButton *)sender;
    if (isShow) {
       [btn setImage:[UIImage imageNamed:@"不选中"] forState:UIControlStateNormal];
         [_pwd setSecureTextEntry:YES];
    }else{
        [btn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
        [_pwd setSecureTextEntry:NO];

    }
    isShow=!isShow;
}

- (IBAction)onExit:(id)sender {
    
}


@end
