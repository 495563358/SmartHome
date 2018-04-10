//
//  CameraSettingMoreTableViewController.h
//  SmartHome
//
//  Created by Smart house on 2018/1/12.
//  Copyright © 2018年 sunzl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPPPChannelManagement.h"
#import "SmartHome-Swift.h"
#import "CameraListMgt.h"


@interface CameraSettingMoreTableViewController : UITableViewController{
//    CPPPPChannelManagement *m_pPPPPChannelMgt ;
//    CameraListMgt* cameraListMgt;
//    
//    NSString *m_strDID;
//    NSString *m_strPWD;
//    
//    Equip *temp;
}


@property (nonatomic, assign)CPPPPChannelManagement *m_pPPPPChannelMgt ;
@property (nonatomic, assign)CameraListMgt* cameraListMgt;
@property (nonatomic, assign)Equip *temp;
@property (nonatomic, copy)NSString *m_strDID;
@property (nonatomic, copy)NSString *m_strPWD;


//@property (nonatomic, copy)
//@property (nonatomic, assign) CPPPPChannelManagement *m_pChannelMgt;

@end
