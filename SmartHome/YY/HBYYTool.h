//
//  HBYYTool.h
//  SmartHome
//
//  Created by Smart house on 2018/3/28.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"

@class IFlyDataUploader;
@class IFlySpeechRecognizer;
@class IFlySpeechSynthesizer;
@interface HBYYTool : UIViewController<IFlySpeechRecognizerDelegate,IFlySpeechSynthesizerDelegate>
{
    BOOL _isON;
}
//合成对象
@property (nonatomic, strong) IFlySpeechSynthesizer * iFlySpeechSynthesizer;
//关键词识别对象
@property (nonatomic, strong) IFlySpeechRecognizer * iFlySpeechRecognizer;
//@property (nonatomic, strong)   LCVoiceHud * voiceHud_  ;
//数据上传对象
@property (nonatomic, strong) IFlyDataUploader * uploader;

@property (nonatomic ,strong) UIView * parentView;

@property (nonatomic, strong) NSString             * reString;
@property (nonatomic)         BOOL                 isCanceled;
+ (instancetype)share;
-(void)yyfuwu;
@end
