//
//  PPPPAlarmProtocol.h
//  P2PCamera
//
//  Created by yan luke on 14-2-24.
//
//

#import <Foundation/Foundation.h>
#import "P2P_API_Define.h"
@protocol PPPPAlarmProtocol <NSObject>
- (void) Camera:(NSString*) did Alarminfo:(STRU_SENSOR_ALARM_INFO) alarminfo;
@end
