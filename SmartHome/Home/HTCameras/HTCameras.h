//
//  HTCameras.h
//  IPCam
//
//  Created by yaoyaodu on 13-6-18.
//  Copyright (c) 2013年 yaoyaodu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTCameras : NSObject
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *PassWord;
@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) NSString *deviceType;
@property (nonatomic, strong) NSString *roomId;

@end
