//
//  CameraSDCardStatusProtocol.h
//  P2PCamera
//
//  Created by yan luke on 13-6-17.
//
//

#import <Foundation/Foundation.h>

@protocol CameraStatusProtocol <NSObject>
- (void) PPPPCameraStatusSysver:(char*) sysv appver:(char*) appv oemid:(char*) oemid;
@end
