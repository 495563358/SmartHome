//
//  MotionPushPlanViewController.h
//  P2PCamera
//
//  Created by 黄甜 on 17/2/9.
//
//

#import <UIKit/UIKit.h>
#import "PPPPChannelManagement.h"
@interface MotionPushPlanViewController : UIViewController
@property (nonatomic) CPPPPChannelManagement* m_PPPPChannelMgt;
@property (nonatomic, retain) NSString* m_strDID;
@end
