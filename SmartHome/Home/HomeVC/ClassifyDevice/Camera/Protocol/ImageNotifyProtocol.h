//
//  ImageNotifyProtocol.h
//  P2PCamera
//
//  Created by mac on 12-7-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ImageNotifyProtocol <NSObject>

- (void) ImageNotify: (UIImage *)image timestamp: (NSInteger)timestamp;
- (void) YUVNotify: (Byte*) yuv length:(int)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp;
- (void) H264Data: (Byte*) h264Frame length: (int) length type: (int) type timestamp: (NSInteger) timestamp;

@optional
- (void) ImageNotify: (UIImage *)image timestamp: (NSInteger)timestamp szdid:(NSString*)szdid;
- (void) YUVNotify: (Byte*) yuv length:(int)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp szdid:(NSString*)szdid;
- (void) H264Data: (Byte*) h264Frame length: (int) length type: (int) type timestamp: (NSInteger) timestamp szdid:(NSString*)szdid;


@end
