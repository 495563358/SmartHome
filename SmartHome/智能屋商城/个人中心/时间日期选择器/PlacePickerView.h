//
//  PlacePickerView.h
//  在定义日期地点键盘
//
//  Created by Yang on 2017/7/12.
//  Copyright © 2017年 Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AYPlaceView;

@protocol AYPlaceViewDelegate <NSObject>

- (void)areaPickerView:(AYPlaceView *)areaPickerView didSelectArea:(NSString *)area;

@end

@interface PlacePickerView : UIView

@property(nonatomic, assign) BOOL isHidden;
//设置代理
@property(nonatomic, assign) id<AYPlaceViewDelegate> delegate;

- (instancetype)initWithDelegate:(id<AYPlaceViewDelegate>)delegate;

@end
