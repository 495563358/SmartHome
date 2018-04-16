//
//  HBYYTool.m
//  SmartHome
//
//  Created by Smart house on 2018/3/28.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import "HBYYTool.h"
#import "SmartHome-Swift.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioSession.h>
#import "iflyMSC/IFlyContact.h"
#import "iflyMSC/IFlySpeechError.h"
#import "iflyMSC/IFlyDataUploader.h"
#import "iflyMSC/IFlyUserWords.h"
#import "RecognizerFactory.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlyResourceUtil.h"
#import "ISRDataHelper.h"

#import "UIView+Toast.h"
#import "ToolTableViewCell.h"

#define IOS8_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
@interface HBYYTool ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *_talkBtn;
    UILabel *_tipLabel;
    BOOL isTalking;
    UITableView *tableView;
    
    UILabel *tipLab;
}

@property(nonatomic,strong)NSMutableArray<NSDictionary *> *messageData;
@property(nonatomic,strong)NSMutableArray<UIImageView *> *voiceImgs;

@end

@implementation HBYYTool

-(NSMutableArray *)messageData{
    if (!_messageData) {
        _messageData = [NSMutableArray array];
//        [_messageData addObject:@{@"id":@"robot",@"message":@"你好"}];
    }
    return _messageData;
}

-(NSMutableArray *)voiceImgs{
    if (!_voiceImgs) {
        _voiceImgs = [NSMutableArray array];
    }
    return _voiceImgs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"yuyin_beijing"]];
    
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:Sc_bounds];
    backImg.image = [UIImage imageNamed:@"yuyin_beijing"];
    [self.view addSubview:backImg];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 35, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backTohomeViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *helpBtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 35, 35, 30, 30)];
    [helpBtn setImage:[UIImage imageNamed:@"yuyin_icon_bangzhu"] forState:UIControlStateNormal];
    [helpBtn addTarget:self action:@selector(helpClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:helpBtn];
    
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(36, 60, Sc_w - 72, Sc_h/2 - 40) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    
    
    _talkBtn = [[UIButton alloc]initWithFrame:CGRectMake((Sc_w - 166)/2, Sc_h - 166 - 80, 166, 166)];
    _talkBtn.adjustsImageWhenHighlighted = NO;
    [_talkBtn setBackgroundImage:[UIImage imageNamed:@"yuyin_yuan"] forState:UIControlStateNormal];
    [_talkBtn setImage:[UIImage imageNamed:@"yuyin_icon_maikefang"] forState:UIControlStateNormal];
    [_talkBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 20, 0)];
    
    
    _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _talkBtn.frame.size.height/2 + 10, _talkBtn.frame.size.width, 30)];
    _tipLabel.text = @"按住说话";
    _tipLabel.textColor = Color_system;
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    [_talkBtn addSubview:_tipLabel];
//    _talkBtn.adj
    [self.view addSubview:_talkBtn];
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpress:)];
    [_talkBtn addGestureRecognizer:press];
    
    //初始化讯飞
    [self initIfly];
    
    for (int i = 0; i<30; i++) {
        [self initwithIndex:i];
    }
    
    tipLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, Sc_w, 200)];
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.numberOfLines = 0;
    tipLab.textColor = [UIColor whiteColor];
    tipLab.font = [UIFont systemFontOfSize:18];
    tipLab.text = @"您可以这样说\n\n关灯\n\n开灯\n\n关窗帘\n\n开窗帘";
    [self.view addSubview:tipLab];
    
}

- (void)initwithIndex:(int)index{
    
    CGFloat space = (Sc_w - _talkBtn.mj_w)/30;
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _talkBtn.mj_w + space * index, _talkBtn.mj_h + space * index)];
    imgV.layer.cornerRadius = imgV.mj_w/2;
    imgV.layer.borderWidth = 1;
    imgV.layer.masksToBounds = YES;
    imgV.layer.borderColor = [[UIColor whiteColor] CGColor];
    imgV.alpha = 0.4 - 0.01 * index;
    imgV.center = _talkBtn.center;
    [self.view addSubview:imgV];
    imgV.hidden = YES;
    
    NSLog(@"%f",imgV.alpha);
    
    [self.voiceImgs addObject:imgV];
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetRGBStrokeColor(context, 255.0, 255.0, 255.0, alpha);
//    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
//    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
//    CGContextAddArc(context, _talkBtn.mj_x + _talkBtn.mj_w/2, _talkBtn.mj_y + _talkBtn.mj_h/2, _talkBtn.mj_w/2 + space * index, 0, 2*M_PI, 0); //添加一个圆
//    CGContextDrawPath(context, kCGPathStroke);
}


