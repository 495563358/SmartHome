//
//  ZenKeyboard.h
//  ZenKeyboard
//
//  Created by Kevin Nick on 2012-11-9.
//  Copyright (c) 2012年 com.zen. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define KEYBOARD_NUMERIC_KEY_WIDTH SCREEN_WIDTH/320*108
//#define KEYBOARD_NUMERIC_KEY_HEIGHT SCREEN_WIDTH/320*53

@protocol ZenKeyboardDelegate <NSObject>

- (void)numericKeyDidPressed:(int)key;
- (void)backspaceKeyDidPressed;

@end

@interface ZenKeyboard : UIView
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, assign) UITextField *textField;
@property (nonatomic, assign) UISwitch *VoiceSwitch;
@end
