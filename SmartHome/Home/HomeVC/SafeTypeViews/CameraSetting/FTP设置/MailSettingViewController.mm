//
//  MailSettingViewController.m
//  P2PCamera
//
//  Created by Tsang on 12-12-12.
//
//

static const double PageViewControllerTextAnimationDuration = 0.33;

#import "MailSettingViewController.h"
#import "defineutility.h"
#import "obj_common.h"
#import "CameraInfoCell.h"
#import "oLableCell.h"
#import "oSwitchCell.h"
#import "oDropController.h"


@interface MailSettingViewController ()

@end

@implementation MailSettingViewController

@synthesize tableView;
@synthesize navigationBar;
@synthesize m_pChannelMgt;
@synthesize m_strDID;
@synthesize currentTextField;
@synthesize m_strPwd;
@synthesize m_strRecv1;
@synthesize m_strRecv2;
@synthesize m_strRecv4;
@synthesize m_strRecv3;
@synthesize m_strSender;
@synthesize m_strSMTPSvr;
@synthesize m_strUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    m_pChannelMgt->SetMailDelegate((char*)[m_strDID UTF8String], nil);
    self.navigationBar = nil;
    self.tableView = nil;
    self.m_strDID = nil;
    self.currentTextField = nil;
    self.m_strSender = nil;
    self.m_strSMTPSvr = nil;
    self.m_strUser = nil;
    self.m_strPwd = nil;
    self.m_strRecv1 = nil;
    self.m_strRecv2 = nil;
    self.m_strRecv3 = nil;
    self.m_strRecv4 = nil;
//    [super dealloc];
}


- (void)switchChanged: (id) sender
{
    
    NSLog(@"switchChanged....");
    UISwitch *mySwitch = (UISwitch*)sender;
    
    if (mySwitch.isOn) {
        m_nTableviewCount = 11;
        m_nAuth = 1;
    }else{
        m_nAuth = 0;
        m_nTableviewCount = 9;
    }
    
    [self.tableView reloadData];
} 

- (void) btnSetMail:(id) sender
{
    [currentTextField resignFirstResponder];
    
    //NSLog(@"sender: %@, smtpsvr: %@, port: %d, ssl:%d, auth: %d, user: %@, pwd: %@, recv1: %@, recv2: %@, recv3: %@, recv4: %@", m_strSender,m_strSMTPSvr, m_nSMTPPort, m_nSSL, m_nAuth, m_strUser, m_strPwd, m_strRecv1, m_strRecv2, m_strRecv3, m_strRecv4);

    
    m_pChannelMgt->SetMail((char*)[m_strDID UTF8String],
                           (char*)[m_strSender UTF8String],
                           (char*)[m_strSMTPSvr UTF8String],
                           m_nSMTPPort,
                           m_nSSL,
                           m_nAuth,
                           (char*)[m_strUser UTF8String],
                           (char*)[m_strPwd UTF8String],
                           (char*)[m_strRecv1 UTF8String],
                           (char*)[m_strRecv2 UTF8String],
                           (char*)[m_strRecv3 UTF8String],
                           (char*)[m_strRecv4 UTF8String]);
    

   
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    self.m_strSender = @"";
    self.m_strSMTPSvr = @"";
    self.m_strUser = @"";
    self.m_strPwd = @"";
    self.m_strRecv1 = @"";
    self.m_strRecv2 = @"";
    self.m_strRecv2 = @"";
    self.m_strRecv3 = @"";
    self.m_strRecv4 = @"";
    m_nSMTPPort = 0;
    m_nSSL = 0;
    m_nAuth = 0;
    m_nTableviewCount = 9;
    
   // UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
    //[self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
   // self.navigationBar.delegate = self;
    //self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    
    //self.textPassword = nil;
    NSString *strTitle = NSLocalizedStringFromTable(@"MailSetting", @STR_LOCALIZED_FILE_NAME, nil);
    //UINavigationItem *back = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil)];
    //UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:strTitle];
    
    self.navigationItem.title = strTitle;
    //创建一个右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil)
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(btnSetMail:)];
    
    //item.rightBarButtonItem = rightButton;
    self.navigationItem.rightBarButtonItem = rightButton;
   // NSArray *array = [NSArray arrayWithObjects:back, item, nil];
    //[self.navigationBar setItems:array];
