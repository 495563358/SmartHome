//
//  OpenRecScheduleCell.h
//  P2PCamera
//
//  Created by yan luke on 13-6-21.
//
//

#import <UIKit/UIKit.h>
#import "RecordTimeMode.h"
@interface OpenRecScheduleCell : UITableViewCell
@property (nonatomic, retain) IBOutlet RecordTimeMode* iconImg;
@property (nonatomic, retain) IBOutlet UILabel* titleLabel;
@end
