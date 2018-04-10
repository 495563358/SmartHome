//
//  HTCameraStatus.h
//  IPCam
//
//  Created by yaoyaodu on 13-6-19.
//  Copyright (c) 2013年 yaoyaodu. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "PPPPChannelManagement.h"
@interface HTCameraStatus : NSObject
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *statusnum;
@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) NSString *ID;
@property  CPPPPChannelManagement* m_PPPPChannelMgt;
@property (nonatomic, strong) NSString *roomName;
@end
