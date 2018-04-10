//
//  WifiPwdCell.m
//  P2PCamera
//
//  Created by mac on 12-10-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WifiPwdCell.h"

@implementation WifiPwdCell

@synthesize textPassword;
@synthesize lablePassword;

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

- (void) dealloc
{
    textPassword = nil;
    lablePassword = nil;
}

@end
