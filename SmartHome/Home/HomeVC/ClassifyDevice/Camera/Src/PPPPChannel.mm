
#import <UIKit/UIKit.h>

#include <pthread.h>
#include "string.h"
#include "defineutility.h"
#include "PPPPDefine.h"
#include "PPPPChannel.h"
#include "cmdhead.h"
#include "moto.h"

#include "P2P_API_Define.h"
#include "H264Decoder.h"
#include "obj_common.h"


//使用那家P2P标识
enum EM_USE_P2PVER
{
    USE_P2PVER_PPPP = 0,
    USE_P2PVER_XQP2P  =1,
};

CPPPPChannel::CPPPPChannel(CCircleBuf *pVideoBuf, CCircleBuf *pPlaybackVideoBuf, const char *DID, const char *user, const char *pwd)
{
    memset(szDID, 0, sizeof(szDID));
    strcpy(szDID, DID);
    
    NSString *uid = [NSString stringWithUTF8String:szDID];
    //NSLog(@"RICKY CPPPPChannel:%@",uid);
    if ([[uid uppercaseString] rangeOfString:@"VSTD"].location != NSNotFound)
        m_nP2pVer = USE_P2PVER_XQP2P;
    else
        m_nP2pVer = USE_P2PVER_PPPP;
    
    memset(szUser, 0, sizeof(szUser));
    strcpy(szUser, user);
    
    memset(szPwd, 0, sizeof(szPwd));
    strcpy(szPwd, pwd);
    
    //init
    m_bAlarmThreadRuning = 0;
    m_bCommandThreadRuning = 0;
    m_bDataThreadRuning = 0;
    m_bPlaybackThreadRuning = 0;
    m_bTalkThreadRuning = 0;
    m_bCommandRecvThreadRuning = 0;
    m_bAudioThreadRuning = 0;
    m_nCamType = 128;
    m_CommandRecvThreadID = NULL;
    m_CommandThreadID = NULL;
    m_DataThreadID = NULL;
    m_PlaybackThreadID = NULL;
    m_TalkThreadID = NULL;
    m_AlarmThreadID = NULL;
    m_AudioThreadID = NULL;
    m_pCommandBuffer = NULL;
    m_bFindIFrame = 0;
    m_pVideoBuf = pVideoBuf;
    m_pPlayBackVideoBuf = pPlaybackVideoBuf;
    m_hSessionHandle = -1;
    m_bOnline = 0;
    
    m_PPPPStatusDelegate = nil;
    m_CameraViewSnapshotDelegate = nil;
    m_PlayViewPPPPStatusDelegate = nil;
    //m_PlayViewAVDataDelegate = nil;
    m_PlayViewParamNotifyDelegate = nil;
    m_PlayViewImageNotifyDelegate = nil;
    m_WifiParamsDelegate = nil;
    m_UserPwdParamsDelegate = nil;
    m_DateTimeParamsDelegate = nil;
    m_AlarmParamsDelegate = nil;
    m_SDCardSearchDelegate = nil;
    m_FtpDelegate = nil;
    m_MailDelegate = nil;
    m_PlaybackViewImageNotifyDelegate = nil;
    
    m_PlayViewPPPPStatusDelegateLock = [[NSCondition alloc] init];
    m_PlayViewAVDataDelegateLock = [[NSCondition alloc] init];
    m_PlayViewParamNotifyDelegateLock = [[NSCondition alloc] init];
    m_PPPPCloseCondition = [[NSCondition alloc] init];
    m_StopCondition = [[NSCondition alloc] init];
    m_WifiParamsLock = [[NSCondition alloc] init];
    m_PlaybackViewAVDataDelegateLock = [[NSCondition alloc] init];
    
    m_UserPwdParamsLock = [[NSCondition alloc] init];
    m_DateTimeParamsLock = [[NSCondition alloc] init];
    m_AlarmParamsLock = [[NSCondition alloc] init];
    m_SDCardSearchLock = [[NSCondition alloc] init];
    m_FTPLock = [[NSCondition alloc] init];
    m_MailLock = [[NSCondition alloc] init];
    m_SDCardScheduleLock=[[NSCondition alloc]init];
    m_SDCardStatusLock = [[NSCondition alloc] init];
    m_CamStatusDelegateLock = [[NSCondition alloc] init];
    
    m_bPlayThreadRuning = 0;
    m_PlayThreadID = NULL;
    
    m_EnumVideoMode = ENUM_VIDEO_MODE_UNKNOWN;
    m_bReconnectImmediately = 0;
    m_bAudioStarted = 0;
    m_bTalkStarted = 0;
    
    m_pTalkAdpcm = NULL;
    m_pAudioBuf = NULL;
    m_pTalkAudioBuf = NULL;
    m_pAudioAdpcm = NULL;
    m_pPCMPlayer = NULL;
    m_pPCMRecorder = NULL;
    
    m_bPlayBackFindIFrame = 0;
    m_bPlayBackStreamOK = NULL;
    m_bPlaybackStarted = 0;
    m_EnumPlayBackVideoMode = ENUM_VIDEO_MODE_UNKNOWN;
    m_PlaybackVideoPlayerThreadID = NULL;
    
    m_deviceEnableAdpcm = 0;
}

CPPPPChannel::~CPPPPChannel()
{
    Stop();
    
    [m_PlayViewPPPPStatusDelegateLock release];
    m_PlayViewPPPPStatusDelegateLock = nil;
    
    [m_PlayViewAVDataDelegateLock release];
    m_PlayViewAVDataDelegateLock = nil;
    
    [m_PlayViewParamNotifyDelegateLock release];
    m_PlayViewAVDataDelegateLock = nil;
    
    [m_PPPPCloseCondition release];
    m_PPPPCloseCondition = nil;
    
    [m_StopCondition release];
    m_StopCondition = nil;
    
    [m_WifiParamsLock release];
    m_WifiParamsLock = nil;
    
    [m_UserPwdParamsLock release];
    m_UserPwdParamsLock = nil;
    
    [m_DateTimeParamsLock release];
    m_DateTimeParamsLock = nil;
    
    [m_AlarmParamsLock release];
    m_AlarmParamsLock = nil;
    
    [m_SDCardSearchLock release];
    m_SDCardSearchLock = nil;
    
    [m_SDCardStatusLock release],m_SDCardStatusLock = nil;
    
    [m_FTPLock release];
    m_FTPLock = nil;
    
    [m_MailLock release];
    m_MailLock = nil;
    
    [m_PlaybackViewAVDataDelegateLock release];
    m_PlaybackViewAVDataDelegateLock = nil;
    
    [m_CamStatusDelegateLock release],m_CamStatusDelegateLock = nil;
}

void CPPPPChannel::XQP2PClose()
{
    if(m_nP2pVer == USE_P2PVER_XQP2P) {
        
        if(m_hSessionHandle >= 0)
            XQP2P_ForceClose(m_hSessionHandle);
        else
            XQP2P_Break(szDID);
        
        m_hSessionHandle = -1;
    }
}

void CPPPPChannel::PPPPClose()
{
    [m_PPPPCloseCondition lock];
    if(m_nP2pVer == USE_P2PVER_XQP2P) {
        /*XQP2P_Connect_Break();
         if(m_hSessionHandle < 0)
         {
         return;
         }
         XQP2P_ForceClose(m_hSessionHandle);
         m_hSessionHandle = -1;*/
        if(m_hSessionHandle >= 0)
            XQP2P_ForceClose(m_hSessionHandle);
        else
            XQP2P_Break(szDID);
        
        m_hSessionHandle = -1;
        
    } else {
    PPPP_Connect_Break();
    if (m_hSessionHandle >= 0) {
        //PPPP_Close(m_hSessionHandle);
        PPPP_ForceClose(m_hSessionHandle);
        m_hSessionHandle = -1;
    }
    }
    [m_PPPPCloseCondition unlock];
}

void CPPPPChannel::MsgNotify(int MsgType,int Param)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    MainWindowNotify(MsgType, Param);
    PlayWindowNotify(MsgType, Param);
    [pool release];
}

int CPPPPChannel::Start()
{
    m_pCommandBuffer = new CCircleBuf();
    m_pCommandBuffer->Create(COMMAND_BUFFER_SIZE);
    
    m_pAudioBuf = new CCircleBuf();
    m_pTalkAudioBuf = new CCircleBuf();
    m_pAudioAdpcm = new CAdpcm();
    m_pTalkAdpcm = new CAdpcm();
    
    return StartCommandChannel();
}

void CPPPPChannel::PlaybackAudioBuffer_Callback(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef buffer)
{
    //NSLog(@"PlaybackAudioBuffer_Callback");
    CPPPPChannel *pChannel = (CPPPPChannel*)inUserData;
    pChannel->ProcessAudioBuf(inAQ, buffer);
}

void CPPPPChannel::ProcessRecordAudioBuf(AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp *inStartTime, UInt32 inNumPackets, const AudioStreamPacketDescription *inPacketDesc)
{
    if(0 == m_pTalkAudioBuf->Write(inBuffer->mAudioData, inBuffer->mAudioDataByteSize))
    {
        m_pTalkAudioBuf->Reset();
        m_pTalkAudioBuf->Write(inBuffer->mAudioData, inBuffer->mAudioDataByteSize);
    }
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
}

void CPPPPChannel::RecordAudioBuffer_Callback(void *aqData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp *inStartTime, UInt32 inNumPackets, const AudioStreamPacketDescription *inPacketDesc)
{
    //NSLog(@"RecordAudioBuffer_Callback...");
    CPPPPChannel *pChannel = (CPPPPChannel*)aqData;
    pChannel->ProcessRecordAudioBuf(inAQ, inBuffer, inStartTime, inNumPackets, inPacketDesc);
}

void CPPPPChannel::ProcessAudioBuf(AudioQueueRef inAQ, AudioQueueBufferRef buffer)
{
    int nAudioBufSize = AVCODEC_MAXAUDIO_FRAME_SIZE * 4;
    char PCMBuf[AVCODEC_MAXAUDIO_FRAME_SIZE*4 + 1] = {0};
    
    //读取包数据
    AudioQueueBufferRef outBufferRef = buffer;
    
    memset(PCMBuf, 0, sizeof(PCMBuf));
    if (0 == m_pAudioBuf->Read(PCMBuf, nAudioBufSize)) {
        memset(outBufferRef->mAudioData, 0, nAudioBufSize);
    }else {
        memcpy(outBufferRef->mAudioData, PCMBuf, nAudioBufSize);
    }
    
    outBufferRef->mAudioDataByteSize = nAudioBufSize;
    AudioQueueEnqueueBuffer(inAQ, outBufferRef, 0, nil);
}

void CPPPPChannel::Stop()
{
    [m_StopCondition lock];
    
    m_bCommandThreadRuning = 0;
    m_bCommandRecvThreadRuning = 0;
    m_bAlarmThreadRuning = 0;
    m_bDataThreadRuning = 0;
    m_bPlaybackThreadRuning = 0;
    m_bSensorAlarmThreadRuning = 0;
    
    if(m_nP2pVer == USE_P2PVER_PPPP)
        PPPPClose();
    
    //NSLog(@"Stop CommandThread... %s", szDID);
    if(m_CommandThreadID != NULL)
    {
        pthread_join(m_CommandThreadID, NULL);
        m_CommandThreadID = NULL;
    }
    if(m_nP2pVer == USE_P2PVER_XQP2P)
        XQP2PClose();
    //NSLog(@"Stop CommandRecvThread...%s", szDID);
    if(m_CommandRecvThreadID!= NULL)
    {
        pthread_join(m_CommandRecvThreadID, NULL);
        m_CommandRecvThreadID = NULL;
    }
    
    //NSLog(@"Stop DataThread... %s", szDID);
    if(m_DataThreadID!= NULL)
    {
        pthread_join(m_DataThreadID, NULL);
        m_DataThreadID = NULL;
    }
    
    //NSLog(@"Stop AlarmThread...%s", szDID);
    if(m_AlarmThreadID!= NULL)
    {
        pthread_join(m_AlarmThreadID, NULL);
        m_AlarmThreadID = NULL;
    }
    
    //NSLog(@"Stop PlaybackThread...%s", szDID);
    if(m_PlaybackThreadID!= NULL)
    {
        pthread_join(m_PlaybackThreadID, NULL);
        m_PlaybackThreadID = NULL;
    }
    
    if(m_AudioThreadID != NULL)
    {
        pthread_join(m_AudioThreadID, NULL);
        m_AudioThreadID = NULL;
    }
    
    StopTalk();
    StopAudio(1);
    
    SAFE_DELETE(m_pCommandBuffer);
    SAFE_DELETE(m_pAudioBuf);
    SAFE_DELETE(m_pTalkAudioBuf);
    SAFE_DELETE(m_pAudioAdpcm);
    SAFE_DELETE(m_pTalkAdpcm);
    
    StopVideoPlay();
    StopPlaybackVideoPlayer();
    
    [m_StopCondition unlock];
    
}

int CPPPPChannel::AddCommand(void * data, int len)
{
    if(m_bOnline == 0)
    {
        return 0;
    }
    
    if(m_pCommandBuffer == NULL)
        return 0;
    
    CMD_BUF_HEAD bufhead;
    memset(&bufhead, 0, sizeof(bufhead));
    
    int headlen = sizeof(bufhead);
    int Length = headlen + len;
    char *pbuf = new char[Length];
    
    bufhead.head = BUFFER_HEAD_CODE;
    bufhead.len = len;
    
    memcpy(pbuf, (char*)&bufhead, headlen);
    memcpy(pbuf + headlen, data, len);
    
    if(0 == m_pCommandBuffer->Write(pbuf, Length))
    {
        SAFE_DELETE(pbuf);
        return 0;
    }
    
    SAFE_DELETE(pbuf);
    
    return 1;
}

int CPPPPChannel::StartSensorAlarmChannel(){
    m_bSensorAlarmThreadRuning = 1;
    pthread_create(&m_SensorThreadID, NULL, SensorAlarmThread, (void*)this);
    return 1;
}

void* CPPPPChannel::SensorAlarmThread(void *param){
    CPPPPChannel* pPPPChannel = (CPPPPChannel*)param;
    pPPPChannel->SensorAlarmProcess();
    return NULL;
}

void CPPPPChannel::SensorAlarmProcess(){
    while (m_bSensorAlarmThreadRuning) {
        //read head/*CMD_HEAD  与  SENSOR_HEAD结构相同所以使用同一个HEAD*/
        CMD_CHANNEL_HEAD sensoralarmHead;
        memset(&sensoralarmHead, 0, sizeof(sensoralarmHead));
        INT32 res = PPPP_IndeedRead(P2P_SENSORALARM, (CHAR*)&sensoralarmHead, sizeof(sensoralarmHead), m_bSensorAlarmThreadRuning);
        if (res < 0) {
            NSLog(@"SensorAlarmProcess PPPP_IndeedRead...1111 return: %d", res);
            return ;
        }
        //check head
        if (sensoralarmHead.startcode != CMD_START_CODE) {
            NSLog(@"cmdhead.startcode != CMD_START_CODE");
            return;
        }
        
        if (sensoralarmHead.len < 0) {
            NSLog(@"SensorAlarmProcess cmdhead.len < 0  error!");
            return;
        }
        
        if (sensoralarmHead.len == 0) {
            NSLog(@"SensorAlarmProcess cmdhead.len == 0");
            continue;
        }
        char *pbuf = new char[sensoralarmHead.len];
        
        if (pbuf == NULL) {
            NSLog(@"SensorAlarmProcess pbuf == NULL");
            SAFE_DELETE(pbuf);
            return;
        }
        if (sensoralarmHead.len == 4) {
            int info;
            memset(&info, 0, sizeof(info));
            //read data
            res = PPPP_IndeedRead(P2P_SENSORALARM, (CHAR *)&info, sensoralarmHead.len, m_bSensorAlarmThreadRuning);
            if(res < 0)
            {
                SAFE_DELETE(pbuf);
                NSLog(@"SensorAlazrmProcess PPPP_IndeedRead...2222 return: %d", res);
                return;
            }
            NSLog(@"门铃报警状态info为20 cmd:24640（对应十六进制：0x6040）：motion info  %d， %d",info, sensoralarmHead.cmd);
            STRU_SENSOR_ALARM_INFO  alarminfo;
            memset(&alarminfo, 0, sizeof(alarminfo));
            if (info == 1) {
                alarminfo.cmd = ALARM_MOTION_INFO;
                NSLog(@"SensorAlarmProcessRecv  %x  Enable %d",sensoralarmHead.cmd, alarminfo.cmd);
                ProcessCommand(sensoralarmHead.cmd, (char*)&alarminfo, sensoralarmHead.len);
            }
            
        }else{
            STRU_SENSOR_ALARM_INFO  info;
            memset(&info, 0, sizeof(info));
            //read data
            res = PPPP_IndeedRead(P2P_SENSORALARM, (CHAR *)&info, sensoralarmHead.len, m_bSensorAlarmThreadRuning);
            if(res < 0)
            {
                SAFE_DELETE(pbuf);
                NSLog(@"SensorAlazrmProcess PPPP_IndeedRead...2222 return: %d", res);
                return;
            }
            NSLog(@"SensorAlarmProcessRecv  %x  Enable %d,SensorID[0] %d,SensorID[1] %d,SensorID[2] %d, LinkPreset %d, SensorName-%s-len%d",sensoralarmHead.cmd, info.cmd, info.SensorID[0],info.SensorID[1],info.SensorID[2],info.LinkPreset,info.SensorName,sensoralarmHead.len);
            ProcessCommand(sensoralarmHead.cmd, (char*)&info, sensoralarmHead.len);
        }
        
        
        SAFE_DELETE(pbuf);
    }
}

int CPPPPChannel::StartCommandRecvThread()
{
    m_bCommandRecvThreadRuning = 1;
    pthread_create(&m_CommandRecvThreadID, NULL, CommandRecvThread, (void*)this);
    return 1;
}

