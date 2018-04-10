//
//  CameraList.h
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBSelectResultProtocol.h"
#import "CameraDBUtils.h"

#import "obj_common.h"


@interface CameraListMgt : NSObject <DBSelectResultProtocol> {
    
    
@private
    NSMutableArray *CameraArray;
    CameraDBUtils *cameraDB;
    
    NSCondition *m_Lock;

}
-(BOOL)UpdateCameraAuthority:(NSString *)did User:(NSString *)user3 Pwd:(NSString *)pwd3;
- (BOOL) AddCamera:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd Snapshot:(UIImage *)img;
- (BOOL) EditCamera:(NSString *)olddid Name:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd;
- (NSInteger) UpdateCamereaImage:(NSString *)did Image:(UIImage *)img;
- (BOOL) RemoveCamerea:(NSString *)did ;
- (int) GetCount;
- (NSDictionary*) GetCameraAtIndex:(NSInteger) index;
- (BOOL) CheckCamere:(NSString *)did;
- (BOOL) RemoveCameraAtIndex:(NSInteger) index;
- (NSInteger) UpdatePPPPStatus: (NSString*) did status:(int)status;
- (NSInteger) UpdatePPPPMode: (NSString*) did mode: (int) mode;
- (int) GetIndexFromDID:(NSString*) did;
@end
