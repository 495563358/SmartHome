//
//  HTPalyViewViewController.m
//  IPCam
//
//  Created by yaoyaodu on 13-6-17.
//  Copyright (c) 2013年 yaoyaodu. All rights reserved.
//

#import "HTPlayCamerViewController.h"
#include "MyAudioSession.h"
#import "MyGLViewController.h"

#include "APICommon.h"
#import "PPPPDefine.h"
#import "obj_common.h"
#import "cmdhead.h"
#import "UIImage+UIImageExtras.h"

#import "UIView+Toast.h"
#import "MBProgressHUD.h"


#define EnterBackground    @"applicationDidEnterBackground" 
//应用程序进入后台
@interface HTPlayCamerViewController (){
    int currentHD;
    BOOL bPlaying;
    int nResolution;//分辨率
    
    int m_nWidth;
    int m_nHeight;
    int m_videoFormat;
    
    NSCondition *m_YUVDataLock;
    Byte *m_pYUVData;
    
    UIImage *cacheImg;
    NSInteger needImg;
    
    MyGLViewController *myGLViewController;
}

@property (nonatomic, retain) NSCondition* m_PPPPChannelMgtCondition;

@end

@implementation HTPlayCamerViewController


#pragma mark -
#pragma mark PPPPStatusDelegate 状态协议
- (void) PPPPStatus: (NSString*) strDID statusType:(NSInteger) statusType status:(NSInteger) status{
    NSString* strPPPPStatus;
    switch (status) {
        case PPPP_STATUS_UNKNOWN:
            strPPPPStatus = NSLocalizedStringFromTable(@"未知状态", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECTING:
            strPPPPStatus = NSLocalizedStringFromTable(@"连接中", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INITIALING:
            strPPPPStatus = NSLocalizedStringFromTable(@"初始化中", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECT_FAILED:
            strPPPPStatus = NSLocalizedStringFromTable(@"连接失败", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DISCONNECT:
            strPPPPStatus = NSLocalizedStringFromTable(@"取消连接", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INVALID_ID:
            strPPPPStatus = NSLocalizedStringFromTable(@"非法设备号", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"摄像机已连接", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DEVICE_NOT_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"摄像机不在线", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECT_TIMEOUT:
            strPPPPStatus = NSLocalizedStringFromTable(@"连接超时", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INVALID_USER_PWD:
            strPPPPStatus = NSLocalizedStringFromTable(@"无效密码", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        default:
            strPPPPStatus = NSLocalizedStringFromTable(@"未知状态", @STR_LOCALIZED_FILE_NAME, nil);
            break;
    }
    if(status == PPPP_STATUS_CONNECT_FAILED || status == PPPP_STATUS_DISCONNECT || status == PPPP_STATUS_INVALID_ID || status == PPPP_STATUS_DEVICE_NOT_ON_LINE || status == PPPP_STATUS_CONNECT_TIMEOUT || status == PPPP_STATUS_INVALID_USER_PWD || status == PPPP_STATUS_UNKNOWN || status == PPPP_STATUS_ON_LINE){
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:mainWindowss animated:YES];
            [self.view makeToast:strPPPPStatus];
        });
    }
    
    //如果是PPP断开，则停止播放
    if (statusType == MSG_NOTIFY_TYPE_PPPP_STATUS && status == PPPP_STATUS_DISCONNECT) {
        NSLog(@"连接断开");
        [self performSelectorOnMainThread:@selector(StopPlay:) withObject:nil waitUntilDone:NO];
    }
    dispatch_async(dispatch_get_main_queue(),^{
        self.statusLabel.text=strPPPPStatus;
        if (status == PPPP_STATUS_ON_LINE) {
            NSLog(@"连接正常");
            [self starVideo:nil];
        }
        
    });
}

//停止播放
- (void) StopPlay:(int)bForce
{   
    if (_m_PPPPChannelMgt != NULL) {
        _m_PPPPChannelMgt->StopPPPPLivestream([_cameraID UTF8String]);
        _m_PPPPChannelMgt->StopPPPPAudio([_cameraID UTF8String]);
        _m_PPPPChannelMgt->StopPPPPTalk([_cameraID UTF8String]);
    }
}

#pragma mark -
#pragma mark ParamNotify
-(void)ParamNotify:(int)paramType params:(void *)params{
    if (paramType == CGI_IEGET_CAM_PARAMS) {
        NSLog(@"参数种类 = 6003");
    }
    if (paramType == STREAM_CODEC_TYPE){
        NSLog(@"参数种类 = 6040");
    }
}


#pragma mark -
#pragma mark ImageNotify
-(void)ImageNotify:(UIImage *)image timestamp:(NSInteger)timestamp{
    NSLog(@"图片通知ImageNotify  时间 = %ld", (long)timestamp);
    if (m_videoFormat == -1) {
        m_videoFormat = 0;
    }
    [self performSelector:@selector(refreshImage:) withObject:image];
}

/* 视频处理 */
-(void)YUVNotify:(Byte *)yuv length:(int)length width:(int)width height:(int)height timestamp:(unsigned int)timestamp{
    
    if (bPlaying == NO) {
        [self performSelectorOnMainThread:@selector(CreateGLView) withObject:nil waitUntilDone:YES];
        [self updataResolution:width height:height];
        bPlaying = YES;
    }
    [myGLViewController WriteYUVFrame:yuv Len:length width:width height:height];
    [m_YUVDataLock lock];
    SAFE_DELETE(m_pYUVData);
    int yuvlength = width * height * 3 / 2;
    m_pYUVData = new Byte[yuvlength];
    memcpy(m_pYUVData, yuv, yuvlength);
    m_nWidth = width;
    m_nHeight = height;
    
    
    if (m_YUVDataLock == NULL) {
        [m_YUVDataLock unlock];
        return;
    }
    
    [m_YUVDataLock unlock];
    
    if (needImg>=0) {
        
//        cacheImg = [APICommon YUV420ToImage:yuv width:width height:height];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld.png",_cameraID,(long)needImg]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:needImg inSection:0];
        needImg = -1;
        UIImage *image = [APICommon YUV420ToImage:yuv width:width height:height];
        NSData *imageData = UIImageJPEGRepresentation(image,0.5);
        
        BOOL result = [imageData writeToFile:uniquePath atomically:YES];
        if (result) {
            NSLog(@"success");
            
            UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
            UIImageView *imageView;
            imageView = (UIImageView *)[cell viewWithTag:1];
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = image;
            });
        }else {
            NSLog(@"no success");
        }
    }
}

- (void) CreateGLView
{
    myGLViewController = [[MyGLViewController alloc] init];
    if ([[UIApplication sharedApplication] statusBarOrientation]== UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation]== UIInterfaceOrientationLandscapeRight) {
        myGLViewController.view.frame = _playView.frame;//CGRectMake(0, 0, m_nScreenWidth, m_nScreenHeight);
    }else{
        myGLViewController.view.frame = _playView.frame;//CGRectMake(0, 224, 768, 576);
    }
    
    [self.playView addSubview:myGLViewController.view];
    
}

//协议三
- (void) H264Data: (Byte*) h264Frame length: (int) length type: (int) type timestamp: (NSInteger) timestamp{
    if (m_videoFormat == -1) {
        m_videoFormat = 2;
        //        [self performSelectorOnMainThread:@selector(enableButton) withObject:nil waitUntilDone:NO];
    }
}


- (void) updataResolution: (int) width height:(int)height
{
    int m_nVideoWidth = width;
    int m_nVideoHeight = height;
    
    if(m_nVideoWidth == 1280 && m_nVideoHeight == 720){
        nResolution = 3;
//        [self performSelectorOnMainThread:@selector(updateVideoResolution) withObject:nil waitUntilDone:NO];
    }else if(m_nVideoWidth == 640 && m_nVideoHeight == 480){
        nResolution = 0;
//        [self performSelectorOnMainThread:@selector(updateVideoResolution) withObject:nil waitUntilDone:NO];
    }else if(m_nVideoWidth == 320 && m_nVideoHeight == 240){
        nResolution = 1;
//        [self performSelectorOnMainThread:@selector(updateVideoResolution) withObject:nil waitUntilDone:NO];
    }
//    [self performSelectorOnMainThread:@selector(setDisplayMode) withObject:nil waitUntilDone:NO];
    
}



-(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//View处理
- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}

/* 出现时 */
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (_m_PPPPChannelMgt == nil) {
            _m_PPPPChannelMgtCondition = [[NSCondition alloc] init];
            _m_PPPPChannelMgt = new CPPPPChannelManagement();
            _m_PPPPChannelMgt->pCameraViewController = self;
            //[self Initialize:nil];
            [self ConnectCam:self.username psw:self.password];
        }
        else{
            [self starVideo:nil];
        }
    });
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.navigationBar.hidden = YES;
}


