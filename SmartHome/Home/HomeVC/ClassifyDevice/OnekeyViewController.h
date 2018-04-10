//
//  OnekeyViewController.h
//  OneKeyWifi
//
//  Created by 莫晓文 on 16/7/18.
//  Copyright © 2016年 VSTARTCAM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import "voiceEncoder.h"
#import <AVFoundation/AVFoundation.h>
@interface OnekeyViewController : UIViewController{
    
    UITextField *MyWifi;
    UITextField *MyPassword;
    UIButton *Sendbtn;
    UIButton *Cancelbtn;
    int *freq;
    
    NSThread *_voiceThread;// 播放声波的子线程
    NSTimer *_voiceTimesTimer;//播放timer 用来循环播放
    char *_mac;//用来播放的数组
    NSInteger _times;
    
    NSString *MyWiFiSSID;
    NSString *MyWiFiMac;
    NSString *MyWiFiPwd;
    
    VoiceEncoder *play;
    
    UIButton *showPWD;
    
    UILabel *macLab;
}


@end

