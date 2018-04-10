//
//  FirstViewController.h
//  FanHeater
//
//  Created by kincony on 15/7/15.
//  Copyright (c) 2015年 kincony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCVoiceHud.h"
//关键字查询

#import "iflyMSC/IFlySpeechRecognizerDelegate.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"



@class PopupView;
@class IFlyDataUploader;
@class IFlySpeechRecognizer;
@class IFlySpeechSynthesizer;
@interface YYTool : NSObject <IFlySpeechRecognizerDelegate,IFlySpeechSynthesizerDelegate>
{
    BOOL _isON;
}
//合成对象
@property (nonatomic, strong) IFlySpeechSynthesizer * iFlySpeechSynthesizer;
//关键词识别对象
@property (nonatomic, strong) IFlySpeechRecognizer * iFlySpeechRecognizer;
@property (nonatomic, strong)   LCVoiceHud * voiceHud_  ;
//数据上传对象
@property (nonatomic, strong) IFlyDataUploader * uploader;
@property (nonatomic, strong) PopupView            * popUpView;

;
@property (nonatomic ,strong) UIView * parentView;

@property (nonatomic, strong) NSString             * reString;
@property (nonatomic)         BOOL                 isCanceled;
+ (instancetype)share;
-(void)yyfuwu;
@end
