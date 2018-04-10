//
//  RecordTimeMode.h
//  P2PCamera
//
//  Created by yan luke on 13-6-20.
//
//

#import <UIKit/UIKit.h>
@class RecordTimeMode;
@protocol RecordTimeModeDelegate<NSObject>
@optional
- (void) ClickRecordTimeMode:(RecordTimeMode*) recM;
@end
@interface RecordTimeMode : UIImageView
@property (nonatomic) BOOL is_Selected;
@property (nonatomic) BOOL is_Selected_Icon;
@property (nonatomic) BOOL is_Add_Icon;
@property (nonatomic, assign) id<RecordTimeModeDelegate> delegate;
@end
