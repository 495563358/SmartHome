//
//  WifiSettingViewController.h
//  P2PCamera
//
//  Created by mac on 12-10-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WifiParamsProtocol.h"
#import "PPPPChannelManagement.h"

@interface WifiSettingViewController : UIViewController <UITableViewDataSource, 
UITableViewDelegate, WifiParamsProtocol, UIAlertViewDelegate, UINavigationBarDelegate>
{
    CPPPPChannelManagement *m_pPPPPChannelMgt;   
    
    //wifi参数需要保存的
    NSString *m_strSSID;
    int m_authtype;
    int m_channel;
    NSString *m_strWEPKey;
    NSString *m_strWPA_PSK;
    
    BOOL m_bFinished; 
    
    NSMutableArray *m_wifiScanResult;
    NSString *m_strDID;
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UITableView *wifiTableView;
    
    int m_currentIndex;
    NSTimer *m_timer;
    NSCondition *m_timerLock;
}

@property (nonatomic, assign) CPPPPChannelManagement *m_pPPPPChannelMgt;
@property (copy,nonatomic) NSString *m_strSSID;
@property (copy,nonatomic) NSString *m_strWEPKey;
@property (copy,nonatomic) NSString *m_strWPA_PSK;
@property (copy,nonatomic) NSString *m_strDID;
@property (retain, nonatomic) UITableView *wifiTableView;
@property (nonatomic, retain) UINavigationBar *navigationBar;

@end
