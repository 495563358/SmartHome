//
//  NewuserViewController.h
//  UI进阶项目
//
//  Created by mac on 2016/12/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewuserViewController : UIViewController
@property (strong, nonatomic)  UITextField *account;
@property (strong, nonatomic)  UITextField *password;

@property (strong, nonatomic)  UITextField *token;
@property (strong, nonatomic)  UITextField *pwdToken;


@property (strong, nonatomic)  UIButton *getToken;


@property(nonatomic ,copy)void(^accountAndPwd)(NSString *,NSString *);

@end
