//
//  LoadViewController.h
//  UI进阶项目
//
//  Created by mac on 2016/12/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadViewController : UIViewController
@property(nonatomic ,strong)UITextField *account;
@property(nonatomic ,strong)UITextField *password;

@property(nonatomic,assign)BOOL isHideSelfOrTurntoUsercenter;

@property(nonatomic ,copy)void(^hideLoadBlock)(NSString *);

@end
