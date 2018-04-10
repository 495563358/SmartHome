//
//  OnekeyViewController.m
//  OneKeyWifi
//
//  Created by 莫晓文 on 16/7/18.
//  Copyright © 2016年 VSTARTCAM. All rights reserved.
//



#import "OnekeyViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "voiceEncoder.h"
#import "SmartLink.h"
#import "UIView+Toast.h"

@interface OnekeyViewController ()

@end

@implementation OnekeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem.title = @"返回";
    self.navigationItem.title = @"无线配置";
    //1.获取当前WIFI
    [self GetCurrentWiFiSSID];
    
    //音波频率
    int i;
    freq = (int*)malloc(sizeof(int)*19);
    freq[0] = 6500;
    for (i = 0; i < 18; i++) {
        freq[i + 1] = freq[i] + 200;
    }
    
    
    [self createUI];
    
    
}

-(void)createUI
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    MyWifi = [[UITextField alloc]initWithFrame:CGRectMake(40, 74, bounds.size.width-80, 50)];
    
    MyWifi.leftViewMode = UITextFieldViewModeAlways;
    
    
    UILabel *WifiLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
    WifiLeft.text = @"账号:";
    WifiLeft.textAlignment = NSTextAlignmentCenter;
    MyWifi.leftView = WifiLeft;
    
    MyWifi.text = MyWiFiSSID;
    MyWifi.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:MyWifi];
    
    MyPassword  = [[UITextField alloc]initWithFrame:CGRectMake(40, 134+20, bounds.size.width-80, 50)];
    MyPassword.leftViewMode = UITextFieldViewModeAlways;
    UILabel *PwdLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
    PwdLeft.text = @"密码:";
    PwdLeft.textAlignment = NSTextAlignmentCenter;
    MyPassword.leftView = PwdLeft;
    MyPassword.placeholder =@"请输入WIFI密码";
    MyPassword.borderStyle = UITextBorderStyleRoundedRect;
    MyPassword.secureTextEntry = YES;
    [self.view addSubview:MyPassword];
    
    
//    macLab = [[UILabel alloc]initWithFrame:CGRectMake(10, Sc_h - 50 - 64, Sc_w - 20, 40)];
//    [self.view addSubview:macLab];
//    macLab.text = MyWiFiMac;
    NSLog(@"text = %@",MyWiFiMac);
    
    showPWD = [[UIButton alloc]initWithFrame:CGRectMake(bounds.size.width -150, bounds.size.height/2-110, 100, 30)];
    [showPWD setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [showPWD setTitle:@" 显示密码" forState:UIControlStateNormal];
    [showPWD setImage:[UIImage imageNamed:@"不选中"] forState:UIControlStateNormal];
    showPWD.tag = 100;
    [showPWD addTarget:self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showPWD];
    
    
    Sendbtn = [[UIButton alloc]initWithFrame:CGRectMake(80, bounds.size.height/2-40, bounds.size.width-160, 50)];
    [Sendbtn setTitle:@"开始无线配置" forState:UIControlStateNormal];
    [Sendbtn setTintColor:[UIColor whiteColor]];
    Sendbtn.layer.cornerRadius = 10.0;
    [Sendbtn setBackgroundColor:[UIColor colorWithRed:14.0/255.0 green:173.0/255.0 blue:254.0/255.0 alpha:1.0]];
    [Sendbtn addTarget:self action:@selector(PlayVoice) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Sendbtn];
    
    
//    Cancelbtn =[[UIButton alloc]initWithFrame:CGRectMake((bounds.size.width-65)-85, bounds.size.height/2-60, 85, 45)];
//    [Cancelbtn setTitle:@"取消" forState:UIControlStateNormal];
//    [Cancelbtn setTintColor:[UIColor whiteColor]];
//    [Cancelbtn setBackgroundColor:[UIColor colorWithRed:93/255.0 green:176.0/255.0 blue:253.0/255.0 alpha:1.0]];
//    Cancelbtn.layer.cornerRadius = 5.0;
//    [Cancelbtn addTarget:self action:@selector(StopVoice) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:Cancelbtn];
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, bounds.size.height/2 + 40, bounds.size.width - 80, 120)];
    tipLabel.textColor = [UIColor grayColor];
    tipLabel.font = [UIFont systemFontOfSize:16];
    tipLabel.text = @"提示:若摄像头未进行无线配置或者进行复位操作，请进行此操作。当听到摄像头发出无线配置等待中时，点击”开始无线配置“，当听到”无线配置成功“时，即为摄像头配置成功。";
    tipLabel.numberOfLines = 0;
    [self.view addSubview:tipLabel];

}


