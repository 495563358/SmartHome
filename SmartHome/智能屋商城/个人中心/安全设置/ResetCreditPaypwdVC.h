//
//  ResetCreditPaypwdVC.h
//  SmartMall
//
//  Created by Smart house on 2017/10/26.
//  Copyright © 2017年 verb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetCreditPaypwdVC : UIViewController
@property (strong, nonatomic)  UITextField *account;
@property (strong, nonatomic)  UITextField *password;


@property (strong, nonatomic)  UITextField *token;
@property (strong, nonatomic)  UITextField *pwdToken;

@property (strong, nonatomic)  UIButton *getToken;


@property (strong, nonatomic) UIImage *headImg;
@property (nonatomic, copy) NSString *moblie;
@end
