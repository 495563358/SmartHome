//
//  CameraManagerVC.m
//  SmartHome
//
//  Created by Smart house on 2018/1/4.
//  Copyright © 2018年 sunzl. All rights reserved.
//

#import "CameraManagerVC.h"

#import "SmartHome-Swift.h"

#import "UserPwdSetViewController.h"

#import "CameraTableViewCell.h"

#import "UIView+Toast.h"

#import "Wrapper.h"

#import "MyAudioSession.h"

//#import "SettingViewController.h"

#import "WifiSettingViewController.h"

#import "SystemUpgradeViewController.h"

#import "DateTimeController.h"

#import "AlarmController.h"

#import "RecordScheduleSettingViewController.h"

#import "MotionPushPlanViewController.h"

#import "FtpSettingViewController.h"

#import "MailSettingViewController.h"

#import "CameraSettingMoreTableViewController.h"

@interface CameraManagerVC ()<UITableViewDataSource,UITableViewDelegate,PPPPStatusProtocol,SnapshotProtocol>{
    CPPPPChannelManagement *m_pPPPPChannelMgt ;
    CameraListMgt* cameraListMgt;
    UITableView *tableview;
    
    NSCondition *ppppChannelMgntCondition;
}

@end

@implementation CameraManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"摄像头管理";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhui(b)"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    
    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backClick)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGes];
    
    tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 35)];
    label.text = @"温馨提示：点击左侧图像可查看详情";
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    if (!m_pPPPPChannelMgt){
        m_pPPPPChannelMgt = new CPPPPChannelManagement();
        cameraListMgt = [[CameraListMgt alloc] init];
        //设置代理
        m_pPPPPChannelMgt->pCameraViewController = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self Initialize:nil];
        });
    }
    
    self.navigationController.navigationBarHidden = NO;
    
    self.cameras = [[DataDeal sharedDataDeal] searchAllSXTModel];
    
    
    for (int i = 0;i<[cameraListMgt GetCount];i++) {
        NSDictionary *dict = [cameraListMgt GetCameraAtIndex:i];
        NSLog(@"本地所有信息 = %@",dict);
    }
    
    __block int index = 0;
    for (Equip *temp in _cameras) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self ConnectCam:temp.equipID user:@"admin" psw:temp.num];
            [cameraListMgt AddCamera:temp.name DID:temp.equipID User:@"admin" Pwd:temp.num Snapshot:[UIImage imageNamed:@"fangjian"]];
            
            BOOL isture2 = [cameraListMgt UpdateCameraAuthority:temp.equipID User:@"admin" Pwd:temp.num];
            bool isture = [cameraListMgt CheckCamere:temp.equipID];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary *dict = [cameraListMgt GetCameraAtIndex:[cameraListMgt GetIndexFromDID:temp.equipID]];
                
                NSLog(@"服务器端保存数据 = %@",temp.equipID);
                NSLog(@"服务器端保存数据 = %@",temp.name);
                NSLog(@"服务器端保存数据 = %@",temp.type);
                NSLog(@"服务器端保存数据 = %@",temp.num);
                NSLog(@"服务器端保存数据 = %@",temp.status);
                
                NSLog(@"摄像机信息 = %@",dict);
                
                NSLog(@"更新摄像机 = %i  检查摄像机 = %i",isture2,isture);
                [self->tableview reloadData];
                
                index++;
            });
        });
        
    }
    
}


- (void) StartPPPPThread
{
    NSLog(@"StartPPPPThread");
    [ppppChannelMgntCondition lock];
    if (m_pPPPPChannelMgt == NULL) {
        [ppppChannelMgntCondition unlock];
        return;
    }
    [NSThread detachNewThreadSelector:@selector(StartPPPP:) toTarget:self withObject:nil];
    [ppppChannelMgntCondition unlock];
}


- (void) StartPPPP:(id) param
{
    sleep(1);
    
    int count = [cameraListMgt GetCount];
    
    int i;
    for (i = 0; i < count; i++) {
        NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:i];
        
        NSString *strDID = [cameraDic objectForKey:@STR_DID];
        NSString *strUser = [cameraDic objectForKey:@STR_USER];
        NSString *strPwd = [cameraDic objectForKey:@STR_PWD];
        NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
        if ([nPPPPStatus intValue] == PPPP_STATUS_INVALID_ID) {
            continue;
        }
        
        usleep(100000);
        m_pPPPPChannelMgt->Start([strDID UTF8String], [strUser UTF8String], [strPwd UTF8String]);
        
    }
}

//刷新
- (void) refresh: (id) sender
{
    [self UpdateCameraSnapshot];
}

