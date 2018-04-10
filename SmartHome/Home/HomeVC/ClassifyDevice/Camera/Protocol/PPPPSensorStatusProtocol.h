//
//  PPPPSensorStatusProtocol.h
//  P2PCamera
//
//  Created by yan luke on 13-9-5.
//
//

#import <Foundation/Foundation.h>

@protocol PPPPSensorStatusProtocol <NSObject>
@optional
- (void) PPPPSensorStatus: (NSString*) strDid GarrisonStatus:(NSInteger) garrisonstatus AlarmStatus:(NSInteger) alarmstatus CodeStatus:(NSInteger) codeStatus;
- (void) PPPPSensorStatus: (NSString*) strDid doorbellStatus:(NSInteger) doorbell;
@end