void* CPPPPChannel::CommandRecvThread(void * param)
{
    CPPPPChannel *pPPPChannel = (CPPPPChannel*)param;
    pPPPChannel->CommandRecvProcess();
    return NULL;
}

void CPPPPChannel::CommandRecvProcess()
{
    while(m_bCommandRecvThreadRuning)
    {
        //read head
        CMD_CHANNEL_HEAD cmdhead;
        memset(&cmdhead, 0, sizeof(cmdhead));
        INT32 res = PPPP_IndeedRead(P2P_CMDCHANNEL, (CHAR*)&cmdhead, sizeof(cmdhead), m_bCommandThreadRuning);
        if(res < 0)
        {
            //NSLog(@"CommandRecvProcess PPPP_IndeedRead...1111 return: %d", res);
            return ;
        }
        
        //check head
        if(cmdhead.startcode != CMD_START_CODE)
        {
            //NSLog(@"cmdhead.startcode != CMD_START_CODE");
            return ;
        }
        
        if (cmdhead.len < 0) {
            //NSLog(@"CommandRecvProcess cmdhead.len < 0  error!");
            return;
        }
        
        if (cmdhead.len == 0) {
            continue;
        }
        
        char *pbuf = new char[cmdhead.len];
        if (pbuf == NULL) {
            //NSLog(@"CommandRecvProcess pbuf == NULL");
            return;
        }
        
        //read data
        res = PPPP_IndeedRead(P2P_CMDCHANNEL, (CHAR *)pbuf, cmdhead.len, m_bCommandThreadRuning);
        if(res < 0)
        {
            //NSLog(@"CommandRecvProcess PPPP_IndeedRead...2222 return: %d", res);
            return;
        }
        
        //Process command
        ProcessCommand(cmdhead.cmd, pbuf, cmdhead.len);
        
        //NSLog(@"Command recv: %s", pbuf);
        SAFE_DELETE(pbuf);
        
    }
}

void CPPPPChannel::ProcessSnapshot(char *pbuf, int len)
{
//    NSLog(@"ProcessSnapshot....");
    if (m_CameraViewSnapshotDelegate != nil) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        [m_CameraViewSnapshotDelegate SnapshotNotify:[NSString stringWithUTF8String:szDID] data:pbuf length:len];
        [pool release];
    }
}

//void CPPPPChannel::ProcessCommand(int cmd, char *pbuf, int len)
//{
//    //NSLog(@"Call ProcessCommand cmd: %d, len: %d", cmd, len);
//    switch(cmd)
//    {
//        case CGI_IEGET_CAM_PARAMS:
//            ProcessCameraParams(pbuf, len);
//            break;
//        case CGI_DECODER_CONTROL:
//            break;
//        case CGI_IESET_SNAPSHOT:
//            ProcessSnapshot(pbuf, len);
//            break;
//    }
//
//}

void CPPPPChannel::ProcessWifiScanResult(STRU_WIFI_SEARCH_RESULT_LIST wifiSearchResultList)
{
    [m_WifiParamsLock lock];
    if (m_WifiParamsDelegate  == nil) {
        [m_WifiParamsLock unlock];
        return ;
    }
    
    int nCount = wifiSearchResultList.nResultCount;
    int i;
    for (i = 0; i < nCount; i++)
    {
        int bEnd = 0;
        if (i == nCount - 1)
        {
            bEnd = 1;
        }
        
        [m_WifiParamsDelegate WifiScanResult:[NSString stringWithUTF8String:szDID] ssid:[NSString stringWithUTF8String:wifiSearchResultList.wifi[i].ssid] mac:[NSString stringWithUTF8String:wifiSearchResultList.wifi[i].mac] security:wifiSearchResultList.wifi[i].security db0:atoi(wifiSearchResultList.wifi[i].dbm0) db1:100 mode:wifiSearchResultList.wifi[i].mode channel:wifiSearchResultList.wifi[i].channel bEnd:bEnd];
    }
    
    [m_WifiParamsLock unlock];
}

void CPPPPChannel::ProcessWifiParam(STRU_WIFI_PARAMS wifiParams)
{
    [m_WifiParamsLock lock];
    if (m_WifiParamsDelegate != nil) {
        [m_WifiParamsDelegate WifiParams:[NSString stringWithUTF8String:szDID] enable:wifiParams.enable ssid:[NSString stringWithUTF8String:wifiParams.ssid] channel:wifiParams.channel mode:wifiParams.mode authtype:wifiParams.authtype encryp:wifiParams.encrypt keyformat:wifiParams.keyformat defkey:wifiParams.defkey strKey1:[NSString stringWithUTF8String:wifiParams.key1] strKey2:[NSString stringWithUTF8String:wifiParams.key2] strKey3:[NSString stringWithUTF8String:wifiParams.key3] strKey4:[NSString stringWithUTF8String:wifiParams.key4] key1_bits:wifiParams.key1_bits key2_bits:wifiParams.key2_bits key3_bits:wifiParams.key3_bits key4_bits:wifiParams.key4_bits wpa_psk:[NSString stringWithUTF8String:wifiParams.wpa_psk]];
    }
    [m_WifiParamsLock unlock];
}
void CPPPPChannel::ProcessUserInfo(STRU_USER_INFO userInfo)
{
    [m_UserPwdParamsLock lock];
    if (m_UserPwdParamsDelegate != nil) {
        //[m_UserPwdParamsDelegate UserPwdResult:[NSString stringWithUTF8String:userInfo.user1]  pwd1:[NSString stringWithUTF8String:userInfo.pwd1] user2:[NSString stringWithUTF8String:userInfo.user2] pwd2:[NSString stringWithUTF8String:userInfo.pwd2] user3:[NSString stringWithUTF8String:userInfo.user3] pwd3:[NSString stringWithUTF8String:userInfo.pwd3]];
        //[m_UserPwdParamsDelegate UserPwdResult:<#(NSString *)#> user1:<#(NSString *)#> pwd1:<#(NSString *)#> user2:<#(NSString *)#> pwd2:<#(NSString *)#> user3:<#(NSString *)#> pwd3:<#(NSString *)#>]
        [m_UserPwdParamsDelegate UserPwdResult:[NSString stringWithUTF8String:szDID] user1:[NSString stringWithUTF8String:userInfo.user1]  pwd1:[NSString stringWithUTF8String:userInfo.pwd1] user2:[NSString stringWithUTF8String:userInfo.user2] pwd2:[NSString stringWithUTF8String:userInfo.pwd2] user3:[NSString stringWithUTF8String:userInfo.user3] pwd3:[NSString stringWithUTF8String:userInfo.pwd3]];
    }
    [m_UserPwdParamsLock unlock];
}

void CPPPPChannel::ProcessFtpParams(STRU_FTP_PARAMS ftpParam)
{
    [m_FTPLock lock];
    if (m_FtpDelegate != nil) {
        [m_FtpDelegate FtpParam:ftpParam.svr_ftp user:ftpParam.user pwd:ftpParam.pwd dir:ftpParam.dir port:ftpParam.port uploadinterval:ftpParam.upload_interval mode:ftpParam.mode];
        
        
    }
    [m_FTPLock unlock];
}

void CPPPPChannel::ProcessMailParams(STRU_MAIL_PARAMS mailParam)
{
    [m_MailLock lock];
    if (m_MailDelegate != nil) {
        //        [m_MailDelegate MailParam:[NSString stringWithFormat:@"%s",mailParam.sender]
        //                          smtpsvr:[NSString stringWithFormat:@"%s",mailParam.svr]
        //                         smtpport:mailParam.port
        //                              ssl:mailParam.ssl
        //                             auth:(strlen(mailParam.user) > 0 ? 1 : 0)
        //                             user:[NSString stringWithFormat:@"%s",mailParam.user]
        //                              pwd:[NSString stringWithFormat:@"%s",mailParam.pwd]
        //                            recv1:[NSString stringWithFormat:@"%s",mailParam.receiver1]
        //                            recv2:[NSString stringWithFormat:@"%s",mailParam.receiver2]
        //                            recv3:[NSString stringWithFormat:@"%s",mailParam.receiver3]
        //                            recv4:[NSString stringWithFormat:@"%s",mailParam.receiver4]];
        
        [m_MailDelegate MailParam:[NSString stringWithUTF8String:mailParam.sender]
                          smtpsvr:[NSString stringWithUTF8String:mailParam.svr]
                         smtpport:mailParam.port
                              ssl:mailParam.ssl
                             auth:(strlen(mailParam.user) > 0 ? 1 : 0)
                             user:[NSString stringWithUTF8String:mailParam.user]
                              pwd:[NSString stringWithUTF8String:mailParam.pwd]
                            recv1:[NSString stringWithUTF8String:mailParam.receiver1]
                            recv2:[NSString stringWithUTF8String:mailParam.receiver2]
                            recv3:[NSString stringWithUTF8String:mailParam.receiver3]
                            recv4:[NSString stringWithUTF8String:mailParam.receiver4]];
    }
    [m_MailLock unlock];
}

void CPPPPChannel::ProcessDatetimeParams(STRU_DATETIME_PARAMS datetime){
    [m_DateTimeParamsLock lock];
    if (m_DateTimeParamsDelegate != nil) {
        [m_DateTimeParamsDelegate DateTimeProtocolResult:datetime.now  tz:(int)datetime.tz ntp_enable:(int)datetime.ntp_enable net_svr:[NSString stringWithUTF8String:datetime.ntp_svr]];
    }
    [m_DateTimeParamsLock unlock];
}

void CPPPPChannel::ProcessAlaramParams(STRU_ALARM_PARAMS alarm)
{
    [m_AlarmParamsLock lock];
    if (m_AlarmParamsDelegate != nil && [m_AlarmParamsDelegate isKindOfClass:[UIViewController class]]) {
        [m_AlarmParamsDelegate AlarmProtocolResult:alarm.motion_armed motion_sensitivity:(int)alarm.motion_sensitivity input_armed:(int)alarm.input_armed ioin_level:(int)alarm.ioin_level alarmpresetsit:(int)alarm.alarmpresetsit iolinkage:(int)alarm.iolinkage ioout_level:(int)alarm.ioout_level mail:(int)alarm.mail snapshot:(int)alarm.snapshot upload_interval:(int)alarm.upload_interval record:alarm.record];
    }
    [m_AlarmParamsLock unlock];
}
int CPPPPChannel::GetResult(char *pbuf, int len)
{
    int result;
    
    //result
    char *p = strstr(pbuf, "result=");
    if (p == NULL)
        return 0;
    
    sscanf(p, "result=%d;\r\n", &result);
    
    if(result != 0)
    {
        return 0;
    }
    
    return 1;
}

void CPPPPChannel::ProcessCommand(int cmd, char *pbuf, int len)
{
    NSLog(@"Call ProcessCommand cmd: %d, len: %d pbuf: %s", cmd, len, pbuf);
    
    switch(cmd)
    {
        case CGI_IEGET_CAM_PARAMS:
            ProcessCameraParams(pbuf, len);
            break;
        case CGI_DECODER_CONTROL:
            break;
        case CGI_IESET_SNAPSHOT:
            ProcessSnapshot(pbuf, len);
            break;
            //        case CGI_DECODER_CONTROL:
            ////            ProcessResult(pbuf, len, MSG_TYPE_DECODER_CONTROL);
            //            break;
            //        case CGI_IEGET_CAM_PARAMS:
            //        {
            //            //TRACE("CGI_IEGET_CAM_PARAMS pbuf: %s\n", pbuf) ;
            //            STRU_CAMERA_PARAMS cameraParams;
            //            memset(&cameraParams, 0, sizeof(cameraParams));
            //            if(m_CgiPacket.UnpacketCameraParam(pbuf, cameraParams))
            //            {
            //                ProcessCameraParam(cameraParams);
            //            }
            //        }
            //            break;
            //        case CGI_IESET_SNAPSHOT:
            //            ProcessSnapshot(pbuf, len);
            //            break;
        case CGI_CAM_CONTROL:
            //            ProcessResult(pbuf, len, MSG_TYPE_CAMERA_CONTROL);
            break;
        case CGI_IESET_NETWORK:
            //            ProcessResult(pbuf, len, MSG_TYPE_SET_NETWORK);
            break;
        case CGI_IESET_DATE:
            //           ProcessResult(pbuf, len, MSG_TYPE_SET_DATETIME);
            break;
            //        case CGI_CHECK_USER:
            //            //ProcessCheckUser(pbuf, len);
            //            break;
        case CGI_IESET_WIFISCAN:
        {
            //TRACE("CGI_IESET_WIFISCAN pbuf: %s\n", pbuf) ;
            STRU_WIFI_SEARCH_RESULT_LIST wifiSearchResultList;
            memset(&wifiSearchResultList, 0 ,sizeof(wifiSearchResultList));
            if (m_CgiPacket.UnpacketWifiSearchResult(pbuf, wifiSearchResultList))
            {
                ProcessWifiScanResult(wifiSearchResultList);
            }
        }
            break;
            
        case CGI_IEGET_PARAM:
        {
            //NSLog(@"CGI_IEGET_PARAM pbuf: %s\n", pbuf);
            STRU_NETWORK_PARAMS networkParams;
            memset(&networkParams, 0 ,sizeof(networkParams));
            if (m_CgiPacket.UnpacketNetworkParam(pbuf, networkParams))
            {
                //     ProcessNetworkParams(networkParams);
            }
            
            STRU_WIFI_PARAMS wifiParams;
            memset(&wifiParams, 0, sizeof(wifiParams));
            if (m_CgiPacket.UnpacketWifiParams(pbuf, wifiParams))
            {
                ProcessWifiParam(wifiParams);
            }
            
            STRU_USER_INFO userInfo;
            memset(&userInfo, 0, sizeof(userInfo));
            if (m_CgiPacket.UnpacketUserinfo(pbuf, userInfo))
            {
                ProcessUserInfo(userInfo);
            }
            
            STRU_FTP_PARAMS ftpParams;
            memset(&ftpParams, 0, sizeof(ftpParams));
            if (m_CgiPacket.UnpacketFtpParam(pbuf, ftpParams))
            {
                ProcessFtpParams(ftpParams);
            }
            
            STRU_MAIL_PARAMS mailParams;
            memset(&mailParams, 0, sizeof(mailParams));
            if (m_CgiPacket.UnpacketMailParam(pbuf, mailParams))
            {
                ProcessMailParams(mailParams);
            }
            
            STRU_DDNS_PARAMS ddnsParams;
            memset(&ddnsParams, 0, sizeof(ddnsParams));
            if (m_CgiPacket.UnpacketDdnsParam(pbuf, ddnsParams))
            {
                //     ProcessDdnsParams(ddnsParams);
            }
            
            STRU_DATETIME_PARAMS datetimeParams;
            memset(&datetimeParams, 0, sizeof(datetimeParams));
            if (m_CgiPacket.UnpacketDatetimeParam(pbuf, datetimeParams))
            {
                ProcessDatetimeParams(datetimeParams);
            }
            
            STRU_ALARM_PARAMS alarmParams;
            memset(&alarmParams, 0, sizeof(alarmParams));
            if (m_CgiPacket.UppacketAlarmParams(pbuf, alarmParams))
            {
                ProcessAlaramParams(alarmParams);
            }
        }
            break;
        case CGI_IEGET_STATUS:
        {
            STRU_CAMERA_STATUS cameraStatus;
            memset(&cameraStatus, 0, sizeof(cameraStatus));
            if (m_CgiPacket.UnpacketStatusParam(pbuf, cameraStatus))
            {
                ProcessCameraStatusParams(cameraStatus);
            }
        }
            break;
        case CGI_IEFORMATSD:
        {
            NSLog(@"CGI_IEFORMATSD  %s",pbuf);
        }
        case CGI_IEGET_MISC:
        {
            //TRACE("CGI_IEGET_MISC pbuf: %s\n", pbuf);
            STRU_PTZ_PARAMS ptzParams;
            memset(&ptzParams, 0, sizeof(ptzParams));
            if (m_CgiPacket.UnpacketPtzParam(pbuf, ptzParams))
            {
                //     ProcessPtzParams(ptzParams);
            }
        }
            break;
        case CGI_IEGET_ALARMLOG:
            break;
        case CGI_IESET_USER:
            //   ProcessResult(pbuf, len, MSG_TYPE_SET_USER);
            break;
        case CGI_IESET_MAIL:
            //    ProcessResult(pbuf, len, MSG_TYPE_SET_MAIL);
            break;
        case CGI_IESET_FTP:
            //   ProcessResult(pbuf, len, MSG_TYPE_SET_FTP);
            break;
        case CGI_IESET_WIFI:
            //    ProcessResult(pbuf, len, MSG_TYPE_SET_WIFI);
            
            break;
        case CGI_IESET_ALARM:
            //   ProcessResult(pbuf, len, MSG_TYPE_SET_ALARM);
            break;
        case CGI_IEGET_RECORD_FILE:
        {
            // NSLog(@"CGI_IEGET_RECORD_FILE: %s", pbuf);
            
            STRU_RECORD_FILE_LIST recordFileList;
            memset(&recordFileList, 0, sizeof(recordFileList));
            
            if (m_CgiPacket.UnpacketSdCardRecordFileList(pbuf, recordFileList))
            {
                //NSLog(@"CGI_IEGET_RECORD_FILE: ");
                ProcessRecordFile(recordFileList);
                
            }
        }
            break;
        case CGI_CHECK_USER:
            // NSLog(@"CGI_IEGET_RECORD_FILE: %s", pbuf);
            ProcessCheckUser(pbuf, len);
            break;
            
        case CGI_IEGET_RECORD:
        {
            STRU_SD_RECORD_PARAM recordParam;
            memset(&recordParam, 0, sizeof(recordParam));
            if (m_CgiPacket.UnpacketSdCardRecordParam(pbuf, recordParam))
            {
                ProcessRecordParam(recordParam);
            }
            
        }
            break;
        case CGI_MUSIC_OPERATION:
        {
            NSString *resultStr = [NSString stringWithCString:pbuf encoding:NSUTF8StringEncoding];
            if (resultStr == nil) {
                resultStr = [NSString stringWithFormat:@"%s",pbuf];
            }
            if (resultStr != nil)
            {
                NSArray *resultArray = [resultStr componentsSeparatedByString:@";"];
                NSString *cmdString = nil;
                NSString *typeString = nil;
                NSString *statusString = nil;
                NSString *commandString = nil;
                NSString *json = nil;
                NSString *sceneIndex = nil;
                NSString *resultString = nil;
                for (int i = 0; i <[resultArray count]; i ++)
                {
                    NSString *contentStr = resultArray[i];
                    NSArray *contentArray = [contentStr componentsSeparatedByString:@"="];
                    if ([contentArray count] > 1)
                    {
                        NSString *subStr = contentArray[0];
                        if ([subStr rangeOfString:@"cmd"].location != NSNotFound)
                        {
                            cmdString = contentArray[1];
                        }
                        else if ([subStr rangeOfString:@"type"].location != NSNotFound)
                        {
                            typeString = contentArray[1];
                        }
                        else if ([subStr rangeOfString:@"status"].location != NSNotFound)
                        {
                            statusString = contentArray[1];
                        }
                        else if ([subStr rangeOfString:@"command"].location != NSNotFound)
                        {
                            commandString = contentArray[1];
                        }
                        else if ([subStr rangeOfString:@"json"].location != NSNotFound)
                        {
                            json = contentArray[1];
                        }
                        else if ([subStr rangeOfString:@"var result"].location != NSNotFound) {
                            resultString = contentArray[1];
                        }
                        else if ([subStr rangeOfString:@"sceneIndex"].location != NSNotFound) {
                            sceneIndex = contentArray[1];
                        }
                    }
                }
                if ([cmdString integerValue] == 2017)
                {
                    
                    NSString *pbufStr = [NSString stringWithUTF8String:pbuf];
                    NSArray *array = [pbufStr componentsSeparatedByString:@"status"];
                    NSLog(@"执行？%lu", (unsigned long)array.count);
                    if (array.count <= 1)
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"oldPlanStatus" object:[NSString stringWithUTF8String:szDID]];
                        NSLog(@"执行？？");
                        break;
                    }
                    if ([commandString integerValue] == 11)
                    {
                        STRU_SD_RECORD_PLAN recordPlan;
                        memset(&recordPlan, 0, sizeof(recordPlan));
                        if (m_CgiPacket.UnpacketMotionRecordPlan(pbuf, recordPlan))
                        {
                            ProcessMotionRecordPlan(recordPlan);
                        }
                        else if (m_CgiPacket.UnpacketMotionPushPlan(pbuf, recordPlan))
                        {
                            ProcessMotionPushPlan(recordPlan);
                        }
                        else if (m_CgiPacket.UnpacketRecordPlan(pbuf, recordPlan))
                        {
                            ProcessRecordPlan(recordPlan);
                        }
                        
                    }
                    break;
                }
            }
            
        }
            break;
            
        default:
            break;
            
    }
    
}