/* 消失时 */
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopVideo:nil];
    if (_m_PPPPChannelMgt == nil) {
        [self stopCamera:nil];
    }
    _m_PPPPChannelMgt->StopAll();
    _m_PPPPChannelMgt = nil;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
    // iOS 7
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];

    }
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    self.view.bounds = CGRectMake(0, 0, frame.size.height, frame.size.width);
    UIImage* image =[self imageWithColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:image];

    //初始化文字
    [self.ContrastButton setTitle:@"对比度" forState:UIControlStateNormal];
    [self.MirrorHoriButton setTitle:@"水平镜像" forState:UIControlStateNormal];
    [self.MirrorVerButton setTitle:@"垂直镜像" forState:UIControlStateNormal];
    [self.BrightnessButton setTitle:@"亮度" forState:UIControlStateNormal];
    [self.HD_Button setTitle:@"1080P" forState:UIControlStateNormal];
    [self.SD_Button setTitle:@"720P" forState:UIControlStateNormal];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back:) name:EnterBackground object:nil];
    
    if (self.statusLabel.text.length == 0 && !self.m_PPPPChannelMgt) {
        [self.statusLabel setText:@"正在与服务器连接"];
    }
    
    shezhi=1;
    mode=1;
    yushe=1;
    flog=-1;
    horizontal=YES;
    vertical=YES;
    currentHD = 99;
    m_YUVDataLock = [[NSCondition alloc] init];
    m_pYUVData = NULL;
    m_nWidth = 0;
    m_nHeight = 0;
    m_videoFormat = -1;
    needImg = -1;
    
    
    NSLog(@"camerID = %@",_cameraID);
    
