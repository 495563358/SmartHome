//
//  MailSettingViewController.h
//  P2PCamera
//
//  Created by Tsang on 12-12-12.
//
//

#import <UIKit/UIKit.h>
#import "PPPPChannelManagement.h"
#import "DropListProtocol.h"
#import "MailParamProtocol.h"

@interface MailSettingViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate,DropListProtocol,MailParamProtocol>{
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UITableView *tableView;
    
    CGFloat textFieldAnimatedDistance;
    UITextField *currentTextField;

    
    CPPPPChannelManagement *m_pChannelMgt;
    NSString *m_strDID;
    
    int m_nTableviewCount ;
    
    
    NSString *m_strSender;
    NSString *m_strSMTPSvr;
    int m_nSMTPPort;
    int m_nSSL;
    int m_nAuth;
    NSString *m_strUser;
    NSString *m_strPwd;
    NSString *m_strRecv1;
    NSString *m_strRecv2;
    NSString *m_strRecv3;
    NSString *m_strRecv4;
}

@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, copy) NSString *m_strDID;
@property (nonatomic, assign) CPPPPChannelManagement *m_pChannelMgt;
@property (nonatomic, retain) UITextField *currentTextField;
@property (nonatomic, copy) NSString *m_strSender;
@property (nonatomic, copy) NSString *m_strSMTPSvr;
@property (nonatomic, copy) NSString *m_strUser;
@property (nonatomic, copy) NSString *m_strPwd;
@property (nonatomic, copy) NSString *m_strRecv1;
@property (nonatomic, copy) NSString *m_strRecv2;
@property (nonatomic, copy) NSString *m_strRecv3;
@property (nonatomic, copy) NSString *m_strRecv4;

@end
