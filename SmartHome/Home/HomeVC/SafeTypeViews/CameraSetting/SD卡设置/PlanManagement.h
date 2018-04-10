//
//  PlanManagement.h
//  P2PCamera
//
//  Created by 黄甜 on 17/2/8.
//
//

#import <Foundation/Foundation.h>

@interface PlanManagement : NSObject
@property (nonatomic, strong) NSMutableArray *RecordPlanArray;
@property (nonatomic, strong) NSMutableArray *MotionRecordPlanArray;
@property (nonatomic, strong) NSMutableArray *MotiondPushRecordPlanArray;
@property (nonatomic, strong) NSMutableArray *AlarmPlanArray;
+(PlanManagement *)shareManagement;
@end