//    NSData *imgData = [self getSnapshotByDID:_cameraID];
//    if (imgData != nil) {
//        self.playView.image = [UIImage imageWithData:imgData];
//    }
    
    
    //    [self hidebar:nil];
    [self performSelector:@selector(hidebar:) withObject:nil afterDelay:0.5];
    
    
    _yusheView.frame=CGRectMake(Sc_h/6 + 20, 44, 120, 196);
    
    UIView *tipForYusheViewheaderView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, 120, 40)];
    tipForYusheViewheaderView.backgroundColor = [UIColor grayColor];
    UILabel *tipForYusheViewheaderViewtitleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 39)];
    tipForYusheViewheaderViewtitleL.text = @"选择预设位";
    tipForYusheViewheaderViewtitleL.backgroundColor = [UIColor whiteColor];
    tipForYusheViewheaderViewtitleL.textAlignment = NSTextAlignmentCenter;
    tipForYusheViewheaderViewtitleL.font = [UIFont systemFontOfSize:14];
    UILabel *tipForYusheViewheaderViewsetL = [[UILabel alloc] initWithFrame:CGRectMake(76, 0, 44, 39)];
    tipForYusheViewheaderViewsetL.text = @"设置";
    tipForYusheViewheaderViewsetL.backgroundColor = [UIColor whiteColor];
    tipForYusheViewheaderViewsetL.textAlignment = NSTextAlignmentCenter;
    tipForYusheViewheaderViewsetL.font = [UIFont systemFontOfSize:14];
    [tipForYusheViewheaderView addSubview:tipForYusheViewheaderViewtitleL];
    [tipForYusheViewheaderView addSubview:tipForYusheViewheaderViewsetL];
    
    _tableView.tableHeaderView = tipForYusheViewheaderView;
    
    [self.view addSubview:_yusheView];
    _setView.frame=CGRectMake(Sc_h/3 + 20, 44, 120, 160);
    [self.view addSubview:_setView];
    _modeView.frame=CGRectMake(Sc_h/6 * 5 + 20, 44, 99, 118);
    [self.view addSubview:_modeView];

    [self.Toolbar1 setBackgroundImage:[UIImage imageNamed:@"bar.png"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.Toolbar2 setBackgroundImage:[UIImage imageNamed:@"bar.png"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    _audioImgOn = [[self fitImage:[UIImage imageNamed:@"audio"] tofitHeight:35] retain];
    _audioImgOff = [[self fitImage:[UIImage imageNamed:@"ptz_audio_off"] tofitHeight:35] retain];
    _talkImgOn = [[self fitImage:[UIImage imageNamed:@"micro_on"] tofitHeight:35] retain];
    _talkImgOff = [[self fitImage:[UIImage imageNamed:@"microphone_off"] tofitHeight:35] retain];
}

- (NSData *) getSnapshotByDID: (NSString*) strDID
{
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:strDID];
    //NSLog(@"strPath: %@", strPath);
    strPath = [strPath stringByAppendingPathComponent:@"snapshot.jpg"];
    
    NSData *dataImage = [NSData dataWithContentsOfFile:strPath];
    
    return dataImage;
    
}


- (UIImage*) fitImage:(UIImage*)image tofitHeight:(CGFloat)height{
    CGSize imagesize = image.size;
    CGFloat scale = 0.0;
    if (imagesize.height > height) {
        scale = imagesize.height / height;
    }
    imagesize = CGSizeMake(imagesize.width/scale, height);
    UIGraphicsBeginImageContext(imagesize);
    [image drawInRect:CGRectMake(0, 0, imagesize.width, imagesize.height)];
    UIImage* newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}

- (IBAction)Initialize:(id)sender {
    st_PPPP_NetInfo NetInfo;
    PPPP_NetworkDetect(&NetInfo, 0);
    PPPP_Initialize((CHAR*)"ADCBBFAOPPJAHGJGBBGLFLAGDBJJHNJGGMBFBKHIBBNKOKLDHOBHCBOEHOKJJJKJBPMFLGCPPJMJAPDOIPNL"
                    );
    
    st_PPPP_NetInfo1 netInfo;
    XQP2P_NetworkDetect(&netInfo, 0);
    XQP2P_Initialize((CHAR *)"HZLXSXIALKHYEIEJHUASLMHWEESUEKAUIHPHSWAOSTEMENSQPDLRLNPAPEPGEPERIBLQLKHXELEHHULOEGIAEEHYEIEK-$$", 0);
}


- (void)ConnectCam:(NSString *)user psw:(NSString *)psw
{
    _m_PPPPChannelMgt->Start([_cameraID UTF8String], [user UTF8String], [psw UTF8String]);
}

- (IBAction)starVideo:(id)sender {
    if (_m_PPPPChannelMgt != NULL) {
        if (_m_PPPPChannelMgt->StartPPPPLivestream([_cameraID UTF8String], 10,0, self) == 0) {
            _m_PPPPChannelMgt->StopPPPPAudio([_cameraID UTF8String]);
            _m_PPPPChannelMgt->StopPPPPLivestream([_cameraID UTF8String]);
            return;
        }
    }
}

- (IBAction)starAudio:(id)sender{
    _m_PPPPChannelMgt->StartPPPPAudio([_cameraID UTF8String]);
}

- (IBAction)stopVideo:(id)sender{
    _m_PPPPChannelMgt->StopPPPPAudio([_cameraID UTF8String]);
    _m_PPPPChannelMgt->StopPPPPLivestream([_cameraID UTF8String]);
    dispatch_async(dispatch_get_main_queue(),^{
        _playView.image = nil;
    });
}

- (IBAction)stopAudio:(id)sender{
    _m_PPPPChannelMgt->Stop([_cameraID UTF8String]);
}

- (IBAction)stopCamera:(id)sender{
    [_m_PPPPChannelMgtCondition lock];
    if (_m_PPPPChannelMgt == NULL) {
        [_m_PPPPChannelMgtCondition unlock];
        return;
    }
    _m_PPPPChannelMgt->StopAll();
    [_m_PPPPChannelMgtCondition unlock];
    dispatch_async(dispatch_get_main_queue(),^{
        _playView.image = nil;
    });
    
}



//refreshImage
- (void) refreshImage:(UIImage* ) image{
    if (image != nil) {
        dispatch_async(dispatch_get_main_queue(),^{
            _playView.image = image;
        });
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"yusheCell" owner:self options:nil];
        cell = self.yusheCell;
        self.yusheCell = nil;
    }
    UILabel *label;
    label=(UILabel *)[cell viewWithTag:2];
    label.text=[NSString stringWithFormat:@"%@%ld",@"预置位",row+1];
    UIButton *btn;
    btn=(UIButton *)[cell viewWithTag:3];
    btn.tag=row;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,                                                                          NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath2 = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld.png",_cameraID,row]];
    UIImage *img = [UIImage imageWithContentsOfFile:filePath2];
    UIImageView *image=(UIImageView *)[cell viewWithTag:1];
    if (img!=nil) {
        [image setImage:img];
    }
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 39;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:
            _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_PREFAB_BIT_RUN0);
            break;
        case 1:
            _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_PREFAB_BIT_RUN1);
            break;
        case 2:
            _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_PREFAB_BIT_RUN2);
            break;
        case 3:
            _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_PREFAB_BIT_RUN3);
            break;
        case 4:
            _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_PREFAB_BIT_RUN4);
            break;
        default:
            break;
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self stopVideo:nil];
        [self.navigationController popViewControllerAnimated:YES];
 
    
    if (_m_PPPPChannelMgt == nil) {
        [self stopCamera:nil];
        //        _m_PPPPChannelMgt->StopAll();
        //        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)hideView{
    _contrastSlider.hidden=YES;
    _lightnessSlider.hidden=YES;
    _setView.hidden=YES;
    _modeView.hidden=YES;
    _yusheView.hidden=YES;
}
- (IBAction)left_right:(id)sender {
    [self hideView];
    if (![self.left_rightButton.tintColor isEqual:[UIColor redColor]]) {
        [self.leftrightButton setImage:[UIImage imageNamed:@"ico3on.png"] forState:UIControlStateNormal];
        self.left_rightButton.tintColor=[UIColor redColor];
        _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_LEFT_RIGHT);
    }else{
        [self.leftrightButton setImage:[UIImage imageNamed:@"ico3.png"] forState:UIControlStateNormal];
        self.left_rightButton.tintColor=nil;
        _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_LEFT_RIGHT_STOP);
    }
}
- (void)dealloc {
      NSLog(@"视图销毁");
    [_playView release];
    [_left_rightButton release];
    [_up_downButton release];
    [_Toolbar1 release];
    [_Toolbar2 release];
    [_setView release];
    [_contrastSlider release];
    [_lightnessSlider release];
    [_modeView release];
    [_yusheView release];
    [_yusheCell release];
    [_tableView release];
    [_leftrightButton release];
    [_updownButton release];
    [_leftImage release];
    [_upImage release];
    [_downImage release];
    [_rightImage release];
    [_statusLabel release];
    [_yuShe release];
    [_ContrastButton release];
    [_BrightnessButton release];
    [_MirrorHoriButton release];
    [_MirrorVerButton release];
    [_HD_Button release];
    [_SD_Button release];
    
    if (_audioImgOn) {
        [_audioImgOn release];
        _audioImgOn = nil;
    }
    if (_audioImgOff) {
        [_audioImgOff release];
        _audioImgOff = nil;
    }
    if (_talkImgOn) {
        [_talkImgOn release];
        _talkImgOn = nil;
    }
    if (_talkImgOff) {
        [_talkImgOff  release];
        _talkImgOff = nil;
    }
    
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPlayView:nil];
    [self setLeft_rightButton:nil];
    [self setUp_downButton:nil];
    [self setToolbar1:nil];
    [self setToolbar2:nil];
    [self setSetView:nil];
    [self setContrastSlider:nil];
    [self setLightnessSlider:nil];
    [self setModeView:nil];
    [self setYusheView:nil];
    [self setYusheCell:nil];
    [self setTableView:nil];
    [self setLeftrightButton:nil];
    [self setUpdownButton:nil];
    [self setLeftImage:nil];
    [self setUpImage:nil];
    [self setDownImage:nil];
    [self setRightImage:nil];
    [self setStatusLabel:nil];
    [self setYuShe:nil];
    [self setContrastButton:nil];
    [self setBrightnessButton:nil];
    [self setMirrorHoriButton:nil];
    [self setMirrorVerButton:nil];
    [self setHD_Button:nil];
    [self setSD_Button:nil];
    [super viewDidUnload];
}
- (IBAction)up_down:(id)sender {
    [self hideView];
    if (![self.up_downButton.tintColor isEqual:[UIColor redColor]]) {
        [self.updownButton setImage:[UIImage imageNamed:@"ico4on.png"] forState:UIControlStateNormal];
        self.up_downButton.tintColor=[UIColor redColor];
        _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_UP_DOWN);
    }else{
        [self.updownButton setImage:[UIImage imageNamed:@"ico4.png"] forState:UIControlStateNormal];
        self.up_downButton.tintColor=nil;
        _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_UP_DOWN_STOP);
    }
}
- (IBAction)left:(id)sender {
    self.leftImage.hidden=NO;
    [self performSelector:@selector(hideImage) withObject:nil afterDelay:0.3];
    
    _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_LEFT);
}

