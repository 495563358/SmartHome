//
//  MyScorllView.m
//  LongMaoSport
//
//  Created by SunZlin on 16/4/3.
//  Copyright © 2016年 SunZlin. All rights reserved.
//
//使用
//_images = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"demo.jpg"],[UIImage imageNamed:@"demo.jpg"],[UIImage imageNamed:@"demo.jpg"],nil];

//调用 setupPage方法
//[self setupPage];
#define CGI_IEGET_CAM_PARAMS		0x6003
#import "MySxtScorllView.h"
#include "MyAudioSession.h"
#include "APICommon.h"
#include "PPPPChannelManagement.h"
#import "PPPPDefine.h"
#import "obj_common.h"

#import "HTCameraStatus.h"
#import "HTPlayCamerViewController.h"
#import "UIImageView+WebCache.h"

//#import "EZOpenSDK.h"
//#import "UIViewController+EZBackPop.h"
//#import "EZDeviceInfo.h"
//#import "EZPlayer.h"
//#import "DDKit.h"
//#import "Masonry.h"
//#import "HIKLoadView.h"

#import "UIView+Toast.h"

#import "SmartHome-Swift.h"
#import "MyGLViewController.h"




@interface MySxtScorllView()<UIScrollViewDelegate>{//,EZPlayerDelegate

    BOOL bPlaying;
    MyGLViewController *myGLViewController;

    NSCondition *m_YUVDataLock;
    Byte *m_pYUVData;
    Byte *m_pYUVData1;
    Byte *m_pYUVData2;
    Byte *m_pYUVData3;
    Byte *m_pYUVData4;

    NSMutableDictionary *_GLViewControllerDict;
    NSMutableDictionary *_datasDict;
    NSMutableDictionary *_conditonDict;

}
@property (strong, nonatomic)  UIScrollView *scrollView;
@property  CPPPPChannelManagement* m_PPPPChannelMgt;
@property (nonatomic, retain) NSCondition *m_PPPPChannelMgtCondition;
@property (retain, nonatomic) UIPageControl *pageControl;
@property (nonatomic,strong) NSMutableArray <UIImageView *> *players;
//@property (nonatomic, strong) NSMutableArray<EZPlayer *> *ezplayer;
@property (nonatomic, strong) NSMutableArray *ezplayer;
@property (nonatomic, retain) NSMutableArray *camstatus;
@end
@implementation MySxtScorllView
@synthesize testActivityIndicator;
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        [self configView:frame];

        _loadingViews = [NSMutableArray array];
    }

    return self;
}



-(void)configView:(CGRect)frame
{
    _players = [NSMutableArray array];
    _ezplayer = [NSMutableArray array];
    //设置scrollview
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height)];
     //初始化pageControl
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(80, frame.size.height - 40, frame.size.width-160,40)];
    //把scrollView与pageControl添加到当前视图中


    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    testActivityIndicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);//只能设置中心，不能设置大小
    [testActivityIndicator startAnimating];
    [self addSubview:testActivityIndicator];


    [self addSubview:_scrollView];
    [self addSubview:_pageControl];


}

-(void)config{
    //

    _m_PPPPChannelMgtCondition = [[NSCondition alloc] init];
    _m_PPPPChannelMgt = new CPPPPChannelManagement();
    _m_PPPPChannelMgt->pCameraViewController = self;

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self Initialize:nil];
    });

    dispatch_apply([self.dataArray count], queue, ^(size_t index){
        HTCameras *cam = [HTCameras new];
        cam = [self.dataArray objectAtIndex:index];
        if ([cam.deviceType isEqualToString:@"100"]) {
            [self ConnectCam:cam.ID user:cam.Name psw:cam.PassWord];
        }
        NSLog(@"配置完成config");
    });
}