void CPPPPChannel::ProcessCameraStatusParams(STRU_CAMERA_STATUS cameraStatus){
    
    [m_SDCardStatusLock lock];
    
    if (m_SDCardStatusDelegate != nil) {
        [m_SDCardStatusDelegate CameraSDCardStatus:cameraStatus.sdcardstatus SDtotal:cameraStatus.sdcardtotalsize SDFree:cameraStatus.sdcardremainsize];
    }
    
    [m_SDCardStatusLock unlock];
    
    [m_CamStatusDelegateLock lock];
    
    if (m_CamStatusDelegate != nil) {
        [m_CamStatusDelegate PPPPCameraStatusSysver:cameraStatus.sysver appver:cameraStatus.appver oemid:cameraStatus.oemid];
    }
    
    [m_CamStatusDelegateLock unlock];
}

void CPPPPChannel::ProcessRecordParam(STRU_SD_RECORD_PARAM recordParam)
{
    NSLog(@"ProcessRecordParam   total=%d",recordParam.sdtotal );
    [m_SDCardScheduleLock lock];
    
    if (m_SDcardScheduleDelegate != nil) {
        [m_SDcardScheduleDelegate sdcardScheduleParams:[NSString stringWithUTF8String:szDID] Tota:recordParam.sdtotal RemainCap:recordParam.sdfree SD_status:recordParam.record_sd_status Cover:recordParam.record_cover_enable TimeLength:recordParam.record_timer FixedTimeRecord:recordParam.record_time_enable RecordSize:recordParam.record_size record_schedule_sun_0:recordParam.record_schedule_sun_0 record_schedule_sun_1:recordParam.record_schedule_sun_1 record_schedule_sun_2:recordParam.record_schedule_sun_2 record_schedule_mon_0:recordParam.record_schedule_mon_0 record_schedule_mon_1:recordParam.record_schedule_mon_1 record_schedule_mon_2:recordParam.record_schedule_mon_2 record_schedule_tue_0:recordParam.record_schedule_tue_0 record_schedule_tue_1:recordParam.record_schedule_tue_1 record_schedule_tue_2:recordParam.record_schedule_tue_2 record_schedule_wed_0:recordParam.record_schedule_wed_0 record_schedule_wed_1:recordParam.record_schedule_wed_1 record_schedule_wed_2:recordParam.record_schedule_wed_2 record_schedule_thu_0:recordParam.record_schedule_thu_0 record_schedule_thu_1:recordParam.record_schedule_thu_1 record_schedule_thu_2:recordParam.record_schedule_thu_2 record_schedule_fri_0:recordParam.record_schedule_fri_0 record_schedule_fri_1:recordParam.record_schedule_fri_1 record_schedule_fri_2:recordParam.record_schedule_fri_2 record_schedule_sat_0:recordParam.record_schedule_sat_0 record_schedule_sat_1:recordParam.record_schedule_sat_1 record_schedule_sat_2:recordParam.record_schedule_sat_2];
    }
    [m_SDCardScheduleLock unlock];
}

void CPPPPChannel::ProcessRecordPlan(STRU_SD_RECORD_PLAN recordPlan)
{
    [m_SDCardScheduleLock lock];
    NSString *mask = [NSString stringWithUTF8String:recordPlan.mask];
    if (m_SDcardScheduleDelegate != nil && [m_SDcardScheduleDelegate isKindOfClass:[UIViewController class]] && [mask isEqualToString:@"212"])
    {
        [m_SDcardScheduleDelegate recordSchedule:[NSString stringWithUTF8String:szDID] Record_plan1:recordPlan.record_plan1 Record_plan2:recordPlan.record_plan2 Record_plan3:recordPlan.record_plan3 Record_plan4:recordPlan.record_plan4 Record_plan5:recordPlan.record_plan5 Record_plan6:recordPlan.record_plan6 Record_plan7:recordPlan.record_plan7 Record_plan8:recordPlan.record_plan8 Record_plan9:recordPlan.record_plan9 Record_plan10:recordPlan.record_plan10 Record_plan11:recordPlan.record_plan11 Record_plan12:recordPlan.record_plan12 Record_plan13:recordPlan.record_plan13 Record_plan14:recordPlan.record_plan14 Record_plan15:recordPlan.record_plan15 Record_plan16:recordPlan.record_plan16 Record_plan17:recordPlan.record_plan17 Record_plan18:recordPlan.record_plan18 Record_plan19:recordPlan.record_plan19 Record_plan20:recordPlan.record_plan20 Record_plan21:recordPlan.record_plan21 Record_plan_enable:recordPlan.record_plan_enable];
    }
    [m_SDCardScheduleLock unlock];
}

void CPPPPChannel::ProcessMotionRecordPlan(STRU_SD_RECORD_PLAN recordPlan)
{
    [m_SDCardScheduleLock lock];
    NSString *mask = [NSString stringWithUTF8String:recordPlan.mask];
    if (m_SDcardScheduleDelegate != nil && [m_SDcardScheduleDelegate isKindOfClass:[UIViewController class]] && [mask isEqualToString:@"212"])
    {
        [m_SDcardScheduleDelegate motionRecordSchedule:[NSString stringWithUTF8String:szDID] motion_record_plan1:recordPlan.record_plan1 motion_record_plan2:recordPlan.record_plan2 motion_record_plan3:recordPlan.record_plan3 motion_record_plan4:recordPlan.record_plan4 motion_record_plan5:recordPlan.record_plan5 motion_record_plan6:recordPlan.record_plan6 motion_record_plan7:recordPlan.record_plan7 motion_record_plan8:recordPlan.record_plan8 motion_record_plan9:recordPlan.record_plan9 motion_record_plan10:recordPlan.record_plan10 motion_record_plan11:recordPlan.record_plan11 motion_record_plan12:recordPlan.record_plan12 motion_record_plan13:recordPlan.record_plan13 motion_record_plan14:recordPlan.record_plan14 motion_record_plan15:recordPlan.record_plan15 motion_record_plan16:recordPlan.record_plan16 motion_record_plan17:recordPlan.record_plan17 motion_record_plan18:recordPlan.record_plan18 motion_record_plan19:recordPlan.record_plan19 motion_record_plan20:recordPlan.record_plan20 motion_record_plan21:recordPlan.record_plan21 Motion_record_plan_enable:recordPlan.record_plan_enable];
    }
    [m_SDCardScheduleLock unlock];
}

void CPPPPChannel::ProcessMotionPushPlan(STRU_SD_RECORD_PLAN recordPlan)
{
    [m_SDCardScheduleLock lock];
    NSString *mask = [NSString stringWithUTF8String:recordPlan.mask];
    if (m_SDcardScheduleDelegate != nil && [m_SDcardScheduleDelegate isKindOfClass:[UIViewController class]] && [mask isEqualToString:@"212"])
    {
        [m_SDcardScheduleDelegate motionPushSchedule:[NSString stringWithUTF8String:szDID] motion_push_plan1:recordPlan.record_plan1 motion_push_plan2:recordPlan.record_plan2 motion_push_plan3:recordPlan.record_plan3 motion_push_plan4:recordPlan.record_plan4 motion_push_plan5:recordPlan.record_plan5 motion_push_plan6:recordPlan.record_plan6 motion_push_plan7:recordPlan.record_plan7 motion_push_plan8:recordPlan.record_plan8 motion_push_plan9:recordPlan.record_plan9 motion_push_plan10:recordPlan.record_plan10 motion_push_plan11:recordPlan.record_plan11 motion_push_plan12:recordPlan.record_plan12 motion_push_plan13:recordPlan.record_plan13 motion_push_plan14:recordPlan.record_plan14 motion_push_plan15:recordPlan.record_plan15 motion_push_plan16:recordPlan.record_plan16 motion_push_plan17:recordPlan.record_plan17 motion_push_plan18:recordPlan.record_plan18 motion_push_plan19:recordPlan.record_plan19 motion_push_plan20:recordPlan.record_plan20 motion_push_plan21:recordPlan.record_plan21 motion_push_enable:recordPlan.record_plan_enable];
    }
    [m_SDCardScheduleLock unlock];
}

void CPPPPChannel::ProcessRecordFile(STRU_RECORD_FILE_LIST recordFileList)
{
    int nCount = recordFileList.nCount;
    int i;
    
    [m_SDCardSearchLock lock];
    int bEnd = 0;
    for(i = 0; i < nCount; i++)
    {
        if(i == nCount - 1)
        {
            bEnd = 1;
        }
        
        //[m_SDCardSearchDelegate SDCardRecordFileSearchResult:[NSString stringWithFormat:@"%s", recordFileList.recordFile[i].szFileName] fileSize:recordFileList.recordFile[i].nFileSize bEnd:bEnd];
        [m_SDCardSearchDelegate SDCardRecordFileSearchResult:[NSString stringWithUTF8String:szDID] filename:[NSString stringWithUTF8String:recordFileList.recordFile[i].szFileName] fileSize:recordFileList.recordFile[i].nFileSize recodeCount:recordFileList.nRecordCount pageindex:recordFileList.nPageIndex pageSize:recordFileList.nPageSize bEnd:bEnd];
    }
    
    [m_SDCardSearchLock unlock];
}

void CPPPPChannel::ProcessCheckUser(char *pbuf, int len){
    int result = 0;
    
    //result
    char *p = strstr(pbuf, "result=");
    if(p != NULL)
    {
        sscanf(p, "result=%d;\r\n", &result);
    }
    //[m_PlayViewPPPPStatusDelegateLock lock];
    if(result != 0)
    {
        
        [m_PPPPStatusDelegate PPPPStatus:[NSString stringWithUTF8String:szDID] statusType:MSG_NOTIFY_TYPE_PPPP_STATUS status:PPPP_STATUS_INVALID_USER_PWD];
    }else{
        [m_PPPPStatusDelegate PPPPStatus:[NSString stringWithUTF8String:szDID] statusType:MSG_NOTIFY_TYPE_PPPP_STATUS status:PPPP_STATUS_ON_LINE];
    }
    //[m_PlayViewPPPPStatusDelegateLock unlock];
    
}

void CPPPPChannel::ProcessCameraParams(char *pbuf, int len)
{
    //    NSLog(@"ProcessCameraParams....");
    //    NSLog(@"pbuf: %s", pbuf);
    //    NSLog(@"len: %d", len);
    //
    //    resolution=0;
    //    vbright=0;
    //    vcontrast=128;
    //    vhue=0;
    //    vsaturation=0;
    //    OSDEnable=0;
    //    mode=0;
    //    flip=0;
    //    enc_framerate=30;
    //    sub_enc_framerate=15;
    
    STRU_CAMERA_PARAM CameraParam;
    memset(&CameraParam, 0, sizeof(CameraParam));
    
    int result = 0;
    
    //result
    char *p = strstr(pbuf, "result=");
    if(p != NULL)
    {
        sscanf(p, "result=%d;\r\n", &result);
    }
    
    if(result != 0)
    {
        return ;
    }
    
    //resolution
    p = strstr(pbuf, "resolution=");
    if(p != NULL)
    {
        sscanf(p, "resolution=%d", &(CameraParam.resolution));
    }
    
    //brightness
    p = strstr(pbuf, "vbright=");
    if(p != NULL)
    {
        sscanf(p, "vbright=%d", &(CameraParam.bright));
    }
    
    //contrast
    p = strstr(pbuf, "vcontrast=");
    if(p != NULL)
    {
        sscanf(p, "vcontrast=%d", &(CameraParam.contrast));
    }
    
    //hue
    p = strstr(pbuf, "vhue=");
    if(p != NULL)
    {
        sscanf(p, "vhue=%d", &(CameraParam.hue));
    }
    
    //saturation
    p = strstr(pbuf, "vsaturation=");
    if(p != NULL)
    {
        sscanf(p, "vsaturation=%d", &(CameraParam.saturation));
    }
    
    //osdenable
    p = strstr(pbuf, "OSDEnable=");
    if(p != NULL)
    {
        sscanf(p, "OSDEnable=%d", &(CameraParam.osdenable));
    }
    
    //mode
    p = strstr(pbuf, "mode=");
    if(p != NULL)
    {
        sscanf(p, "mode=%d", &(CameraParam.mode));
    }
    
    //flip
    p = strstr(pbuf, "flip=");
    if(p != NULL)
    {
        sscanf(p, "flip=%d", &(CameraParam.flip));
    }
    
    PlayViewParamNotify(CGI_IEGET_CAM_PARAMS, (void*)&CameraParam);
    
}


int CPPPPChannel::PTZ_Control(int command)
{
    if (m_bOnline == 0) {
        return 0;
    }
    
    char buf[128];
    char cmdbuf[512];
    
    CMD_CHANNEL_HEAD cmdhead;
    memset(&cmdhead, 0, sizeof(cmdhead));
    cmdhead.startcode = CMD_START_CODE;
    
    int onestep = 0;
    if (command == CMD_PTZ_UP || command == CMD_PTZ_DOWN || command == CMD_PTZ_LEFT || command == CMD_PTZ_RIGHT) {
        onestep = 1;
    }
    
    memset(buf, 0, sizeof(buf));
    sprintf(buf, "GET /decoder_control.cgi?command=%d&onestep=%d&&user=%s&pwd=%s&", command, onestep, szUser, szPwd);
    cmdhead.len = strlen(buf);
    
    memcpy(cmdbuf , (char*)&cmdhead, sizeof(cmdhead));
    memcpy(cmdbuf + sizeof(cmdhead), buf, cmdhead.len);
    
    return CPPPPChannel::AddCommand(cmdbuf, sizeof(cmdhead) + cmdhead.len);
}

void CPPPPChannel::SetSDCardSearchDelegate(id delegate)
{
    [m_SDCardSearchLock lock];
    m_SDCardSearchDelegate = delegate;
    [m_SDCardSearchLock unlock];
    
}

int CPPPPChannel::CameraControl(int param, int value)
{
    if (m_bOnline == 0) {
        return 0;
    }
    
    char buf[128];
    char cmdbuf[512];
    
    CMD_CHANNEL_HEAD cmdhead;
    memset(&cmdhead, 0, sizeof(cmdhead));
    cmdhead.startcode = CMD_START_CODE;
    
    memset(buf, 0, sizeof(buf));
    sprintf(buf, "GET /camera_control.cgi?param=%d&value=%d&&user=%s&pwd=%s&", param, value, szUser, szPwd);
    cmdhead.len = strlen(buf);
    
    memcpy(cmdbuf , (char*)&cmdhead, sizeof(cmdhead));
    memcpy(cmdbuf + sizeof(cmdhead), buf, cmdhead.len);
    
    return CPPPPChannel::AddCommand(cmdbuf, sizeof(cmdhead) + cmdhead.len);
}

