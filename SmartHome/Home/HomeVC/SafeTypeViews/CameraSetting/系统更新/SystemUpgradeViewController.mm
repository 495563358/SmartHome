//
//  SystemUpgradeViewController.m
//  P2PCamera
//
//  Created by yan luke on 13-7-26.
//
//

#import "SystemUpgradeViewController.h"
#import "obj_common.h"
#import "cmdhead.h"
#import "DownloadFile.h"
#import "MBProgressHUD.h"

//#define mAppDelegate ((IpCameraClientAppDelegate*)[UIApplication sharedApplication].delegate)
#define FIRMWARE_URL @"http://api4.eye4.cn:808/firmware/%@/CN"

@interface SystemUpgradeViewController ()
{
    NSTimer *startTimer;
    NSMutableData *firmwareData;
    NSMutableData *bodyData;
    NSURLConnection *firmwareConnection;
    NSURLConnection *bodyConnection;
    MBProgressHUD *loadHUD;
}
@property (nonatomic, retain) NSString* cam_sysver;
@property (nonatomic, retain) NSString* cam_appver;
@property (nonatomic, retain) NSString* oem_id;

@property (nonatomic, retain) NSString* newest_sysver;
@property (nonatomic, retain) NSString* newest_Server;
@property (nonatomic, retain) NSString* newest_sysFileName;

@property (nonatomic, retain) NSString* newest_appver;
@property (nonatomic, retain) NSString* newest_appFileName;

@property (nonatomic, retain) NSString* tempStr;
@property (nonatomic, assign) BOOL isSysInfo;

@property (nonatomic, assign) int numberofSections;
@property (nonatomic, assign) int numofRows;

@property (nonatomic, assign) NSString* download_file;
@property (nonatomic, assign) NSString* download_server;
@property (nonatomic, assign) NSString* name;

@property (nonatomic, retain) NSString* firmware_name;
@property (nonatomic, retain) NSString* firmware_file;
@property (nonatomic, retain) NSString* firmware_server;

@property(nonatomic,retain) UIButton *firmware;

@property (nonatomic, retain) UIActivityIndicatorView* activityIndicatorV;

@property (nonatomic, retain) NSTimer* timer;
@end

@implementation SystemUpgradeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        firmwareData = [[NSMutableData alloc] init];
        bodyData = [[NSMutableData alloc] init];
    }
    return self;
}

- (void) popVIew:(id) sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //  获取ip的前提
    m_pSearchDVS = new CSearchDVS();
    m_pSearchDVS->searchResultDelegate = self;
    m_pSearchDVS->Open();   //  开启了就要关闭【m_pSearchDVS->Close();】
    //  获取ip结束
    
    self.numberofSections = 0;
    self.numofRows = 0;
    _aTabelView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _aTabelView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _aTabelView.delegate = self;
    _aTabelView.dataSource = self;
    _aTabelView.backgroundView = [[UIView alloc] init];
    _aTabelView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_aTabelView];
    
    self.activityIndicatorV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicatorV.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
    self.activityIndicatorV.center = [UIApplication sharedApplication].keyWindow.center;
    [self.view addSubview:self.activityIndicatorV];
    [self.activityIndicatorV startAnimating];
    
    UIView* footView = [[UIView alloc] initWithFrame:CGRectZero];
    self.aTabelView.tableFooterView = footView;
//    [footView release],footView = nil;
    self.aTabelView.scrollEnabled = NO;
    
    _m_pPPPPChannelMgt->SetCameraStatusDelegate((char*)[self.str_uid UTF8String], self);
    _m_pPPPPChannelMgt->GetCGI([self.str_uid UTF8String], CGI_IEGET_STATUS);
    
    startTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(startNetworkRequest) userInfo:nil repeats:YES];
    
    //  升级按钮
    self.firmware = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.firmware.frame = CGRectMake(0, 280, [UIScreen mainScreen].bounds.size.width, 40);
    [self.firmware setTitle:NSLocalizedStringFromTable(@"PFZB_UPGRADE_INFO_ADD", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    self.firmware.tintColor = [UIColor whiteColor];
    self.firmware.hidden = YES;
    [self.firmware addTarget:self action:@selector(FirmwareUpgrade) forControlEvents:UIControlEventTouchUpInside];
    self.firmware.backgroundColor = [UIColor colorWithRed:0/255.0 green:198./255.0 blue:243.0/255.0 alpha:1];
    [self.view addSubview:self.firmware];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPostRequest:) name:@"downloadSuccess" object:nil];
}

