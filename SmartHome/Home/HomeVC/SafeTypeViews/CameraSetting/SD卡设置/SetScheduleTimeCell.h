//
//  SetScheduleTimeCell.h
//  P2PCamera
//
//  Created by yan luke on 13-6-21.
//
//

#import <UIKit/UIKit.h>
#import "RecordTimeMode.h"
@interface SetScheduleTimeCell : UITableViewCell
@property (nonatomic, retain) IBOutlet RecordTimeMode* iconImg;
@property (nonatomic, retain) IBOutlet UILabel* titleLabel;
@property (nonatomic, retain) IBOutlet UILabel* detailLabel;
@end