void CPPPPChannel::PlayViewParamNotify(int paramType, void *param)
{
    [m_PlayViewParamNotifyDelegateLock lock];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [m_PlayViewParamNotifyDelegate ParamNotify:paramType params:param];
    [pool release];
    [m_PlayViewParamNotifyDelegateLock unlock];
}

int CPPPPChannel::StartAlarmChannel()
{
    m_bAlarmThreadRuning= 1;
    pthread_create(&m_AlarmThreadID, NULL, AlarmThread, (void*)this);
    return 1;
}

void* CPPPPChannel::AlarmThread(void * param)
{
    CPPPPChannel *pPPPChannel = (CPPPPChannel*)param;
    pPPPChannel->AlarmProcess();
    return NULL;
}

void CPPPPChannel::AlarmProcess()
{
    while(m_bAlarmThreadRuning)
    {
        usleep(10000);
    }
}

int CPPPPChannel::StartCommandChannel()
{
    m_bCommandThreadRuning = 1;
    pthread_create(&m_CommandThreadID, NULL, CommandThread, (void*)this);
    
    return 1;
}

void* CPPPPChannel::CommandThread(void * param)
{
    CPPPPChannel *pPPPChannel = (CPPPPChannel*)param;
    //NSLog(@"RICKY CommandThread beg:%s",pPPPChannel->szDID);
    if (pPPPChannel->m_nP2pVer == USE_P2PVER_XQP2P) {
        NSLog(@"CommandThread use p2p USE_P2PVER_XQP2P");
        pPPPChannel->XQP2PCommandProcess();
    }
    else
    {
        NSLog(@"CommandThread use p2p USE_P2PVER_PPPP");
        pPPPChannel->PPPPCommandProcess();
    }
    //NSLog(@"RICKY CommandThread end:%s",pPPPChannel->szDID);
    return NULL;
}

void CPPPPChannel::StopOtherThread()
{
    [m_StopCondition lock];
    
    //NSLog(@"CPPPPChannel::StopOtherThread()...begin...");
    m_bCommandRecvThreadRuning = 0;
    m_bAlarmThreadRuning = 0;
    m_bDataThreadRuning = 0;
    m_bPlaybackThreadRuning = 0;
    m_bTalkThreadRuning = 0;
    
    PPPPClose();
    
    //NSLog(@"wait for CommondThread stop");
    if(m_CommandRecvThreadID!= NULL)
    {
        pthread_join(m_CommandRecvThreadID, NULL);
        m_CommandRecvThreadID = NULL;
    }
    
    //NSLog(@"wait for DataThread stop...");
    if(m_DataThreadID!= NULL)
    {
        pthread_join(m_DataThreadID, NULL);
        m_DataThreadID = NULL;
    }
    
    //NSLog(@"wait for AlarmThread stop...");
    if(m_AlarmThreadID!= NULL)
    {
        pthread_join(m_AlarmThreadID, NULL);
        m_AlarmThreadID = NULL;
    }
    
    //NSLog(@"wait for TalkThread stop");
    if(m_TalkThreadID!= NULL)
    {
        pthread_join(m_TalkThreadID, NULL);
        m_TalkThreadID = NULL;
    }
    
    //NSLog(@"wait for PlaybackThread stop");
    if(m_PlaybackThreadID!= NULL)
    {
        pthread_join(m_PlaybackThreadID, NULL);
        m_PlaybackThreadID = NULL;
    }
    
    if(m_AudioThreadID != NULL)
    {
        pthread_join(m_AudioThreadID, NULL);
        m_AudioThreadID = NULL;
    }
    
    StopVideoPlay();
    StopPlaybackVideoPlayer();
    
    m_pCommandBuffer->Reset();
    //NSLog(@"StopOtherThread end..");
    [m_StopCondition unlock];
    
}

int CPPPPChannel::StartAudioChannel()
{
    m_bAudioThreadRuning = 1;
    pthread_create(&m_AudioThreadID, NULL, AudioThread, (void*)this);
    return 1;
}

void* CPPPPChannel::AudioThread(void *param)
{
    CPPPPChannel *pChannel = (CPPPPChannel*)param;
    pChannel->AudioProcess();
    return NULL;
}

void CPPPPChannel::AudioProcess()
{
    while(m_bAudioThreadRuning)
    {
        //read head
        AV_HEAD avhead;
        memset(&avhead, 0, sizeof(avhead));
        int nRet = PPPP_IndeedRead(P2P_AUDIOCHANNEL, (CHAR*)&avhead, sizeof(avhead), m_bAudioThreadRuning);
        if(nRet < 0)
        {
            //Log("AudioProces  PPPP_IndeedRead failed  return: %d", nRet);
            return ;
        }
        
        //NSLog(@"AudioProces avhead.type:%d, avhead.streamid:%d, avhead.militime:%d, avhead.sectime:%d, avhead.len:%d, avhead.frameno:%d\n",
        //    avhead.type, avhead.streamid, avhead.militime, avhead.sectime, avhead.len, avhead.frameno);
        
        //check invalid data
        if(avhead.len > MAX_AUDIO_DATA_LENGTH)
        {
            NSLog(@"recv audio data is invalid!!\n");
            return;
        }
        
        if(avhead.len == 0)
        {
            continue;
        }
        
        NSLog(@"m_bAudioPreSample1: %d %d", m_bAudioPreSample, avhead.version);
        NSLog(@"m_bAudioPreSample:%d m_deviceEnableAdpcm:%d",m_bAudioPreSample,m_deviceEnableAdpcm);
        if((m_nCamType != 128 && m_nCamType != 126) || (0 == avhead.sample && 0 == avhead.index && m_nCamType == 128))
        {
            m_pAudioAdpcm->DecoderClr();
            m_bAudioPreSample = 1;
            NSLog(@"########### avhead == 0  && avhead.index == 0");
        }
        else
        {
            NSLog(@"########### avhead != 0  !! avhead.sample != 0");
            if(m_bAudioPreSample)
            {
                m_pAudioAdpcm->m_nDeAudioPreSample = avhead.sample;
                m_pAudioAdpcm->m_nDeAudioIndex = avhead.index;
                m_bAudioPreSample = 0;
                m_deviceEnableAdpcm =1;
                NSLog(@"###########in m_deviceEnableAdpcm%d",m_deviceEnableAdpcm);
                NSLog(@"###########in avhead.version%d",avhead.version);
            }
        }
        NSLog(@"m_bAudioPreSample:%d m_deviceEnableAdpcm:%d",m_bAudioPreSample,m_deviceEnableAdpcm);
        NSLog(@"########### m_bAudioPreSample%d",m_bAudioPreSample);
        NSLog(@"########### avhead.sample%d",avhead.sample);
        NSLog(@"########### avhead.index%d",avhead.index);
        NSLog(@"########### m_nCamType%d",m_nCamType);
        int Length = avhead.len;
        
        //----- read data ------------------------------------------
        char *pbuf = new char[Length + 1];
        nRet = PPPP_IndeedRead(P2P_AUDIOCHANNEL, (CHAR*)pbuf, Length, m_bAudioThreadRuning);
        if(nRet < 0)
        {
            NSLog(@"AudioProces PPPP_IndeedRead error: %d", nRet);
            SAFE_DELETE(pbuf);
            return ;
        }
        
        if(m_bAudioStarted == 0)
        {
            SAFE_DELETE(pbuf);
            continue;
        }
        
        //----- adpcm --> pcm ---------------------------------------
        int nPCMLen = 4 * Length;
        char *pPCMBuf = new char[nPCMLen];
        m_pAudioAdpcm->ADPCMDecode(pbuf, Length, pPCMBuf);
        m_pAudioBuf->Write(pPCMBuf, nPCMLen);
        SAFE_DELETE(pPCMBuf);
        SAFE_DELETE(pbuf);
    }
    
}

//获取cgi的公共函数
int CPPPPChannel::cgi_get_common(char * cgi)
{
    if (m_bOnline == 0) {
        return 0;
    }
    
    char buf[2048];
    char cmdbuf[2048];
    
    CMD_CHANNEL_HEAD cmdhead;
    memset(&cmdhead, 0, sizeof(cmdhead));
    cmdhead.startcode = CMD_START_CODE;
    
    memset(buf, 0, sizeof(buf));
    sprintf(buf, "GET /%sloginuse=%s&loginpas=%s&user=%s&pwd=%s&", cgi, szUser, szPwd, szUser, szPwd);
    cmdhead.len = strlen(buf);
    
    NSLog(@"cgi_get_common: %s", buf);
    
    memcpy(cmdbuf , (char*)&cmdhead, sizeof(cmdhead));
    memcpy(cmdbuf + sizeof(cmdhead), buf, cmdhead.len);
    
    return CPPPPChannel::AddCommand(cmdbuf, sizeof(cmdhead) + cmdhead.len);
}

int CPPPPChannel::StartAudio(char request)
{
    NSLog(@"StartAudio did %s...." , szDID);
    if(request)
    {
        cgi_get_common((char*)"audiostream.cgi?streamid=1&adpcm_ver=1&");
        //        cgi_get_common((char*)"audiostream.cgi?streamid=1&");
    }
    if (m_bAudioStarted == 1)
    {
        return 1;
    }
    m_pAudioBuf->Create(ABUF_SIZE);
    m_pPCMPlayer = new CPCMPlayer(PlaybackAudioBuffer_Callback, (void*)this);
    m_pPCMPlayer->StartPlay();
    m_bAudioStarted = 1;
    m_bAudioPreSample=1;
    NSLog(@"StartAudio did %s....................................end" , szDID);
    return 1;
}

int CPPPPChannel::StopAudio(char request)
{
    NSLog(@"stopAudio did %s....................................end" , szDID);
    if(request)
    {
        cgi_get_common((char*)"audiostream.cgi?streamid=16&");
    }
    if (m_bAudioStarted == 0) {
        return 1;
    }
    m_pAudioBuf->Release();
    
    SAFE_DELETE(m_pPCMPlayer);
    m_bAudioStarted = 0;
    return 1;
}

int CPPPPChannel::StartTalk()
{
    if (m_bTalkStarted == 1) {
        return 1;
    }
    StartTalkChannel();
    m_pTalkAudioBuf->Create(ABUF_SIZE);
    if (m_pPCMRecorder == NULL) {
        m_pPCMRecorder = new CPCMRecorder(CPPPPChannel::RecordAudioBuffer_Callback, this);
        m_pPCMRecorder->StartRecord();
    }
    m_bTalkStarted = 1;
    return 1;
}

int CPPPPChannel::StopTalk()
{
    if (m_bTalkStarted == 0) {
        return 1;
    }
    SAFE_DELETE(m_pPCMRecorder);
    m_bTalkThreadRuning = 0;
    if (m_TalkThreadID != NULL) {
        pthread_join(m_TalkThreadID, NULL);
        m_TalkThreadID = NULL;
    }
    m_pTalkAudioBuf->Release();
    m_bTalkStarted = 0;
    return 1;
}

int CPPPPChannel::TalkAudioData(const char* data, int len)
{
    if (0 == m_pTalkAudioBuf->Write((void*)data, len)) {
        m_pTalkAudioBuf->Reset();
        m_pTalkAudioBuf->Write((void*)data, len);
    }
    return 1;
}

void CPPPPChannel::SetStop()
{
    m_bCommandThreadRuning = 0;
    m_bCommandRecvThreadRuning = 0;
    m_bDataThreadRuning = 0;
    m_bTalkThreadRuning = 0;
    m_bPlaybackThreadRuning = 0;
    m_bAlarmThreadRuning = 0;
    m_bSensorAlarmThreadRuning = 0;
}

void CPPPPChannel::ReconnectImmediately()
{
    m_bReconnectImmediately = 1;
}



#pragma mark *****************PPPPCommandProcess*****************
void CPPPPChannel::PPPPCommandProcess()
{
    int ReConnect = 0;
    int nWaitTime = 0;
    
    int nReconnectCount = 0;
    
RE_CONNECT:
    
    m_bOnline = 0;
    
    //if the status is ReConnect , first ,stop the other thread
    if(ReConnect == 1)
    {
        StopOtherThread();
    }
    
    nWaitTime = 0;
    //====== ReConnect wait ==================================================================
    while(1)
    {
        if(m_bCommandThreadRuning == 0)
        {
            return;
        }
        
        if(ReConnect == 1)
        {
            nWaitTime++;
            //Log("nWaitTime: %d", nWaitTime);
            if(nWaitTime < 30 && m_bReconnectImmediately == 0)
            {
                //Log("wait time is not enough ,continue wait...");
                usleep(100000);
                continue;
            }
            
            m_bReconnectImmediately = 0;
            ReConnect = 0;
            nWaitTime = 0;
        }
        
        //NSLog(@"PPPP_Connect begin...%s", szDID);
        MsgNotify(MSG_NOTIFY_TYPE_PPPP_STATUS, PPPP_STATUS_CONNECTING);
        NSString *uid = [NSString stringWithUTF8String:szDID];
        if ([[uid uppercaseString] rangeOfString:@"VSTA"].location != NSNotFound) {
            m_hSessionHandle =PPPP_ConnectByServer(szDID, 1, 0, (CHAR*)"EFGFFBBOKAIEGHJAEDHJFEEOHMNGDCNJCDFKAKHLEBJHKEKMCAFCDLLLHAOCJPPMBHMNOMCJKGJEBGGHJHIOMFBDNPKNFEGCEGCBGCALMFOHBCGMFK");
        }else if ([[uid uppercaseString] rangeOfString:@"VSTE"].location != NSNotFound) {
            
            m_hSessionHandle =PPPP_ConnectByServer(szDID, 1, 0, (CHAR*)"EEGDFHBAKKIOGNJHEGHMFEEDGLNOHJMPHAFPBEDLADILKEKPDLBDDNPOHKKCIFKJBNNNKLCPPPNDBFDL");
        }
        else {
            m_hSessionHandle = PPPP_Connect(szDID, 1, 0);
        }
        if(m_hSessionHandle < 0)
        {
            //NSLog(@"PPPP_Connect failed.. %s return: %d", szDID, m_hSessionHandle);
            /**************************************************************************************
             //连接超时 --> 重连一定的次数后，如果还不成功，则停止p2p
             ERROR_PPPP_TIME_OUT
             
             //ID号无效 --> 停止p2p
             ERROR_PPPP_INVALID_ID
             ERROR_PPPP_INVALID_PREFIX
             
             //设备不在线 -->停止p2p
             ERROR_PPPP_DEVICE_NOT_ONLINE
             
             //连接失败 -->停止p2p
             ERROR_PPPP_NOT_INITIALIZED
             ERROR_PPPP_NO_RELAY_SERVER_AVAILABLE
             ERROR_PPPP_MAX_SESSION
             ERROR_PPPP_UDP_PORT_BIND_FAILED
             ERROR_PPPP_USER_CONNECT_BREAK
             *****************************************************************************************/
            switch(m_hSessionHandle)
            {
                case ERROR_PPPP_TIME_OUT:
                    break;
                case ERROR_PPPP_INVALID_ID:
                case ERROR_PPPP_ID_OUT_OF_DATE:
                case ERROR_PPPP_INVALID_PREFIX:
                    MsgNotify(MSG_NOTIFY_TYPE_PPPP_STATUS, PPPP_STATUS_INVALID_ID);
                    return;
                case ERROR_PPPP_DEVICE_NOT_ONLINE:
                    MsgNotify(MSG_NOTIFY_TYPE_PPPP_STATUS, PPPP_STATUS_DEVICE_NOT_ON_LINE);
                    return;
                case ERROR_PPPP_NOT_INITIALIZED:
                case ERROR_PPPP_NO_RELAY_SERVER_AVAILABLE:
                case ERROR_PPPP_MAX_SESSION:
                case ERROR_PPPP_UDP_PORT_BIND_FAILED:
                    MsgNotify(MSG_NOTIFY_TYPE_PPPP_STATUS, PPPP_STATUS_CONNECT_FAILED);
                    return;
                case ERROR_PPPP_USER_CONNECT_BREAK:
                    break;
                default:
                    MsgNotify(MSG_NOTIFY_TYPE_PPPP_STATUS, PPPP_STATUS_CONNECT_FAILED);
                    return;
            }
            
            usleep(100000) ;
            ReConnect = 1;
            
            nReconnectCount++;
            //Log("ReConnectCount: %d\n", ReConnectCount);
            if(nReconnectCount > 6)
            {
                nReconnectCount = 0;
                ReConnect = 0;
                MsgNotify(MSG_NOTIFY_TYPE_PPPP_STATUS, PPPP_STATUS_CONNECT_TIMEOUT);
                return;
            }
            continue;
        }
        //NSLog(@"PPPP_Connect success...m_hSessionHandle: %d %s", m_hSessionHandle, szDID);
        
        /* pppp session */
        st_PPPP_Session SInfo;
        int nRet = PPPP_Check(m_hSessionHandle, &SInfo);
        if(nRet < 0)
        {
            if (nRet != ERROR_PPPP_SESSION_CLOSED_CALLED) {
                PPPPClose();
            }
            ReConnect = 1;
            goto RE_CONNECT;
        }
        
        int mode;
        if(SInfo.bMode == 0)
        {
            mode = PPPP_MODE_P2P;
        }
        else
        {
            mode = PPPP_MODE_RELAY;
        }
        
        MsgNotify(MSG_NOTIFY_TYPE_PPPP_MODE, mode);
        MsgNotify(MSG_NOTIFY_TYPE_PPPP_STATUS, PPPP_STATUS_INITIALING);
        // MsgNotify(MSG_NOTIFY_TYPE_PPPP_STATUS, PPPP_STATUS_ON_LINE);
        m_bOnline = 1;
        ReConnect = 0;
        break;
    }
    
    //=======================================================================
    m_bResetCoder = YES;
    StartSensorAlarmChannel();
    StartCommandRecvThread();
    StartDataChannel();
    //    StartAlarmChannel();
    StartAudioChannel();
    StartPlaybackChannel();
    
    nReconnectCount = 0;
    //XMXM  check_user.cgi?
    cgi_get_common((char*)"check_user.cgi?");
    //snapshot.cgi
    cgi_get_common((char*)"snapshot.cgi?");
    
    while(m_bCommandThreadRuning)
    {
        UINT32 uiReadSize = 0;
        UINT32 uiWriteSize = 0;
        
        //------- check pppp read buffer ---------------------------------------------------
        INT32 res = PPPP_Check_Buffer(m_hSessionHandle, P2P_CMDCHANNEL, &uiWriteSize, &uiReadSize);
        if(res < 0)
        {
            //NSLog(@"CommandProcess PPPP_Check_Buffer return failed: %d", res);
            if (res != ERROR_PPPP_SESSION_CLOSED_CALLED) {
                PPPPClose();
            }
            
            ReConnect = 1;
            MsgNotify(MSG_NOTIFY_TYPE_PPPP_STATUS, PPPP_STATUS_DISCONNECT);
            m_bResetCoder = NO;
            goto RE_CONNECT;
        }
        
        //NSLog(@"CommandProcess PPPP_Check_Buffer CHANNEL_COMMAND: uiWriteSize: %d, uiReadSize: %d", uiWriteSize, uiReadSize);
        
        if(uiWriteSize >= PPPP_WRITE_BUFFER_MAX_SIZE)
        {
            usleep(10000);
            continue;
        }
        
        //---- read head -----------------------------------------
        CMD_BUF_HEAD bufhead;
        int nHeadLen = sizeof(CMD_BUF_HEAD);
        memset(&bufhead, 0, sizeof(bufhead));
        int nRet = m_pCommandBuffer->Read((char*)&bufhead, nHeadLen);
        if(nRet == 0)
        {
            //Log("the CommandBuffer is empty...");
            usleep(10000);
            continue;
        }
        
        //Log("CommandBuffer read success");
        
        //----- read data ----------------------------------------------------
        char *pbuf = new char[bufhead.len];
        nRet = m_pCommandBuffer->Read(pbuf, bufhead.len);
        if(nRet != bufhead.len)
        {
            NSLog(@"CommandProcess Read CmdData error!");
            SAFE_DELETE(pbuf);
            return ;
        }
        
        //---- send ----------------------------------------------------------
        res = PPPP_Write(m_hSessionHandle, P2P_CMDCHANNEL, pbuf, bufhead.len);
        if(res < 0)
        {
            //NSLog(@"CommandProcess PPPP_Write return failed: %d", res);
            if (res != ERROR_PPPP_SESSION_CLOSED_CALLED) {
                PPPPClose();
            }
            SAFE_DELETE(pbuf);
            ReConnect = 1;
            MsgNotify(MSG_NOTIFY_TYPE_PPPP_STATUS, PPPP_STATUS_DISCONNECT);
            goto RE_CONNECT;
        }
        
        SAFE_DELETE(pbuf);
    }
    
}
void CPPPPChannel::sleepCommandProcess(double s)
{
    int ms = s * 1000;
    for (int jj=0; jj<ms; ++jj) {
        usleep(100);
        if(m_bCommandThreadRuning == 0)
        {
            return;
        }
    }
}

