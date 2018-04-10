//
//  DateTimeController.h
//  P2PCamera
//
//  Created by mac on 12-10-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPPPChannelManagement.h"
#import "DropListProtocol.h"


@interface DateTimeController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,DropListProtocol, UINavigationBarDelegate>{
    
    NSString *m_strDID;
    CPPPPChannelManagement *m_pChannelMgt;
    
    CGFloat textFieldAnimatedDistance;

    int m_dateTime;
    int m_timeZone;
    int m_Timing;
    NSString *m_timingSever;
    
    UILabel *dateTime;
    UILabel *timeZone;
    UISwitch *timing;
    UILabel *timingServer;
    
    
    IBOutlet UITableView *tableView;
    IBOutlet UINavigationBar *navigationBar;
}


@property (copy,nonatomic) NSString *m_strDID;
@property (nonatomic, assign) CPPPPChannelManagement *m_pChannelMgt;

@property (copy,nonatomic) NSString *m_timingSever;


@property (retain, nonatomic) UILabel *dateTime;
@property (retain, nonatomic) UILabel *timeZone;
@property (retain, nonatomic) UISwitch *timing;
@property (retain, nonatomic) UILabel *timingServer;

@property (nonatomic, retain) UITableView *tableView;
@property (retain, nonatomic) UINavigationBar *navigationBar;

@end
