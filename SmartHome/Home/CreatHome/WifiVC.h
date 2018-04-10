//
//  WifiVC.h
//  DeliBaoxiang
//
//  Created by sunzl on 15/8/20.
//  Copyright (c) 2015年 sunzl. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface WifiVC : UIViewController
@property (assign) bool isFirst;

@property (strong, nonatomic) IBOutlet UIButton *btn;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UIButton *showbtn;
@property (weak, nonatomic) IBOutlet UILabel *tishi;
@property (weak, nonatomic) IBOutlet UILabel *pass;

- (IBAction)showTap:(id)sender;

- (IBAction)onExit:(id)sender;


@property (strong, nonatomic) UILabel *loading;
@property (strong, nonatomic) UIImageView *imgV;
@property (strong, nonatomic) IBOutlet UITextField *ssid;
@property (strong, nonatomic) IBOutlet UITextField *pwd;
- (IBAction)nextTap:(id)sender;
- (IBAction)goTap:(id)sender;
- (IBAction)hideKeyTap:(id)sender;

@end
