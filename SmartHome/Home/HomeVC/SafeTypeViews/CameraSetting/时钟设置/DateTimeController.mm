//
//  DateTimeController.m
//  P2PCamera
//
//  Created by mac on 12-10-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DateTimeController.h"
#import "obj_common.h"
#import "oDropListStruct.h"
#import "oDropController.h"
#import "oLableCell.h"
#import "oSwitchCell.h"



@interface DateTimeController ()
@property (nonatomic, retain) UISwipeGestureRecognizer* swipeGes;
@property (nonatomic, retain) NSString* dateStr;
@end
static const double PageViewControllerTextAnimationDuration = 0.33;

@implementation DateTimeController

@synthesize m_strDID;
@synthesize m_pChannelMgt;

@synthesize m_timingSever;

@synthesize dateTime;
@synthesize timeZone;
@synthesize timing;
@synthesize timingServer;

@synthesize tableView;
@synthesize navigationBar;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // m_timingSever = @"ssssssss";
        NSDate* date = [NSDate date];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString* str = [formatter stringFromDate:date];
        self.dateStr = str;
//        [formatter release];
    }
    return self;
}
- (void) btnBack: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) btnSetDatetime:(id)sender
{
    m_pChannelMgt->SetDateTime((char*)[m_strDID UTF8String], 0, m_timeZone, m_Timing, (char*)[m_timingSever UTF8String]);
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *strTitle = NSLocalizedStringFromTable(@"ClockSetting", @STR_LOCALIZED_FILE_NAME, nil);
    self.navigationItem.title = strTitle;
    
    //创建一个右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil)
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(btnSetDatetime:)];
    self.navigationItem.rightBarButtonItem = rightButton;
//    [rightButton release];
    
    _swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGes)];
    _swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_swipeGes];
    
    m_pChannelMgt->SetDateTimeDelegate((char*)[m_strDID UTF8String], self);
    m_pChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);
}

