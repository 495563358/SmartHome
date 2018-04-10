//
//  PlanPickerView.h
//  Eye4
//
//  Created by 黄甜 on 16/10/20.
//
//

#import <UIKit/UIKit.h>
#import "MXSCycleScrollView.h"
#import "PPPPChannelManagement.h"
@interface PlanPickerView : UIView<MXSCycleScrollViewDatasource,MXSCycleScrollViewDelegate,UIAlertViewDelegate>
{
    int tmp[32];
    NSMutableArray *RecordTime;//用于存储设置的时间参数
}
@property (nonatomic) CPPPPChannelManagement* m_PPPPChannelMgt;
@property(nonatomic,assign) NSInteger ID;
@property(nonatomic,assign) NSInteger rowIndex;
@property(nonatomic,retain) NSString *str_DID;
@property(nonatomic,assign) BOOL isEdit;

- (id)initWithFrame:(CGRect)frame Str_DID:(NSString *)str_DID rowIndex:(NSInteger)rowIndex IsEdit:(BOOL)isEdit Type:(NSString *)type;

-(BOOL) saveData;
-(BOOL) saveMotionRecordPlanData;
-(BOOL) saveMotionPushPlanData;
-(BOOL) saveAlarmPlanData;
@end
