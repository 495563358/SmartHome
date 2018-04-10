//
//  SetRecordScheduleCell.h
//  P2PCamera
//
//  Created by yan luke on 13-6-20.
//
//

#import <UIKit/UIKit.h>
#import "RecordTimeMode.h"
@interface SetRecordScheduleCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UILabel* timeLabel;
@property (nonatomic, retain) IBOutlet RecordTimeMode* firIv;
@property (nonatomic, retain) IBOutlet RecordTimeMode* secIv;
@property (nonatomic, retain) IBOutlet RecordTimeMode* thirdIv;
@property (nonatomic, retain) IBOutlet RecordTimeMode* fourIv;
@property (nonatomic, retain) IBOutlet RecordTimeMode* SelectIcon;
@end