#pragma mark *****************XQP2PCommandProcess*****************
void CPPPPChannel::XQP2PCommandProcess()
{
    int ReConnect = 0;
    int nWaitTime = 0;
    int nReconnectCount = 0;
    
RE_CONNECT:
    m_bOnline = 0;
    nWaitTime = 0;
    while(1)
    {
        if(m_bCommandThreadRuning == 0)
            return;
        
        NSLog(@"PPPP_Connect begin...%s", szDID);
        MsgNotify(MSG_NOTIFY_TYPE_PPPP_STATUS, PPPP_STATUS_CONNECTING);
        char *svrStr = (CHAR *)"HZLXSXIALKHYEIEJHUASLMHWEESUEKAUIHPHSWAOSTEMENSQPDLRLNPAPEPGEPERIBLQLKHXELEHHULOEGIAEEHYEIEK-$$";
        m_hSessionHandle = XQP2P_Connect(szDID, 1, 0, &svrStr);
        
        NSLog(@"#############PPPP_Connect handle is  %d id is :%s ！！！！", m_hSessionHandle, szDID);
        if(m_hSessionHandle < 0)
        {
            switch(m_hSessionHandle)
            {
                case ERROR_PPPP_DEVICE_NOT_ONLINE:
                case ERROR_PPPP_NO_RELAY_SERVER_AVAILABLE:
                {
                    sleepCommandProcess(2.0);
                    nReconnectCount += 5;
                    break;
                }
                case ERROR_PPPP_TIME_OUT:
                {
                    sleepCommandProcess(1.0);
                    nReconnectCount++;
                    break;
                }
                case ERROR_PPPP_INVALID_ID:
                case ERROR_PPPP_ID_OUT_OF_DATE:
                case ERROR_PPPP_INVALID_PREFIX:
                    MsgNotify(MSG_NOTIFY_TYPE_PPPP_STATUS, PPPP_STATUS_INVALID_ID);
                    m_bCommandThreadRuning = 0;
                    return;
                case ERROR_PPPP_NOT_INITIALIZED:
                case ERROR_PPPP_MAX_SESSION:
                case ERROR_PPPP_UDP_PORT_BIND_FAILED:
                    MsgNotify(MSG_NOTIFY_TYPE_PPPP_STATUS, PPPP_STATUS_CONNECT_FAILED);
                    m_bCommandThreadRuning = 0;
                    return;
                case ERROR_PPPP_USER_CONNECT_BREAK:
                    break;
                case ERROR_PPPP_INVALID_SESSION_HANDLE:
                {
                    nReconnectCount += 5;
                    sleepCommandProcess(0.6);
                    break;
                }
                default:
                    MsgNotify(MSG_NOTIFY_TYPE_PPPP_STATUS, PPPP_STATUS_CONNECT_FAILED);
                    m_bCommandThreadRuning = 0;
                    return;
            }
            
            ReConnect = 1;
            if(nReconnectCount > 20)
            {
                nReconnectCount = 0;
                ReConnect = 0;
                if (m_hSessionHandle == ERROR_PPPP_DEVICE_NOT_ONLINE) {
                    MsgNotify(MSG_NOTIFY_TYPE_PPPP_STATUS, PPPP_STATUS_DEVICE_NOT_ON_LINE);
                }
                else
                    MsgNotify(MSG_NOTIFY_TYPE_PPPP_STATUS, PPPP_STATUS_CONNECT_TIMEOUT);
                m_bCommandThreadRuning = 0;
                return;
            }
            continue;
        }//连接异常处理
        
        //P2P连接成功 开始工作了(^_^)
        int nRet = 0;
        st_PPPP_Session1 SInfo;
        nRet = XQP2P_Check(m_hSessionHandle, &SInfo);
        if(nRet < 0)
        {
            NSLog(@"#############fun %s PPPP_Check error handle is  %d id is :%s ret %d！！！！" ,__FUNCTION__ ,m_hSessionHandle, szDID , nRet);
            if (nRet != ERROR_PPPP_SESSION_CLOSED_CALLED) {
                PPPPClose();
            }
            ReConnect = 1;
            goto RE_CONNECT;
        }
        
        int mode;
        if(SInfo.bMode == 0)
            mode = PPPP_MODE_P2P;
        else
            mode = PPPP_MODE_RELAY;
        
        MsgNotify(MSG_NOTIFY_TYPE_PPPP_MODE, mode);
        MsgNotify(MSG_NOTIFY_TYPE_PPPP_STATUS, PPPP_STATUS_INITIALING);
        
        m_bOnline = 1;
        ReConnect = 0;
        break;
    }//退出P2P连接请求
    
    if (m_bCommandThreadRuning == 1) {
        m_bResetCoder = YES;
        
        StartCommandRecvThread();
        StartDataChannel();
        StartAudioChannel();
        StartPlaybackChannel();
        StartSensorAlarmChannel();
        nReconnectCount = 0;
        cgi_get_common((char*)"check_user.cgi?");
    }
    
    //读写P2P
    while(m_bCommandThreadRuning)
    {
        UINT32 uiReadSize = 0;
        UINT32 uiWriteSize = 0;
        INT32 res = 0;
        res = XQP2P_Check_Buffer(m_hSessionHandle, P2P_CMDCHANNEL, &uiWriteSize, &uiReadSize);
        if(res < 0)
        {
            NSLog(@"#############fun %s PPPP_Check_Buffer error handle is  %d id is :%s ret %d！！！！" ,__FUNCTION__ ,m_hSessionHandle, szDID , res);
            if (res != ERROR_PPPP_SESSION_CLOSED_CALLED)
                PPPPClose();
            
            ReConnect = 1;
            MsgNotify(MSG_NOTIFY_TYPE_PPPP_STATUS, PPPP_STATUS_DISCONNECT);
            m_bResetCoder = NO;
            goto RE_CONNECT;
        }
        
        if(uiWriteSize >= PPPP_WRITE_BUFFER_MAX_SIZE)
        {
            BOOL tem = NO;
            BOOL isWrite = NO;
            for (int jj=0; jj<1000; ++jj) {
                usleep(100);
                if(m_bCommandThreadRuning == 0)
                {
                    tem = YES;
                    break;
                }
                
                XQP2P_Check_Buffer(m_hSessionHandle, P2P_CMDCHANNEL, &uiWriteSize, &uiReadSize);
                if(uiWriteSize < PPPP_WRITE_BUFFER_MAX_SIZE)
                {
                    isWrite = YES;
                    break;
                }
            }
            
            if (tem) {
                //停止，线程要退了(*_*)
                break;
            }
            
            if (isWrite == NO) {
                continue;
            }
        }//网络好慢排队吧，(*_*)等好了再往里写
        
        //有没东东要发的(^_^)
        CMD_BUF_HEAD bufhead;
        int nHeadLen = sizeof(CMD_BUF_HEAD);
        memset(&bufhead, 0, sizeof(bufhead));
        int nRet = m_pCommandBuffer->Read((char*)&bufhead, nHeadLen);
        if(nRet == 0)
        {
            //没有东东可发，等一下过会再来(*_*)
            BOOL tem = NO;
            BOOL isRead = NO;
            for (int jj=0; jj<1000; ++jj) {
                usleep(100);
                if(m_bCommandThreadRuning == 0)
                {
                    tem = YES;
                    break;
                }
                
                memset(&bufhead, 0, sizeof(bufhead));
                int nRetA = m_pCommandBuffer->Read((char*)&bufhead, nHeadLen);
                if (nRetA != 0) {
                    isRead = YES;
                    break;
                }
            }
            if (tem) {
                //停止，线程要退了(*_*)
                break;
            }
            
            if (isRead == NO) {
                //没有东东可发。(*_*)
                continue;
            }
        }
        
        //有可发的东东(^_^)
        char *pbuf = new char[bufhead.len];
        nRet = m_pCommandBuffer->Read(pbuf, bufhead.len);
        if(nRet != bufhead.len)
        {
            NSLog(@"CommandProcess Read CmdData error!");
            SafeDel(pbuf);
            m_bCommandThreadRuning = 0;
            return ;
        }
        
        //发了(^_^)
        res = XQP2P_Write(m_hSessionHandle, P2P_CMDCHANNEL, pbuf, bufhead.len);
        if(res < 0)
        {
            NSLog(@"#############fun %s PPPP_Write error handle is  %d id is :%s ret %d！！！！" ,__FUNCTION__ ,m_hSessionHandle, szDID , res);
            if (res != ERROR_PPPP_SESSION_CLOSED_CALLED)
                PPPPClose();
            SafeDel(pbuf);
            ReConnect = 1;
            
            MsgNotify(MSG_NOTIFY_TYPE_PPPP_STATUS, PPPP_STATUS_DISCONNECT);
            goto RE_CONNECT;
        }
        SafeDel(pbuf);
    }
}

int CPPPPChannel::StartDataChannel()
{
    m_bDataThreadRuning= 1;
    pthread_create(&m_DataThreadID, NULL, DataThread, (void*)this);
    return 1;
}

void* CPPPPChannel::DataThread(void * param)
{
    CPPPPChannel *pPPPChannel = (CPPPPChannel*)param;
    pPPPChannel->DataProcess();
    return NULL;
}

void CPPPPChannel::DataProcess()
{
    while(m_bDataThreadRuning)
    {
        //read head
        AV_HEAD avhead;
        memset(&avhead, 0, sizeof(avhead));
        int nRet = PPPP_IndeedRead(P2P_VIDEOCHANNEL, (CHAR*)&avhead, sizeof(avhead), m_bDataThreadRuning);
        if(nRet < 0)
        {
            //NSLog(@"DataProcess  PPPP_IndeedRead failed  return: %d", nRet);
            PPPPClose();
            return ;
        }
        
        //NSLog(@"DataProcess avhead.type:%d, avhead.streamid:%d, avhead.militime:%d, avhead.sectime:%d, avhead.len:%d, avhead.frameno:%d\n", avhead.type, avhead.streamid, avhead.militime, avhead.sectime, avhead.len, avhead.frameno);
        
        //check invalid data
        if(avhead.len > MAX_FRAME_LENGTH)
        {
            NSLog(@"recv data is invalid!!\n");
            return;
        }
        
        if (avhead.len == 0) {
            continue;
        }
        m_nCamType = avhead.version;
        int Length = sizeof(VIDEO_BUF_HEAD) + avhead.len;
        
        //read data
        char *pbuf = new char[Length];
        VIDEO_BUF_HEAD *phead = (VIDEO_BUF_HEAD*)pbuf;
        phead->head = VIDEO_HEAD_VALUE;
        phead->timestamp = avhead.sectime;
        phead->len = avhead.len;
        phead->frametype = avhead.type ;
        
        nRet = PPPP_IndeedRead(P2P_VIDEOCHANNEL, (CHAR*)(pbuf + sizeof(VIDEO_BUF_HEAD)), avhead.len, m_bDataThreadRuning);
        if(nRet < 0)
        {
            //NSLog(@"DataProcess PPPP_IndeedRead error: %d", nRet);
            SAFE_DELETE(pbuf);
            return ;
        }
        
        int streamType;
        if (m_EnumVideoMode == ENUM_VIDEO_MODE_UNKNOWN && (avhead.type == 0 || avhead.type == 1)) {
            m_EnumVideoMode = ENUM_VIDEO_MODE_H264;
            streamType = STREAM_CODEC_TYPE_H264;
            PlayViewParamNotify(STREAM_CODEC_TYPE, (void*)&streamType);
            
        }
        
        if (m_EnumVideoMode == ENUM_VIDEO_MODE_UNKNOWN && avhead.type == 3) {
            m_EnumVideoMode = ENUM_VIDEO_MODE_MJPEG;
            streamType = STREAM_CODEC_TYPE_JPEG;
            PlayViewParamNotify(STREAM_CODEC_TYPE, (void*)&streamType);
        }
        
        if(m_EnumVideoMode == ENUM_VIDEO_MODE_UNKNOWN)
        {
            SAFE_DELETE(pbuf);
            continue;
        }
        
        //---------H.264------------------------------------------
        if(m_EnumVideoMode == ENUM_VIDEO_MODE_H264)
        {
            if(m_bFindIFrame)
            {
                if(avhead.type == ENUM_FRAME_TYPE_I)
                {
                    m_bFindIFrame = true;
                    m_pVideoBuf->Write(pbuf, Length);
                }
            }
            else
            {
                if(avhead.type == ENUM_FRAME_TYPE_P || avhead.type == ENUM_FRAME_TYPE_I)
                {
                    if(avhead.type == ENUM_FRAME_TYPE_I)
                    {
                        m_pVideoBuf->Reset();
                        m_pVideoBuf->Write(pbuf, Length) ;
                    }
                    else
                    {
                        if(0 == m_pVideoBuf->Write(pbuf, Length))
                        {
                            m_bFindIFrame = false;
                        }
                    }
                }
            }
        }
        else/*-------------------------MJPEG----------------------- */
        {
            if(avhead.type == ENUM_FRAME_TYPE_MJPEG)
            {
                m_pVideoBuf->Reset();
                m_pVideoBuf->Write(pbuf, Length);
            }
        }
        
        SAFE_DELETE(pbuf);
    }
}

int CPPPPChannel::StartPlaybackChannel()
{
    m_bPlaybackThreadRuning = 1;
    pthread_create(&m_PlaybackThreadID, NULL, PlaybackThread, (void*)this);
    return 1;
}

void* CPPPPChannel::PlaybackThread(void * param)
{
    NSLog(@"PlaybackThread beg");
    CPPPPChannel *pPPPChannel = (CPPPPChannel*)param;
    pPPPChannel->PlaybackProcess();
    NSLog(@"PlaybackThread end");
    return NULL;
}