- (IBAction)right:(id)sender {
    self.rightImage.hidden=NO;
    [self performSelector:@selector(hideImage) withObject:nil afterDelay:0.3];
    _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_RIGHT);
}

- (IBAction)up:(id)sender {
    self.upImage.hidden=NO;
    [self performSelector:@selector(hideImage) withObject:nil afterDelay:0.3];
    _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_UP);
}

- (IBAction)down:(id)sender {
    self.downImage.hidden=NO;
    [self performSelector:@selector(hideImage) withObject:nil afterDelay:0.3];
    _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_DOWN);
}
-(void)hideImage{
    _downImage.hidden=YES;
    _rightImage.hidden=YES;
    _leftImage.hidden=YES;
    _upImage.hidden=YES;
}
- (IBAction)hidebar:(id)sender {
    [UIView beginAnimations:@"doflip" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    if (flog==-1) {
        self.Toolbar1.frame=CGRectMake(0, -44, self.Toolbar1.frame.size.width,44);
        self.Toolbar2.frame=CGRectMake(0, self.Toolbar2.frame.origin.y+44, self.Toolbar2.frame.size.width,44);
        flog=0;
    }else{
        self.Toolbar1.frame=CGRectMake(0,0, self.Toolbar1.frame.size.width,44);
        self.Toolbar2.frame=CGRectMake(0,self.Toolbar2.frame.origin.y-44, self.Toolbar2.frame.size.width,44);
        flog=-1;
    }
    [self hideView];
    [UIView commitAnimations];
}
- (IBAction)Contrast:(id)sender {
    _setView.hidden=YES;
    _contrastSlider.hidden=NO;
}

- (IBAction)lightness:(id)sender {
    _setView.hidden=YES;
    [self hideView];
    _lightnessSlider.hidden=NO;
}

- (IBAction)horizontal_mirror:(id)sender {
    if (horizontal&&vertical) {
        _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 5, 2);
    }else{
        
        if (!vertical) {
            _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 5, 3);
        }else{
            _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 5, 0);
        }
        if (!horizontal&&!vertical) {
            _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 5, 1);
        }
    }
    
    horizontal=!horizontal;
    UIButton *button=(UIButton *)sender;
    if (button.backgroundColor==[UIColor blueColor]) {
        button.backgroundColor=[UIColor clearColor];
    }else{
        button.backgroundColor=[UIColor blueColor];
    }
}

