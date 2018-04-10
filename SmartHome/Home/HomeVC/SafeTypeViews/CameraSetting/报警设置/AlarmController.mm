//
//  AlarmController.m
//  P2PCamera
//
//  Created by mac on 12-10-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AlarmController.h"
#import "obj_common.h"

#import "oSwitchCell.h"
#import "oLableCell.h"
#import "oTextCell.h"

#import "oDropController.h"
#import "oDropListStruct.h"

@interface AlarmController ()
@property (nonatomic, retain) UISwipeGestureRecognizer* swipeGes;
@end

@implementation AlarmController

@synthesize tableView;
@synthesize navigationBar;

@synthesize m_strDID;
@synthesize m_pChannelMgt;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) btnBack: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) btnSetAlarm:(id)sender
{
    int num = m_pChannelMgt->SetAlarm((char*)[m_strDID UTF8String], m_motion_armed, m_motion_sensitivity, m_input_armed, m_ioin_level, m_alarmpresetsit, m_iolinkage, m_ioout_level, m_mail, m_upload_interval,m_record);
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"num = %i",num);
    if (num) {
        ShowMsg(@"修改成功");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *strTitle = NSLocalizedStringFromTable(@"AlarmSetting", @STR_LOCALIZED_FILE_NAME, nil);
    self.navigationItem.title = strTitle;
    
    //创建一个右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil)
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(btnSetAlarm:)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
//    [rightButton release];
    //UISwipeGestureRecognizer
    _swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGes)];
    _swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_swipeGes];
    
    m_pChannelMgt->SetAlarmDelegate((char*)[m_strDID UTF8String], self);
    m_pChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);
    
}

- (void) handleSwipeGes{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.view removeGestureRecognizer:_swipeGes];
    m_pChannelMgt->SetAlarmDelegate((char*)[m_strDID UTF8String], nil);
    
}

