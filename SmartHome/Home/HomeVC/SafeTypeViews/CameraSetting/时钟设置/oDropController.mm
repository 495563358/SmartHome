//
//  oDropController.m
//  P2PCamera
//
//  Created by mac on 12-10-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "oDropController.h"
#import "oDropListCell.h"
#import "obj_common.h"
#import "oDropListStruct.h"

@interface oDropController ()
@property (nonatomic, retain) UISwipeGestureRecognizer* swipeGes;
@end

@implementation oDropController

@synthesize tableView;
@synthesize navigationBar;
@synthesize m_nIndexDrop;
@synthesize m_DropListProtocolDelegate;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_nIndexDrop = 3;
        m_DropListProtocolDelegate = nil;
    }
    return self;
}

- (void) btnBack: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *strTitle = @"";
    
    switch (m_nIndexDrop) {
        case 1: //motion level
            strTitle = NSLocalizedStringFromTable(@"DropListMotionLevel", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case 3: //trigger level
            strTitle = NSLocalizedStringFromTable(@"alarmExternMode", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case 4: //preset
            strTitle = NSLocalizedStringFromTable(@"DropListPreset", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case 6: //output level
            strTitle = NSLocalizedStringFromTable(@"DropListOutputLevel", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case 9: //ftp upload interval
            strTitle = NSLocalizedStringFromTable(@"DropListUploadInterval", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case 101: //ntp server
            strTitle = NSLocalizedStringFromTable(@"DropListNtpServer", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case 102: //time zone
            strTitle = NSLocalizedStringFromTable(@"DropListTimeZone", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case 103: //mail ssl
            strTitle = @"SSL";
            break;
        case 104: //smtp server
            strTitle = NSLocalizedStringFromTable(@"MailSmtpSvr", @STR_LOCALIZED_FILE_NAME, nil);
            break;
            
        default:
            break;
    }
    
    self.navigationItem.title = strTitle;
    
    _swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGes)];
    _swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_swipeGes];
}

- (void) handleGes{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self.view removeGestureRecognizer:_swipeGes];
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
    if (m_nIndexDrop == 1) {return 3;}
    if (m_nIndexDrop == 3) {return 2;}
    if (m_nIndexDrop == 6) {return 2;}
    if (m_nIndexDrop == 4) {return 17;}
    if (m_nIndexDrop == 9) {return 15;}
    if (m_nIndexDrop == 101) {return 4;}
    if (m_nIndexDrop == 102) {return 29;}
    if (m_nIndexDrop == 103) {return 3;}//ssl
    if (m_nIndexDrop == 104) {return 12 ;} //smtp server
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    NSString *cellIdentifier = @"droplistcell";
    UITableViewCell *cell1 =  [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //disable selected cell
    //cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (cell1 == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oDropListCell" owner:self options:nil];
        cell1 = [nib objectAtIndex:0];
    }
    
    
    if (m_nIndexDrop == 1) { //motion level
        
        oDropListCell * cell = (oDropListCell*)cell1;
        cell.keyLable.text = [NSString stringWithFormat:@"%@", _motion_level[anIndexPath.row].strTitle];
        cell.keyLable.textAlignment = NSTextAlignmentCenter;
        cell.keyLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        return cell1;
    }
    
    if (m_nIndexDrop == 3) { //trigger level -- output level
        
        
        oDropListCell * cell = (oDropListCell*)cell1;
        cell.keyLable.text = extern_mode[anIndexPath.row].strTitle;
        cell.keyLable.textAlignment = NSTextAlignmentCenter;
        cell.keyLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        return cell1;
    }
    
    if (m_nIndexDrop == 6) {
        oDropListCell * cell = (oDropListCell*)cell1;
        cell.keyLable.text = extern_level[anIndexPath.row].strTitle;
        cell.keyLable.textAlignment = NSTextAlignmentCenter;
        cell.keyLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        return cell1;
    }
    
    if (m_nIndexDrop == 4) { //preset
        
        oDropListCell * cell = (oDropListCell*)cell1;
        cell.keyLable.text = [[NSString alloc] initWithUTF8String:motion_preset[anIndexPath.row].szName];;
        cell.keyLable.textAlignment = NSTextAlignmentCenter;
        cell.keyLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        return cell1;
    }
    
    if (m_nIndexDrop == 9) { //ftp upload interval
        
        oDropListCell * cell = (oDropListCell*)cell1;
        cell.keyLable.text = [[NSString alloc] initWithUTF8String:pic_timer[anIndexPath.row].szName];;
        cell.keyLable.textAlignment = NSTextAlignmentCenter;
        cell.keyLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        return cell1;
    }
    
    
    if (m_nIndexDrop == 101) { //ntp server
        
        oDropListCell * cell = (oDropListCell*)cell1;
        cell.keyLable.text = ntp_server[anIndexPath.row].strValue;
        cell.keyLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        return cell1;
    }
    
    if (m_nIndexDrop == 102) { //time zone
        
        oDropListCell * cell = (oDropListCell*)cell1;
        cell.keyLable.text = time_zone[anIndexPath.row].strTitle;
        cell.keyLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        return cell1;
    }
    
    if (m_nIndexDrop == 103) { // ssl
        oDropListCell * cell = (oDropListCell*)cell1;
        cell.keyLable.text = [NSString stringWithFormat:@"%s",ssl[anIndexPath.row].szName];
        cell.keyLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        return cell1;
    }
    
    if (m_nIndexDrop == 104) { //smtp server
        oDropListCell * cell = (oDropListCell*)cell1;
        cell.keyLable.text = [NSString stringWithFormat:@"%s",smtp_svr[anIndexPath.row].szName];
        cell.keyLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        return cell1;
    }
    
    return nil;
    
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    //    [currentTextField resignFirstResponder];
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    
    if (m_nIndexDrop == 1)
    {
        if (m_DropListProtocolDelegate != nil) {
            [m_DropListProtocolDelegate DropListResult:_motion_level[anIndexPath.row].strValue
                                                   nID:_motion_level[anIndexPath.row].index
                                                 nType:1 param1:0 param2:0]
            ;
        }
    }
    if (m_nIndexDrop == 3)
    {
        if (m_DropListProtocolDelegate != nil) {
            [m_DropListProtocolDelegate DropListResult:extern_level[anIndexPath.row].strTitle
                                                   nID:extern_level[anIndexPath.row].index
                                                 nType:3 param1:0 param2:0]
            ;
        }
    }
    if (m_nIndexDrop == 4)
    {
        if (m_DropListProtocolDelegate != nil) {
            [m_DropListProtocolDelegate DropListResult:motion_preset[anIndexPath.row].strTitle
                                                   nID:motion_preset[anIndexPath.row].index
                                                 nType:4 param1:0 param2:0]
            ;
        }
    }
    if (m_nIndexDrop == 6)
    {
        if (m_DropListProtocolDelegate != nil) {
            [m_DropListProtocolDelegate DropListResult:extern_level[anIndexPath.row].strTitle
                                                   nID:extern_level[anIndexPath.row].index
                                                 nType:6 param1:0 param2:0]
            ;
        }
    }
    if (m_nIndexDrop == 9)
    {
        if (m_DropListProtocolDelegate != nil) {
            [m_DropListProtocolDelegate DropListResult:pic_timer[anIndexPath.row].strValue
                                                   nID:pic_timer[anIndexPath.row].index
                                                 nType:9 param1:0 param2:0]
            ;
        }
    }
    
    if (m_nIndexDrop == 101)
    {
        if (m_DropListProtocolDelegate != nil) {
            [m_DropListProtocolDelegate DropListResult:ntp_server[anIndexPath.row].strValue
                                                   nID:0
                                                 nType:101 param1:0 param2:0]
            ;
        }
    }
    if (m_nIndexDrop == 102)
    {
        if (m_DropListProtocolDelegate != nil) {
            [m_DropListProtocolDelegate DropListResult:time_zone[anIndexPath.row].strTitle
                                                   nID:time_zone[anIndexPath.row].index
                                                 nType:102 param1:0 param2:0]
            ;
        }
    }
    if (m_nIndexDrop == 103) //ssl
    {
        if (m_DropListProtocolDelegate != nil) {
            [m_DropListProtocolDelegate DropListResult:[NSString stringWithFormat:@"%s",ssl[anIndexPath.row].szName]
                                                   nID:ssl[anIndexPath.row].index
                                                 nType:m_nIndexDrop
                                                param1:0
                                                param2:0]
            ;
        }
    }
    if (m_nIndexDrop == 104) //smtp server
    {
        if (m_DropListProtocolDelegate != nil) {
            [m_DropListProtocolDelegate DropListResult:[NSString stringWithFormat:@"%s",smtp_svr[anIndexPath.row].szName]
                                                   nID:smtp_svr[anIndexPath.row].index
                                                 nType:m_nIndexDrop
                                                param1:smtp_svr[anIndexPath.row].param1
                                                param2:smtp_svr[anIndexPath.row].param2]
            ;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) dealloc{
//    [super dealloc];
//    [_swipeGes release],_swipeGes = nil;
}

#pragma mark -
#pragma mark navigationBarDelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}

@end
