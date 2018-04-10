//
//  LookCurrentRecordScheduleViewController.h
//  P2PCamera
//
//  Created by yan luke on 13-6-26.
//
//

#import <UIKit/UIKit.h>
#import "SdcardScheduleProtocol.h"
#import "SelectWeekCustomView.h"
@interface LookCurrentRecordScheduleViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SelectWeekCustomViewDelegate>{
    NSMutableArray* select;//4*24*7
}
@property (nonatomic, retain) NSMutableArray* select;
@property (nonatomic, retain) UITableView* aTableView;
@property (nonatomic, retain) UISegmentedControl* weekSelected;
@property (nonatomic, retain) SelectWeekCustomView* selectWeek;
@end