- (IBAction)vertical_mirror:(id)sender {
    if (vertical&& horizontal) {
        _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 5, 1);
    }else{
        
        if (!horizontal) {
            _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 5, 3);
        }else{
            _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 5, 0);
        }
        if (!horizontal&&!vertical) {
            _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 5, 2);
        }
    }
    
    vertical=!vertical;
    UIButton *button=(UIButton *)sender;
    if (button.backgroundColor==[UIColor blueColor]) {
        button.backgroundColor=[UIColor clearColor];
    }else{
        button.backgroundColor=[UIColor blueColor];
    }
}

- (IBAction)showSetView:(id)sender {
    [self hideView];
    _setView.hidden=!_setView.hidden;
    shezhi=-shezhi;
}

- (IBAction)contrastSetValue:(id)sender {
    _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 2, _contrastSlider.value);
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"config.plist"];
    
    
    NSMutableDictionary *data2 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    
    NSMutableDictionary *data1 = [NSMutableDictionary dictionary];
    
    [data1 setObject:[NSString stringWithFormat:@"%f",_contrastSlider.value] forKey:@"contrast"];
    [data1 setObject:[NSString stringWithFormat:@"%f",_lightnessSlider.value] forKey:@"lightness"];
    [data2 setObject:data1 forKey:_cameraID];
    
    [data2 writeToFile:filename atomically:YES];
    
    
}