void CPPPPChannel::PlaybackProcess()
{
    const int maxbuffersize = 600 * 1024 ;
    
    while(m_bPlaybackThreadRuning)
    {
        int nCurrSize = m_pPlayBackVideoBuf->GetStock();
        if(nCurrSize >= maxbuffersize)
        {
            usleep(10000);
            continue;
        }
        
        //read head
        AV_HEAD avhead;
        memset(&avhead, 0, sizeof(avhead));
        int nRet = PPPP_IndeedRead(P2P_PLAYBACK, (CHAR*)&avhead, sizeof(avhead), m_bPlaybackThreadRuning);
        if(nRet < 0)
        {
            //NSLog(@"DataProcess  PPPP_IndeedRead failed  return: %d", nRet);
            if (nRet != ERROR_PPPP_SESSION_CLOSED_CALLED) {
                PPPPClose();
            }
            m_bPlaybackThreadRuning = 0;
            return ;
        }
        
        //NSLog(@"DataProcess avhead.type:%d, avhead.streamid:%d, avhead.militime:%d, avhead.sectime:%d, avhead.len:%d, avhead.frameno:%d\n", avhead.type, avhead.streamid, avhead.militime, avhead.sectime, avhead.len, avhead.frameno);
        
        //check invalid data
        if(avhead.len > MAX_FRAME_LENGTH)
        {
            NSLog(@"recv data is invalid!!\n");
            m_bPlaybackThreadRuning = 0;
            return;
        }
        
        if (avhead.len == 0) {
            continue;
        }
        
        if(avhead.type == 6)
        {
            if((m_nCamType != 128 && m_nCamType != 126) || (0 == avhead.sample && 0 == avhead.index && m_nCamType == 128))
            {
                m_pAudioAdpcm->DecoderClr();
                m_bAudioPreSample = 1;
                //NSLog(@"########### avhead == 0  && avhead.index == 0");
            }
            else
            {
                //NSLog(@"########### avhead != 0  !! avhead.index != 0");
                if(m_bAudioPreSample)
                {
                    m_pAudioAdpcm->m_nDeAudioPreSample = avhead.sample;
                    m_pAudioAdpcm->m_nDeAudioIndex = avhead.index;
                    m_bAudioPreSample = 0;
                    m_deviceEnableAdpcm =1;
                    NSLog(@"m_bAudioPreSample3: %d %d", m_deviceEnableAdpcm, avhead.version);
                }
            }
            ProcessAudio(&avhead , P2P_PLAYBACK);
        }
        else
        {
            m_nCamType=avhead.version;
            ProcessPlaybackVideo(&avhead , P2P_PLAYBACK);
        }
        
    }
}
void CPPPPChannel::ProcessPlaybackVideo(AV_HEAD * pAVHead , unsigned char chn)
{
    int Length = sizeof(VIDEO_BUF_HEAD) + pAVHead->len;
    int nRet = 0;
    //read data
    char *pbuf = new char[Length];
    VIDEO_BUF_HEAD *phead = (VIDEO_BUF_HEAD*)pbuf;
    phead->head = VIDEO_HEAD_VALUE;
    phead->timestamp = pAVHead->sectime;
    phead->len = pAVHead->len;
    phead->frametype = pAVHead->type ;
    phead->militime = pAVHead->militime;
    nRet = PPPP_IndeedRead(chn, (CHAR*)(pbuf + sizeof(VIDEO_BUF_HEAD)), pAVHead->len,m_bPlaybackThreadRuning);
    if(nRet < 0)
    {
        NSLog(@"DataProcess PPPP_IndeedRead error: %d", nRet);
        SafeDel(pbuf);
        m_bPlaybackThreadRuning = 0;
        return ;
    }
    
    if (m_bPlaybackStarted == 0) {
        SafeDel(pbuf);
        usleep(10000);
        return;
    }
    
    if (m_EnumPlayBackVideoMode == ENUM_VIDEO_MODE_UNKNOWN && (pAVHead->type == 0 || pAVHead->type == 1)) {
        m_EnumPlayBackVideoMode = ENUM_VIDEO_MODE_H264;
        
    }
    
    if (m_EnumPlayBackVideoMode == ENUM_VIDEO_MODE_UNKNOWN && pAVHead->type == 3) {
        m_EnumPlayBackVideoMode = ENUM_VIDEO_MODE_MJPEG;
    }
    
    if(m_EnumPlayBackVideoMode == ENUM_VIDEO_MODE_UNKNOWN)
    {
        SafeDel(pbuf);
        return;
    }
    
    
    if(m_EnumPlayBackVideoMode == ENUM_VIDEO_MODE_H264)
    {
        if(!m_bPlayBackFindIFrame)
        {
            if(pAVHead->type == ENUM_FRAME_TYPE_I)
            {
                m_bPlayBackFindIFrame = true;
                m_pPlayBackVideoBuf->Reset();
                //NSLog(@"----------------------执行录像回放Write---------");
                m_pPlayBackVideoBuf->Write(pbuf, Length);
            }
        }
        else
        {
            int n = m_pPlayBackVideoBuf->Write(pbuf, Length);
            //NSLog(@"----------------------执行录像回放Write2 %d---------", n);
            if(0 == n)
            {
                 //NSLog(@"----------------------执行录像回放Write3---------");
                m_bPlayBackFindIFrame = false;
            }
        }
    }
    else
    {
        if(pAVHead->type == ENUM_FRAME_TYPE_MJPEG)
        {
            m_pPlayBackVideoBuf->Reset();
            m_pPlayBackVideoBuf->Write(pbuf, Length);
        }
    }
    //NSLog(@"\n---------------endWrite");
    SafeDel(pbuf);
}
void CPPPPChannel::ProcessAudio(AV_HEAD * pHead , unsigned char chn)
{
    
    int nRet = 0;
    int Length = pHead->len;
    char *pbuf = new char[Length + 1];
    memset(pbuf, 0, Length + 1);
    nRet = PPPP_IndeedRead(chn, (CHAR*)pbuf, Length,m_bAudioThreadRuning);
    if(nRet < 0)
    {
        NSLog(@"AudioProces PPPP_IndeedRead error: %d", nRet);
        SafeDel(pbuf);
        m_bAudioThreadRuning = 0;
        return ;
    }
    if(m_bAudioStarted == 0)
    {
        SafeDel(pbuf);
        return;
    }
    if (m_bPlaybackStarted == 0 && chn == P2P_PLAYBACK)
    {
        SafeDel(pbuf);
        usleep(10000);
        return;
    }
    int nPCMLen = 4 * Length;
    char *pPCMBuf = new char[nPCMLen];
    if(NULL == m_pAudioAdpcm)
    {
        SafeDel(pPCMBuf);
        SafeDel(pbuf);
        return;
    }
    m_pAudioAdpcm->ADPCMDecode(pbuf, Length, pPCMBuf);
    if( m_pAudioBuf)
    {
        m_pAudioBuf->Write(pPCMBuf, nPCMLen);
    }
    SafeDel(pPCMBuf);
    SafeDel(pbuf);
}

void CPPPPChannel::SafeDel(CHAR *buf){
    if (buf != NULL) {
        delete [] buf;
        buf = 0;
    }
}

//android main window msg notify
void CPPPPChannel::MainWindowNotify(int MsgType,int Param)
{
    if (m_PPPPStatusDelegate != nil) {
        [m_PPPPStatusDelegate PPPPStatus:[NSString stringWithUTF8String:szDID ] statusType:MsgType status:Param];
    }
}

//the play window msg notify
void CPPPPChannel::PlayWindowNotify(int MsgType, int Param)
{
    [m_PlayViewPPPPStatusDelegateLock lock];
    [m_PlayViewPPPPStatusDelegate PPPPStatus:[NSString stringWithUTF8String:szDID ] statusType:MsgType status:Param];
    [m_PlayViewPPPPStatusDelegateLock unlock];
}

int CPPPPChannel::StartTalkChannel()
{
    m_bTalkThreadRuning= 1;
    pthread_create(&m_TalkThreadID, NULL, TalkThread, (void*)this);
    return 1;
}

void* CPPPPChannel::TalkThread(void * param)
{
    CPPPPChannel *pPPPChannel = (CPPPPChannel*)param;
    pPPPChannel->TalkProcess();
    return NULL;
}

void CPPPPChannel::TalkProcess()
{
    char AudioBuf[MIN_PCM_AUDIO_SIZE + 1] = {0};
    char AdpcmBuf[256 + 1]= {0};
    
    while(m_bTalkThreadRuning)
    {
        UINT32 uiReadSize = 0;
        UINT32 uiWriteSize = 0;
        int nRet = 0;
        if(m_nP2pVer == USE_P2PVER_XQP2P) {
            nRet = XQP2P_Check_Buffer(m_hSessionHandle, P2P_TALKCHANNEL, &uiWriteSize, &uiReadSize);
        } else {
            nRet = PPPP_Check_Buffer(m_hSessionHandle, P2P_TALKCHANNEL, &uiWriteSize, &uiReadSize);
        }
        if(nRet < 0)
        {
            return;
        }
        
        //Log("PPPP_Check_Buffer.. uiWriteSize: %d, uiReadSize: %d", uiWriteSize, uiReadSize);
        if(uiWriteSize >= TALK_WRITE_BUFFER_MAX_SIZE)
        {
            usleep(10000);
            continue;
        }
        
        if(m_pTalkAudioBuf->GetStock() < MIN_PCM_AUDIO_SIZE)
        {
            usleep(10000);
            continue;
        }
        
        memset(AudioBuf, 0, sizeof(AudioBuf));
        int nRead = m_pTalkAudioBuf->Read((char*)AudioBuf, MIN_PCM_AUDIO_SIZE);
        if(nRead != MIN_PCM_AUDIO_SIZE)
        {
            usleep(10000);
            continue;
        }
        
        //pcm --> adpcm
        memset(AdpcmBuf, 0, sizeof(AdpcmBuf));
        if(!m_deviceEnableAdpcm)
        {
            m_pTalkAdpcm->EncoderClr();
        }
        m_pTalkAdpcm->ADPCMEncode((unsigned char*)AudioBuf, MIN_PCM_AUDIO_SIZE, (unsigned char*)AdpcmBuf);
        if(!SendTalk(AdpcmBuf, 256))
        {
            return;
        }
    }
}

int CPPPPChannel::SendTalk(char * pbuf,int len)
{
    int adpcmIndex = 0;
    int adpcmPresample = 0;
    if(m_deviceEnableAdpcm)
    {
        m_pTalkAdpcm->EncoderGetIndex(&adpcmPresample, &adpcmIndex);
    }
    //Log("SendTalk, len: %d", len);
    AV_HEAD avhead;
    memset(&avhead, 0, sizeof(avhead));
    avhead.type = 8;
    avhead.streamid = 1;
    avhead.len = len;
    avhead.frameno = 0;
    
    if(m_nP2pVer == USE_P2PVER_XQP2P)
    {
        if(XQP2P_Write(m_hSessionHandle, P2P_TALKCHANNEL, (CHAR*)&avhead, sizeof(avhead)) < 0)
        {
            return 0;
        }
        
        if(XQP2P_Write(m_hSessionHandle, P2P_TALKCHANNEL, (CHAR*)pbuf, len) < 0)
        {
            return 0;
        }
    }
    else
    {
        if(PPPP_Write(m_hSessionHandle, P2P_TALKCHANNEL, (CHAR*)&avhead, sizeof(avhead)) < 0)
        {
            return 0;
        }
        
        if(PPPP_Write(m_hSessionHandle, P2P_TALKCHANNEL, (CHAR*)pbuf, len) < 0)
        {
            return 0;
        }
    }
    
    return 1;
}

int CPPPPChannel::PPPP_IndeedRead(UCHAR channel, CHAR * buf,int len, int &bRunning)
{
    CHAR *p = buf;
    INT32 readSize ;
    INT32 remainSize = len;
    INT32 res;
    
    do
    {
        readSize = remainSize;
        if (readSize > 32*1024) {
            readSize = 32*1024;
        }
        if(m_nP2pVer == USE_P2PVER_XQP2P){
            res = XQP2P_Read(m_hSessionHandle, channel, p, &readSize, 100);
        } else {
            res = PPPP_Read(m_hSessionHandle, channel, p, &readSize, 100);
        }
        if(res == ERROR_PPPP_TIME_OUT)
        {
            //Log("PPPP_Read timeout: readSize: %d, %s", readSize, szDID);
            remainSize -= readSize;
            p += readSize;
            usleep(100000);
            continue;
        }
        
        if(res < 0)
        {
            //NSLog(@"PPPP_Read error : %d", res);
            return res;
        }
        
        remainSize -= readSize;
        p += readSize;
    }while(remainSize > 0 && bRunning);
    
    return 0;
}

int CPPPPChannel::cgi_livestream(int bstart, int streamid,int subStreamID)
{
    if(m_bOnline == 0)
        return 0;
    
    char buf[128];
    
    if(bstart == 1)
    {
        if(0 == m_pVideoBuf->Create(VBUF_SIZE))
        {
            return 0;
        }
        
        StartVideoPlay();
        m_EnumVideoMode = ENUM_VIDEO_MODE_UNKNOWN;
    }
    else
    {
        StopVideoPlay();
        m_pVideoBuf->Release();
    }
    
    memset(buf, 0, sizeof(buf));
    sprintf(buf, "GET /livestream.cgi?streamid=%d&", streamid);
    return cgi_get_common(buf);
}

void CPPPPChannel::StartPlaybackVideoPlayer()
{
    if (m_PlaybackVideoPlayerThreadID != NULL) {
        return ;
    }
    
    m_bPlaybackVideoPlayerThreadRuning = 1;
    pthread_create(&m_PlaybackVideoPlayerThreadID, NULL, PlaybackVideoPlayerThread, (void*)this);
}

void* CPPPPChannel::PlaybackVideoPlayerThread(void *param)
{
    CPPPPChannel *pChannel = (CPPPPChannel*)param;
    pChannel->PlaybackVideoPlayerProcess();
    return NULL;
}

void CPPPPChannel::PlaybackVideoPlayerProcess()
{
    //unsigned int oldTimeStamp = 0;
    CH264Decoder *pH264Decoder=new CH264Decoder();
    m_bResetCoder = YES;
    while(m_bPlaybackVideoPlayerThreadRuning)
    {
        if (m_EnumPlayBackVideoMode == ENUM_VIDEO_MODE_UNKNOWN) {
            usleep(100000);
            continue;
        }
        
        if(m_pPlayBackVideoBuf->GetStock() == 0)
        {
            //Log("videobuf is empty...");
            usleep(10000);
            continue;
        }
        
        char *pbuf = NULL;
        int videoLen = 0;
        VIDEO_BUF_HEAD videobufhead;
        memset(&videobufhead, 0, sizeof(videobufhead));
        
        //读取一帧视频数据
        pbuf = m_pPlayBackVideoBuf->ReadOneFrame1(videoLen, videobufhead) ;
        if(NULL == pbuf)
        {
            usleep(10000);
            continue;
        }
        
        /*if(oldTimeStamp > 0)
        {
            int nSleepTime = videobufhead.timestamp - oldTimeStamp;
            if(nSleepTime > 500 || nSleepTime <= 0)
            {
                nSleepTime = 30;
            }
            oldTimeStamp = videobufhead.timestamp;
            
            //usleep(1000 * nSleepTime);
            int iSleep = 0;
            for (iSleep = 0; iSleep <= nSleepTime; iSleep++) {
                if (m_bPlaybackVideoPlayerThreadRuning == 0) {
                    SAFE_DELETE(pbuf) ;
                    return;
                }
                usleep(1000);
                
            }
            
            //Log("nSleepTime: %d", nSleepTime);
        }
        
        if(oldTimeStamp == 0)
        {
            oldTimeStamp = videobufhead.timestamp;
        }*/
        
        unsigned int untimestamp = videobufhead.timestamp;
        long long  dFrameT = (long long )untimestamp*1000 + videobufhead.militime;
        IsPlaybackSleep(dFrameT);
        //Log("get one frame");
        if(ENUM_VIDEO_MODE_H264 == m_EnumPlayBackVideoMode)
        {
            
            
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            
            [m_PlaybackViewAVDataDelegateLock lock];
            
            if (m_PlaybackViewImageNotifyDelegate != nil) {
                
                int yuvlen = 0;
                int nWidth = 0;
                int nHeight = 0;
                
                if (pH264Decoder->DecoderFrame((uint8_t*)pbuf, videoLen, nWidth, nHeight)) {
                    yuvlen=nWidth*nHeight*3/2;
                    uint8_t *pYUVBuffer = new uint8_t[yuvlen];
                    if (pYUVBuffer != NULL) {
                        int nRec=pH264Decoder->GetYUVBuffer(pYUVBuffer, yuvlen);
                        
                        if (nRec>0) {
                            YUVNotify(pYUVBuffer, yuvlen, nWidth, nHeight, untimestamp);
                            [m_PlaybackViewImageNotifyDelegate YUVNotify:pYUVBuffer length:yuvlen width:nWidth height:nHeight timestamp:untimestamp];
                        }
                        
                        delete[] pYUVBuffer;
                        pYUVBuffer = NULL;
                    }
                    
                }
                
                
            }
            
            [m_PlaybackViewAVDataDelegateLock unlock];
            
            [pool release];
            
        }
        else /* JPEG */
        {
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            NSData *image = [[NSData alloc] initWithBytes:pbuf length:videoLen];
            UIImage *img = [[UIImage alloc] initWithData:image];
            PlaybackImageNotify(img, 0);
            [img release];
            [image release];
            [pool release];
            
        }
        
        SAFE_DELETE(pbuf) ;
        usleep(10000);
        
    }
    
    delete pH264Decoder;
    pH264Decoder=NULL;
}

void CPPPPChannel::IsPlaybackSleep(long long frameTime)
{
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
    
    if (m_bResetCoder) {
        m_nLastPlayMobileTime = theTime;
        m_nLastPlayFrameTime  = frameTime;
        m_bResetCoder = NO;
        NSLog(@"播放启起帧");
    }
    else
    {
        long long  mobileT  = theTime - m_nLastPlayMobileTime;
        long long  frameT  = frameTime - m_nLastPlayFrameTime;
        
        
        int time = frameT - mobileT ;
        
        if (time > 18)
        {
            if (time < 1000) {
                for (int jj=0; jj < time; ++jj) {
                    usleep(1000);
                    if (m_bPlaybackVideoPlayerThreadRuning ==0) {
                        break;
                    }
                }
                
                nowtime = [[NSDate date] timeIntervalSince1970]*1000;
                theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
            }
            else
            {
                NSLog(@"时间戳超出:%d 毫秒",time);
            }
            
            m_nLastPlayMobileTime = theTime;
            m_nLastPlayFrameTime  = frameTime;
        }
        else
        {
            m_nLastPlayMobileTime = theTime;
            m_nLastPlayFrameTime  = frameTime;
        }
    }
}

