//
//  PPPPSensorAlarmProtocol.h
//  P2PCamera
//
//  Created by yan luke on 13-9-5.
//
//

#import <Foundation/Foundation.h>
#import "P2P_API_Define.h"
@protocol PPPPSensorAlarmProtocol <NSObject>
- (void) PPPPSensorAlarm:(NSString*) strDid andSensorInfo:(STRU_SENSOR_ALARM_INFO)  sensorInfo;
@end