- (void) handleSwipeGes{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (void) dealloc
{
    [self.view removeGestureRecognizer:_swipeGes];
    m_pChannelMgt->SetDateTimeDelegate((char*)[m_strDID UTF8String], nil);
    self.m_strDID = nil;
//    [_swipeGes release],_swipeGes = nil;
    self.m_pChannelMgt = nil;
    self.m_timingSever = nil;
    self.dateTime = nil;
    self.timing = nil;
    self.timingServer = nil;
    self.tableView = nil;
    self.navigationBar = nil;
//    [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    NSString *cellIdentifier = @"datetime";
    UITableViewCell *cell1 =  [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //disable selected cell
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger row = anIndexPath.row;
    switch (row) {
        case 0:
        {
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            oLableCell * cell = (oLableCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"datetimeDeviceTime", @STR_LOCALIZED_FILE_NAME, nil);
            
            //time_t t = (m_dateTime-m_timeZone)*1000;
            cell.DescriptionLable.text = _dateStr;//[NSString stringWithUTF8String:ctime(&t)];
            cell.DescriptionLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        case 1:
        {
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            oLableCell * cell = (oLableCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"datetimeDeviceTimezone", @STR_LOCALIZED_FILE_NAME, nil);
            
            
            cell.DescriptionLable.text = [self get_time_zone_des:m_timeZone];
            
            cell.DescriptionLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
            break;
        case 2:
        {
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            oSwitchCell * cell = (oSwitchCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"datetimeDeviceTiming", @STR_LOCALIZED_FILE_NAME, nil);
            //[cell.keySwitch setOn:NO];
            [cell.keySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            cell.keySwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        case 3:
        {
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            oLableCell * cell = (oLableCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"datetimeDeviceTimingServer", @STR_LOCALIZED_FILE_NAME, nil);
            // cell.textLabel.placeholder = NSLocalizedStringFromTable(@"InputUserName", @STR_LOCALIZED_FILE_NAME, nil);
            cell.DescriptionLable.text = self.m_timingSever;
            //[cell.textLabel setEnabled: NO];
            cell.DescriptionLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 4:
        {
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            oSwitchCell * cell = (oSwitchCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"datetimeDeviceTimeLocal", @STR_LOCALIZED_FILE_NAME, nil);
            [cell.keySwitch setOn:NO];
            [cell.keySwitch addTarget:self action:@selector(switchActionlocal:) forControlEvents:UIControlEventValueChanged];
            cell.keySwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        default:
            break;
    }
    
    
	
	return cell1;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    //    [currentTextField resignFirstResponder];
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    
    
    switch (anIndexPath.row) {
        case 1:
        {
            oDropController *dpView = [[oDropController alloc] init];
            dpView.m_nIndexDrop = 102;
            dpView.m_DropListProtocolDelegate = self;
            [self.navigationController pushViewController:dpView animated:YES];
//            [dpView release];
        }
            break;
        case 3:
        {
            oDropController *dpView = [[oDropController alloc] init];
            dpView.m_nIndexDrop = 101;
            dpView.m_DropListProtocolDelegate = self;
            [self.navigationController pushViewController:dpView animated:YES];
//            [dpView release];
        }
            break;
        default:
            break;
    }
    
}

- (void) DropListResult:(NSString*)strDescription nID:(int)nID nType:(int)nType param1:(int)param1 param2:(int)param2
{
    if (nType == 101) {
        m_timingSever = strDescription;
    }
    if (nType == 102) {
        m_timeZone = nID;
    }
    
    [self performSelectorOnMainThread:@selector(reloadTableView:) withObject:nil waitUntilDone:NO];
}
#pragma mark -
#pragma mark PerformInMainThread

- (void) reloadTableView:(id) param
{
    [tableView reloadData];
}

- (NSString *) get_time_zone_des:(int) nID
{
    for (int i=0; i<29; i++) {
        if (time_zone[i].index == nID) {
            return time_zone[i].strTitle;
        }
    }
    return  @"";
}
- (void)switchAction:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        m_Timing = 1;
    }else {
        m_Timing = 0;
    }
}
- (void)switchActionlocal:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        //设置时间
        NSTimeZone *zone = [NSTimeZone defaultTimeZone];//获得当前应用程序默认的时区
        NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];//以秒为单位返回当前应用程序与世界标准时间（格林威尼时间）的时差
        NSInteger IntervalSince1970 = [[NSDate date] timeIntervalSince1970];
        
        m_pChannelMgt->SetDateTime((char*)[m_strDID UTF8String], /*time(0)/1000*/IntervalSince1970, (-1)*interval, m_Timing, (char*)[m_timingSever UTF8String]);
        //返回
        //[self.navigationController popViewControllerAnimated:YES];
        m_pChannelMgt->PPPPSetSystemParams((char*)[self.m_strDID UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);
    }
}


- (void) DateTimeProtocolResult:(int)now tz:(int)tz ntp_enable:(int)ntp_enable net_svr:(NSString*)ntp_svr
{
    NSLog(@"now  %d  tz  %d   ntp_enable    %d    ntp_svr   %@",now,tz,ntp_enable,ntp_svr);
    m_timeZone = tz;
    m_dateTime = now;
    m_Timing = ntp_enable;
    self.m_timingSever = ntp_svr;
    
    NSTimeZone *tmz=[NSTimeZone timeZoneForSecondsFromGMT:m_timeZone];
    NSCalendar *ca=[NSCalendar currentCalendar];
    
    //    NSUInteger unitFlags =NSHourCalendarUnit | NSMinuteCalendarUnit |
    //
    //    NSSecondCalendarUnit | NSDayCalendarUnit
    //
    //    | NSMonthCalendarUnit | NSYearCalendarUnit|NSWeekdayCalendarUnit;
    
    NSTimeInterval se=(long)m_dateTime;
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:se];
    NSDate *dd=[date dateByAddingTimeInterval:-m_timeZone];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:tmz];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSString *strDate=[formatter stringFromDate:dd];
    NSString *strD=[dd description];
    NSRange yR=NSMakeRange(0, 4);
    NSString *strYear=[strD substringWithRange:yR];
    NSRange mR=NSMakeRange(5, 2);
    NSString *month=[strD substringWithRange:mR];
    NSRange dR=NSMakeRange(8, 2);
    NSString *day=[strD substringWithRange:dR];
    NSRange tR=NSMakeRange(10, 9);
    NSString *strTime=[strD substringWithRange:tR];
    int m=[month intValue];
    int d=[day intValue];
    NSString *strMon=nil;
    switch (m) {
        case 1:
            strMon=@"Jan";
            break;
        case 2:
            strMon=@"Feb";
            break;
        case 3:
            strMon=@"Mar";
            break;
        case 4:
            strMon=@"Apr";
            break;
        case 5:
            strMon=@"May";
            break;
        case 6:
            strMon=@"Jun";
            break;
        case 7:
            strMon=@"Jun";
            break;
        case 8:
            strMon=@"Aug";
            break;
        case 9:
            strMon=@"Sept";
            break;
        case 10:
            strMon=@"Oct";
            break;
        case 11:
            strMon=@"Nov";
            break;
        case 12:
            strMon=@"Dec";
            break;
            
    }
    
    //    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    //    [formatter setTimeZone:tz];
    //    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSString *sd=[formatter stringFromDate:date];
    //    NSLog(@"sd=%@",sd);
    
    NSDateComponents *dateComp=[ca components:NSWeekdayCalendarUnit fromDate:date];
    //    int year=[dateComp year];
    //    int month=[dateComp month];
    //    int day=[dateComp day];
    //    int hour=[dateComp hour];
    //    int minute=[dateComp minute];
    //    int second=[dateComp second];
    int week=[dateComp weekday];
    NSString *strW=nil;
    switch (week) {
        case 1:
            strW=@"Sun";
            break;
        case 2:
            strW=@"Mon";
            break;
        case 3:
            strW=@"Tue";
            break;
        case 4:
            strW=@"Wed";
            break;
        case 5:
            strW=@"Thur";
            break;
        case 6:
            strW=@"Fri";
            break;
        case 7:
            strW=@"Sat";
            break;
            
    }
    
    self.dateStr = [NSString stringWithFormat:@"%@ %d %@ %@ %@",strW,d,strMon,strYear,strTime];
    
    [self performSelectorOnMainThread:@selector(reloadTableView:) withObject:nil waitUntilDone:NO];
}

#pragma mark -
#pragma mark navigationBarDelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}
@end
