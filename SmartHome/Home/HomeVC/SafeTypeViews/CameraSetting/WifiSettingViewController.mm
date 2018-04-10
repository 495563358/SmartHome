//
//  WifiSettingViewController.m
//  P2PCamera
//
//  Created by mac on 12-10-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WifiSettingViewController.h"
#import "WifiPwdViewController.h"
#import "obj_common.h"


@interface WifiSettingViewController ()
@property (nonatomic, retain) UISwipeGestureRecognizer* swipeGes;
@end

@implementation WifiSettingViewController

@synthesize m_pPPPPChannelMgt;
@synthesize m_strSSID;
@synthesize m_strWEPKey;
@synthesize m_strWPA_PSK;
@synthesize m_strDID;
@synthesize navigationBar;

@synthesize wifiTableView;

#pragma mark -
#pragma mark system

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)handleTimer:(id)param
{    
    [self StopTimer];
    [self hideLoadingIndicator];  
    m_bFinished = YES;
    [self performSelectorOnMainThread:@selector(reloadTableView:) withObject:nil waitUntilDone:NO];
}

- (void) StopTimer
{
    [m_timerLock lock];
    if (m_timer != nil) {
        [m_timer invalidate];
        m_timer = nil;
    }
    [m_timerLock unlock];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    ///UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
//[self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
   // self.navigationBar.delegate = self;
   // self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    
    //NSLog(@"WifiSettingViewController viewDidLoad");
    m_timerLock = [[NSCondition alloc] init];
   
    m_bFinished = NO;
    m_wifiScanResult = [[NSMutableArray alloc] init];
    
    [self showLoadingIndicator];
    m_timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
    
    _swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGes)];
    _swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_swipeGes];
    
    m_pPPPPChannelMgt->SetWifiParamDelegate((char*)[m_strDID UTF8String], self);
    m_pPPPPChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);
    m_pPPPPChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_WIFI_SCAN, NULL, 0);
}

- (void) handleSwipeGes{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    m_pPPPPChannelMgt->SetWifiParamDelegate((char*)[m_strDID UTF8String], nil);
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self StopTimer];
    m_pPPPPChannelMgt->SetWifiParamDelegate((char*)[m_strDID UTF8String], nil);
}

- (void)dealloc
{
    [self.view removeGestureRecognizer:_swipeGes];
    self.m_pPPPPChannelMgt = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) refresh:(id)param
{
    [m_wifiScanResult removeAllObjects];
    [self showLoadingIndicator];
    m_timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
    m_pPPPPChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);
    m_pPPPPChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_WIFI_SCAN, NULL, 0);
    
    m_bFinished = NO;
    [self reloadTableView:nil];
}

- (void)showLoadingIndicator
{
    NSString *strTitle = NSLocalizedStringFromTable(@"WifiSetting", @STR_LOCALIZED_FILE_NAME, nil);
   // UINavigationItem *back = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil)];
   // UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:strTitle];
    self.navigationItem.title = strTitle;
    //创建一个右边按钮  
    UIActivityIndicatorView *indicator =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	indicator.frame = CGRectMake(0, 0, 24, 24);
	[indicator startAnimating];
	UIBarButtonItem *progress =
    [[UIBarButtonItem alloc] initWithCustomView:indicator];

    //item.rightBarButtonItem = progress;
    self.navigationItem.rightBarButtonItem = progress;
   // NSArray *array = [NSArray arrayWithObjects:back, item, nil];
    //[self.navigationBar setItems:array];
	
    //[item release];
    //[back release];
}

- (void)hideLoadingIndicator
{
    NSString *strTitle = NSLocalizedStringFromTable(@"WifiSetting", @STR_LOCALIZED_FILE_NAME, nil);
    UINavigationItem *back = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:strTitle];
 
    //创建一个右边按钮  
   
	UIBarButtonItem *refreshButton =
    [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
      target:self
      action:@selector(refresh:)];

    self.navigationItem.rightBarButtonItem = refreshButton;
    return;
    
    item.rightBarButtonItem = refreshButton;
    
    NSArray *array = [NSArray arrayWithObjects:back, item, nil];    
    [self.navigationBar setItems:array];
	
    
}

