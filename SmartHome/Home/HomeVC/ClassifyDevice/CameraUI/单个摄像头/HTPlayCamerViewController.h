//
//  HTPalyViewViewController.h
//  IPCam
//
//  Created by yaoyaodu on 13-6-17.
//  Copyright (c) 2013年 yaoyaodu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#include "PPPP_API.h"
#include "PPPPChannelManagement.h"
#import "ImageNotifyProtocol.h"

@interface HTPlayCamerViewController : UIViewController<ImageNotifyProtocol,SnapshotProtocol,ParamNotifyProtocol,PPPPStatusProtocol>{
    int flog;
    int horizontal;
    int vertical;
    int yushe;
    int shezhi;
    int mode;
}

@property  CPPPPChannelManagement* m_PPPPChannelMgt;
@property (retain, nonatomic) IBOutlet UILabel *yuShe;
@property (retain, nonatomic) IBOutlet UIButton *ContrastButton;
@property (retain, nonatomic) IBOutlet UIButton *BrightnessButton;
@property (retain, nonatomic) IBOutlet UIButton *MirrorHoriButton;
@property (retain, nonatomic) IBOutlet UIButton *MirrorVerButton;
@property (retain, nonatomic) IBOutlet UIButton *HD_Button;
@property (retain, nonatomic) IBOutlet UIButton *SD_Button;

@property (nonatomic, retain) NSString* cameraID;
@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* password;
@property (retain, nonatomic) IBOutlet UIImageView *playView;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;
- (IBAction)back:(id)sender;
- (IBAction)left_right:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *leftrightButton;
@property (retain, nonatomic) IBOutlet UIButton *updownButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *left_rightButton;
- (IBAction)up_down:(id)sender;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *up_downButton;
- (IBAction)left:(id)sender;
- (IBAction)right:(id)sender;
- (IBAction)up:(id)sender;
- (IBAction)down:(id)sender;
- (IBAction)hidebar:(id)sender;
@property (retain, nonatomic) IBOutlet UIToolbar *Toolbar1;
@property (retain, nonatomic) IBOutlet UIToolbar *Toolbar2;
@property (retain, nonatomic) IBOutlet UIView *setView;     //摄像头设置view
- (IBAction)Contrast:(id)sender;
@property (retain, nonatomic) IBOutlet UISlider *contrastSlider;
@property (retain, nonatomic) IBOutlet UISlider *lightnessSlider;
- (IBAction)lightness:(id)sender;   //亮度
- (IBAction)horizontal_mirror:(id)sender;//水平镜像
- (IBAction)vertical_mirror:(id)sender;//垂直镜像
- (IBAction)showSetView:(id)sender;
- (IBAction)contrastSetValue:(id)sender;    //对比度按钮触发
- (IBAction)lightnessSetValue:(id)sender;
- (IBAction)mode:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *modeView;    //视频样式（标清，高清设置）view
- (IBAction)modeHD:(id)sender;//高清
- (IBAction)modeSD:(id)sender;//标清
@property (retain, nonatomic) IBOutlet UIView *yusheView;   //预设view
@property (retain, nonatomic) IBOutlet UITableViewCell *yusheCell;
- (IBAction)yushewei:(id)sender;
- (IBAction)yusheButton:(id)sender;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) IBOutlet UIImageView *downImage;
@property (retain, nonatomic) IBOutlet UIImageView *rightImage;
@property (retain, nonatomic) IBOutlet UIImageView *leftImage;
@property (retain, nonatomic) IBOutlet UIImageView *upImage;
//
@property (assign)BOOL m_bAudioStarted;
@property (assign)BOOL m_bTalkStarted;
// @property (assign)int m_videoFormat;
@property (nonatomic, retain) UIImage* audioImgOn;
@property (nonatomic, retain) UIImage* audioImgOff;
@property (nonatomic, retain) UIImage* talkImgOn;
@property (nonatomic, retain) UIImage* talkImgOff;

@property (nonatomic, retain) IBOutlet UIButton* audioBtn;
@property (nonatomic, retain) IBOutlet UIButton* talkBtn;

- (IBAction) btnAudioControl: (id) sender;
- (IBAction) btnTalkControl:(id)sender;
- (UIImage*) fitImage:(UIImage*)image tofitHeight:(CGFloat)height;
@end