//  获取ip的代理
- (void) SearchCameraResult:(NSString *)mac Name:(NSString *)name Addr:(NSString *)addr Port:(NSString *)port DID:(NSString*)did{
    if ([did length] == 0) {
        return;
    }
    
    if ([did isEqualToString:self.str_uid]) {
        self.str_ipaddr = addr;
        self.str_port = port;
        NSLog(@" 对应 ip %@,%@,%@",did,addr,port);
        m_pSearchDVS->Close();
    }
    
}

-(void) startPostRequest:(NSNotification *)notifaction{
    NSString *isOK = [notifaction object];
    if ([isOK integerValue] == 1) {
        
        [loadHUD hide:YES];
        
        //  post 指令
        NSData * data =[NSData dataWithContentsOfFile:[self getPath]];
        NSLog(@"data.length %ld",(unsigned long)data.length);
        
        NSString *urlPath = [NSString stringWithFormat:@"http://%@:%@/upgrade_firmware.cgi?next_url=reboot.htm&loginuse=admin&loginpas=%@&user=admin&pwd=%@",_str_ipaddr,self.str_port,_str_pwd,_str_pwd];
        NSLog(@"post 升级 %@",urlPath);
        NSURL *url = [NSURL URLWithString:urlPath];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:data];
        bodyConnection = [NSURLConnection connectionWithRequest:request delegate:self];
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"UpgradeTimeDes", @STR_LOCALIZED_FILE_NAME, nil) message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil), nil];
        alert.tag = 105;
        [alert show];
//        [alert release],alert = nil;
        
    }else if ([isOK integerValue] == 0){

        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Message", @STR_LOCALIZED_FILE_NAME, nil) message:NSLocalizedStringFromTable(@"PFZB_UPGRADE_UPCANCEL_ADD", @STR_LOCALIZED_FILE_NAME, nil) delegate:nil cancelButtonTitle:nil otherButtonTitles: NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil),nil];
        [alert show];
//        [alert release],alert = nil;
    }
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (_timer != nil) {
        [_timer invalidate];
        self.timer = nil;
    }
}

#pragma mark -
#pragma mark UITableViewDelegate  DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _numberofSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _numofRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* celliden = @"cellIden";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:celliden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:celliden];
    }
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.text = NSLocalizedStringFromTable(@"SysFirmware", @STR_LOCALIZED_FILE_NAME, nil);
    
    if (indexPath.section == 0) {
        
        cell.detailTextLabel.text = self.cam_sysver;
        
    }else if (indexPath.section == 1){
        
        cell.detailTextLabel.text = self.firmware_name;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 20, 40)];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, [UIScreen mainScreen].bounds.size.width - 20, 20)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor lightGrayColor];
    if (section == 0) {
        headerLabel.text = NSLocalizedStringFromTable(@"CamFirmwareInfo", @STR_LOCALIZED_FILE_NAME, nil);
        
    }else if(section == 1){
        headerLabel.text = NSLocalizedStringFromTable(@"NewestFirmwareInfo", @STR_LOCALIZED_FILE_NAME, nil);
    }
    [customView addSubview:headerLabel];
    return customView;
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100 || alertView.tag == 101) {
        if (buttonIndex == 1) {
            
            //  mAppDelegate->m_pPPPPChannelMgt
            
            NSLog(@"%@=+++%@",self.firmware_server,self.firmware_file);
            _m_pPPPPChannelMgt->FirmwareUpgrade([self.str_uid UTF8String], (char*)[self.firmware_server UTF8String], (char*)[self.firmware_file UTF8String], 0);
            
            NSLog(@"gujianshengji %@--- %@ --- %@",self.str_uid,self.firmware_server,self.firmware_file);
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"UpgradeTimeDes", @STR_LOCALIZED_FILE_NAME, nil) message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil), nil];
            alert.tag = 105;
            [alert show];
