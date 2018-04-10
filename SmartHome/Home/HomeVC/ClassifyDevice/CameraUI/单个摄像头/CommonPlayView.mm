//
//  CommonPlayView.m
//  ZNJD2
//
//  Created by sunzl on 16/4/22.
//
//

#import "CommonPlayView.h"
#include "MyAudioSession.h"
#include "APICommon.h"
#import "PPPPDefine.h"
#import "obj_common.h"
#import "UIImage+UIImageExtras.h"
#import "HTPlayCamerViewController.h"
@interface CommonPlayView()
@property (assign) BOOL isStarting;
@property (strong, nonatomic)  UIImageView *playView;
@property (strong, nonatomic)  UIButton *btn;
@property (nonatomic, retain) NSCondition* m_PPPPChannelMgtCondition;

@end
@implementation CommonPlayView

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        NSLog(@"-----");
        self.backgroundColor = [UIColor blueColor];
       _playView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_btn addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn];
        [self addSubview:_playView];
        _isStarting = NO;
        
            
    }
   return self;
}
-(void)tap:(id)sender
{
//    [self.delegate passTouch:@{@"cameraID":self.cameraID,@"username":self.username,@"password":self.password}];
    
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





    

//begin
-(void)begin{
   
    if (_m_PPPPChannelMgt == nil) {
        _m_PPPPChannelMgtCondition = [[NSCondition alloc] init];
        _m_PPPPChannelMgt = new CPPPPChannelManagement();
        _m_PPPPChannelMgt->pCameraViewController = self;
        [self Initialize:nil];
        [self ConnectCam:self.username psw:self.password];
    }
    else{
        [self starVideo];
    }
}
//over
-(void)end{
    if (_isStarting) {
        
 
    [self stopVideo];
    if (_m_PPPPChannelMgt == nil) {
        [self stopCamera];
    }
        
    }
    _isStarting = NO;

}

- (void)starVideo {
    if (_m_PPPPChannelMgt != NULL) {
        if (_m_PPPPChannelMgt->StartPPPPLivestream([_cameraID UTF8String], 10, 0,self) == 0) {
            _m_PPPPChannelMgt->StopPPPPAudio([_cameraID UTF8String]);
            _m_PPPPChannelMgt->StopPPPPLivestream([_cameraID UTF8String]);
            return;
        }
    }
}



- (void)stopVideo{
    _m_PPPPChannelMgt->StopPPPPAudio([_cameraID UTF8String]);
    _m_PPPPChannelMgt->StopPPPPLivestream([_cameraID UTF8String]);
    dispatch_async(dispatch_get_main_queue(),^{
        _playView.image = nil;
    });
}
- (void) startAudio
{
    _m_PPPPChannelMgt->StartPPPPAudio([_cameraID UTF8String]);
}

- (void) stopAudio
{
    _m_PPPPChannelMgt->StopPPPPAudio([_cameraID UTF8String]);
}

- (void) startTalk
{
    _m_PPPPChannelMgt->StartPPPPTalk([_cameraID UTF8String]);
}

- (void) stopTalk
{
    _m_PPPPChannelMgt->StopPPPPTalk([_cameraID UTF8String]);
}

- (void)left {
  
    
    _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_LEFT);
}

- (void)right{
   
    _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_RIGHT);
}

- (void)up{
   
    _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_UP);
}

- (void)down{
  
    _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_DOWN);
}


-(void)Initialize:(id)sender{
    st_PPPP_NetInfo NetInfo;
    PPPP_NetworkDetect(&NetInfo, 0);
    PPPP_Initialize((CHAR*)"ADCBBFAOPPJAHGJGBBGLFLAGDBJJHNJGGMBFBKHIBBNKOKLDHOBHCBOEHOKJJJKJBPMFLGCPPJMJAPDOIPNL"
                    );
    
    st_PPPP_NetInfo1 netInfo;
    XQP2P_NetworkDetect(&netInfo, 0);
    XQP2P_Initialize((CHAR *)"HZLXSXIALKHYEIEJHUASLMHWEESUEKAUIHPHSWAOSTEMENSQPDLRLNPAPEPGEPERIBLQLKHXELEHHULOEGIAEEHYEIEK-$$", 0);
}

- (void)ConnectCam:(NSString *)user psw:(NSString *)psw{
    _m_PPPPChannelMgt->Start([_cameraID UTF8String], [user UTF8String], [psw UTF8String]);
}






- (void)stopCamera{
    [_m_PPPPChannelMgtCondition lock];
    if (_m_PPPPChannelMgt == NULL) {
        [_m_PPPPChannelMgtCondition unlock];
        return;
    }
    _m_PPPPChannelMgt->StopAll();
    [_m_PPPPChannelMgtCondition unlock];
    dispatch_async(dispatch_get_main_queue(),^{
        self.playView.image = nil;
    });
    
}

// PPPPStatusDelegate
- (void) PPPPStatus: (NSString*) strDID statusType:(NSInteger) statusType status:(NSInteger) status{
    NSString* strPPPPStatus;
    switch (status) {
        case PPPP_STATUS_UNKNOWN:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECTING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnecting", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INITIALING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInitialing", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECT_FAILED:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectFailed", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DISCONNECT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INVALID_ID:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvalidID", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DEVICE_NOT_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECT_TIMEOUT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectTimeout", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INVALID_USER_PWD:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvaliduserpwd", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        default:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
    }
    dispatch_async(dispatch_get_main_queue(),^{
      //  self.statusLabel.text=strPPPPStatus;
        if (status==2) {
            [self performSelector:@selector(starVideo) withObject:nil afterDelay:0.1];
        }
     
    });
}

//ImageNotifyProtocol
- (void) ImageNotify: (UIImage *)image timestamp: (NSInteger)timestamp DID:(NSString *)did{
    [self performSelector:@selector(refreshImage:) withObject:image];
}

- (void) YUVNotify: (Byte*) yuv length:(int)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did{
    
    UIImage* image = [APICommon YUV420ToImage:yuv width:width height:height];
    [self performSelector:@selector(refreshImage:) withObject:image];
    
}

- (void) H264Data: (Byte*) h264Frame length: (int) length type: (int) type timestamp: (NSInteger) timestamp{
    
}
//refreshImage
- (void) refreshImage:(UIImage* ) image{
    if (image != nil) {
        dispatch_async(dispatch_get_main_queue(),^{
            _playView.image = image;
        });
    }
}

#pragma mark -
#pragma mark SnapshotNotify

- (void) SnapshotNotify:(NSString *)strDID data:(char *)data length:(int)length{
    
}

@end
