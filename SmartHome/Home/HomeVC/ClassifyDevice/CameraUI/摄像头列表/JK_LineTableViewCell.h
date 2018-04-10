//
//  JK_LineTableViewCell.h
//  ZNJD2
//
//  Created by he on 14-7-18.
//
//

#import <UIKit/UIKit.h>
#import "HTCameras.h"
#import "SmartHome-Swift.h"
@interface JK_LineTableViewCell : UITableViewCell
//@property (nonatomic,strong) UITextField *userName;
@property (nonatomic,strong) UITextField *passWord;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
-(void)setModel:(Equip *)camera;
@end

/*
 {
 addrCode = 0;
 closeDataCode = 0;
 codeType = "";
 deviceIcon = "ico_sx.png";
 deviceId = 43;
 deviceName = "\U5927\U5385\U76d1\U63a7";
 deviceRmk = "";
 deviceType = SX;
 floor = 1;
 floorName = "14 \U697c";
 freqType = "";
 on = 0;
 openDataCode = 0;
 percent = 0;
 read = "zigbee respone";
 resType = "";
 roomId = 2;
 roomName = "\U5927\U5385";
 vidiconId = 32;
 vidiconPort = "";
 vidiconPwd = 888888;
 vidiconUID = VSTC157043LHUBW;
 vidiconUrl = "";
 vidiconUser = admin;
 zbAddrCode = 0;
 zbCurId = 0;
 zbIndex = 0;
 }
 */
