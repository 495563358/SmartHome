//
//  AlarmController.h
//  P2PCamera
//
//  Created by mac on 12-10-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPPPChannelManagement.h"
#import "DropListProtocol.h"

@interface AlarmController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,DropListProtocol, UINavigationBarDelegate>
{
    NSString *m_strDID;
    CPPPPChannelManagement *m_pChannelMgt;
    
    IBOutlet UITableView *tableView;
    IBOutlet UINavigationBar *navigationBar;
    
    
    int m_motion_armed;
    int m_motion_sensitivity;
    int m_input_armed;
    int m_ioin_level;
    
    int m_alarmpresetsit;
    
    int m_iolinkage;
    int m_ioout_level;

    int m_mail;
    int m_snapshot;
    int m_record;
    int m_upload_interval;
    
    //int nPicTimer;
}
@property (copy,nonatomic) NSString *m_strDID;
@property (nonatomic, assign) CPPPPChannelManagement *m_pChannelMgt;
@property (nonatomic, retain) UITableView *tableView;
@property (retain, nonatomic) UINavigationBar *navigationBar;

@end