- (void) UpdateCameraSnapshot
{
    int count = self.cameras.count;
    if (count == 0) {
        return;
    }
    
    for (Equip *temp in self.cameras) {
        NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:[cameraListMgt GetIndexFromDID:temp.equipID]];
        if (cameraDic == nil) {
            return ;
        }
        
        NSNumber *nPPPPStatus = [cameraDic objectForKey:@STR_PPPP_STATUS];
        if ([nPPPPStatus intValue] != PPPP_STATUS_ON_LINE) {
            continue;
        }
        
        NSString *did = [cameraDic objectForKey:@STR_DID];
        m_pPPPPChannelMgt->Snapshot([did UTF8String]);
        
        NSLog(@"UpdateCameraSnapshot...count: %d", self.cameras.count);
    }
}

- (void) NotifyReloadData{
    NSLog(@"sdadasdasdasd");
}

//根据设备号刷新列表
- (void) ReloadRowDataAtIndex: (NSString *)strDID
{
    int indexNumber = 0;
    for (Equip *temp in self.cameras) {
        if ([temp.equipID isEqualToString:strDID]) {
            break;
        }
        indexNumber++;
    }
    NSLog(@"根据设备号刷新列表 = %i",indexNumber);
    if (indexNumber == self.cameras.count) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexNumber inSection:0];
    UITableViewCell *cell = [tableview cellForRowAtIndexPath:indexPath];
    if (cell != nil) {
        NSArray *array = [NSArray arrayWithObject:indexPath];
        [tableview reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    }
}


- (void) StopPPPPByDID:(NSString*)did
{
    m_pPPPPChannelMgt->Stop([did UTF8String]);
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
    m_pPPPPChannelMgt->Start([cameraID UTF8String], [user UTF8String], [psw UTF8String]);
}