//            [alert release],alert = nil;
        }
    }else if (alertView.tag == 105){
        if (buttonIndex == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}
#pragma mark CameraStatusProtocol
- (void) PPPPCameraStatusSysver:(char*) sysv appver:(char*) appv oemid:(char*) oemid{
    self.cam_appver = [NSString stringWithUTF8String:appv];
    self.cam_sysver = [NSString stringWithUTF8String:sysv];
    self.oem_id = [NSString stringWithUTF8String:oemid];
    
    self.numberofSections = 2;
    self.numofRows = 1;
    
    if ([_timer isValid]) {
        [_timer invalidate];
    }
}

-(void) startNetworkRequest
{
    if (self.cam_sysver != nil) {
        [startTimer invalidate];
        startTimer = nil;
        
        NSString *path = [NSString stringWithFormat:FIRMWARE_URL,self.cam_sysver];
        NSURL *url = [NSURL URLWithString:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        firmwareConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    }
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (connection == firmwareConnection) {
        [firmwareData setLength:0];
    }else if (connection == bodyConnection){
        [bodyData setLength:0];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == firmwareConnection) {
        [firmwareData appendData:data];
    }else if (connection == bodyConnection){
        [bodyData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == firmwareConnection) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:firmwareData options:NSJSONReadingMutableContainers error:nil];
        _download_file = json[@"download_file"];
        _download_server = json[@"download_server"];
        _name = json[@"name"];
        self.firmware_name = [NSString stringWithString:_name];
        self.firmware_file = [NSString stringWithString:_download_file];
        self.firmware_server = [NSString stringWithString:_download_server];
        NSLog(@"_download_file = %@,%@,%@",_download_file,_download_server,_name);
        NSLog(@"self.cam_sysver = %@",self.cam_sysver);
        [self.activityIndicatorV stopAnimating];
        
        [_aTabelView reloadData];
        
        //  判断是否有升级按钮
        if (![self.cam_sysver isEqualToString:self.firmware_name]) {
            self.firmware.hidden = NO;
        }
    }else if (connection == bodyConnection){
        NSLog(@"HTTP post");
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if (connection == bodyConnection) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Message", @STR_LOCALIZED_FILE_NAME, nil) message:NSLocalizedStringFromTable(@"PFZB_UPGRADE_UPCANCEL_ADD", @STR_LOCALIZED_FILE_NAME, nil) delegate:nil cancelButtonTitle:nil otherButtonTitles: NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil),nil];
        [alert show];
//        [alert release],alert = nil;
    }
}

//	获取路径
- (NSString *)getPath
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    return [path stringByAppendingPathComponent:@"CH-sys-48-50-64.bin"];
}

-(void) FirmwareUpgrade
{
    NSArray *array = [self.cam_sysver componentsSeparatedByString:@"."];
    if ([array[0] isEqualToString:@"48"] && [array[1] isEqualToString:@"50"] && [array[2] isEqualToString:@"64"] && [array[3] integerValue] < 49) {
    
        loadHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:loadHUD];
        loadHUD.labelText = NSLocalizedStringFromTable(@"PleaseWait", @STR_LOCALIZED_FILE_NAME, Nil);
        [loadHUD show:YES];
        
    //  网上下载
    //  http://download.eye4.cn/fm/UP_Firmware/TH-sys-48.5.64.27.bin
    
        DownloadFile *downloadFile = [[DownloadFile alloc] init];
        NSString *downloadPath = [NSString stringWithFormat:@"http://%@%@",self.firmware_server,self.firmware_file];
        [downloadFile startDownloadFile:downloadPath];
        
        
    }else{
        //  p2p指令
        if (![self.firmware_name isEqualToString:self.cam_sysver]) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Discoveryofnewversion", @STR_LOCALIZED_FILE_NAME, nil) message:[NSString stringWithFormat:@"%@(%@)",NSLocalizedStringFromTable(@"WhetherUpgradeNewest", @STR_LOCALIZED_FILE_NAME, nil),self.firmware_name] delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil), nil];
            alert.tag = 100;
            [alert show];
//            [alert release],alert = nil;
        }else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"NewestVer", @STR_LOCALIZED_FILE_NAME, nil) message:[NSString stringWithFormat:@"%@(%@)",NSLocalizedStringFromTable(@"WhetherUpgradeService", @STR_LOCALIZED_FILE_NAME, nil), self.firmware_name] delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil), nil];
            alert.tag = 101;
            [alert show];
//            [alert release],alert = nil;
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)shouldAutorotate{
    //UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    return NO;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc{
    
    _m_pPPPPChannelMgt->SetCameraStatusDelegate((char*)[self.str_uid UTF8String], nil);
    if (_timer != nil) {
        [_timer invalidate];
        self.timer = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"downloadSuccess" object:nil];
    
    //  关闭
    m_pSearchDVS->Close();

    self.str_uid = nil;
    self.str_pwd = nil;
    self.str_port = nil;
    self.str_ipaddr = nil;
//    [_activityIndicatorV release],_activityIndicatorV = nil;
//    [_aTabelView release],_aTabelView = nil;
//    [firmwareData release];
//    [bodyData release],bodyData = nil;
//    [super dealloc];
}
@end