-(void)initIfly{
    _iFlySpeechRecognizer = [RecognizerFactory CreateRecognizer:self Domain:@"iat"];
    _uploader = [[IFlyDataUploader alloc] init];
    [self onUploadUserWord];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ToolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pools"];
    
    NSDictionary *info = self.messageData[indexPath.row];
    
    if (!cell) {
        cell = [[ToolTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"pools"];
    }
    if ([info[@"id"] isEqualToString:@"robot"]) {
        cell.content.textAlignment = NSTextAlignmentLeft;
    }else{
        cell.content.textAlignment = NSTextAlignmentRight;
    }
    cell.content.text = info[@"message"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



-(void)longpress:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"开始录音");
        [_talkBtn setBackgroundImage:[UIImage imageNamed:@"yuyin_yuan_anxia"] forState:UIControlStateNormal];
        [_iFlySpeechSynthesizer stopSpeaking];
        [_iFlySpeechRecognizer startListening];
        
    }else if (sender.state == UIGestureRecognizerStateEnded){
        NSLog(@"结束录音");
        [_talkBtn setBackgroundImage:[UIImage imageNamed:@"yuyin_yuan"] forState:UIControlStateNormal];
        [self performSelector:@selector(stopListening) withObject:nil afterDelay:1.0];
        
        
    }
}

-(void)stopListening{
    [_iFlySpeechRecognizer stopListening];
    //取消波纹
    for (UIImageView *imgV in self.voiceImgs) {
        if (!imgV.isHidden) {
            imgV.hidden = YES;
        }
    }
}

-(void)helpClick:(UIButton *)sender{
    
    if (!self.messageData.count) {
        return;
    }
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        tipLab.hidden = NO;
        tableView.hidden = YES;
    }else{
        tipLab.hidden = YES;
        tableView.hidden = NO;
    }
    
}

-(void)backTohomeViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    [self yyfuwu];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [self cancel];
}



-(void)yyfuwu{
    _reString=@"";
    self.isCanceled = NO;
    isTalking = NO;
    /*
     配置语音识别
     */
    
    //设置音频来源为麦克风
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    [_iFlySpeechRecognizer setDelegate:self];
    
    /*
     配置语音合成
     */
    
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    //设置协议委托对象
    _iFlySpeechSynthesizer.delegate = self;
    //设置合成参数
    //设置在线工作方式
    [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD]
                                  forKey:[IFlySpeechConstant ENGINE_TYPE]];
    //设置音量，取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"50"
                                  forKey: [IFlySpeechConstant VOLUME]];
    //发音人，默认为”xiaoyan”，可以设置的参数列表可参考“合成发音人列表”
    [_iFlySpeechSynthesizer setParameter:@" xiaoyan "
                                  forKey: [IFlySpeechConstant VOICE_NAME]];
    //保存合成文件名，如不再需要，设置为nil或者为空表示取消，默认目录位于library/cache下
    [_iFlySpeechSynthesizer setParameter:@" tts.pcm"
                                  forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
    
    [_iFlySpeechSynthesizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
//    [_iFlySpeechSynthesizer startSpeaking: @"你好。"];
    
    
}

-(void)cancel
{
    //取消识别
    [_iFlySpeechRecognizer cancel];
    [_iFlySpeechRecognizer setDelegate: nil];
    
    [_iFlySpeechSynthesizer stopSpeaking];
    _iFlySpeechSynthesizer.delegate = nil;
    
    [self backTohomeViewController];
    
    NSLog(@"取消识别");
}
#pragma mark - IFlySpeechRecognizerDelegate

/**
 * @fn      onVolumeChanged
 * @brief   音量变化回调
 *
 * @param   volume      -[in] 录音的音量，音量范围1~100
 * @see
 */
- (void) onVolumeChanged: (int)volume
{
    
//    if (self.isCanceled) {
//
//        [self cancel];
//
//        return;
//    }
    
    double ff = volume * 0.3;
    int index = floor(ff);

    NSLog(@"index - %i",index);
    for (int i = 0; i< self.voiceImgs.count; i++) {
        
        if (i<index) {
            self.voiceImgs[i].hidden = NO;
        }else{
            self.voiceImgs[i].hidden = YES;
        }
    }
    
    
//    [voiceHud_ setProgress:volume/60.0f];
    
}

/*!
 *  开始录音回调<br>
 *  当调用了`startListening`函数之后，如果没有发生错误则会回调此函数。<br>
 *  如果发生错误则回调onError:函数
 */
- (void) onBeginOfSpeech
{
    isTalking = [_iFlySpeechSynthesizer isSpeaking];
    if (isTalking) {
//        [_iFlySpeechRecognizer cancel];
        
        NSLog(@"正在说话");
    }
    NSLog(@"onBeginOfSpeech");
}

/*!
 *  停止录音回调<br>
 *  当调用了`stopListening`函数或者引擎内部自动检测到断点，如果没有发生错误则回调此函数。<br>
 *  如果发生错误则回调onError:函数
 */
- (void) onEndOfSpeech
{
    //    [self showVoiceHudOrHide:NO];
    
    NSLog(@"onEndOfSpeech");
    
}


/**
 * @fn      onError
 * @brief   识别结束回调
 *
 * @param   errorCode   -[out] 错误类，具体用法见IFlySpeechError
 */
- (void) onError:(IFlySpeechError *) error
{
    if (isTalking) {
        return;
    }
    NSString *text ;
    
    if (self.isCanceled) {
        text = @"识别取消";
    }
    else if (error.errorCode == 0 ) {
        
        if (_reString.length==0) {
            text = @"无识别结果";
        }
        else
        {
            text = @"识别成功";
        }
    }
    else
    {
        text = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errorDesc];
    }
    
    NSLog(@"识别结束错误回调 %@",text);
    
    
    
}