-(void)backClick{
    [self StopPPPP];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) StopPPPP
{
    [ppppChannelMgntCondition lock];
    if (m_pPPPPChannelMgt == NULL) {
        [ppppChannelMgntCondition unlock];
        return;
    }
    m_pPPPPChannelMgt->StopAll();
    [ppppChannelMgntCondition unlock];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cameras.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CameraTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"pool%i",indexPath.row]];
    
    Equip *temp = self.cameras[indexPath.row];
    
    NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:[cameraListMgt GetIndexFromDID:temp.equipID]];
    if (!cell) {
        cell = [[CameraTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"pool%i",indexPath.row]];
        cell.titleL.text = [NSString stringWithFormat:@"%@(%@)",temp.name,self.roomDict[temp.roomCode]];
        cell.textL.text = temp.equipID;
        cell.cameraBtn.tag = indexPath.row;
        [cell.cameraBtn addTarget:self action:@selector(catCameraClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (UIImageJPEGRepresentation(cameraDic[@"img"], 1)) {
        cell.imageV.image = cameraDic[@"img"];
    }else{
        cell.imageV.image = [UIImage imageNamed:@"fangjian"];
    }
    
    NSNumber *nPPPPStatus = [cameraDic objectForKey:@"ppppstatus"];
    NSString *strPPPPStatus = nil;
    switch ([nPPPPStatus intValue]) {
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
            strPPPPStatus = NSLocalizedStringFromTable(@"非法ID", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"在线", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DEVICE_NOT_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"不在线", @STR_LOCALIZED_FILE_NAME, nil);
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
    cell.statusLab.text = strPPPPStatus;
    if (([nPPPPStatus intValue] == PPPP_STATUS_ON_LINE) && [temp.num isEqualToString:@"888888"]) {
        cell.warnBtn.hidden = NO;
    }else{
        cell.warnBtn.hidden = YES;
    }
    
    return cell;
}

//列表选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Equip *temp = self.cameras[indexPath.row];
    int num = [cameraListMgt GetIndexFromDID:temp.equipID];
    NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:num];
    NSNumber *nPPPPStatus = [cameraDic objectForKey:@"ppppstatus"];
    
    if ([nPPPPStatus intValue] != 2) {
        [self.view makeToast:@"摄像机不在线"];
        return;
    }
    
    
    NSString *m_strDID = [cameraDic objectForKey:@STR_DID];
    NSString *m_strPWD = [cameraDic objectForKey:@STR_PWD];
    
    CameraSettingMoreTableViewController *vc = [CameraSettingMoreTableViewController new];
    vc.cameraListMgt = cameraListMgt;
    vc.m_pPPPPChannelMgt = m_pPPPPChannelMgt;
    vc.temp = temp;
    vc.m_strDID = m_strDID;
    vc.m_strPWD = m_strPWD;
    [self.navigationController pushViewController:vc animated:YES];
    
    //修改摄像头密码
//    UserPwdSetViewController *UserPwdSettingView = [[UserPwdSetViewController alloc] init];
//    UserPwdSettingView.m_pChannelMgt = m_pPPPPChannelMgt;
//    UserPwdSettingView.cameraListMgt = cameraListMgt;
//    UserPwdSettingView.m_strDID = temp.equipID;
//    UserPwdSettingView.cameraName = temp.name;
//    UserPwdSettingView.equip = temp;
//    [self.navigationController pushViewController:UserPwdSettingView animated:YES];
//    
//    
//    MailSettingViewController *mailSettingView = [[MailSettingViewController alloc] init];
//    mailSettingView.m_pChannelMgt = m_pPPPPChannelMgt;
//    mailSettingView.m_strDID = m_strDID;
//    [self.navigationController pushViewController:mailSettingView animated:YES];
//    
//    //FTP设置
//    FtpSettingViewController *ftpSettingView = [[FtpSettingViewController alloc] init];
//    ftpSettingView.m_pChannelMgt = m_pPPPPChannelMgt;
//    ftpSettingView.m_strDID = m_strDID;
//    [self.navigationController pushViewController:ftpSettingView animated:YES];
//    
//    
//    //移动侦测报警计划设置
//    MotionPushPlanViewController *motionPushPlan = [[MotionPushPlanViewController alloc] init];
//    motionPushPlan.m_PPPPChannelMgt = m_pPPPPChannelMgt;
//    motionPushPlan.m_strDID = m_strDID;
//    motionPushPlan.navigationItem.title = @"移动侦测报警计划";
//    [self.navigationController pushViewController:motionPushPlan animated:YES];
//    
//    
//    
//    //SD卡
//    RecordScheduleSettingViewController* sdcardSet = [[RecordScheduleSettingViewController alloc] initWithNibName:@"RecordScheduleSettingViewController" bundle:nil];
//    sdcardSet.m_PPPPChannelMgt = m_pPPPPChannelMgt;
//    sdcardSet.m_strDID = m_strDID;
//    sdcardSet.navigationItem.title = NSLocalizedStringFromTable(@"SDSetting", @STR_LOCALIZED_FILE_NAME, nil);
//    [self.navigationController pushViewController:sdcardSet animated:YES];
//    
//    
//    //报警系统
//    AlarmController *AlarmSettingView = [[AlarmController alloc] init];
//    AlarmSettingView.m_pChannelMgt = m_pPPPPChannelMgt;
//    AlarmSettingView.m_strDID = m_strDID;
//    [self.navigationController pushViewController:AlarmSettingView animated:YES];
//    
//    
//    
//    //时间设置
//    DateTimeController *DateTimeSettingView = [[DateTimeController alloc] init];
//    DateTimeSettingView.m_pChannelMgt = m_pPPPPChannelMgt;
//    DateTimeSettingView.m_strDID = m_strDID;
//    [self.navigationController pushViewController:DateTimeSettingView animated:YES];
//    
//    
//    
//    //系统固件升级
//    SystemUpgradeViewController* sysUpgrade = [[SystemUpgradeViewController alloc] initWithNibName:@"SystemUpgradeViewController" bundle:nil];
//    sysUpgrade.navigationItem.title = NSLocalizedStringFromTable(@"FirmwareUpgrade", @STR_LOCALIZED_FILE_NAME, nil);
//    sysUpgrade.m_pPPPPChannelMgt = m_pPPPPChannelMgt;
//    sysUpgrade.str_uid = m_strDID;
//    sysUpgrade.str_pwd = m_strPWD;
//    [self.navigationController pushViewController:sysUpgrade animated:YES];
//    
//    //WIFI 列表
//    WifiSettingViewController *wifiSettingView = [[WifiSettingViewController alloc] init];
//    wifiSettingView.m_pPPPPChannelMgt = m_pPPPPChannelMgt;
//    wifiSettingView.m_strDID = m_strDID;
//    [self.navigationController pushViewController:wifiSettingView animated:YES];
    
    
//    SettingViewController* settingViewCtr = [[SettingViewController alloc] init];
//    settingViewCtr.cameraListMgt = cameraListMgt;
//    settingViewCtr.m_pPPPPChannelMgt = m_pPPPPChannelMgt;
//    settingViewCtr.m_strDID = [cameraDic objectForKey:@STR_DID];
//    settingViewCtr.cameraDic = cameraDic;
//    [self.navigationController pushViewController:settingViewCtr animated:YES];
    
    
    
}

//点击查看摄像机
-(void)catCameraClick:(UIButton *)sender{
    
    Equip *temp = self.cameras[sender.tag];
    int num = [cameraListMgt GetIndexFromDID:temp.equipID];
    NSDictionary *cameraDic = [cameraListMgt GetCameraAtIndex:num];
    NSNumber *nPPPPStatus = [cameraDic objectForKey:@"ppppstatus"];
    
    NSLog(@"%@",nPPPPStatus);
    
    if ([nPPPPStatus intValue] != 2) {
        [self.view makeToast:@"摄像机不在线"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:mainWindowss animated:true];
    [[Wrapper new] pushCamera:self dict:@{@"cameraID":temp.equipID,@"username":@"admin",@"password":temp.num}];
    
}


#pragma mark -
#pragma mark PPPPStatusNotify
//获取状态协议
- (void) PPPPStatus:(NSString *)strDID statusType:(NSInteger)statusType status:(NSInteger)status
{
    NSLog(@"相机状态响应  相机DID: %@, 类型: %d, 状态码: %d", strDID, statusType, status);
    
    if (statusType == MSG_NOTIFY_TYPE_PPPP_MODE) {
        NSInteger index = [cameraListMgt UpdatePPPPMode:strDID mode:status];
        if ( index >= 0){
            [self performSelectorOnMainThread:@selector(ReloadRowDataAtIndex:) withObject:strDID waitUntilDone:NO];
        }
        return;
    }
    
    if (statusType == MSG_NOTIFY_TYPE_PPPP_STATUS) {
        NSInteger index = [cameraListMgt UpdatePPPPStatus:strDID status:status];
        
        if ( index >= 0){
            
            int number = 0;
            for (Equip *temp in self.cameras) {
                if ([temp.equipID isEqualToString:strDID]) {
                    [self performSelectorOnMainThread:@selector(ReloadRowDataAtIndex:) withObject:strDID waitUntilDone:NO];
                    break;
                }
                number ++;
            }
            //[self performSelectorOnMainThread:@selector(ReloadCameraTableView) withObject:nil waitUntilDone:NO];
        }
        //如果是ID号无效，则停止该设备的P2P
        if (status == PPPP_STATUS_INVALID_ID
            || status == PPPP_STATUS_CONNECT_TIMEOUT
            || status == PPPP_STATUS_DEVICE_NOT_ON_LINE
            || status == PPPP_STATUS_CONNECT_FAILED
            || status == PPPP_STATUS_INVALID_USER_PWD) {
            [self performSelectorOnMainThread:@selector(StopPPPPByDID:) withObject:strDID waitUntilDone:NO];
        }
        if (status == 2) {
            [self UpdateCameraSnapshot];
            [_RecordNotifyEventDelegate NotifyReloadData];
        }
        return;
    }
}


#pragma mark -
#pragma mark SnapshotNotify
//保存截图协议
- (void) SnapshotNotify: (NSString*) strDID data:(char*) data length:(int) length{
    NSLog(@"CameraViewController SnapshotNotify... strDID: %@, length: %d", strDID, length);
    if (length < 20) {
        return;
    }
    
    //显示图片
    NSData *image = [[NSData alloc] initWithBytes:data length:length];
    if (image == nil) {
        
        return;
    }
    
    UIImage *img = [[UIImage alloc] initWithData:image];
    
    
    UIImage *imgScale = [self imageWithImage:img scaledToSize:CGSizeMake(160, 120)];
    
    NSInteger index = [cameraListMgt UpdateCamereaImage:strDID  Image:imgScale] ;
    if (index >= 0) {
        [self saveSnapshot:imgScale DID:strDID];
        [self performSelectorOnMainThread:@selector(ReloadRowDataAtIndex:) withObject:strDID waitUntilDone:NO];
    }
    
    
}



- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    NSData *dataImg = UIImageJPEGRepresentation(newImage, 1.0);
    UIImage *imgOK = [UIImage imageWithData:dataImg];
    
    // Return the new image.
    return imgOK;
}

- (void) saveSnapshot: (UIImage*) image DID: (NSString*) strDID
{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:strDID];
    //NSLog(@"strPath: %@", strPath);
    
    [fileManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    //[fileManager createDirectoryAtPath:strPath attributes:nil];
    
    
    strPath = [strPath stringByAppendingPathComponent:@"snapshot.jpg"];
    NSLog(@"截图已保存 strPath: %@", strPath);
    
    NSData *dataImage = UIImageJPEGRepresentation(image, 1.0);
    [dataImage writeToFile:strPath atomically:YES ];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
