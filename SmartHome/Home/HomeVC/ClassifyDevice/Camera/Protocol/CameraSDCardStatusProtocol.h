//
//  CameraSDCardStatusProtocol.h
//  P2PCamera
//
//  Created by yan luke on 13-6-17.
//
//

#import <Foundation/Foundation.h>

@protocol CameraSDCardStatusProtocol <NSObject>
- (void) CameraSDCardStatus:(int) sdCardStatus SDtotal:(int) SDtotal SDFree:(int) SDFree;
@end