#pragma mark 设计视图使用的方法
//改变滚动视图的方法实现
- (void)setupPage
{
    if (_GLViewControllerDict) {
        NSLog(@"已经setupPage");
        return;
    }
    //设置委托
    _scrollView.tag=111;
    _scrollView.delegate = self;
    //是否自动裁切超出部分
    _scrollView.clipsToBounds = YES;
    //是否自动裁切超出部分;
    self.scrollView.clipsToBounds = YES;
    //设置是否可以缩放
    self.scrollView.scrollEnabled = YES;
    //设置是否可以进行画面切换
    self.scrollView.pagingEnabled = YES;
    //设置在拖拽的时候是否锁定其在水平或者垂直的方向
    self.scrollView.directionalLockEnabled = YES;
    //隐藏滚动条设置（水平、跟垂直方向）
    self.scrollView.alwaysBounceHorizontal = NO;
    self.scrollView.alwaysBounceVertical =  NO;
    self.scrollView.showsHorizontalScrollIndicator =  NO;
    self.scrollView.showsVerticalScrollIndicator =  NO;

    //设置页码控制器的响应方法
//    [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchDragInside];
    //设置总页数
    _pageControl.numberOfPages = _dataArray.count;
    //默认当前页为第一页
    _pageControl.currentPage = 0;
    //为页码控制器设置标签
    _pageControl.tag = 110;
    //设置滚动视图的位置
    [_scrollView setContentSize:CGSizeMake(_dataArray.count*self.scrollView.frame.size.width, 0)];


    //存值字典
    _GLViewControllerDict = [[NSMutableDictionary alloc]init];
    _conditonDict = [[NSMutableDictionary alloc]init];
    _datasDict = [[NSMutableDictionary alloc]init];

    m_pYUVData = NULL;
    m_pYUVData1 = NULL;
    m_pYUVData2 = NULL;
    m_pYUVData3 = NULL;
    m_pYUVData4 = NULL;

    //设置是否可以缩放
    //用来记录页数
    NSUInteger pages = 0;
    //用来记录scrollView的x坐标
    int originX = 0;
    for(HTCameras * equip in _dataArray)
    {

        NSCondition *condition = [[NSCondition alloc] init];

        MyGLViewController *temp = [[MyGLViewController alloc] init];
        temp.view.frame = CGRectMake(originX, 0, _scrollView.frame.size.width,  _scrollView.frame.size.height);

        //单指双击
        UITapGestureRecognizer *singleFingerTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
        singleFingerTwo.numberOfTouchesRequired = 1;
        singleFingerTwo.numberOfTapsRequired = 2;

        temp.view.userInteractionEnabled = YES;
        [temp.view addGestureRecognizer:singleFingerTwo];

        temp.view.tag = pages;

        UIButton *biggerBtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 38, (Sc_h  * 100 / 320 - 38), 36, 36)];
        [biggerBtn addTarget:self action:@selector(biggerClick:) forControlEvents:UIControlEventTouchUpInside];
        biggerBtn.tag = pages;
        [biggerBtn setImage:[UIImage imageNamed:@"fangda"] forState:UIControlStateNormal];


        //设置图片内容的显示模式()
//        temp.view.contentMode = UIViewContentModeScaleAspectFill;
        //把视图添加到当前的滚动视图中
//        temp.view.layer.masksToBounds=YES;
        [_scrollView addSubview:temp.view];

        UIImageView *imgV = [UIImageView new];

        [_players addObject:imgV];
        [_GLViewControllerDict setObject:temp forKey:equip.ID];
        [_conditonDict setObject:condition forKey:equip.ID];
        [_datasDict setObject:[NSNumber numberWithInteger:pages] forKey:equip.ID];


        [temp.view addSubview:biggerBtn];
        [temp.view bringSubviewToFront:biggerBtn];
        [self bringSubviewToFront:testActivityIndicator];




//        HIKLoadView *_loadingView = [[HIKLoadView alloc] initWithHIKLoadViewStyle:HIKLoadViewStyleSqureClockWise];
//        [playView addSubview:_loadingView];
//        [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.height.mas_equalTo(@14);
//            make.centerX.mas_equalTo(playView.mas_centerX);
//            make.centerY.mas_equalTo(playView.mas_centerY);
//        }];
//        [self.loadingViews addObject:_loadingView];
//        [_loadingView startSquareClcokwiseAnimation];

        if ([equip.deviceType isEqualToString:@"101"]) {
//            [EZOpenSDK setValidateCode:equip.PassWord forDeviceSerial:equip.ID];
//            NSLog(@"ez=%@,%@",equip.PassWord,equip.ID);
//            EZPlayer *player = [EZPlayer createPlayerWithCameraId:equip.ID];
//            player.delegate = self;
//            [player setPlayerView:temp.view];
//            [player startRealPlay];
//            [_ezplayer addObject:player];
            NSLog(@"创建了EZ");
        }

        //下一张视图的x坐标:offset为:self.scrollView.frame.size.width.
        originX += (self.scrollView.frame.size.width);
        //记录scrollView内imageView的个数
        pages++;

        NSLog(@"添加了视图");
    }
    _scrollView.hidden = YES;
}

