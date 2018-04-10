//
//  SetScheduleTimeCell.m
//  P2PCamera
//
//  Created by yan luke on 13-6-21.
//
//

#import "SetScheduleTimeCell.h"

@implementation SetScheduleTimeCell

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
    _iconImg = nil;
    _titleLabel = nil;
    _detailLabel = nil;
}
@end
