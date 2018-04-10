//
//  ZenKeyboard.m
//  ZenKeyboard
//
//  Created by Kevin Nick on 2012-11-9.
//  Copyright (c) 2012年 com.zen. All rights reserved.
//

#import "ZenKeyboard.h"
#import "Config.h"
#import <AVFoundation/AVFoundation.h>
//2016.11.18
#import "NSArray+DDKit.h"
#define kMaxNumber 16
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define KEYBOARD_NUMERIC_KEY_WIDTH SCREEN_WIDTH/320*108
#define KEYBOARD_NUMERIC_KEY_HEIGHT SCREEN_WIDTH/320*53


@interface ZenKeyboard()

@property (nonatomic,assign) id<UITextInput> textInputDelegate;
@property (nonatomic,strong) AVAudioPlayer*player;
@end;

@implementation ZenKeyboard
@synthesize textField=_textField;
@synthesize textInputDelegate;
@synthesize player,VoiceSwitch;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame]; 
    if (self) {        
        UIImageView *keyboardBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"123jp"]];
        keyboardBackground.frame=frame;
        //UIImageView *keyboardGridLines = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"KeyboardNumericEntryViewGridLinesTextured"]];
       // keyboardGridLines.frame=frame;
        keyboardBackground.contentMode = UIViewContentModeScaleToFill;
       // keyboardGridLines.contentMode = UIViewContentModeScaleToFill;
        UIImageView *keyboardShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"KeyboardTopShadow"]];
        
       keyboardShadow.frame=CGRectMake(0, 0, frame.size.width, keyboardShadow.frame.size.height);
       keyboardShadow.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:keyboardBackground];
     //   [self addSubview:keyboardGridLines];
        NSArray *numOfKey=@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
        numOfKey=[numOfKey dd_randomizedArray];
     
        [self addSubview:[self addNumericKeyWithTitle:numOfKey[0] frame:CGRectMake(0, 1, KEYBOARD_NUMERIC_KEY_WIDTH - 3, KEYBOARD_NUMERIC_KEY_HEIGHT)]];
        [self addSubview:[self addNumericKeyWithTitle:numOfKey[1]  frame:CGRectMake(KEYBOARD_NUMERIC_KEY_WIDTH - 2, 1, KEYBOARD_NUMERIC_KEY_WIDTH, KEYBOARD_NUMERIC_KEY_HEIGHT)]];
        [self addSubview:[self addNumericKeyWithTitle:numOfKey[2] frame:CGRectMake(KEYBOARD_NUMERIC_KEY_WIDTH * 2 - 1, 1, KEYBOARD_NUMERIC_KEY_WIDTH - 2, KEYBOARD_NUMERIC_KEY_HEIGHT)]];
        
        [self addSubview:[self addNumericKeyWithTitle:numOfKey[3] frame:CGRectMake(0, KEYBOARD_NUMERIC_KEY_HEIGHT + 2, KEYBOARD_NUMERIC_KEY_WIDTH - 3, KEYBOARD_NUMERIC_KEY_HEIGHT)]];
        [self addSubview:[self addNumericKeyWithTitle:numOfKey[4]  frame:CGRectMake(KEYBOARD_NUMERIC_KEY_WIDTH - 2, KEYBOARD_NUMERIC_KEY_HEIGHT + 2, KEYBOARD_NUMERIC_KEY_WIDTH, KEYBOARD_NUMERIC_KEY_HEIGHT)]];
        [self addSubview:[self addNumericKeyWithTitle:numOfKey[5]  frame:CGRectMake(KEYBOARD_NUMERIC_KEY_WIDTH * 2 - 1, KEYBOARD_NUMERIC_KEY_HEIGHT + 2, KEYBOARD_NUMERIC_KEY_WIDTH - 3, KEYBOARD_NUMERIC_KEY_HEIGHT)]];

        [self addSubview:[self addNumericKeyWithTitle:numOfKey[6]  frame:CGRectMake(0, KEYBOARD_NUMERIC_KEY_HEIGHT * 2 + 3, KEYBOARD_NUMERIC_KEY_WIDTH - 3, KEYBOARD_NUMERIC_KEY_HEIGHT)]];
        [self addSubview:[self addNumericKeyWithTitle:numOfKey[7]  frame:CGRectMake(KEYBOARD_NUMERIC_KEY_WIDTH - 2, KEYBOARD_NUMERIC_KEY_HEIGHT * 2 + 3, KEYBOARD_NUMERIC_KEY_WIDTH , KEYBOARD_NUMERIC_KEY_HEIGHT)]];
        [self addSubview:[self addNumericKeyWithTitle:numOfKey[8]  frame:CGRectMake(KEYBOARD_NUMERIC_KEY_WIDTH * 2 - 1, KEYBOARD_NUMERIC_KEY_HEIGHT * 2 + 3, KEYBOARD_NUMERIC_KEY_WIDTH, KEYBOARD_NUMERIC_KEY_HEIGHT)]];

       // [self addSubview:[self addNumericKeyWithTitle:@"." frame:CGRectMake(0, KEYBOARD_NUMERIC_KEY_HEIGHT * 3 + 4, KEYBOARD_NUMERIC_KEY_WIDTH - 3, KEYBOARD_NUMERIC_KEY_HEIGHT)]];
        [self addSubview:[self addNumericKeyWithTitle:numOfKey[9]  frame:CGRectMake(KEYBOARD_NUMERIC_KEY_WIDTH - 2, KEYBOARD_NUMERIC_KEY_HEIGHT * 3 + 4, KEYBOARD_NUMERIC_KEY_WIDTH, KEYBOARD_NUMERIC_KEY_HEIGHT)]];
        [self addSubview:[self addBackspaceKeyWithFrame:CGRectMake(KEYBOARD_NUMERIC_KEY_WIDTH * 2 - 1, KEYBOARD_NUMERIC_KEY_HEIGHT * 3 + 4, KEYBOARD_NUMERIC_KEY_WIDTH - 3, KEYBOARD_NUMERIC_KEY_HEIGHT)]];
        
        [self addSubview:keyboardShadow];
       UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, -35,SCREEN_WIDTH, 40)];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 40)];
        label.text=NSLocalizedString(@"智能屋专用键盘", nil);
        label.backgroundColor=[UIColor whiteColor];
        label.textColor = [UIColor colorWithRed:33/255.0 green:154/255.0 blue:254/255.0 alpha:1];
       // label.textColor=RGBA(33, 145, 254, 1);
        label.font=[UIFont systemFontOfSize:20];
        self.btn  = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50,0,50, 40)];
        [self.btn  setTitle:@"收起" forState:UIControlStateNormal];
        self.btn .titleLabel.font=[UIFont systemFontOfSize:12];
       // [self.btn  setTitleColor:RGBA(33, 145, 254, 1) forState:UIControlStateNormal];
        [self.btn  setTitleColor:[UIColor colorWithRed:33/255.0 green:154/255.0 blue:254/255.0 alpha:1] forState:UIControlStateNormal];
        [self.btn  addTarget:self action:@selector(closeKey) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:label];
        [view addSubview:self.btn ];
        [self.btn setHidden:YES];
        [self addSubview:view];
    
    }
    
    return self;
}

