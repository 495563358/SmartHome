//
//  SystemUpgradeViewController.h
//  P2PCamera
//
//  Created by yan luke on 13-7-26.
//
//

#import <UIKit/UIKit.h>
#import "PPPPChannelManagement.h"
#import "CameraStatusProtocol.h"
#import "SearchDVS.h"

@interface SystemUpgradeViewController : UIViewController<CameraStatusProtocol, NSXMLParserDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate,SearchCameraResultProtocol>
{
    CSearchDVS *m_pSearchDVS;
}
@property (nonatomic, assign) CPPPPChannelManagement* m_pPPPPChannelMgt;
@property (nonatomic, retain) NSString* str_uid;
@property (nonatomic, retain) NSString* str_ipaddr;
@property (nonatomic, retain) NSString* str_pwd;
@property (nonatomic, retain) NSString* str_port;
@property (nonatomic, retain) UITableView* aTabelView;
@end
