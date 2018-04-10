//
//  FtpSettingViewController.h
//  P2PCamera
//
//  Created by Tsang on 12-12-12.
//
//

#import <UIKit/UIKit.h>
#import "PPPPChannelManagement.h"
#import "FtpParamProtocol.h"

@interface FtpSettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,
UITextFieldDelegate, UINavigationBarDelegate, FtpParamProtocol>{
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UITableView *tableView;
    
    CGFloat textFieldAnimatedDistance;
    UITextField *currentTextField;
    
    NSString *m_strFTPSvr;
    NSString *m_strUser;
    NSString *m_strPwd;
    int m_nFTPPort;
    int m_nUploadInterval;
    
    CPPPPChannelManagement *m_pChannelMgt;
    NSString *m_strDID;
    
}

@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UITextField *currentTextField;
@property (nonatomic, copy) NSString *m_strFTPSvr;
@property (nonatomic, copy) NSString *m_strUser;
@property (nonatomic, copy) NSString *m_strPwd;
@property (nonatomic,assign) CPPPPChannelManagement *m_pChannelMgt;
@property (nonatomic, copy) NSString *m_strDID;


@end