-(void)biggerClick:(UIButton *)sender{
    //单指双击
    HTCameras *cam4 = [self.dataArray objectAtIndex:sender.tag];
    if ([cam4.deviceType isEqualToString:@"101"]) {

        // 点击进入摄像头详情界面
//        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"EZMain" bundle:nil];
//        EZLivePlayViewController * ezlive =(EZLivePlayViewController *) [storyBoard instantiateViewControllerWithIdentifier:@"EZLivePlayViewController"];
//        ezlive.cameraId = cam4.ID;
//        ezlive.hidesBottomBarWhenPushed = YES;
//        [[self parentController].navigationController pushViewController: ezlive animated:YES];
    }else{

        [self.delegate passTouch:@{@"cameraID":cam4.ID,@"username":@"admin",@"password": cam4.PassWord}];

    }
    NSLog(@"单指点击%d",sender.tag);
}

//处理事件的方法，代码：
- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
{
    //单指双击
    HTCameras *cam4 = [self.dataArray objectAtIndex:sender.view.tag];
    if ([cam4.deviceType isEqualToString:@"101"]) {

        // 点击进入摄像头详情界面
//        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"EZMain" bundle:nil];
//        EZLivePlayViewController * ezlive =(EZLivePlayViewController *) [storyBoard instantiateViewControllerWithIdentifier:@"EZLivePlayViewController"];
//         ezlive.cameraId = cam4.ID;
//         ezlive.hidesBottomBarWhenPushed = YES;
//       [[self parentController].navigationController pushViewController: ezlive animated:YES];
    }else{

        [self.delegate passTouch:@{@"cameraID":cam4.ID,@"username":@"admin",@"password": cam4.PassWord}];

    }
        NSLog(@"单指双击%i",sender.view.tag);
}

- (UIViewController *)parentController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[HomeVC class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}



//改变页码的方法实现
- (void)changePage:(id)sender
{
    NSLog(@"指示器的当前索引值为:%li",(long)_pageControl.currentPage);
    //获取当前视图的页码
    CGRect rect = _scrollView.frame;
    //设置视图的横坐标，一幅图为320*460，横坐标一次增加或减少320像素
    rect.origin.x = _pageControl.currentPage * self.scrollView.frame.size.width;
    //设置视图纵坐标为0
    rect.origin.y = 0;
    //scrollView可视区域
    [_scrollView scrollRectToVisible:rect animated:YES];
}
#pragma mark-----UIScrollViewDelegate---------
//实现协议UIScrollViewDelegate的方法，必须实现的
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //获取当前视图的宽度
    CGFloat pageWith = scrollView.frame.size.width;
    //根据scrolView的左右滑动,对pageCotrol的当前指示器进行切换(设置currentPage)
    int page = floor((scrollView.contentOffset.x - pageWith/2)/pageWith)+1;
    //切换改变页码，小圆点
    self.pageControl.currentPage = page;
}


//初始化
- (void)Initialize:(id)sender{
    st_PPPP_NetInfo NetInfo;
    PPPP_NetworkDetect(&NetInfo, 0);
    PPPP_Initialize((CHAR*)"ADCBBFAOPPJAHGJGBBGLFLAGDBJJHNJGGMBFBKHIBBNKOKLDHOBHCBOEHOKJJJKJBPMFLGCPPJMJAPDOIPNL"
                    );
    
    st_PPPP_NetInfo1 netInfo;
    XQP2P_NetworkDetect(&netInfo, 0);
    XQP2P_Initialize((CHAR *)"HZLXSXIALKHYEIEJHUASLMHWEESUEKAUIHPHSWAOSTEMENSQPDLRLNPAPEPGEPERIBLQLKHXELEHHULOEGIAEEHYEIEK-$$", 0);
}

//立马账号链接
- (void)ConnectCam:(NSString *)cameraID user:(NSString *)user psw:(NSString *)psw{
    NSLog(@"%@,%@,%@",cameraID,user,psw);
    _m_PPPPChannelMgt->Start([cameraID UTF8String], [user UTF8String], [psw UTF8String]);
}


// PPPPStatusDelegate
- (void) PPPPStatus: (NSString*) strDID statusType:(NSInteger) statusType status:(NSInteger) status{
    NSLog(@"状态为:%li",(long)status);
    NSString* strPPPPStatus;
    switch (status){
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
            [self starVideo:nil];
            break;
        case PPPP_STATUS_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"连接成功", @STR_LOCALIZED_FILE_NAME, nil);
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

    dispatch_async(dispatch_get_main_queue(),^{

//        if(status > 2 || status < 0){
            [self makeToast:strPPPPStatus];
//        }
        HTCameras *cam4 = self.dataArray[[self getCameraIndex:strDID]];
//        [self.loadingViews[[self getCameraIndex:strDID]]stopSquareClockwiseAnimation];
        if (status == 2) {
            [self starVideo:cam4.ID];
        }

    });
}

