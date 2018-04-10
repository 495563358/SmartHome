//
//  TXTradePasswordView.h
//  TF
//
//  Created by --- on 16/1/3.
//  Copyright © 2016年 吴天祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define  boxWidth (SCREEN_WIDTH -70)/6 //密码框的宽度



@class TXTradePasswordView;

@protocol TXTradePasswordViewDelegate <NSObject>

@optional

-(void)TXTradePasswordView:(TXTradePasswordView *)view WithPasswordString:(NSString *)Password;

@end




@interface TXTradePasswordView : UIView <UITextFieldDelegate>

@property (nonatomic,assign)id <TXTradePasswordViewDelegate>TXTradePasswordDelegate;



- (id)initWithFrame:(CGRect)frame WithTitle :(NSString *)title;

///标题
@property (nonatomic,)UILabel *lable_title;
///  TF
@property (nonatomic,)UITextField *TF;

///  假的输入框
@property (nonatomic,)UIView *view_box;
@property (nonatomic,)UIView *view_box2;
@property (nonatomic,)UIView *view_box3;
@property (nonatomic,)UIView *view_box4;
@property (nonatomic,)UIView *view_box5;
@property (nonatomic,)UIView *view_box6;

///   密码点
@property (nonatomic,)UILabel *lable_point;
@property (nonatomic,)UILabel *lable_point2;
@property (nonatomic,)UILabel *lable_point3;
@property (nonatomic,)UILabel *lable_point4;
@property (nonatomic,)UILabel *lable_point5;
@property (nonatomic,)UILabel *lable_point6;
@end
