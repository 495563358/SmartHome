//
//  PPPPSensorAlarmLogProtocol.h
//  P2PCamera
//
//  Created by yan luke on 13-9-5.
//
//

#import <Foundation/Foundation.h>

@protocol PPPPSensorAlarmLogProtocol <NSObject>
- (void) sensorAlarm:(NSString*)str_did andFileName:(NSString*) fileName SensorName:(NSString*) sensorName andActionType:(int) actionType andDvsType:(int) dvstype andEnd:(BOOL) bEnd;
- (void) sensorAlarm:(NSString*) str_did result:(int) reslut;
@end