- (IBAction)lightnessSetValue:(id)sender {
    _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 1, _lightnessSlider.value);
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"config.plist"];
    
    
    NSMutableDictionary *data2 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    
    NSMutableDictionary *data1 = [NSMutableDictionary dictionary];
    
    [data1 setObject:[NSString stringWithFormat:@"%f",_contrastSlider.value] forKey:@"contrast"];
    [data1 setObject:[NSString stringWithFormat:@"%f",_lightnessSlider.value] forKey:@"lightness"];
    [data2 setObject:data1 forKey:_cameraID];
    
    [data2 writeToFile:filename atomically:YES];
}

- (IBAction)mode:(id)sender {
    [self hideView];
    
    _modeView.hidden=!_modeView.hidden;
    mode=-mode;
}

- (IBAction)modeHD:(id)sender {
    
    if (currentHD == 0) {
        return;
    }
    
    
    _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 16, 0);
    currentHD = 0;
    
    UIButton *button=(UIButton *)[_modeView viewWithTag:500];
    UIButton *button2=(UIButton *)[_modeView viewWithTag:501];
    if (button.backgroundColor==[UIColor blueColor]) {
        button.backgroundColor=[UIColor clearColor];
    }else{
        button.backgroundColor=[UIColor blueColor];
        button2.backgroundColor=[UIColor clearColor];
        button.enabled=NO;
        button2.enabled=YES;
    }
    
    [self mode:nil];
}