//    [rightButton release];
    ///[item release];
    //[back release];
    
    
    m_pChannelMgt->SetMailDelegate((char*)[m_strDID UTF8String], self);
    m_pChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);
    
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShowNotification:)
     name:UIKeyboardWillShowNotification
     object:nil];
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHideNotification:)
     name:UIKeyboardWillHideNotification
     object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillShowNotification
     object:nil];
	[[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillHideNotification
     object:nil];
}



#pragma mark -
#pragma mark TableViewDelegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)anIndexPath
{
    //NSLog(@"accessoryButtonTappedForRowWithIndexPath.. row: %d", anIndexPath.row);
    
    if (anIndexPath.row != 1) {
        return ;
    }
    oDropController *dropView = [[oDropController alloc] init];
    dropView.m_nIndexDrop = 104;
    dropView.m_DropListProtocolDelegate = self;
    [self.navigationController pushViewController:dropView animated:YES];
//    [dropView release];
//    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return m_nTableviewCount;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    NSString *cellIdentifier1 = @"MailSettingCell1"; //CameraInfoCell
    NSString *cellIdentifier2 = @"MailSettingCell2"; //oSwitchCell
    NSString *cellIdentifier3 = @"MailSettingCell3"; //oLabelCell
    
    UITableViewCell *cell = nil;
        
    switch (anIndexPath.row) {
        case 0: //sender
        {
            CameraInfoCell *cell1 =  (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CameraInfoCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            cell1.keyLable.text = NSLocalizedStringFromTable(@"MailSender", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.text = self.m_strSender;
            cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputMailSender", @STR_LOCALIZED_FILE_NAME, nil);
            
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            cell1.textField.delegate = self;
            cell1.textField.tag = anIndexPath.row;
            
            cell = cell1;
            
            
        }
            break;
        case 1: //SMTP server
        {
            CameraInfoCell *cell1 =  (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CameraInfoCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            
            cell1.keyLable.text = NSLocalizedStringFromTable(@"MailSmtpSvr", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.text = self.m_strSMTPSvr;
            cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputMailServer", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.delegate = self;
            cell1.textField.tag = anIndexPath.row;
            cell1.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell = cell1;
            
        }
            break;
        case 2: //smtp port
        {
            CameraInfoCell *cell1 =  (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CameraInfoCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            
            cell1.keyLable.text = NSLocalizedStringFromTable(@"MailSmtpPort", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.text = [NSString stringWithFormat:@"%d", m_nSMTPPort];
            cell1.textField.keyboardType = UIKeyboardTypeNumberPad;
            cell1.textField.delegate = self;
            cell1.textField.tag = anIndexPath.row;
            
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell = cell1;
            
        }
            break;
        case 3: //ssl
        {
            oLableCell *cell1 =  (oLableCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier3];
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oLableCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            
            cell1.keyLable.text = @"SSL";
           
            NSString *strSSL = @"NONE";
            switch (m_nSSL) {
                case 0: //NONE
                    strSSL = @"NONE";
                    break;
                case 1: //SSL
                    strSSL = @"SSL";
                    break;
                case 2: //TLS
                    strSSL = @"TLS";
                    break;
                    
                default:
                    m_nSSL = 0;
                    break;
            }
            cell1.DescriptionLable.text = strSSL;
            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell = cell1;
            
        }
            break;
        case 4: //authentication
        {
            oSwitchCell *cell1 =  (oSwitchCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier2];
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"oSwitchCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            
            cell1.keyLable.text = NSLocalizedStringFromTable(@"MailAuth", @STR_LOCALIZED_FILE_NAME, nil);
            [cell1.keySwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];

            if (m_nAuth) {
                [cell1.keySwitch setOn:YES];
            }else{
                [cell1.keySwitch setOn:NO];
            }
            
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell = cell1;
            
        }
            break;
        case 5: //user || receiver1
        {
            CameraInfoCell *cell1 =  (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CameraInfoCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            
            if (m_nAuth) {
                cell1.keyLable.text = NSLocalizedStringFromTable(@"MailUser", @STR_LOCALIZED_FILE_NAME, nil);
                cell1.textField.text = self.m_strUser;
                cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputMailUser", @STR_LOCALIZED_FILE_NAME, nil);
            }else{
                cell1.keyLable.text = NSLocalizedStringFromTable(@"MailRecv1", @STR_LOCALIZED_FILE_NAME, nil);
                cell1.textField.text = self.m_strRecv1;
                cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputMailRecv", @STR_LOCALIZED_FILE_NAME, nil);
            }            
            
            cell1.textField.delegate = self;
            cell1.textField.tag = anIndexPath.row;
            
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell = cell1;
        }
            break;
        case 6: //pwd || receiver2
        {
            CameraInfoCell *cell1 =  (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CameraInfoCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            
            if (m_nAuth) {
                cell1.keyLable.text = NSLocalizedStringFromTable(@"MailPwd", @STR_LOCALIZED_FILE_NAME, nil);
                cell1.textField.text = self.m_strPwd;
                cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputMailPwd", @STR_LOCALIZED_FILE_NAME, nil);
                cell1.textField.secureTextEntry = YES;
            }else{
                cell1.keyLable.text = NSLocalizedStringFromTable(@"MailRecv2", @STR_LOCALIZED_FILE_NAME, nil);
                cell1.textField.text = self.m_strRecv1;
                cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputMailRecv", @STR_LOCALIZED_FILE_NAME, nil);
                cell1.textField.secureTextEntry = NO;
            }
            
            
            cell1.textField.delegate = self;
            cell1.textField.tag = anIndexPath.row;
            
            
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell = cell1;
        }
            break;
        case 7: //recv1 || recv3
        {
            CameraInfoCell *cell1 =  (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CameraInfoCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            
            if (m_nAuth) {
                cell1.keyLable.text = NSLocalizedStringFromTable(@"MailRecv1", @STR_LOCALIZED_FILE_NAME, nil);
                cell1.textField.text = self.m_strRecv1;

            }else{
                cell1.keyLable.text = NSLocalizedStringFromTable(@"MailRecv3", @STR_LOCALIZED_FILE_NAME, nil);
                cell1.textField.text = self.m_strRecv3;
            }
            
            cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputMailRecv", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.delegate = self;
            cell1.textField.tag = anIndexPath.row;
            
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell = cell1;
        }
            break;
        case 8: //recv2 || recv4
        {
            CameraInfoCell *cell1 =  (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CameraInfoCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            
            if (m_nAuth) {
                cell1.keyLable.text = NSLocalizedStringFromTable(@"MailRecv2", @STR_LOCALIZED_FILE_NAME, nil);
                cell1.textField.text = self.m_strRecv2;
            }else{
                cell1.keyLable.text = NSLocalizedStringFromTable(@"MailRecv4", @STR_LOCALIZED_FILE_NAME, nil);
                cell1.textField.text = self.m_strRecv4;
            }            
            
            cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputMailRecv", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.delegate = self;
            cell1.textField.tag = anIndexPath.row;
            
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell = cell1;
        }
            break;
        case 9: //recv3
        {
            CameraInfoCell *cell1 =  (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CameraInfoCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            
            cell1.keyLable.text = NSLocalizedStringFromTable(@"MailRecv3", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.text = self.m_strRecv3;
            cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputMailRecv", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.delegate = self;
            cell1.textField.tag = anIndexPath.row;
            
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell = cell1;
        }
            break;
        case 10: //recv4
        {
            CameraInfoCell *cell1 =  (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            if (cell1 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CameraInfoCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            
            cell1.keyLable.text = NSLocalizedStringFromTable(@"MailRecv4", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.text = self.m_strRecv4;
            cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputMailRecv", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.delegate = self;
            cell1.textField.tag = anIndexPath.row;
            
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell = cell1;
        }
            break;
            
        default:
            break;
    }
    
    
	return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    [currentTextField resignFirstResponder];
    
    [aTableView deselectRowAtIndexPath:anIndexPath animated:YES];
    
    if (anIndexPath.row != 3) {
        return ;
    }
    
    oDropController *dropView = [[oDropController alloc] init];
    dropView.m_nIndexDrop = 103;
    dropView.m_DropListProtocolDelegate = self;
    [self.navigationController pushViewController:dropView animated:YES];
//    [dropView release];
    
}

#pragma mark -
#pragma mark KeyboardNotification

- (void)keyboardWillShowNotification:(NSNotification *)aNotification
{
    //NSLog(@"keyboardWillShowNotification");
    
    CGRect keyboardRect = CGRectZero;
	
	//
	// Perform different work on iOS 4 and iOS 3.x. Note: This requires that
	// UIKit is weak-linked. Failure to do so will cause a dylib error trying
	// to resolve UIKeyboardFrameEndUserInfoKey on startup.
	//
	if (UIKeyboardFrameEndUserInfoKey != nil)
	{
		keyboardRect = [self.view.superview
                        convertRect:[[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]
                        fromView:nil];
	}
	else
	{
		NSArray *topLevelViews = [self.view.window subviews];
		if ([topLevelViews count] == 0)
		{
			return;
		}
		
		UIView *topLevelView = [[self.view.window subviews] objectAtIndex:0];
		
		//
		// UIKeyboardBoundsUserInfoKey is used as an actual string to avoid
		// deprecated warnings in the compiler.
		//
		keyboardRect = [[[aNotification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
		keyboardRect.origin.y = topLevelView.bounds.size.height - keyboardRect.size.height;
		keyboardRect = [self.view.superview
                        convertRect:keyboardRect
                        fromView:topLevelView];
	}
	
	CGRect viewFrame = self.tableView.frame;
    
	textFieldAnimatedDistance = 0;
	if (keyboardRect.origin.y < viewFrame.origin.y + viewFrame.size.height)
	{
		textFieldAnimatedDistance = (viewFrame.origin.y + viewFrame.size.height) - (keyboardRect.origin.y - viewFrame.origin.y);
		viewFrame.size.height = keyboardRect.origin.y - viewFrame.origin.y;
        
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:PageViewControllerTextAnimationDuration];
		[self.tableView setFrame:viewFrame];
		[UIView commitAnimations];
	}
    
    //    NSLog(@"currentTextField: %f, %f, %f, %f",currentTextField.bounds.origin.x, currentTextField.bounds.origin.y, currentTextField.bounds.size.height, currentTextField.bounds.size.width);
    
	const CGFloat PageViewControllerTextFieldScrollSpacing = 10;
    
	CGRect textFieldRect =
    [self.tableView convertRect:currentTextField.bounds fromView:currentTextField];
    
    NSArray *rectarray = [self.tableView indexPathsForRowsInRect:textFieldRect];
    if (rectarray.count <= 0) {
        return;
    }
    
    //    NSIndexPath * indexPath = [rectarray objectAtIndex:0];
    //    NSLog(@"row: %d", indexPath.row);
    
	textFieldRect = CGRectInset(textFieldRect, 0, -PageViewControllerTextFieldScrollSpacing);
	[self.tableView scrollRectToVisible:textFieldRect animated:NO];
    
}

- (void)keyboardWillHideNotification:(NSNotification* )aNotification
{
    //NSLog(@"keyboardWillHideNotification");
    
    if (textFieldAnimatedDistance == 0)
	{
		return;
	}
	
	CGRect viewFrame = self.tableView.frame;
	viewFrame.size.height += textFieldAnimatedDistance;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:PageViewControllerTextAnimationDuration];
	[self.tableView setFrame:viewFrame];
	[UIView commitAnimations];
	
	textFieldAnimatedDistance = 0;
}


#pragma mark -
#pragma mark textFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	//NSLog(@"textFieldDidEndEditing");
    switch (textField.tag) {
        case 0: // sender
            self.m_strSender = textField.text;
            break;
        case 1: //smtp server
            self.m_strSMTPSvr = textField.text;

            break;
        case 2: //smtp port
            m_nSMTPPort = atoi([textField.text UTF8String]);
            if (m_nSMTPPort <= 0) {
                m_nSMTPPort = 25;
            }
            break;
        case 3://ssl
            m_nSSL = atoi([textField.text UTF8String]);
            if (m_nSMTPPort < 0) {
                m_nSMTPPort = 0;
            }
            break;
        case 4: //auth
           
            break;
        case 5: //user || recv1
        {
            if (m_nAuth) {
                self.m_strUser = textField.text;
            }else{
                self.m_strRecv1 = textField.text;
            }
        }
            break;
        case 6: //pwd || recv2;
        {
            if (m_nAuth) {
                self.m_strPwd = textField.text;
            }else{
                self.m_strRecv2 = textField.text;
            }
        }
            break;
        case 7: //recv1 || recv3
        {
            if (m_nAuth) {
                self.m_strRecv1 = textField.text;
            }else{
                self.m_strRecv3 = textField.text;
            }
            
        }
            break;
        case 8: //recv2 || recv4
        {
            if (m_nAuth) {
                self.m_strRecv2 = textField.text;
            }else{
                self.m_strRecv4 = textField.text;
            }
        }
            break;
        case 9: //recv3
        {
            self.m_strRecv3 = textField.text;
        }
            break;
        case 10: //recv4
        {
            self.m_strRecv4 = textField.text;
        }
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

#pragma mark -
#pragma mark navigationBarDelegate

- (BOOL) navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}

#pragma mark -
#pragma mark performOnMainThread
- (void) reloadTableView
{
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark droplistdelegate
- (void) DropListResult:(NSString*)strDescription nID:(int)nID nType:(int)nType param1:(int)param1 param2:(int)param2
{
    if (nType == 103) { //SSL
        m_nSSL = nID;
    }
    
    if (nType == 104) { //smtp server
        self.m_strSMTPSvr = strDescription;
        m_nSMTPPort = param1;
        m_nSSL = param2;
    }
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark maildelegate

- (void) MailParam:(NSString *)strSender smtpsvr:(NSString *)strSmtpSvr smtpport:(int)smtpport ssl:(int)ssl auth:(int)auth user:(NSString *)user pwd:(NSString *)pwd recv1:(NSString *)recv1 recv2:(NSString *)recv2 recv3:(NSString *)recv3 recv4:(NSString *)recv4
{
   // NSLog(@"sender: %@, svr: %@, port: %d, ssl: %d, auth: %d, user: %@, pwd:%@, recv1: %@, recv2: %@, recv3: %2, recv4: %2",strSender, strSmtpSvr, smtpport, ssl, auth, user, pwd, recv1, recv2, recv3, recv4);
    
    self.m_strSender = strSender;
    self.m_strSMTPSvr = strSmtpSvr;
    m_nSMTPPort = smtpport;
    m_nSSL = ssl;
    m_nAuth = auth;
    self.m_strUser = user;
    self.m_strPwd = pwd;
    self.m_strRecv1 = recv1;
    self.m_strRecv2 = recv2;
    self.m_strRecv3 = recv3;
    self.m_strRecv4 = recv4;
    
    if (m_nAuth) {
        m_nTableviewCount = 11;
    }
    
    
    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
    
}


@end