-(int)getCameraIndex:(NSString *)strDID
{
    int i ;
    for (  i = 0; i < self.dataArray.count; i++) {
        HTCameras *cam = [HTCameras new];
        cam = [self.dataArray objectAtIndex:i];
        if ([strDID isEqualToString:cam.ID]) {
            break;
        }
    }
    return i;

}
//refreshImage
- (void) refreshImage:(NSArray* ) arr{

//    if ([arr objectAtIndex:0] != nil) {
//        dispatch_async(dispatch_get_main_queue(),^{
//          _players[[self getCameraIndex:arr[1]]].image = arr[0];
//
//          [self stopVideo:arr[1]];
//        });
//    }
}

- (void)starVideo:(NSString *)caid{
    if (_m_PPPPChannelMgt != NULL) {
        NSLog(@"%@",caid);
        if (caid == nil) {
            return;
        }

        _m_PPPPChannelMgt -> StartPPPPAudio([caid UTF8String]);
        if (_m_PPPPChannelMgt->StartPPPPLivestream([caid UTF8String], 10,0, self) == 0) {
            _m_PPPPChannelMgt->StopPPPPAudio([caid UTF8String]);
            _m_PPPPChannelMgt->StopPPPPLivestream([caid UTF8String]);
        }

        _m_PPPPChannelMgt -> StopPPPPAudio([caid UTF8String]);
        _m_PPPPChannelMgt->GetCGI([caid UTF8String], CGI_IEGET_CAM_PARAMS);
    }
}

- (void)stopVideo:(NSString *)caid{
    _m_PPPPChannelMgt->StopPPPPAudio([caid UTF8String]);
    _m_PPPPChannelMgt->StopPPPPLivestream([caid UTF8String]);
}
- (void)doBack {


    if (_players.count - _ezplayer.count > 0) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            _m_PPPPChannelMgt->StopAll();
        });
        //存值字典
        _GLViewControllerDict = Nil;
        _conditonDict = Nil;
        _datasDict = Nil;

        m_pYUVData = NULL;
        m_pYUVData1 = NULL;
        m_pYUVData2 = NULL;
        m_pYUVData3 = NULL;
        m_pYUVData4 = NULL;
    }
//    for(EZPlayer * player in _ezplayer){
//        [EZOpenSDK releasePlayer:player];
//
//    }

}


///#pragma mark - PlayerDelegate Methods

//- (void)player:(EZPlayer *)player didPlayFailed:(NSError *)error
//{
//    NSLog(@"player = %@, error = %@",player, error.userInfo[@"NSLocalizedDescription"]);
//    if ([error.userInfo[@"NSLocalizedDescription"] isEqualToString:@"https error code = 10002"]) {
//
//        [BaseHttpService sendRequestAccess:[NSString stringWithFormat:@"%@/smarthome.IMCPlatform/xingUser/gainEzTokens.action",BaseHttpUrl] parameters:@{} success:^(id json) {
//            NSString * ezToken = json[@"Eztoken"];
//
//            [GlobalKit shareKit].accessToken = [ezToken isEqualToString:@"NO_BUNDING"]?nil :ezToken;
//              NSLog(@"%@", [GlobalKit shareKit].accessToken);
//            [EZOpenSDK setAccessToken: [GlobalKit shareKit].accessToken];
//            [BaseHttpService setAccessToken:[GlobalKit shareKit].accessToken];
//            if (![ezToken isEqualToString:@"NO_BUNDING"]) {
//                [player startRealPlay];
//            }
//
//        }];
//    }
//    if ([error.userInfo[@"NSLocalizedDescription"] isEqualToString:@"cas error code = 128"]) {
//        [[[UIAlertView alloc]initWithTitle:@"请先去萤石客户端解除终端绑定!" message:@"我的->设置->账号安全->终端绑定" delegate:nil cancelButtonTitle:NSLocalizedString(@"我知道了", nil) otherButtonTitles:nil, nil]show];
//    }
//}
//
//- (void)player:(EZPlayer *)player didReceviedMessage:(NSInteger)messageCode
//{
//    if(messageCode == PLAYER_REALPLAY_START)
//    {
//       //[player stopVoiceTalk];
//
//        [player closeSound];
//    }
//    else if (messageCode == PLAYER_NEED_VALIDATE_CODE)
//    {
//        //终端安全验证
//        [EZOpenSDK getSMSCode:EZSMSTypeSecure completion:^(NSError *error) {
//            if(!error)
//            {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"安全验证" message:@"请输入安全手机号码收到的安全验证短信内容" delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:@"确定", nil];
//                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
//                [alertView show];
//            }
//        }];
//    }
//}
//#pragma mark - UIAlertViewDelegate Methods
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1)
//    {
//        NSString *smsCode = [alertView textFieldAtIndex:0].text;
//        //验证输入的安全短信验证码
//        [EZOpenSDK secureSmsValidate:smsCode completion:^(NSError *error) {
//            if (!error)
//            {
//                for(EZPlayer * player in _ezplayer){
//
//                [player startRealPlay];
//                [player stopVoiceTalk];
//                [player closeSound];
//                }
//            }
//        }];
//    }
//}