void CPPPPChannel::StopPlaybackVideoPlayer()
{
    m_bPlaybackVideoPlayerThreadRuning = 0;
    if(m_PlaybackVideoPlayerThreadID != NULL)
    {
        pthread_join(m_PlaybackVideoPlayerThreadID, NULL);
        m_PlaybackVideoPlayerThreadID = NULL;
    }
}

int CPPPPChannel::StartPlayback(char *szFilename, int offset)
{
    if(m_bOnline == 0)
        return 0;
    
    char buf[128];
    
    m_bFindIFrame = 0;
    m_nCamType = 128;
    if(0 == m_pPlayBackVideoBuf->Create(VBUF_SIZE))
    {
        return 0;
    }
    
    memset(buf, 0, sizeof(buf));
    sprintf(buf, (char*)"livestream.cgi?streamid=4&filename=%s&offset=%d&", szFilename, offset);
    int nRet = cgi_get_common(buf);
    if(nRet == 1)
    {
        m_bPlaybackStarted = 1;
    }
    
    StartPlaybackVideoPlayer();
    StartAudio(0);
    return nRet;
}

int CPPPPChannel::StopPlayback()
{
    char buf[128];
    
    memset(buf, 0, sizeof(buf));
    sprintf(buf, (char*)"livestream.cgi?streamid=%d", 0x11);
    cgi_get_common(buf);
    
    StopPlaybackVideoPlayer();
    m_pPlayBackVideoBuf->Release();
    m_bPlaybackStarted = 0;
    
    StopAudio(0);
    
    return 1;
}

void CPPPPChannel::SetPlayViewParamNotifyDelegate(id<ParamNotifyProtocol> delegate)
{
    [m_PlayViewParamNotifyDelegateLock lock];
    m_PlayViewParamNotifyDelegate = delegate;
    [m_PlayViewParamNotifyDelegateLock unlock];
}

void CPPPPChannel::SetPlayViewPPPPStatusDelegate(id<PPPPStatusProtocol> delegate)
{
    [m_PlayViewPPPPStatusDelegateLock lock];
    m_PlayViewPPPPStatusDelegate = delegate;
    [m_PlayViewPPPPStatusDelegateLock unlock];
}

void CPPPPChannel::StartVideoPlay()
{
    //StartPlayThread
    m_bPlayThreadRuning = 1;
    pthread_create(&m_PlayThreadID, NULL, PlayThread, (void*)this);
}

void CPPPPChannel::StopVideoPlay()
{
    m_bPlayThreadRuning = 0;
    if(m_PlayThreadID != NULL)
    {
        pthread_join(m_PlayThreadID, NULL);
        m_PlayThreadID = NULL;
    }
}

void CPPPPChannel::PlayProcess()
{
    CH264Decoder *pH264Decoder = new CH264Decoder();//创建h264的解码库
    while(m_bPlayThreadRuning)
    {
        if (m_EnumVideoMode == ENUM_VIDEO_MODE_UNKNOWN) {
            usleep(100000);
            continue;
        }
        
        if(m_pVideoBuf->GetStock() == 0)
        {
            //Log("videobuf is empty...");
            usleep(10000);
            continue;
        }
        
        char *pbuf = NULL;
        int videoLen = 0;
        
        VIDEO_BUF_HEAD videohead;
        memset(&videohead, 0, sizeof(videohead));
        pbuf = m_pVideoBuf->ReadOneFrame1(videoLen, videohead) ;
        if(NULL == pbuf)
        {
            
            usleep(10000);
            continue;
        }
        
        unsigned int untimestamp = videohead.timestamp;
        
        //NSLog(@"get one frame");
        if(ENUM_VIDEO_MODE_H264 == m_EnumVideoMode)
        {
            
            //            if (videohead.frametype == 0) {
            //                UninitH264Decoder();
            //                InitH264Decoder();
            //            }
            //
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            
            // uint8_t *yuvBuf = NULL;
            int yuvlen = 0;
            int nWidth = 0;
            int nHeight = 0;
            
            //NSLog(@"DecoderH264Frame being.. id: %s", szDID);
            
            
            /*int nRet = DecoderH264Frame((uint8_t*)pbuf, videoLen, &yuvBuf, &yuvlen, &nWidth, &nHeight);
             if (nRet > 0) {
             //NSLog(@"decoder success... videoLen: %d, yuvlen: %d, nWidth: %d, nHeight: %d",
             //      videoLen, yuvlen, nWidth, nHeight);
             YUVNotify(yuvBuf, yuvlen, nWidth, nHeight, untimestamp);
             }
             
             //NSLog(@"DecoderH264Frame end.. id: %s", szDID);
             
             SAFE_DELETE(yuvBuf);
             
             H264DataNotify((unsigned char*)pbuf, videoLen, videohead.frametype, untimestamp);
             
             [pool release];
             
             
             }
             else  //JPEG
             {
             NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
             NSData *image = [[NSData alloc] initWithBytes:pbuf length:videoLen];
             UIImage *img = [[UIImage alloc] initWithData:image];
             ImageNotify(img, untimestamp);
             [img release];
             [image release];
             
             [pool release];
             
             }*/
            
            if (pH264Decoder->DecoderFrame((uint8_t*)pbuf, videoLen, nWidth, nHeight)) {
                yuvlen=nWidth*nHeight*3/2;
                uint8_t *pYUVBuffer = new uint8_t[yuvlen];
                if (pYUVBuffer != NULL) {
                    int nRec=pH264Decoder->GetYUVBuffer(pYUVBuffer, yuvlen);
                    
                    if (nRec>0) {
                        YUVNotify(pYUVBuffer, yuvlen, nWidth, nHeight, untimestamp);
                    }
                    
                    delete pYUVBuffer;
                    pYUVBuffer = NULL;
                }
                
            }
            else
            {
                delete pH264Decoder;
                pH264Decoder = new CH264Decoder();
                m_pVideoBuf->Reset();
                m_bFindIFrame = 0;
            }
            
            H264DataNotify((unsigned char*)pbuf, videoLen, videohead.frametype, untimestamp);
            
            [pool release];
            
            
        }
        else /* JPEG */
        {
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            NSData *image = [[NSData alloc] initWithBytes:pbuf length:videoLen];
            UIImage *img = [[UIImage alloc] initWithData:image];
            ImageNotify(img, untimestamp);
            [img release];
            [image release];
            
            [pool release];
            
        }
        
        
        SAFE_DELETE(pbuf) ;
        usleep(10000);
        
    }
    delete pH264Decoder;
    pH264Decoder=NULL;
}

void CPPPPChannel::SetPlaybackDelegate(id delegate)
{
    [m_PlaybackViewAVDataDelegateLock lock];
    m_PlaybackViewImageNotifyDelegate = delegate;
    [m_PlaybackViewAVDataDelegateLock unlock];
}

void CPPPPChannel::H264DataNotify(unsigned char *h264Data, int length, int type, unsigned int timestamp)
{
    [m_PlayViewAVDataDelegateLock lock];
    [m_PlayViewImageNotifyDelegate H264Data:h264Data length:length type:type timestamp:timestamp];
    if ([m_PlayViewImageNotifyDelegate respondsToSelector:@selector(H264Data:length:type:timestamp:szdid:)]) {
        [m_PlayViewImageNotifyDelegate H264Data:h264Data length:length type:type timestamp:timestamp szdid:[NSString stringWithUTF8String:szDID]];
    }
    
    // NSLog(@"szDid YUv%s",szDID);
    [m_PlayViewAVDataDelegateLock unlock];
}

void CPPPPChannel::YUVNotify(unsigned char *yuv, int len, int width, int height, unsigned int timestamp)
{
    [m_PlayViewAVDataDelegateLock lock];
    [m_PlayViewImageNotifyDelegate YUVNotify:yuv length:len width:width height:height timestamp:timestamp];
    if ([m_PlayViewImageNotifyDelegate respondsToSelector:@selector(YUVNotify:length:width:height:timestamp:szdid:)]) {
        [m_PlayViewImageNotifyDelegate YUVNotify:yuv length:len width:width height:height timestamp:timestamp szdid:[NSString stringWithUTF8String:szDID]];
    }
    
    [m_PlayViewAVDataDelegateLock unlock];
}

void CPPPPChannel::ImageNotify(UIImage *image, unsigned int timestamp)
{
    [m_PlayViewAVDataDelegateLock lock];
    [m_PlayViewImageNotifyDelegate ImageNotify:image timestamp:timestamp];
    if ([m_PlayViewImageNotifyDelegate respondsToSelector:@selector(ImageNotify:timestamp:szdid:)]) {
        [m_PlayViewImageNotifyDelegate ImageNotify:image timestamp:timestamp szdid:[NSString stringWithUTF8String:szDID]];
    }
    
    //NSLog(@"szDid IMage %s",szDID);
    [m_PlayViewAVDataDelegateLock unlock];
    
}

void CPPPPChannel::PlaybackYUVNotify(unsigned char *yuv, int len, int width, int height, unsigned int timestamp)
{
    [m_PlaybackViewAVDataDelegateLock lock];
    [m_PlaybackViewImageNotifyDelegate YUVNotify:yuv length:len width:width height:height timestamp:timestamp];
    [m_PlaybackViewAVDataDelegateLock unlock];
}

void CPPPPChannel::PlaybackImageNotify(UIImage *image, unsigned int timestamp)
{
    [m_PlaybackViewAVDataDelegateLock lock];
    [m_PlaybackViewImageNotifyDelegate ImageNotify:image timestamp:timestamp];
    [m_PlaybackViewAVDataDelegateLock unlock];
    
}


void* CPPPPChannel::PlayThread(void* param)
{
    CPPPPChannel *pPPPP = (CPPPPChannel*)param ;
    pPPPP->PlayProcess();
    return NULL;
}

void CPPPPChannel::SetPlayViewImageNotifyDelegate(id<ImageNotifyProtocol> delegate)
{
    m_PlayViewImageNotifyDelegate = delegate;
}

int CPPPPChannel::get_cgi(int cgi)
{
    char szCGI[64] = {0};
    memset(szCGI, 0, sizeof(szCGI));
    
    switch (cgi) {
        case CGI_IEGET_CAM_PARAMS:
            strcpy(szCGI, "get_camera_params.cgi?");
            break;
        case CGI_IEGET_STATUS:
            strcpy(szCGI, "get_status.cgi?");
            break;
        case CGI_IEFORMATSD:
            strcpy(szCGI, "set_formatsd.cgi?");
            break;
        default:
            return 0;
    }
    return cgi_get_common(szCGI);
}

int CPPPPChannel::get_json_cgi(int cgi, char *buf){
    char szCGI[1024 * 5] = {0};
    memset(szCGI, 0, sizeof(szCGI));
    strcpy(szCGI,buf);
    int x = cgi_get_common(szCGI);
    NSLog(@"%d",x);
    return x;
}

int CPPPPChannel::Snapshot()
{
    return cgi_get_common((char*)"snapshot.cgi?");
}

int CPPPPChannel::SetSystemParams(int type,char * msg,int len)
{
    int nRet = 0;
    
    switch (type)
    {
        case MSG_TYPE_GET_CAMERA_PARAMS:
            nRet = cgi_get_common((char*)"get_camera_params.cgi?");
            break;
        case MSG_TYPE_SNAPSHOT:
            nRet = cgi_get_common((char*)"snapshot.cgi?");
            break;
        case MSG_TYPE_DECODER_CONTROL:
            //nRet = SendDecoderControl(msg, len);
            break;
        case MSG_TYPE_CAMERA_CONTROL:
            //nRet = SendCameraControl(msg, len);
            break;
        case MSG_TYPE_SET_NETWORK:
            //nRet = SendNetWorkSetting(msg, len);
            break;
        case MSG_TYPE_REBOOT_DEVICE:
            [m_PPPPStatusDelegate PPPPStatus:[NSString stringWithUTF8String:szDID] statusType:MSG_NOTIFY_TYPE_PPPP_STATUS status:PPPP_STATUS_DISCONNECT];
            nRet = cgi_get_common((char*)"reboot.cgi?");
            break;
        case MSG_TYPE_RESTORE_FACTORY:
            nRet = cgi_get_common((char*)"restore_factory.cgi?");
            break;
        case MSG_TYPE_SET_USER:
            //nRet = SendSetUser(msg, len);
        {
            PSTRU_USER_INFO pTemp = (PSTRU_USER_INFO)msg;
            char buf[1024];
            sprintf(buf,"set_users.cgi?user1=%s&user2=%s&user3=%s&pwd1=%s&pwd2=%s&pwd3=%s&",pTemp->user1,pTemp->user2,pTemp->user3,pTemp->pwd1,pTemp->pwd2,pTemp->pwd3
                    );
            
            nRet = cgi_get_common(buf);
        }
            break;
        case MSG_TYPE_SET_WIFI:
            nRet = SendWifiSetting(msg, len);
            break;
        case MSG_TYPE_SET_DATETIME:
            //nRet = SendDatetimeSetting(msg, len);
        {
            STRU_DATETIME_PARAMS *pTemp = (STRU_DATETIME_PARAMS *)msg;
            char buf[1024];
            if (pTemp->now == 0)
            {
                sprintf(buf,"set_datetime.cgi?tz=%d&ntp_enable=%d&ntp_svr=%s&",
                        pTemp->tz,pTemp->ntp_enable,pTemp->ntp_svr
                        );
            }
            else{
                sprintf(buf,"set_datetime.cgi?now=%d&tz=%d&ntp_enable=%d&ntp_svr=%s&",
                        pTemp->now,pTemp->tz,pTemp->ntp_enable,pTemp->ntp_svr
                        );
            }
            
            nRet = cgi_get_common(buf);
        }
            break;
        case MSG_TYPE_WIFI_SCAN:
            nRet = cgi_get_common((char*)"wifi_scan.cgi?");
            break;
        case MSG_TYPE_SET_FTP:
        {
            PSTRU_FTP_PARAMS pftpParam = (PSTRU_FTP_PARAMS)msg;
            char buf[1024];
            
            sprintf(buf,"set_ftp.cgi?svr=%s&port=%d&user=%s&pwd=%s&mode=%d&dir=%s&interval=%d&",
                    pftpParam->svr_ftp, pftpParam->port, pftpParam->user,
                    pftpParam->pwd, pftpParam->mode, pftpParam->dir, pftpParam->upload_interval);
            
            nRet = cgi_get_common(buf);
            
        }
            //nRet = SendFTPSetting(msg, len);
            break;
        case MSG_TYPE_SET_MAIL:
        {
            if (msg == NULL || len != sizeof(STRU_MAIL_PARAMS))
            {
                return -1;
            }
            
            PSTRU_MAIL_PARAMS pMail = (PSTRU_MAIL_PARAMS)msg;
            char buf[1024];
            sprintf(buf, "set_mail.cgi?svr=%s&user=%s&pwd=%s&sender=%s&receiver1=%s&receiver2=%s&receiver3=%s&receiver4=%s&port=%d&ssl=%d&",
                    pMail->svr, pMail->user, pMail->pwd, pMail->sender, pMail->receiver1, pMail->receiver2, pMail->receiver3, pMail->receiver4, pMail->port, pMail->ssl);
            return cgi_get_common(buf);
        }
            //nRet = SendMailSetting(msg, len);
            break;
        case MSG_TYPE_SET_RECORD_SCH:{
            NSLog(@"MSG_TYPE_SET_RECORD_SCH====99999");
            PSTRU_SD_RECORD_PARAM recordParam=(PSTRU_SD_RECORD_PARAM)msg;
            char buf[1024];
            sprintf(buf, "set_recordsch.cgi?record_cover=%d&record_timer=%d&time_schedule_enable=%d&schedule_sun_0=%d&schedule_sun_1=%d&schedule_sun_2=%d&schedule_mon_0=%d&schedule_mon_1=%d&schedule_mon_2=%d&schedule_tue_0=%d&schedule_tue_1=%d&schedule_tue_2=%d&schedule_wed_0=%d&schedule_wed_1=%d&schedule_wed_2=%d&schedule_thu_0=%d&schedule_thu_1=%d&schedule_thu_2=%d&schedule_fri_0=%d&schedule_fri_1=%d&schedule_fri_2=%d&schedule_sat_0=%d&schedule_sat_1=%d&schedule_sat_2=%d&",
                    recordParam->record_cover_enable,
                    recordParam->record_timer,
                    recordParam->record_time_enable,
                    recordParam->record_schedule_sun_0,
                    recordParam->record_schedule_sun_1,
                    recordParam->record_schedule_sun_2,
                    recordParam->record_schedule_mon_0,
                    recordParam->record_schedule_mon_1,
                    recordParam->record_schedule_mon_2,
                    recordParam->record_schedule_tue_0,
                    recordParam->record_schedule_tue_1,
                    recordParam->record_schedule_tue_2,
                    recordParam->record_schedule_wed_0,
                    recordParam->record_schedule_wed_1,
                    recordParam->record_schedule_wed_2,
                    recordParam->record_schedule_thu_0,
                    recordParam->record_schedule_thu_1,
                    recordParam->record_schedule_thu_2,
                    recordParam->record_schedule_fri_0,
                    recordParam->record_schedule_fri_1,
                    recordParam->record_schedule_fri_2,
                    recordParam->record_schedule_sat_0,
                    recordParam->record_schedule_sat_1,
                    recordParam->record_schedule_sat_2);
            return cgi_get_common(buf);
        }
            break;
            
        case MSG_TYPE_GET_PARAMS:
            nRet = cgi_get_common((char*)"get_params.cgi?");
            break;
        case MSG_TYPE_GET_STATUS:
            nRet = cgi_get_common((char*)"get_status.cgi?");
            break;
        case MSG_TYPE_SET_DDNS:
            //nRet = SendDDNSSetting(msg, len);
            break;
        case MSG_TYPE_SET_PTZ:
            //nRet = SendPtzSetting(msg, len);
            break;
        case MSG_TYPE_SET_ALARM:
            //nRet = SendAlarmSetting(msg, len);
        {
            char buf[1024];
            STRU_ALARM_PARAMS *pTemp = (STRU_ALARM_PARAMS *)msg;
            sprintf(buf,"set_alarm.cgi?motion_armed=%d&motion_sensitivity=%d&input_armed=%d&ioin_level=%d&preset=%d&iolinkage=%d&ioout_level=%d&mail=%d&record=%d&upload_interval=%d&schedule_enable=%d&schedule_sun_0=%d&schedule_sun_1=%d&schedule_sun_2=%d&schedule_mon_0=%d&schedule_mon_1=%d&schedule_mon_2=%d&schedule_tue_0=%d&schedule_tue_1=%d&schedule_tue_2=%d&schedule_wed_0=%d&schedule_wed_1=%d&schedule_wed_2=%d&schedule_thu_0=%d&schedule_thu_1=%d&schedule_thu_2=%d&schedule_fri_0=%d&schedule_fri_1=%d&schedule_fri_2=%d&schedule_sat_0=%d&schedule_sat_1=%d&schedule_sat_2=%d&",
                    pTemp->motion_armed,pTemp->motion_sensitivity,pTemp->input_armed,pTemp->ioin_level,
                    pTemp->alarmpresetsit,pTemp->iolinkage,pTemp->ioout_level,pTemp->mail,pTemp->record, pTemp->upload_interval,
                    ((pTemp->motion_armed>0)||(pTemp->input_armed>0))?1:0,
                    0xffffffff,0xffffffff,0xffffffff,
                    0xffffffff,0xffffffff,0xffffffff,
                    0xffffffff,0xffffffff,0xffffffff,
                    0xffffffff,0xffffffff,0xffffffff,
                    0xffffffff,0xffffffff,0xffffffff,
                    0xffffffff,0xffffffff,0xffffffff,
                    0xffffffff,0xffffffff,0xffffffff
                    );
            nRet = cgi_get_common(buf);
            /*  if (msg == NULL || len != sizeof(STRU_ALARM_PARAMS))
             {
             return -1;
             }
             
             PSTRU_ALARM_PARAMS pAlarm = (PSTRU_ALARM_PARAMS)msg;
             char buf[1024] = {0};
             sprintf(buf, "set_alarm.cgi?motion_armed=%d&motion_sensitivity=%d&input_armed=%d&ioin_level=%d&iolinkage=%d&ioout_level=%d&preset=%d&mail=%d&snapshot=%d&record=%d&upload_interval=%d&schedule_enable=%d&schedule_sun_0=%d&schedule_sun_1=%d&schedule_sun_2=%d&schedule_mon_0=%d&schedule_mon_1=%d&schedule_mon_2=%d&schedule_tue_0=%d&schedule_tue_1=%d&schedule_tue_2=%d&schedule_wed_0=%d&schedule_wed_1=%d&schedule_wed_2=%d&schedule_thu_0=%d&schedule_thu_1=%d&schedule_thu_2=%d&schedule_fri_0=%d&schedule_fri_1=%d&schedule_fri_2=%d&schedule_sat_0=%d&schedule_sat_1=%d&schedule_sat_2=%d&",
             pAlarm->motion_armed, pAlarm->motion_sensitivity, pAlarm->input_armed, pAlarm->ioin_level, pAlarm->iolinkage,
             pAlarm->ioout_level, pAlarm->alarmpresetsit, pAlarm->mail, pAlarm->snapshot, pAlarm->record, pAlarm->upload_interval, pAlarm->schedule_enable,
             pAlarm->schedule_sun_0, pAlarm->schedule_sun_1, pAlarm->schedule_sun_2,
             pAlarm->schedule_mon_0,pAlarm->schedule_mon_1,pAlarm->schedule_mon_2,
             pAlarm->schedule_tue_0,pAlarm->schedule_tue_1,pAlarm->schedule_tue_2,
             pAlarm->schedule_wed_0,pAlarm->schedule_wed_1,pAlarm->schedule_wed_2,
             pAlarm->schedule_thu_0,pAlarm->schedule_thu_1,pAlarm->schedule_thu_2,
             pAlarm->schedule_fri_0,pAlarm->schedule_fri_1,pAlarm->schedule_fri_2,
             pAlarm->schedule_sat_0,pAlarm->schedule_sat_1,pAlarm->schedule_sat_2);
             
             //TRACE("buf: %s\n", buf);
             return cgi_get_common(buf);*/
            
        }
            break;
        case MSG_TYPE_GET_PTZ_PARAMS:
            nRet = cgi_get_common((char*)"get_misc.cgi?");
            break;
        case MSG_TYPE_GET_ALARM_LOG:
            nRet = cgi_get_common((char*)"get_alarmlog.cgi?");
            break;
        case MSG_TYPE_SET_DEVNAME:
            //nRet = SendDeviceName(msg, len);
            break;
        case MSG_TYPE_GET_RECORD_FILE:
        {
            
            if (msg == NULL || len != sizeof(STRU_SEARCH_SDCARD_RECORD_FILE)) {
                nRet = 0;
                break;
            }
            
            PSTRU_SEARCH_SDCARD_RECORD_FILE pRecordSearch = (PSTRU_SEARCH_SDCARD_RECORD_FILE)msg;
            char buf[1024] = {0};
            /*sprintf(buf, "get_record_file.cgi?startdate=%d&enddate=%d&", pRecordSearch->PageIndex, pRecordSearch->PageSize);*/
            sprintf(buf, "get_record_file.cgi?PageIndex=%d&PageSize=%d&",pRecordSearch->PageIndex,pRecordSearch->PageSize);
            NSLog(@"buf   %s",buf);
            nRet = cgi_get_common(buf);
            
        }
            break;
        case MSG_TYPE_GET_RECORD:
            //NSLog(@"PPPPChannel---录像计划");
            nRet = cgi_get_common((char*)"get_record.cgi?");
            break;
            
        default:
            nRet = 0;
            break;
    }
    
    return nRet;
}

