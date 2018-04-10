//
//  EditCameraProtocol.h
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol EditCameraProtocol

- (BOOL) EditP2PCameraInfo:(BOOL)bAdd 
                   Name:(NSString *)name 
                   DID:(NSString *)did
                   User:(NSString *)user 
                    Pwd:(NSString *)pwd 
                OldDID:(NSString *)olddid;

@end