#pragma mark -
#pragma mark ParamNotify

- (void) ParamNotify:(int)paramType params:(void *)params
{
    NSLog(@"PlayViewController ParamNotify");

}

#pragma mark -
#pragma mark ImageNotify

- (void) YUVNotify:(Byte *)yuv length:(int)length width:(int)width height:(int)height timestamp:(unsigned int)timestamp
{
//    NSLog(@"MySxtScorllView YUVNotify");
}

- (void) ImageNotify:(UIImage *)image timestamp:(NSInteger)timestamp
{
    NSLog(@"PlayViewController ImageNotify");
}


- (void) H264Data: (Byte*) h264Frame length: (int) length type: (int) type timestamp: (NSInteger) timestamp{
//    NSLog(@"MySxtScorllView H264Data");
}

- (void) ImageNotify: (UIImage *)image timestamp: (NSInteger)timestamp szdid:(NSString*)szdid{
    NSLog(@"MySxtScorllView ImageNotify strDID = %@",szdid);
}

- (void) YUVNotify: (Byte*) yuv length:(int)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp szdid:(NSString*)szdid{

    if(bPlaying == NO){
        bPlaying = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            _scrollView.hidden = NO;
            [testActivityIndicator stopAnimating];
            NSLog(@"取消隐藏 MySxtScorllView YUVNotify  strDID = %@",szdid);
        });
    }
    if ([_GLViewControllerDict objectForKey:szdid]) {
        
//        NSLog(@"MySxtScorllView YUVNotify  strDID = %@",szdid);
        
        [(MyGLViewController *)[_GLViewControllerDict objectForKey:szdid] WriteYUVFrame:yuv Len:length width:width height:height];
        m_YUVDataLock = (NSCondition *)[_conditonDict objectForKey:szdid];
        NSInteger indexNum = [(NSNumber *)[_datasDict objectForKey:szdid] integerValue];

        int yuvlength = width * height * 3 / 2;


        [m_YUVDataLock lock];

        switch (indexNum) {
            case 0:
                SAFE_DELETE(m_pYUVData1);
                m_pYUVData1 = new Byte[yuvlength];
                memcpy(m_pYUVData1, yuv, yuvlength);
                break;
            case 1:
                SAFE_DELETE(m_pYUVData2);
                m_pYUVData2 = new Byte[yuvlength];
                memcpy(m_pYUVData2, yuv, yuvlength);
                break;
            case 2:
                SAFE_DELETE(m_pYUVData3);
                m_pYUVData3 = new Byte[yuvlength];
                memcpy(m_pYUVData3, yuv, yuvlength);
                break;
            case 3:
                SAFE_DELETE(m_pYUVData4);
                m_pYUVData4 = new Byte[yuvlength];
                memcpy(m_pYUVData4, yuv, yuvlength);
                break;

            default:
                SAFE_DELETE(m_pYUVData);
                m_pYUVData = new Byte[yuvlength];
                memcpy(m_pYUVData, yuv, yuvlength);
                break;
        }
        [m_YUVDataLock unlock];

    }
    
}




- (void) H264Data: (Byte*) h264Frame length: (int) length type: (int) type timestamp: (NSInteger) timestamp szdid:(NSString*)szdid{
//    NSLog(@"MySxtScorllView H264Data  strDID = %@",szdid);
}

#pragma mark -
#pragma mark SnapshotNotify

- (void) SnapshotNotify:(NSString *)strDID data:(char *)data length:(int)length{
    NSLog(@"MySxtScorllView 截图 strDID = %@",strDID);
}


@end
