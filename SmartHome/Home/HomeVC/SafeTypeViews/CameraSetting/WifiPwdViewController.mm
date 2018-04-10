//
//  WifiPwdViewController.m
//  P2PCamera
//
//  Created by mac on 12-10-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WifiPwdViewController.h"
#import "WifiPwdCell.h"
#import "obj_common.h"

@interface WifiPwdViewController ()
@property (nonatomic, retain) UISwipeGestureRecognizer* swipeGes;
@end

@implementation WifiPwdViewController

@synthesize m_pChannelMgt;
@synthesize m_strSSID;
@synthesize m_channel;
@synthesize m_security;
@synthesize m_strDID;
@synthesize m_strPwd;
@synthesize textPassword;
@synthesize navigationBar;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    //[self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    //self.navigationBar.delegate = self;
   // self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    
    NSString *strTitle = NSLocalizedStringFromTable(@"EnterPwd", @STR_LOCALIZED_FILE_NAME, nil);
    //UINavigationItem *back = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil)];
    //UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:strTitle];
    self.navigationItem.title = strTitle;
    
    //创建一个右边按钮  
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil)      
                                                                    style:UIBarButtonItemStyleDone     
                                                                   target:self     
                                                                   action:@selector(btnSetWifi:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    //item.rightBarButtonItem = rightButton;
    
    _swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGes)];
    _swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_swipeGes];
    
    //NSArray *array = [NSArray arrayWithObjects:back, item, nil];
    //[self.navigationBar setItems:array];
    //[item release];
    ///[back release];
    
}

- (void) handleSwipeGes{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [self.view removeGestureRecognizer:_swipeGes];
    _swipeGes = nil;
    
    self.m_pChannelMgt = nil;
    self.textPassword = nil;
    self.m_strSSID = nil;
    self.m_strDID = nil;
    self.m_strPwd = nil;
}

- (void) btnSetWifi:(id)sender
{
    //(char *szDID, int enable, char *szSSID, int channel, int mode, int authtype, int encrypt, int keyformat, int defkey, char *strKey1, char *strKey2, char *strKey3, char *strKey4, int key1_bits, int key2_bits, int key3_bits, int key4_bits, char *wpa_psk)
    if (textPassword != nil) {
        [textPassword resignFirstResponder];
    }
    
    char *pkey = NULL;
    char *pwpa_psk = NULL;
    
    switch (m_security) {
        case 0: //none
            pkey = (char*)"";
            pwpa_psk = (char*)"";
            break;
        case 1: //wep
            pkey = (char*)[m_strPwd UTF8String];
            pwpa_psk = (char*)"";
            break;
        case 2: //wpa-psk(AES)
        case 3://wpa-psk(TKIP)
        case 4://wpa2-psk(AES)
        case 5://wpa3-psk(TKIP)
            pkey = (char*)"";
            pwpa_psk = (char*)[m_strPwd UTF8String];
            break;
        default:
            break;
    }
    
    NSLog(@"buhuhuuh = %s /n wep = %i",pwpa_psk,m_security);
    
    m_pChannelMgt->SetWifi((char*)[m_strDID UTF8String], 1, (char*)[m_strSSID UTF8String], m_channel, 0, m_security, 0, 0, 0, pkey, (char*)"", (char*)"", (char*)"", 0, 0, 0, 0, pwpa_psk);
    
    m_pChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_REBOOT_DEVICE, NULL, 0);
    
    alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTable(@"WIFISetSucInfomation", @STR_LOCALIZED_FILE_NAME, nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:nil];
    alertView.delegate = self;
    [alertView show];
    //[self performSelector:@selector(rebootPrompt:) withObject:nil afterDelay:3.f];
}

- (void)rebootPrompt:(id)sender{
    if ((alertView != nil)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        });
        alertView = nil;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)anlertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popToRootViewControllerAnimated:YES];
    alertView = nil;
}

#pragma mark -
#pragma mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
     return 1;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    NSString *cellIdentifier = @"WifiPwdCell";	
    WifiPwdCell *cell =  (WifiPwdCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WifiPwdCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textPassword.delegate = self;
    cell.lablePassword.text = NSLocalizedStringFromTable(@"Pwd", @STR_LOCALIZED_FILE_NAME, nil);
	return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
}

#pragma mark -
#pragma mark textFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldShouldBeginEditing");
    self.textPassword = textField;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	NSLog(@"textFieldDidEndEditing");
    
    self.m_strPwd = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{    
    [textField resignFirstResponder];    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 64) {
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark navigationBarDelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}


@end
