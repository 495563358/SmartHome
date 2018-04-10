//
//  WifiPwdCell.h
//  P2PCamera
//
//  Created by mac on 12-10-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WifiPwdCell : UITableViewCell{
    IBOutlet UILabel *lablePassword;
    IBOutlet UITextField *textPassword;
}

@property (retain, nonatomic) UILabel *lablePassword;
@property (retain, nonatomic) UITextField *textPassword;



@end