//设置清晰度

- (IBAction)modeSD:(id)sender {
    if (currentHD == 3) {
        return;
    }
    _m_PPPPChannelMgt->CameraControl([_cameraID UTF8String], 16, 3);
    
    currentHD = 3;
    UIButton *button2=(UIButton *)[_modeView viewWithTag:500];
    UIButton *button=(UIButton *)[_modeView viewWithTag:501];
    if (button.backgroundColor==[UIColor blueColor]) {
        button.backgroundColor=[UIColor clearColor];
    }else{
        button.backgroundColor=[UIColor blueColor];
        button2.backgroundColor=[UIColor clearColor];
        button.enabled=NO;
        button2.enabled=YES;
    }
    
    [self mode:nil];
}
- (IBAction)yushewei:(id)sender {
    [self hideView];
    
    self.yusheView.hidden = !self.yusheView.hidden;
    yushe=-yushe;
}

- (IBAction)yusheButton:(id)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imageView;
    imageView = (UIImageView *)[cell viewWithTag:1];
    imageView.image = cacheImg;
    switch ([sender tag]) {
        case 0:
            _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_PREFAB_BIT_SET0);
            break;
        case 1:
            _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_PREFAB_BIT_SET1);
            break;
        case 2:
            _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_PREFAB_BIT_SET2);
            break;
        case 3:
            _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_PREFAB_BIT_SET3);
            break;
        case 4:
            _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_PREFAB_BIT_SET4);
            break;
        default:
            break;
    }
    
    needImg = [sender tag];
    
}