- (void)dealloc
{
    m_pChannelMgt->SetAlarmDelegate((char*)[m_strDID UTF8String], nil);
//    self.m_strDID = nil;
//    [_swipeGes release],_swipeGes = nil;
//    self.m_pChannelMgt = nil;
//    self.tableView = nil;
//    self.navigationBar = nil;
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
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"alarmcell%d",anIndexPath.row];
    UITableViewCell *cell1 =  [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //disable selected cell
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger row = anIndexPath.row;
    switch (row) {
        case 0:
        {
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            oSwitchCell * cell = (oSwitchCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmMotionEnable", @STR_LOCALIZED_FILE_NAME, nil);
            [cell.keySwitch setOn:(m_motion_armed>0)?YES:NO];
            [cell.keySwitch addTarget:self action:@selector(switchActionMotion_armed:) forControlEvents:UIControlEventValueChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.keySwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
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
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmMotionLevel", @STR_LOCALIZED_FILE_NAME, nil);
            cell.DescriptionLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            if (m_motion_sensitivity >= 1 && m_motion_sensitivity <= 3) {
                cell.DescriptionLable.text = NSLocalizedStringFromTable(@"MotionLevelHigh", @STR_LOCALIZED_FILE_NAME, nil);
            }else if(m_motion_sensitivity >= 4 && m_motion_sensitivity <= 6){
                cell.DescriptionLable.text = NSLocalizedStringFromTable(@"MotionLevelMiddle", @STR_LOCALIZED_FILE_NAME, nil);
            }else {
                cell.DescriptionLable.text = NSLocalizedStringFromTable(@"MotionLevelLow", @STR_LOCALIZED_FILE_NAME, nil);
            }
            
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
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmExtern", @STR_LOCALIZED_FILE_NAME, nil);
            [cell.keySwitch setOn:(m_input_armed>0)?YES:NO];
            [cell.keySwitch addTarget:self action:@selector(switchActionInput_armed:) forControlEvents:UIControlEventValueChanged];
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
            cell.DescriptionLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmExternMode", @STR_LOCALIZED_FILE_NAME, nil);
            cell.DescriptionLable.text = extern_mode[m_ioin_level].strTitle;
            //[NSString stringWithFormat:@"%d", m_ioin_level];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 4:
        {
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            oLableCell * cell = (oLableCell*)cell1;
            cell.DescriptionLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmMotionPreset", @STR_LOCALIZED_FILE_NAME, nil);
            cell.DescriptionLable.text = [NSString stringWithUTF8String:motion_preset[m_alarmpresetsit].szName];
            //(m_alarmpresetsit == 0)?@"No":[NSString stringWithFormat:@"%d", m_alarmpresetsit];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
        case 5:
        {
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            oSwitchCell * cell = (oSwitchCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmMotionIO", @STR_LOCALIZED_FILE_NAME, nil);
            [cell.keySwitch setOn:(m_iolinkage>0)?YES:NO];
            [cell.keySwitch addTarget:self action:@selector(switchActionIolinkage:) forControlEvents:UIControlEventValueChanged];
            cell.keySwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        case 6:
        {
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            oLableCell * cell = (oLableCell*)cell1;
            cell.DescriptionLable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmMotionIOLevel", @STR_LOCALIZED_FILE_NAME, nil);
            cell.DescriptionLable.text = extern_level[m_ioout_level].strTitle;
            //NSString stringWithUTF8String:motion_preset[m_alarmpresetsit].szName];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
            
            //        case 7: //邮件通知
            //        {
            //            if (cell1 == nil)
            //            {
            //                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell" owner:self options:nil];
            //                cell1 = [nib objectAtIndex:0];
            //            }
            //            oSwitchCell * cell = (oSwitchCell*)cell1;
            //            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmMail", @STR_LOCALIZED_FILE_NAME, nil);
            //            [cell.keySwitch setOn:(m_mail>0)?YES:NO];
            //            [cell.keySwitch addTarget:self action:@selector(switchActionMail:) forControlEvents:UIControlEventValueChanged];
            //            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //        }
            //            break;
            //        case 8://上传图片间隔
            //        {
            //            if (cell1 == nil)
            //            {
            //                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell" owner:self options:nil];
            //                cell1 = [nib objectAtIndex:0];
            //            }
            //            oLableCell * cell = (oLableCell*)cell1;
            //            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmPicTimer", @STR_LOCALIZED_FILE_NAME, nil);
            //            cell.DescriptionLable.text = [NSString stringWithFormat:@"%d", m_upload_interval];
            //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //        }
            //            break;
        case 7://alarm record
        {
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            oSwitchCell * cell = (oSwitchCell*)cell1;
            cell.keyLable.text = NSLocalizedStringFromTable(@"alarmRecord", @STR_LOCALIZED_FILE_NAME, nil);
            [cell.keySwitch setOn:(m_record>0)?YES:NO];
            [cell.keySwitch addTarget:self action:@selector(switchActionRecord:) forControlEvents:UIControlEventValueChanged];
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
    //[currentTextField resignFirstResponder];
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    
    
    switch (anIndexPath.row) {
        case 1:
        {
            oDropController *dpView = [[oDropController alloc] init];
            dpView.m_nIndexDrop = 1;
            dpView.m_DropListProtocolDelegate = self;
            [self.navigationController pushViewController:dpView animated:YES];
//            [dpView release];
        }
            break;
        case 3:
        {
            oDropController *dpView = [[oDropController alloc] init];
            dpView.m_nIndexDrop = 3;
            dpView.m_DropListProtocolDelegate = self;
            [self.navigationController pushViewController:dpView animated:YES];
//            [dpView release];
        }
            break;
        case 4:
        {
            oDropController *dpView = [[oDropController alloc] init];
            dpView.m_nIndexDrop = 4;
            dpView.m_DropListProtocolDelegate = self;
            [self.navigationController pushViewController:dpView animated:YES];
//            [dpView release];
        }
            break;
        case 6:
        {
            oDropController *dpView = [[oDropController alloc] init];
            dpView.m_nIndexDrop = 6;
            dpView.m_DropListProtocolDelegate = self;
            [self.navigationController pushViewController:dpView animated:YES];
//            [dpView release];
        }
            break;
        case 8:
        {
            oDropController *dpView = [[oDropController alloc] init];
            dpView.m_nIndexDrop = 9;
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
    if (nType == 1) {
        m_motion_sensitivity = nID;
    }
    if (nType == 3) {
        m_ioin_level = nID;
    }
    if (nType == 4) {
        m_alarmpresetsit = nID;
    }
    if (nType == 6) {
        m_ioout_level = nID;
    }
    if (nType == 9) {
        m_upload_interval = nID;
    }
    
    [self performSelectorOnMainThread:@selector(reloadTableView:) withObject:nil waitUntilDone:NO];
}
#pragma mark -
#pragma mark PerformInMainThread

- (void) reloadTableView:(id) param
{
    [tableView reloadData];
}

- (void) AlarmProtocolResult:(int)motion_armed
          motion_sensitivity:(int)motion_sensitivity
                 input_armed:(int)input_armed
                  ioin_level:(int)ioin_level
              alarmpresetsit:(int)alarmpresetsit
                   iolinkage:(int)iolinkage
                 ioout_level:(int)ioout_level
                        mail:(int)mail
                    snapshot:(int)snapshot
             upload_interval:(int)upload_interval
                      record:(int)record
{
    m_motion_armed = motion_armed;
    m_motion_sensitivity = motion_sensitivity;
    
    m_input_armed = input_armed;
    m_ioin_level = ioout_level;
    
    m_alarmpresetsit = alarmpresetsit;
    m_iolinkage = iolinkage;
    m_ioout_level = ioout_level;
    
    m_mail = mail;
    m_snapshot = snapshot;
    m_upload_interval = upload_interval;
    
    m_record = record;
    
    [self performSelectorOnMainThread:@selector(reloadTableView:) withObject:nil waitUntilDone:NO];
    
}


- (void)switchActionMotion_armed:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {   m_motion_armed = 1;   }else {     m_motion_armed = 0;       }
}
- (void)switchActionInput_armed:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {   m_input_armed = 1;   }else {     m_input_armed = 0;       }
}
- (void)switchActionIolinkage:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {   m_iolinkage = 1;   }else {     m_iolinkage = 0;       }
}
- (void)switchActionMail:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {   m_mail = 1;   }else {     m_mail = 0;       }
}
- (void)switchActionSnapshot:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {   m_snapshot = 1;   }else {     m_snapshot = 0;       }
}

- (void)switchActionRecord:(id) sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {   m_record = 1;   }else {     m_record = 0;       }
    
}


#pragma mark -
#pragma mark navigationBarDelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}




@end
