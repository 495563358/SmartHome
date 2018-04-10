//
//  RecordScheduleSettingViewController.h
//  P2PCamera
//
//  Created by yan luke on 13-6-21.
//
//

#import <UIKit/UIKit.h>
#import "PPPPChannelManagement.h"
#import "SdcardScheduleProtocol.h"
#import "SetRecordTimeViewController.h"
@interface RecordScheduleSettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SdcardScheduleProtocol,SetRecordTimeViewControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate>{
    int tmp[32];//用于临时存储一小时的二进制码
    NSMutableArray* Schedule;//用于存储返回来的数据的二进制码
    long int RecordTime[21];//用于存储设置录像的时间参数
}

@property (nonatomic, retain) UITableView* aTableView;
@property (nonatomic) CPPPPChannelManagement* m_PPPPChannelMgt;
@property (nonatomic, retain) NSString* m_strDID;


- (void) TenAndTwo:(int) num atIndex:(int) index;
- (void) TwoAndTen;
- (void) SetSDRecordParam:(id) sender;
@end