/**
 * @fn      onResults
 * @brief   识别结果回调
 *
 * @param   result      -[out] 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，value为置信度
 * @see
 */
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    if(isLast){
        return;
    }
    NSMutableString *resultString = [[NSMutableString alloc] init];
    
    NSDictionary *dic = results[0];
    
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    NSString * resultFromJson =  [[ISRDataHelper shareInstance] getResultFromJson:resultString];
    
    NSLog(@"听写结果：%@ %i",resultFromJson,isLast);
    
    [self reloadMessage:@"user" andMessage:[NSString stringWithFormat:@"“%@”",resultFromJson]];
    
    AppDelegate * appd = (AppDelegate*)[UIApplication sharedApplication].delegate;
    for (ChainModel *m  in appd.models) {
        if ([resultFromJson containsString:m.modelName])
        {
            
            [_iFlySpeechSynthesizer startSpeaking:@"已执行"];
            [self reloadMessage:@"robot" andMessage:@"已执行"];
            [BaseHttpService sendRequestAccess: [NSString stringWithFormat:@"%@/smarthome.IMCPlatform/xingUser/commandmodel.action",BaseHttpUrl] parameters:@{@"modelId":m.modelId} success:^(id backJson) {
            }];
            
            return;
        }
    }
    
    [_iFlySpeechSynthesizer startSpeaking:@"您还没有添加这个情景,请先添加情景"];
    [self reloadMessage:@"robot" andMessage:@"您还没有添加这个情景,请先添加情景"];
    if (isLast)
    {
        // NSLog(@"听写结果(json)：%@",  _reString);
    }
    
    NSLog(@"isLast=%d",isLast);
}

-(void)reloadMessage:(NSString *)ident andMessage:(NSString *)message{
    tableView.hidden = NO;
    [self.messageData addObject:@{@"id":ident,@"message":message}];
    [tableView reloadData];
    NSIndexPath *lastRow = [NSIndexPath indexPathForRow:self.messageData.count - 1 inSection:0];
    [tableView scrollToRowAtIndexPath:lastRow atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    tipLab.hidden = YES;
}

/**
 * @fn      onCancel
 * @brief   取消识别回调
 * 当调用了`cancel`函数之后，会回调此函数，在调用了cancel函数和回调onError之前会有一个短暂时间，您可以在此函数中实现对这段时间的界面显示。
 * @param
 * @see
 */
- (void) onCancel
{
    NSLog(@"取消识别回调");
}

#pragma mark - IFlyDataUploaderDelegate

/**
 * @fn  onUploadFinished
 * @brief   上传完成回调
 * @param grammerID 上传用户词为空
 * @param error 上传错误
 */
- (void) onUploadFinished:(NSString *)grammerID error:(IFlySpeechError *)error
{
    NSLog(@"上传完成 = %d",[error errorCode]);
}



//合成结果回调
-(void)onCompleted:(IFlySpeechError *)error
{
    NSLog(@"onCompleted error=%d",[error errorCode]);
    [_iFlySpeechRecognizer cancel];
    NSString *text = nil;
    
    if (self.isCanceled)
    {
        text = @"合成已取消";
    }
    else if (error.errorCode ==0 )
    {
        text = @"合成结束";
    }
    else
    {
        ShowMsg(@"发生未知错误");
        text = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errorDesc];
//        [_iFlySpeechSynthesizer startSpeaking:@"发生未知错误,请退出后重试。"];
        // self.hasError = YES;
    }
    
    
    isTalking = NO;
    NSLog(@"合成结束 = %@",text);
}

- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos{
    
    NSLog(@"当前播放进度 = %i",progress);
}
#pragma mark - Button Handler
/*
 * @上传用户词
 */
#define NAME @"myuserwords"
#define USERWORDS   @"{\"userword\":[{\"name\":\"iflytek\",\"words\":[\"回家\",\"2档\",\"3档\",\"开启\",\"关闭\",\"开\",\"关\",\"加湿\",\"干燥\",\"摆风\",\"静止\",\"自然\",\"温控\",\"标准\",\"智能\",\"睡眠\",\"离子\",\"指示\",\"摇头\"]}]}"

- (void) onUploadUserWord
{
    
    [self.uploader setParameter:@"iat" forKey:[IFlySpeechConstant SUBJECT]];
    [self.uploader setParameter:@"userword" forKey:[IFlySpeechConstant DATA_TYPE]];
    
    IFlyUserWords *iFlyUserWords = [[IFlyUserWords alloc] initWithJson:USERWORDS ];
    
    [self.uploader uploadDataWithCompletionHandler:^(NSString * grammerID, IFlySpeechError *error)
     {
         [self onUploadFinished:grammerID error:error];
         
     } name:NAME data:[iFlyUserWords toString]];
    
}

@end
