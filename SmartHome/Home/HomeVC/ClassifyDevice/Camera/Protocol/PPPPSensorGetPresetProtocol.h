//
//  PPPPSensorGetSensorPresetProtocol.h
//  P2PCamera
//
//  Created by yan luke on 13-9-25.
//
//

#import <Foundation/Foundation.h>

@protocol PPPPSensorGetPresetProtocol <NSObject>
- (void) PPPPSensorID:(int) sensorID andPresetID:(int) presetID andcmd:(int) cmd;
@end