int CPPPPChannel::SendWifiSetting(char *msg, int len)
{
    if (msg == NULL || len != sizeof(STRU_WIFI_PARAMS))
    {
        return -1;
    }
    
    PSTRU_WIFI_PARAMS pWifi = (PSTRU_WIFI_PARAMS)msg;
    char buf[1024];
    sprintf(buf, "set_wifi.cgi?enable=%d&ssid=%s&encrypt=%d&defkey=%d&key1=%s&key2=%s&key3=%s&key4=%s&authtype=%d&keyformat=%d&key1_bits=%d&key2_bits=%d&key3_bits=%d&key4_bits=%d&channel=%d&mode=%d&wpa_psk=%s&",
            pWifi->enable, pWifi->ssid, pWifi->encrypt, pWifi->defkey, pWifi->key1, pWifi->key2, pWifi->key3, pWifi->key4, pWifi->authtype, pWifi->keyformat, pWifi->key1_bits, pWifi->key2_bits, pWifi->key3_bits, pWifi->key4_bits, pWifi->channel, pWifi->mode, pWifi->wpa_psk);
    
    return cgi_get_common(buf);
    
}


void CPPPPChannel::SetWifiParamsDelegate(id delegate)
{
    [m_WifiParamsLock lock];
    m_WifiParamsDelegate = delegate;
    [m_WifiParamsLock unlock];
}

int CPPPPChannel::SetWifi(int enable, char *szSSID, int channel, int mode, int authtype, int encrypt, int keyformat, int defkey, char *strKey1, char *strKey2, char *strKey3, char *strKey4, int key1_bits, int key2_bits, int key3_bits, int key4_bits, char *wpa_psk)
{
    STRU_WIFI_PARAMS wifiParams;
    memset(&wifiParams, 0, sizeof(wifiParams));
    strcpy(wifiParams.ssid, szSSID);
    strcpy(wifiParams.key1, strKey1);
    strcpy(wifiParams.key2, strKey2);
    strcpy(wifiParams.key3, strKey3);
    strcpy(wifiParams.key4, strKey4);
    strcpy(wifiParams.wpa_psk, wpa_psk);
    wifiParams.enable = enable;
    wifiParams.channel = channel;
    wifiParams.mode = mode;
    wifiParams.authtype = authtype;
    wifiParams.encrypt = encrypt;
    wifiParams.keyformat = keyformat;
    wifiParams.defkey = defkey;
    wifiParams.key1_bits = key1_bits;
    wifiParams.key2_bits = key2_bits;
    wifiParams.key3_bits = key3_bits;
    wifiParams.key4_bits = key4_bits;
    
    return SetSystemParams(MSG_TYPE_SET_WIFI, (char*)&wifiParams, sizeof(wifiParams));
    
}

void CPPPPChannel::SetUserPwdParamsDelegate(id delegate)
{
    [m_UserPwdParamsLock lock];
    m_UserPwdParamsDelegate = delegate;
    [m_UserPwdParamsLock unlock];
}
int CPPPPChannel::SetUserPwd(char *user1,char *pwd1,char *user2,char *pwd2,char *user3,char *pwd3)
{
    STRU_USER_INFO UseParam;
    memset(&UseParam, 0, sizeof(UseParam));
    strcpy(UseParam.user1, user1);
    strcpy(UseParam.user2, user2);
    strcpy(UseParam.user3, user3);
    strcpy(UseParam.pwd1, pwd1);
    strcpy(UseParam.pwd2, pwd2);
    strcpy(UseParam.pwd3, pwd3);
    
    
    return SetSystemParams(MSG_TYPE_SET_USER, (char*)&UseParam, sizeof(UseParam));
    
}

void CPPPPChannel::SetFtpDelegate(id delegate)
{
    [m_FTPLock lock];
    m_FtpDelegate = delegate;
    [m_FTPLock unlock];
    
}

void safecopy(char *pdest, char* psrc, int len)
{
    if (pdest == NULL || psrc == NULL) {
        return;
    }
    
    if (strlen(psrc) >= len) {
        memcpy(pdest, psrc, len);
    }else{
        strcpy(pdest, psrc);
    }
}

int CPPPPChannel::SetFtp(char *szSvr, char *szUser, char *szPwd, char *dir, int port, int uploadinterval, int mode)
{
    
    STRU_FTP_PARAMS ftpParam;
    memset(&ftpParam, 0, sizeof(ftpParam));
    safecopy(ftpParam.svr_ftp, szSvr, 64);
    safecopy(ftpParam.user, szUser, 64);
    safecopy(ftpParam.pwd, szPwd, 64);
    safecopy(ftpParam.dir, dir, 128);
    ftpParam.port = port;
    ftpParam.mode = mode;
    ftpParam.upload_interval = uploadinterval;
    
    return SetSystemParams(MSG_TYPE_SET_FTP, (char*)&ftpParam, sizeof(ftpParam));
}

void CPPPPChannel::SetMailDelegate(id delegate)
{
    [m_MailLock lock];
    m_MailDelegate = delegate;
    [m_MailLock unlock];
}

int CPPPPChannel::SetMail(char *sender, char *smtp_svr, int smtp_port, int ssl, int auth, char *user, char *pwd, char *recv1, char *recv2, char *recv3, char *recv4)
{
    STRU_MAIL_PARAMS mailParam;
    memset(&mailParam, 0, sizeof(mailParam));
    safecopy(mailParam.svr, smtp_svr, 64);
    safecopy(mailParam.user, user, 64);
    safecopy(mailParam.pwd, pwd, 64);
    safecopy(mailParam.sender, sender, 64);
    safecopy(mailParam.receiver1, recv1, 64);
    safecopy(mailParam.receiver2, recv2, 64);
    safecopy(mailParam.receiver3, recv3, 64);
    safecopy(mailParam.receiver4, recv4, 64);
    
    mailParam.port = smtp_port;
    mailParam.ssl = ssl;
    
    return SetSystemParams(MSG_TYPE_SET_MAIL, (char*)&mailParam, sizeof(mailParam));
    
}

void CPPPPChannel::SetDateTimeParamsDelegate(id delegate)
{
    [m_DateTimeParamsLock lock];
    m_DateTimeParamsDelegate = delegate;
    [m_DateTimeParamsLock unlock];
}
int CPPPPChannel::SetDateTime(int now,int tz,int ntp_enable,char *ntp_svr)
{
    STRU_DATETIME_PARAMS datetimePama;
    memset(&datetimePama, 0, sizeof(datetimePama));
    
    datetimePama.now = now;
    datetimePama.tz = tz;
    datetimePama.ntp_enable = ntp_enable;
    strcpy(datetimePama.ntp_svr , ntp_svr);
    
    
    return SetSystemParams(MSG_TYPE_SET_DATETIME, (char*)&datetimePama, sizeof(datetimePama));
    
}
void CPPPPChannel::SetAlarmParamsDelegate(id delegate)
{
    [m_AlarmParamsLock lock];
    m_AlarmParamsDelegate = delegate;
    [m_AlarmParamsLock unlock];
}

int CPPPPChannel::SetAlarm(
                           int motion_armed,
                           int motion_sensitivity,
                           int input_armed,
                           int ioin_level,
                           int alarmpresetsit,
                           int iolinkage,
                           int ioout_level,
                           int mail,
                           int upload_interval,
                           int record)
{
    STRU_ALARM_PARAMS alarmParam;
    memset(&alarmParam, 0, sizeof(alarmParam));
    alarmParam.motion_armed = motion_armed;
    alarmParam.motion_sensitivity = motion_sensitivity;
    alarmParam.input_armed = input_armed;
    alarmParam.ioin_level = ioin_level;
    alarmParam.alarmpresetsit =alarmpresetsit;
    alarmParam.iolinkage = iolinkage,
    alarmParam.ioout_level = ioout_level;
    alarmParam.mail = mail;
    alarmParam.upload_interval = upload_interval;
    alarmParam.record = record;
    
    return SetSystemParams(MSG_TYPE_SET_ALARM, (char*)&alarmParam, sizeof(alarmParam));
    return 0;
}

void CPPPPChannel::SetSDCardScheduleDelegate(id delegate){
    [m_SDCardScheduleLock lock];
    // NSLog(@"CPPPPChannel::SetSDCardScheduleDelegate---999999");
    m_SDcardScheduleDelegate=delegate;
    [m_SDCardScheduleLock unlock];
}
int CPPPPChannel::SetSDCardScheduleParams(
                                          int coverage_enable,
                                          int timelength,
                                          int fixed_enable,
                                          int record_schedule_sun_0,
                                          int record_schedule_sun_1,
                                          int record_schedule_sun_2,
                                          int record_schedule_mon_0,
                                          int record_schedule_mon_1,
                                          int record_schedule_mon_2,
                                          int record_schedule_tue_0,
                                          int record_schedule_tue_1,
                                          int record_schedule_tue_2,
                                          int record_schedule_wed_0,
                                          int record_schedule_wed_1,
                                          int record_schedule_wed_2,
                                          int record_schedule_thu_0,
                                          int record_schedule_thu_1,
                                          int record_schedule_thu_2,
                                          int record_schedule_fri_0,
                                          int record_schedule_fri_1,
                                          int record_schedule_fri_2,
                                          int record_schedule_sat_0,
                                          int record_schedule_sat_1,
                                          int record_schedule_sat_2){
    NSLog(@"CPPPPChannel::SetSDCardScheduleParams====timelength=%d",timelength);
    STRU_SD_RECORD_PARAM recordParam;
    memset(&recordParam, 0, sizeof(recordParam));
    recordParam.record_cover_enable=coverage_enable;
    recordParam.record_time_enable=fixed_enable;
    recordParam.record_timer=timelength;
    recordParam.record_schedule_sun_0=record_schedule_sun_0;
    recordParam.record_schedule_sun_1=record_schedule_sun_1;
    recordParam.record_schedule_sun_2=record_schedule_sun_2;
    recordParam.record_schedule_mon_0=record_schedule_mon_0;
    recordParam.record_schedule_mon_1=record_schedule_mon_1;
    recordParam.record_schedule_mon_2=record_schedule_mon_2;
    recordParam.record_schedule_tue_0=record_schedule_tue_0;
    recordParam.record_schedule_tue_1=record_schedule_tue_1;
    recordParam.record_schedule_tue_2=record_schedule_tue_2;
    recordParam.record_schedule_wed_0=record_schedule_wed_0;
    recordParam.record_schedule_wed_1=record_schedule_wed_1;
    recordParam.record_schedule_wed_2=record_schedule_wed_2;
    recordParam.record_schedule_thu_0=record_schedule_thu_0;
    recordParam.record_schedule_thu_1=record_schedule_thu_1;
    recordParam.record_schedule_thu_2=record_schedule_thu_2;
    recordParam.record_schedule_fri_0=record_schedule_fri_0;
    recordParam.record_schedule_fri_1=record_schedule_fri_1;
    recordParam.record_schedule_fri_2=record_schedule_fri_2;
    recordParam.record_schedule_sat_0=record_schedule_sat_0;
    recordParam.record_schedule_sat_1=record_schedule_sat_1;
    recordParam.record_schedule_sat_2=record_schedule_sat_2;
    
    return SetSystemParams(MSG_TYPE_SET_RECORD_SCH, (char *)&recordParam, sizeof(recordParam));
    return 0;
}

void CPPPPChannel::SetCameraSDCardStatusDelegate(id delegate){
    [m_SDCardStatusLock lock];
    m_SDCardStatusDelegate = delegate;
    [m_SDCardStatusLock unlock];
}

void CPPPPChannel::SetCameraStatusDelegate(id delegate){
    [m_CamStatusDelegateLock lock];
    m_CamStatusDelegate = delegate;
    [m_CamStatusDelegateLock unlock];
}

void CPPPPChannel::FirmwareUpgrade(char *downloadserverAdd, char *downfilename, int FirmwareType){
    char buf[1024];
    sprintf(buf, "auto_download_file.cgi?server=%s&file=%s&type=%d&resevered1=%s&resevered2=%s&resevered3=%s&resevered4=%s&",downloadserverAdd, downfilename, FirmwareType, "","","","");
    cgi_get_common(buf);
}


