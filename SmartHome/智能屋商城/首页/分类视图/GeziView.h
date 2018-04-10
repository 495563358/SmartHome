//
//  GeziView.h
//  UI进阶项目
//
//  Created by mac on 2016/12/18.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeziView : UIView

@property(nonatomic ,strong)UIButton *systemHost1;
@property(nonatomic ,strong)UIButton *switch2;
@property(nonatomic ,strong)UIButton *Lock3;
@property(nonatomic ,strong)UIButton *curtains4;
@property(nonatomic ,strong)UIButton *camera5;
@property(nonatomic ,strong)UIButton *construction6;
@property(nonatomic ,strong)UIButton *allgoods7;
@property(nonatomic ,strong)UIButton *distribution8;

@property (nonatomic,copy)void (^BtnCLickBlock) (NSString *,NSString *);
@property (nonatomic,copy)void (^commssionBlock) ();

@end
