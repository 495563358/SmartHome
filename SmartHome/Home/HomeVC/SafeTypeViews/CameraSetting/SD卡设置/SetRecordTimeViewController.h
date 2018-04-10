//
//  SetRecordTimeViewController.h
//  P2PCamera
//
//  Created by yan luke on 13-6-21.
//
//

#import <UIKit/UIKit.h>
//#import "SingleDatePicCustomView.h"
#import "CustomRepeatView.h"
@class SetRecordTimeViewController;
@protocol SetRecordTimeViewControllerDelegate <NSObject>
- (void) SetRecordTimeViewController:(SetRecordTimeViewController*) recordTime withStarTimes:(NSArray*) startDates EndDateTimes:(NSArray*) endDates andRepeatDay:(int*) weeks OpenRecord:(BOOL) openRecord;
@end

@interface SetRecordTimeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,CustomRepeatViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>{
    int weeks[7];
}
@property (nonatomic, retain) UITableView* aTabelView;


//@property (nonatomic, retain) SingleDatePicCustomView* singlePic;//用于选择录像时间
@property (nonatomic, retain) CustomRepeatView* selectedWeekView;//用于选择录像日期（同一时间段  一周内重复的天数）
@property (nonatomic, retain) NSDate* startTime;
@property (nonatomic, retain) NSDate* endTime;
@property (nonatomic) BOOL is_openRecord;
@property (nonatomic, retain) NSString* startDateStr;
@property (nonatomic, retain) NSString* endDateStr;
@property (nonatomic, retain) NSString* weekStr;

@property (nonatomic, retain) NSMutableArray* Selectweeks;//用于存储修改时的选择的星期天数
@property (nonatomic) BOOL bAddRecordTime;
@property (nonatomic) int replaceIndex;
@property (nonatomic, assign) id<SetRecordTimeViewControllerDelegate> delegate;
@end
