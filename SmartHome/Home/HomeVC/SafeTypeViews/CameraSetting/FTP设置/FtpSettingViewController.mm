//
//  FtpSettingViewController.m
//  P2PCamera
//
//  Created by Tsang on 12-12-12.
//
//

static const double PageViewControllerTextAnimationDuration = 0.33;

#import "FtpSettingViewController.h"
#import "obj_common.h"
#import "defineutility.h"
#import "CameraInfoCell.h"
#import "mytoast.h"


@interface FtpSettingViewController ()

@end

@implementation FtpSettingViewController

@synthesize navigationBar;
@synthesize tableView;
@synthesize currentTextField;
@synthesize m_strFTPSvr;
@synthesize m_strPwd;
@synthesize m_strUser;
@synthesize m_pChannelMgt;
@synthesize m_strDID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) btnSetFTP:(id) sender
{
    [currentTextField resignFirstResponder];
    
    //NSLog(@"ftpSvr: %@, ftpport: %d, ftpUser: %@, ftpPwd: %@", m_strFTPSvr, m_nFTPPort, m_strUser, m_strPwd);

    m_pChannelMgt->SetFTP((char*)[m_strDID UTF8String],
                          (char*)[m_strFTPSvr UTF8String],
                          (char*)[m_strUser UTF8String],
                          (char*)[m_strPwd UTF8String],
                          (char*)"/", m_nFTPPort, m_nUploadInterval, 0);
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.m_strFTPSvr = @"";
    self.m_strPwd = @"";
    self.m_strUser = @"";
    m_nFTPPort = 21;
    m_nUploadInterval = 0;
    
   // UIImage *image = [UIImage imageNamed:@"top_bg_blue.png"];
   // [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    //self.navigationBar.delegate = self;
    //self.navigationBar.tintColor = [UIColor colorWithRed:BTN_NORMAL_RED/255.0f green:BTN_NORMAL_GREEN/255.0f blue:BTN_NORMAL_BLUE/255.0f alpha:1];
    
    //self.textPassword = nil;
    NSString *strTitle = NSLocalizedStringFromTable(@"FTPSetting", @STR_LOCALIZED_FILE_NAME, nil);
    //UINavigationItem *back = [[UINavigationItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Back", @STR_LOCALIZED_FILE_NAME, nil)];
    //UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:strTitle];
    
    self.navigationItem.title = strTitle;
    //创建一个右边按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil)
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(btnSetFTP:)];
    
    //item.rightBarButtonItem = rightButton;
    self.navigationItem.rightBarButtonItem = rightButton;
   // NSArray *array = [NSArray arrayWithObjects:back, item, nil];
    //[self.navigationBar setItems:array];
//    [rightButton release];
    //[item release];
    //[back release];
    
    
    m_pChannelMgt->SetFTPDelegate((char*)[m_strDID UTF8String], self);
    m_pChannelMgt->PPPPSetSystemParams((char*)[m_strDID UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void) dealloc
{
    m_pChannelMgt->SetFTPDelegate((char*)[m_strDID UTF8String], nil);
    self.navigationBar = nil;
    self.tableView = nil;
    self.currentTextField = nil;
    self.m_strPwd = nil;
    self.m_strFTPSvr = nil;
    self.m_strUser = nil;
    self.m_strDID = nil;
//    [super dealloc];
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
    NSString *cellIdentifier = @"FTPSettingCell1";
    
    CameraInfoCell *cell1 =  (CameraInfoCell*)[aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell1 == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CameraInfoCell" owner:self options:nil];
        cell1 = [nib objectAtIndex:0];
    }
    
    switch (anIndexPath.row) {
        case 0: //ftp server
        {            
            cell1.keyLable.text = NSLocalizedStringFromTable(@"FTPServer", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.text = m_strFTPSvr;
            cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputFtpServer", @STR_LOCALIZED_FILE_NAME, nil);
        }
            break;
        case 1: //ftp port
        {
            
            cell1.keyLable.text = NSLocalizedStringFromTable(@"FTPPort", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.text = [NSString stringWithFormat:@"%d", m_nFTPPort];
            cell1.textField.keyboardType = UIKeyboardTypeNumberPad;
          
        }
            break;
        case 2: //ftp user
        {
            cell1.keyLable.text = NSLocalizedStringFromTable(@"FTPUser", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.text = m_strUser;
            cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputFtpUser", @STR_LOCALIZED_FILE_NAME, nil);
            
        }
            break;
        case 3: //ftp pwd
        {
            
            cell1.keyLable.text = NSLocalizedStringFromTable(@"FTPPwd", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.text = m_strPwd;
            cell1.textField.secureTextEntry = YES;
            cell1.textField.placeholder = NSLocalizedStringFromTable(@"InputFtpPwd", @STR_LOCALIZED_FILE_NAME, nil);
            
        }
            break;
        case 4: //upload interval
        {
            cell1.keyLable.text = NSLocalizedStringFromTable(@"FTPUploadInterval", @STR_LOCALIZED_FILE_NAME, nil);
            cell1.textField.text = [NSString stringWithFormat:@"%d", m_nUploadInterval];
            cell1.textField.keyboardType = UIKeyboardTypeNumberPad;
          
        }
            break;
            
        default:
            break;
    }    
    
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    cell1.textField.delegate = self;
    cell1.textField.tag = anIndexPath.row;
    
	return cell1;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)anIndexPath
{
    //[currentTextField resignFirstResponder];
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
        case 0: // ftp server
            self.m_strFTPSvr = textField.text;
            break;
        case 1: //ftp port
            m_nFTPPort = atoi([textField.text UTF8String]);
            if (m_nFTPPort <= 0) {
                m_nFTPPort = 21;
            }
            break;
        case 2: //ftp user
            self.m_strUser = textField.text;
            break;
        case 3://ftp pwd
            self.m_strPwd = textField.text;
            break;
        case 4: //upload interval
            m_nUploadInterval = atoi([textField.text UTF8String]);
            if (m_nUploadInterval < 0) {
                m_nUploadInterval = 0;
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
#pragma mark ftpParamDelegate
- (void) FtpParam:(char *)svr user:(char *)user pwd:(char *)pwd dir:(char *)dir port:(int)port uploadinterval:(int)uploadinterval mode:(int)mode
{
    //NSLog(@"svr: %s, user: %s, pwd: %s, dir: %s, port: %d, uploadinterval: %d, mode: %d", svr, user, pwd, dir, port, uploadinterval,mode);
    
    m_strFTPSvr = [NSString stringWithFormat:@"%s", svr];
    m_strUser = [NSString stringWithFormat:@"%s",user];
    m_strPwd = [NSString stringWithFormat:@"%s",pwd];
    m_nFTPPort = port;
    m_nUploadInterval = uploadinterval;
    
    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
    
}


@end