-(void)closeKey
{
    NSLog(@"closeKey");
    [self.textField resignFirstResponder];

}
- (UIButton *)addNumericKeyWithTitle:(NSString *)title frame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:28.0]];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -0.5)];
    
    UIImage *buttonImage = [UIImage imageNamed:@"KeyboardNumericEntryKeyTextured"];
    UIImage *buttonPressedImage = [UIImage imageNamed:@"KeyboardNumericEntryKeyPressedTextured"];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(pressNumericKey:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UIButton *)addBackspaceKeyWithFrame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    UIImage *buttonImage = [UIImage imageNamed:@"KeyboardNumericEntryKeyTextured"];
    UIImage *buttonPressedImage = [UIImage imageNamed:@"KeyboardNumericEntryKeyPressedTextured"];
    UIImage *image = [UIImage imageNamed:@"KeyboardNumericEntryKeyBackspaceGlyphTextured"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((buttonImage.size.width - image.size.width) / 2, (buttonImage.size.height - image.size.height) / 2, image.size.width, image.size.height)];
    imgView.image = image;
    [button addSubview:imgView];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(pressBackspaceKey) forControlEvents:UIControlEventTouchUpInside];

    return button;
}

- (void)setTextField:(UITextField *)textField {
    _textField = textField;
    _textField.inputView = self;
    self.textInputDelegate = _textField;
}


- (void)pressNumericKey:(UIButton *)button {
    NSString *keyText = button.titleLabel.text;
    if (kMaxNumber < [NSString stringWithFormat:@"%@%@", _textField.text,keyText].length) {
        _textField.text = _textField.text;
    }else{
   
        _textField.text =[NSString stringWithFormat:@"%@%@", _textField.text,keyText];
    }
   
}

- (void)pressBackspaceKey {
   
    if (_textField.text.length==1) {
        _textField.text = @"";
        return;
    } else {
        
        [self.textInputDelegate deleteBackward];
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
