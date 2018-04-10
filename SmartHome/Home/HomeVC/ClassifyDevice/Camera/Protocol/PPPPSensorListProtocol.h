//
//  PPPPSensorListProtocol.h
//  P2PCamera
//
//  Created by yan luke on 13-9-4.
//
//

#import <Foundation/Foundation.h>

@protocol PPPPSensorListProtocol <NSObject>
@optional
- (void) Camera:(NSString*) strDID SensorID:(NSString*) sensorid SensorRealID:(int) realsensorid  andpresetid:(int) presetid  andSensorName:(NSString*) sensorName andSensorType:(int) sensorType  andSensorStatus:(int) sensorStatus andEnd:(BOOL) bEnd;
- (void) SensorListBeginRecive:(NSString*) strDID;
- (void) SensorListReciveFinish:(NSString*) strDID;

- (void) SensorID:(NSString*) sensorid SensorRealID:(int) realsensorid  andpresetid:(int) presetid  andSensorName:(NSString*) sensorName andSensorType:(int) sensorType  andSensorStatus:(int) sensorStatus andEnd:(BOOL) bEnd;
- (void) SensoraListbEnd:(BOOL) bEnd;
- (void) SensorDeleteFinish:(BOOL)isFinish;
@end
