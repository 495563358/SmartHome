
#ifndef _DEFINE_H_
#define _DEFINE_H_

//#define TEST_APP


#ifndef _DEF_STRU_AV_HEAD
#define _DEF_STRU_AV_HEAD
typedef struct tag_AV_HEAD
{
    unsigned int           startcode;    //  0xa815aa55
    
    char                type;
    
    char              streamid;
    unsigned short     militime;
    unsigned int         sectime;
    unsigned int        frameno;
    unsigned int         len;
    
    unsigned char        version;
    unsigned char        resolution;
    unsigned char        sessid;
    unsigned char       currsit;
    unsigned char       endflag;
    char                byzone;
    char                channel;
    char                type1;
    short               sample;
    short               index;
}AV_HEAD,*PAV_HEAD;
#endif

#define MAX_FRAME_LENGTH 209715200 //200 * 1024 * 1024 ; 200KB
#define MAX_AUDIO_DATA_LENGTH 2048

typedef enum tag_ENUM_FRAME_TYPE
{
    ENUM_FRAME_TYPE_I = 0,
    ENUM_FRAME_TYPE_P = 1,
    ENUM_FRAME_TYPE_MJPEG = 3
}ENUM_FRAME_TYPE;

typedef enum tag_ENUM_VIDEO_MODE
{
    ENUM_VIDEO_MODE_MJPEG,
    ENUM_VIDEO_MODE_H264,
    ENUM_VIDEO_MODE_UNKNOWN
}ENUM_VIDEO_MODE;


typedef enum tag_ENUM_STREAM
{
    ENUM_STREAM_MAIN_H264 = 0,
    ENUM_STREAM_SUB_H264 = 1,
    ENUM_STREAM_MAIN_JPEG = 2,
    ENUM_STREAM_SUB_JPEG = 3,
    ENUM_STREAM_RECORD = 4,
    ENUM_STREAM_MOBILE = 10,
}ENUM_STRAM;

const int MSG_TYPE_CONNECT_FAILED = 0;  /* 连接失败 */
const int MSG_TYPE_INIT_NET_ERROR = 1;  /* 初始化网络失败 */
const int MSG_TYPE_SEND_ERROR = 2; /* 发送失败 */
const int MSG_TYPE_RECV_ERROR = 3; /* 接收失败 */


/* 连接超时时间(秒) */
#define CONNECT_TIME_OUT   10

/* Select 时间 */
#define SELECT_TIME_OUT    10

/* Select 最大次数，表明网络断开 */
#define MAX_SELECT_TIME     20

#define VIDEO_HEAD_VALUE 0xFF00FF

//视频缓存中，每包视频数据的头部
struct VIDEO_BUF_HEAD
{
    unsigned int head; /* 头，必须等于0xFF00FF */
    unsigned int timestamp; //时间戳，如果是录像，则填录像的时间戳，如果是实时视频，则为0
    unsigned int militime;
    unsigned int len;    /*长度*/
    unsigned int frametype;
    unsigned char		size;//	图像分辨率，0：VGA，1：QVGA, 2:720P, 3:960P,4:1080P
};


//播放实例的最大个数
#define MAX_PLAY_INSTANCE   64

#define KB 1024

//视频缓存大小
#define VBUF_SIZE      1*KB*KB

//音频缓存大小
#define ABUF_SIZE      KB*KB

//重连时间间隔
#define RE_CONNECT_INTERVAL 30

//最大重连时间间隔
#define MAX_RECONNECT_INTERVAL 300

//最小重连时间间隔
#define MIN_RECONNECT_INTERVAL 10

//最大录像时间（分）
#define MAX_RECORD_TIME 15

//录像文件的最大大小（MB）
#define MAX_RECORD_FILE_SIZE 50

//录像模式
#define RECORD_ONE_TIME 1 //录像一次
#define RECORD_REPEAT 2 //重复录像

#define RECORD_MODE RECORD_ONE_TIME


//计算帧率的视频帧的数目
#define FRAMERATE_CNT   30

//文件播放时，文件大小的最小值(字节)
#define KB 1024
#define RECORD_FILE_MIN_SIZE 64*KB

//播放速度
#define PLAY_SPEED_SLOW16 -16
#define PLAY_SPEED_SLOW8  -8
#define PLAY_SPEED_SLOW4  -4
#define PLAY_SPEED_SLOW2  -2
#define PLAY_SPEED_NORMAL 0
#define PLAY_SPEED_FAST2  2
#define PLAY_SPEED_FAST4  4
#define PLAY_SPEED_FAST8  8
#define PLAY_SPEED_FAST16 16

#ifndef SAFE_DELETE
#define SAFE_DELETE(p)\
{\
if((p) != NULL)\
{\
delete (p);\
(p) = NULL;\
}\
}
#endif

#endif

