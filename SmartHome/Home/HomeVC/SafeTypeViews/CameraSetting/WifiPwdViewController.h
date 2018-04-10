//
//  WifiPwdViewController.h
//  P2PCamera
//
//  Created by mac on 12-10-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.

#import <UIKit/UIKit.h>
#import "PPPPChannelManagement.h"
#import "UserPwdProtocol.h"
#import "CameraListMgt.h"
#import "PPPPDefine.h"

#import "SmartHome-Swift.h"

@interface WifiPwdViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationBarDelegate,UIAlertViewDelegate>{
    CPPPPChannelManagement *m_pChannelMgt;
    
    NSString *m_strSSID;
    int m_security;
    int m_channel;    
    NSString *m_strDID;
    NSString *m_strPwd;
    
    UITextField *textPassword;
    IBOutlet UINavigationBar *navigationBar;
    UIAlertView* alertView;
}

@property (nonatomic, assign) CPPPPChannelManagement *m_pChannelMgt;
@property (copy, nonatomic) NSString *m_strSSID;
@property (copy, nonatomic) NSString *m_strDID;
@property (copy, nonatomic) NSString *m_strPwd;
@property (retain, nonatomic) UITextField *textPassword;
@property int m_security;
@property int m_channel;
@property (retain, nonatomic) UINavigationBar *navigationBar;


- (void) btnSetWifi:(id) sender;

@end
