//
//  PlanManagement.m
//  P2PCamera
//
//  Created by 黄甜 on 17/2/8.
//
//

#import "PlanManagement.h"
static PlanManagement *shareDatabase = nil;
@implementation PlanManagement
-(id) init
{
    if (self == [super init])
    {
        _RecordPlanArray = [[NSMutableArray alloc] init];
        _MotionRecordPlanArray = [[NSMutableArray alloc] init];
        _MotiondPushRecordPlanArray = [[NSMutableArray alloc] init];
        _AlarmPlanArray = [[NSMutableArray alloc] init];
    }
    return self;
}

+(PlanManagement *)shareManagement
{
    if (shareDatabase == nil)
    {
        shareDatabase = [[PlanManagement alloc] init];
    }
    return shareDatabase;
}

@end