-(void) showPassword:(UIButton *)sender{
    if (sender.tag == 100) {
        MyPassword.secureTextEntry = NO;
        [showPWD setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
        sender.tag = 200;
    }else{
        MyPassword.secureTextEntry = YES;
        [showPWD setImage:[UIImage imageNamed:@"不选中"] forState:UIControlStateNormal];
        sender.tag = 100;
    }
    
}

-(void)StopVoice
{
    [play isStopped];
    
    play = nil;
    
    if ([_voiceTimesTimer isValid])
    {
        [_voiceTimesTimer invalidate];
        _voiceTimesTimer = nil;
    }
    
    if (_voiceThread)
    {
        [_voiceThread cancel];
        _voiceThread = nil;
    }
    
    [SmartLink StopSmartLink];
}


//
-(void)PlayVoice
{
    [self StopVoice];
    if (!MyWifi.text.length || [MyWifi.text isEqualToString:@"(null)"]) {
        [self.view makeToast:@"WIFI名为空"];
        return;
    }
    if (!MyPassword.text.length) {
        [self.view makeToast:@"WIFI密码为空"];
        return;
    }
    _times = 0;//控制播放次数
    NSThread *voiceThread = [[NSThread alloc]initWithTarget:self selector:@selector(VoiceThread) object:nil];
    _voiceThread = voiceThread;
    [voiceThread start];
    
    //smartLink
    NSString *pwd = MyPassword.text;
    
    [SmartLink setSmartLink:MyWifi.text setAuthmod:@"0" setPassWord:pwd];
}

-(void)VoiceThread
{
    play = [[VoiceEncoder alloc] init];
    
    
    NSArray *array = [NSArray array];
    array = [MyWiFiMac componentsSeparatedByString:@":"];
    if(array.count < 6){
        NSLog(@"%@",MyWiFiMac);
        [self.view makeToast:@"获取MAC地址失败,请检查您的WIFI"];
        return;
    }
    NSLog(@"array[4]:%@,array[5]%@",array[4],array[5]);
    
    NSString *str1 = [NSString string];
    str1 = array[5];
    
    NSString *str = [NSString string];
    NSString *str2 = [NSString string];
    NSString *astr;
    NSString *bstr;
    NSString *cstr;
    unsigned long red = 0;
    unsigned long blue = 0;
    unsigned long yellow;
    
    
    if ([array[5] isEqualToString:@"0"]) {
        str = array[3];
        str2 = array[4];
        
        bstr = [NSString stringWithFormat:@"0x%@",str];
        cstr = [NSString stringWithFormat:@"0x%@",str2];
        
        blue = strtoul([cstr UTF8String],0,0);
        red = strtoul([bstr UTF8String],0,0);
        
    }
    astr = [NSString stringWithFormat:@"0x%@",str1];
    yellow = strtoul([astr UTF8String],0,0);
    
    if (MyWiFiMac) {
        
        [play setFreqs:freq freqCount:19];
        
        if ([array[5] isEqualToString:@"0"]){
            
            char mac[2] = {red,blue};
            _mac = mac;
            
            NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
            _voiceTimesTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(startPlay:) userInfo:[NSNumber numberWithInt:2] repeats:YES] ;
            [runLoop run];
        }else{
            
            char mac[1] = {yellow};
            _mac = mac;
            
            NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
            _voiceTimesTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(startPlay:) userInfo:[NSNumber numberWithInt:1] repeats:YES] ;
            
            [runLoop run];
            
            
        }
        
    }
    
    
}

- (void)startPlay:(NSTimer *)aTimer {
    @autoreleasepool {
        
        [play playWiFi:_mac macLen:1 pwd:MyPassword.text playCount:[[aTimer userInfo] integerValue] muteInterval:8000];
        while (![play isStopped]) {
            usleep(600*4000);
        }
        _times ++;
        if (_times == 10) {
            [_voiceTimesTimer invalidate];
            _voiceTimesTimer = nil;
            play = nil;
            
            [_voiceThread cancel];
            [SmartLink StopSmartLink];
        }
    }
}


//获取当前WiFi名字以及Mac地址
- (NSString *)GetCurrentWiFiSSID {
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    
    
    id info = nil;
    for (NSString *ifnam in ifs)
    {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        if (info && [info count])
        {
            break;
        }
    }
    
    NSDictionary *dctySSID = (NSDictionary *)info;
    NSString *ssid = [dctySSID objectForKey:@"SSID"];
    MyWiFiSSID =[[NSString alloc] initWithFormat:@"%@", ssid];
    
    NSString *Bssid = [dctySSID objectForKey:@"BSSID"];
    MyWiFiMac =[[NSString alloc] initWithFormat:@"%@", Bssid];
    NSLog(@"WIFIMac地址：%@",MyWiFiMac);
    
    NSString *tempSSID = [[NSString alloc] initWithFormat:@"%@+%@", ssid, Bssid];
    
    return tempSSID;
}

-(void)viewWillDisappear:(BOOL)animated{
    [self StopVoice];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