#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    if (m_bFinished == NO) {
        return 1;
    }
    
    if ([m_wifiScanResult count] > 0) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    return [m_wifiScanResult count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{  
    NSString *cellIdentifier = @"SettingCell";	
    UITableViewCell *cell =  [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }    
    
    int section = [anIndexPath section];
    if (section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (m_bFinished == FALSE) {
            cell.textLabel.text = NSLocalizedStringFromTable(@"Loading", @STR_LOCALIZED_FILE_NAME, nil);
            cell.detailTextLabel.text = @"";
        }else {
            if (m_strSSID.length == 0) {
                cell.textLabel.text = NSLocalizedStringFromTable(@"NotSetting", @STR_LOCALIZED_FILE_NAME, nil);
                cell.detailTextLabel.text = @"";
            }else {
                cell.textLabel.text = m_strSSID;
                [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13.0]];
                cell.detailTextLabel.textColor = [UIColor lightGrayColor];
                cell.detailTextLabel.text = NSLocalizedStringFromTable(@"ADD_WIFISETTING_CONE_ADD", @STR_LOCALIZED_FILE_NAME, nil);
                
            }        
        }   
    }
    
    if (section == 1) {
        int index = anIndexPath.row;
        
        NSDictionary *wifiResult = [m_wifiScanResult objectAtIndex:index];
        NSString *strSSID = [wifiResult objectForKey:@STR_SSID];
        cell.textLabel.text = strSSID;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"SSID";
    }else {
        return NSLocalizedStringFromTable(@"WifiList", @STR_LOCALIZED_FILE_NAME, nil);
    }    
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    if (anIndexPath.section == 0) {
        return;
    }
    
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];

    int index = anIndexPath.row;
    m_currentIndex = index;
    NSDictionary *wifiInfor = [m_wifiScanResult objectAtIndex:index];    
    int security = [[wifiInfor objectForKey:@STR_SECURITY] intValue];
    NSString *strSSID = [wifiInfor objectForKey:@STR_SSID];
    if (security == 0) {
        NSString *strMessage = [NSString stringWithFormat:@"%@%@ ?",NSLocalizedStringFromTable(@"WillSet", @STR_LOCALIZED_FILE_NAME, nil),strSSID];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:strMessage delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil), nil];
        [alertView show];
        return;
    }
    WifiPwdViewController *wifipwdView = [[WifiPwdViewController alloc] init];
    wifipwdView.m_pChannelMgt = m_pPPPPChannelMgt;
    wifipwdView.m_strDID = m_strDID;
    wifipwdView.m_strSSID = strSSID;
    wifipwdView.m_channel = [[wifiInfor objectForKey:@STR_CHANNEL] intValue];
    wifipwdView.m_security = security;
    [self.navigationController pushViewController:wifipwdView animated:YES];
    
}

#pragma mark -
#pragma mark WifiParamsProtocol

- (void) WifiParams:(NSString *)strDID enable:(NSInteger)enable ssid:(NSString *)strSSID channel:(NSInteger)channel mode:(NSInteger)mode authtype:(NSInteger)authtype encryp:(NSInteger)encryp keyformat:(NSInteger)keyformat defkey:(NSInteger)defkey strKey1:(NSString *)strKey1 strKey2:(NSString *)strKey2 strKey3:(NSString *)strKey3 strKey4:(NSString *)strKey4 key1_bits:(NSInteger)key1_bits key2_bits:(NSInteger)key2_bits key3_bits:(NSInteger)key3_bits key4_bits:(NSInteger)key4_bits wpa_psk:(NSString *)wpa_psk
{
    //NSLog(@"WifiParams.....strDID: %@, enable:%d, ssid:%@, channel:%d, mode:%d, authtype:%d, encryp:%d, keyformat:%d, defkey:%d, strKey1:%@, strKey2:%@, strKey3:%@, strKey4:%@, key1_bits:%d, key2_bits:%d, key3_bits:%d, key4_bits:%d, wap_psk:%@", strDID, enable, strSSID, channel, mode, authtype, encryp, keyformat, defkey, strKey1, strKey2, strKey3, strKey4, key1_bits, key2_bits, key3_bits, key4_bits, wpa_psk);
    
    m_strSSID = strSSID;
    m_channel = channel;
    m_authtype = authtype;
    m_strWEPKey = strKey1;
    m_strWPA_PSK = wpa_psk;
            
}

- (void) WifiScanResult:(NSString *)strDID ssid:(NSString *)strSSID mac:(NSString *)strMac security:(NSInteger)security db0:(NSInteger)db0 db1:(NSInteger)db1 mode:(NSInteger)mode channel:(NSInteger)channel bEnd:(NSInteger)bEnd
{
    //NSLog(@"WifiScanResult.....strDID:%@, ssid:%@, mac:%@, security:%d, db0:%d, db1:%d, mode:%d, channel:%d, bEnd:%d", strDID, strSSID, strMac, security, db0, db1, mode, channel, bEnd);
    
    if (m_bFinished == YES) {
        return;
    }
    
    NSNumber *nSecurity = [NSNumber numberWithInt:security];
    NSNumber *nDB0 = [NSNumber numberWithInt:db0];
    NSNumber *nChannel = [NSNumber numberWithInt:channel];
    NSDictionary *wifiscan = [NSDictionary dictionaryWithObjectsAndKeys:strSSID, @STR_SSID, nSecurity, @STR_SECURITY, nDB0, @STR_DB0, nChannel, @STR_CHANNEL, nil];
    
    [m_wifiScanResult addObject:wifiscan];
    
    if (bEnd == 1) {
        m_bFinished = YES;
        [self performSelectorOnMainThread:@selector(StopTimer) withObject:nil waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(hideLoadingIndicator) withObject:nil waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(reloadTableView:) withObject:nil waitUntilDone:NO];
        
    }    
}

#pragma mark -
#pragma mark PerformInMainThread

- (void) reloadTableView:(id) param
{
    [wifiTableView reloadData];
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"buttonIndex: %d", buttonIndex);
    if (buttonIndex != 1) {
        return;
    }
    
    NSDictionary *wifiInfor = [m_wifiScanResult objectAtIndex:m_currentIndex];    
    int security = [[wifiInfor objectForKey:@STR_SECURITY] intValue];
    NSString *strSSID = [wifiInfor objectForKey:@STR_SSID];
    int channel = [[wifiInfor objectForKey:@STR_CHANNEL] intValue];
    
    m_pPPPPChannelMgt->SetWifi((char*)[m_strDID UTF8String], 1, (char*)[strSSID UTF8String], channel, 0, security, 0, 0, 0, (char*)"", (char*)"", (char*)"", (char*)"", 0, 0, 0, 0, (char*)"");
    m_pPPPPChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_REBOOT_DEVICE, NULL, 0);

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark navigationBarDelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}

@end