- (void) StartAudio
{
    _m_PPPPChannelMgt->StartPPPPAudio([_cameraID UTF8String]);
}

- (void) StopAudio
{
    _m_PPPPChannelMgt->StopPPPPAudio([_cameraID UTF8String]);
}

- (void) StartTalk
{
    _m_PPPPChannelMgt->StartPPPPTalk([_cameraID UTF8String]);
}

- (void) StopTalk
{
    _m_PPPPChannelMgt->StopPPPPTalk([_cameraID UTF8String]);
}
- (IBAction)btnAudioControl:(id)sender
{
    if (_m_bAudioStarted) {
        [self StopAudio];
        [_audioBtn setImage:_audioImgOff forState:UIControlStateNormal];
        //btnAudioControl.style = UIBarButtonItemStyleBordered;
        //btnAudioControl.image = [UIImage imageNamed:@"ptz_audio_off"];
        //[btnAudioControl setBackgroundImage:[UIImage imageNamed:@"ptz_audio_off"] forState:UIControlStateNormal style:UIBarButtonItemStyleBordered barMetrics:UIBarMetricsDefault];
    }else {
        if (_m_bTalkStarted) {
            [self StopTalk];
            _m_bTalkStarted = !_m_bTalkStarted;
            [_talkBtn setImage:_talkImgOff forState:UIControlStateNormal];
            //btnTalkControl.style = UIBarButtonItemStyleBordered;
            //btnTalkControl.image = [UIImage imageNamed:@"microphone_off"];
            //[btnAudioControl setBackgroundImage:[UIImage imageNamed:@"audio"] forState:UIControlStateNormal style:UIBarButtonItemStyleDone barMetrics:UIBarMetricsDefault];
        }
        [self StartAudio];
        [_audioBtn setImage:_audioImgOn forState:UIControlStateNormal];
        //btnAudioControl.style = UIBarButtonItemStyleDone;
        //btnAudioControl.image = [UIImage imageNamed:@"audio"];
    }
    
    _m_bAudioStarted = !_m_bAudioStarted;
    
    /*if (m_bAudioStarted) {
     btnTalkControl.enabled = NO;
     }else {
     btnTalkControl.enabled = YES;
     }*/
}
//
- (IBAction)btnTalkControl:(id)sender
{
    if (_m_bTalkStarted) {
        [self StopTalk];
        [_talkBtn setImage:_talkImgOff forState:UIControlStateNormal];
        //btnTalkControl.style = UIBarButtonItemStyleBordered;
        //btnTalkControl.image = [UIImage imageNamed:@"microphone_off"];
        //[btnTalkControl setBackgroundImage:[UIImage imageNamed:@"microphone_off"] forState:UIControlStateNormal style:UIBarButtonItemStyleBordered barMetrics:UIBarMetricsDefault];
    }else {
        if (_m_bAudioStarted) {
            [self StopAudio];
            _m_bAudioStarted = !_m_bAudioStarted;
            [_audioBtn setImage:_audioImgOff forState:UIControlStateNormal];
            //btnAudioControl.style = UIBarButtonItemStyleBordered;
            //btnAudioControl.image = [UIImage imageNamed:@"ptz_audio_off"];
            //[btnTalkControl setBackgroundImage:[UIImage imageNamed:@"micro_on"] forState:UIControlStateNormal style:UIBarButtonItemStyleDone barMetrics:UIBarMetricsDefault];
        }
        [self StartTalk];
        [_talkBtn setImage:_talkImgOn forState:UIControlStateNormal];
        //btnTalkControl.style = UIBarButtonItemStyleDone;
        //btnTalkControl.image = [UIImage imageNamed:@"micro_on"];
    }
    _m_bTalkStarted = !_m_bTalkStarted;
    
    /*if (m_bTalkStarted) {
     btnAudioControl.enabled = NO;
     }else {
     btnAudioControl.enabled = YES;
     }*/
}

#pragma mark -
#pragma mark SnapshotNotify

- (void) SnapshotNotify:(NSString *)strDID data:(char *)data length:(int)length{
    NSLog(@"SnapshotNotify");
}

@end
