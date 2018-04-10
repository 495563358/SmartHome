//
//  CommonPlayView.h
//  ZNJD2
//
//  Created by sunzl on 16/4/22.
//
//

#import <UIKit/UIKit.h>
#include "PPPP_API.h"
#include "PPPPChannelManagement.h"
#import "ImageNotifyProtocol.h"
#import "SmartHome-Swift.h"
//@protocol TouchSXT
//-(void)passTouch:(NSDictionary *)dict;
//@end
@interface CommonPlayView : UIView<ImageNotifyProtocol,SnapshotProtocol>

@property (nonatomic, retain) NSString* cameraID;
@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* password;
@property  CPPPPChannelManagement* m_PPPPChannelMgt;
//@property (assign) id<TouchSXT> delegate;
-(void)begin;
-(void)end;
- (void)starVideo;
- (void)stopVideo;
- (void) startAudio;
- (void) stopAudio;
- (void) startTalk;
- (void) stopTalk;

- (void)left;
- (void)right;
- (void)up;
- (void)down;

@end
