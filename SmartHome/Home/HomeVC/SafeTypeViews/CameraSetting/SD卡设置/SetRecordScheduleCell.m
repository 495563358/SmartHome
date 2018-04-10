//
//  SetRecordScheduleCell.m
//  P2PCamera
//
//  Created by yan luke on 13-6-20.
//
//

#import "SetRecordScheduleCell.h"

@implementation SetRecordScheduleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) dealloc{
//    [super dealloc];
    _firIv = nil;
    _secIv = nil;
    _thirdIv = nil;
    _fourIv = nil;
    _SelectIcon = nil;
}

@end
