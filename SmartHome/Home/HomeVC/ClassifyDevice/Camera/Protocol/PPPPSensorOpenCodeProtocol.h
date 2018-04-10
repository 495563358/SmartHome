//
//  PPPPSensorOpenCodeProtocol.h
//  P2PCamera
//
//  Created by hongzhi on 13-9-13.
//
//

#import <Foundation/Foundation.h>
#import "P2P_API_Define.h"

@protocol PPPPSensorOpenCodeProtocol <NSObject>
- (void) CamerafinshCode:(int) codeResult addSensorInfo:(STRU_SENSOR_ALARM_INFO) sensorInfo;
- (void) CameraFreashSensorList:(BOOL) isReash;
- (void) CameraDoorBell:(STRU_SENSOR_ALARM_INFO) sensorInfo;
@end
