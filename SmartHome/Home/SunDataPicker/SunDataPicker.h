//
//  SunDataPicker.h
//  testPicker
//
//  Created by sunzl on 15/11/19.
//  Copyright © 2015年 sunzl. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^Complete)(NSString * one,NSString * two,NSString * three);
typedef void (^CompleteIndex)(int one,int two,int three);
@interface SunDataPicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UILabel *_title;
}
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UIPickerView *picker;
@property (strong, nonatomic) UIButton *btn1;
@property (strong, nonatomic) UIButton *btn2;
@property (strong, nonatomic,readwrite) UIView *maskView;
@property (assign) int numberOfComponents;
@property (strong,nonatomic )Complete complete;
@property (strong,nonatomic )CompleteIndex completeIndex;
@property (strong,nonatomic )NSDictionary *dict;
@property (strong,nonatomic )NSDictionary *secondDict;
@property (strong,nonatomic )NSArray *oneTitles;
@property (strong,nonatomic )NSArray *secondTitles;
@property (strong,nonatomic )NSArray *thirdTitles;
@property (assign)int selectOne;
@property (assign)int selectTwo;
@property (assign)int selectThree;
//numberOfComponents 列数
//dict 数据源（可以是字典和数组）
//target 添加的界面
//complete 点击完成返回数据；
-(void)setNumberOfComponents:(int)numberOfComponents SET:(id)dict addTarget:(id)target Complete:(Complete)complete;
-(void)setNumberOfComponents:(int)numberOfComponents SET:(id)dict addTarget:(id)target CompleteIndex:(CompleteIndex)completeIndex;
@end
