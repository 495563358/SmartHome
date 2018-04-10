//
//  SetRecordTimeViewController.m
//  P2PCamera
//
//  Created by yan luke on 13-6-21.
//
//

#import "SetRecordTimeViewController.h"
#import "OpenRecScheduleCell.h"
#import "obj_common.h"
//#import "DatePickerCustomView.h"
//#import "SingleDatePicCustomView.h"
#define ICONIMG_TAG 200


@interface SetRecordTimeViewController ()
@property (nonatomic, retain) UIActionSheet* actionSheet;
@property (nonatomic, retain) UIDatePicker* datePic;
@property (nonatomic) BOOL is_startTime;
@property (nonatomic) BOOL is_endTime;
@property (nonatomic) BOOL is_change;//判断是否有更改

@property (nonatomic, retain) UISwipeGestureRecognizer* swipeGes;
@end

@implementation SetRecordTimeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _is_endTime = NO;
        _is_startTime = NO;
        for (int i = 0; i < 7; i++) {
            weeks[i] = 1;
        }
        //self.startDateStr = [NSString string];
        //self.endDateStr = [NSString string];
        _is_change = NO;
        _is_openRecord = YES;
        //self.startTime = [NSDate date];
        //self.endTime = [NSDate date];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self.navigationItem setHidesBackButton:YES];
    
//    UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftBtn setBackgroundImage:[[UIImage imageNamed:@"middle_back_btn_down"] stretchableImageWithLeftCapWidth:56 topCapHeight:0] forState:UIControlStateNormal];
//    [leftBtn setTitle:NSLocalizedStringFromTable(@"SDSetting", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
//    leftBtn.titleLabel.font = [UIFont systemFontOfSize:10.f];
//    leftBtn.titleLabel.shadowColor = [UIColor darkGrayColor];
//    leftBtn.titleLabel.shadowOffset = CGSizeMake(-1.f, 0.f);
//    [leftBtn addTarget:self action:@selector(backSuperView:) forControlEvents:UIControlEventTouchUpInside];
//    leftBtn.frame = CGRectMake(0.f, 5.f, 70.f, 34.f);
//    
//    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:leftBtn] autorelease];
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Done", @STR_LOCALIZED_FILE_NAME, nil) style:UIBarButtonItemStyleDone target:self action:@selector(doneSetRecordTime:)];
    self.navigationItem.rightBarButtonItem = rightItem;
//    [rightItem release],rightItem = nil;
    
    if (!_bAddRecordTime && _Selectweeks != nil && [_Selectweeks count] != 0) {
        for (int i = 0; i < 7; i++) {
            weeks[i] = [[_Selectweeks objectAtIndex:i] intValue];
        }
    }
    
    CGRect winsize = [UIScreen mainScreen].bounds;
    self.aTabelView = [[UITableView alloc] initWithFrame:winsize style:UITableViewStyleGrouped];
    self.aTabelView.delegate = self;
    self.aTabelView.dataSource = self;
    [self.view addSubview:self.aTabelView];
    
    //    self.singlePic = [[SingleDatePicCustomView alloc] initWithFrame:CGRectMake(winsize.size.width/2 - 160.f, (winsize.size.height - 20.f - 44.f)/ 2 - 163.f, 320.f, 326.f)];
    //    self.singlePic.delegate = self;
    //    [self.view addSubview:self.singlePic];
    
    self.selectedWeekView = [[CustomRepeatView alloc] initWithFrame:CGRectMake(0.f, 0.f, 280.f, 0.f)];
    self.selectedWeekView.delegate = self;
    [self.view addSubview:self.selectedWeekView];
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"%@\n\n\n\n\n\n\n\n\n\n\n\n\n",NSLocalizedStringFromTable(@"StartTime", @STR_LOCALIZED_FILE_NAME, nil)] delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
    
    _swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGes)];
    _swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_swipeGes];
}

- (void) handleSwipeGes{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.actionSheet showInView:self.view];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(5.f, 2.f, 80.f, 30.f);
    [btn setBackgroundImage:[[UIImage imageNamed:@"custom-cancel-normal"] stretchableImageWithLeftCapWidth:9 topCapHeight:0] forState:UIControlStateNormal];
    [btn setTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [self.actionSheet addSubview:btn];
    btn = nil;
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.actionSheet.frame.size.width - 80.f - 5.f, 2.f, 80.f, 30.f);
    [btn setBackgroundImage:[[UIImage imageNamed:@"custom-button-normal"] stretchableImageWithLeftCapWidth:9 topCapHeight:0] forState:UIControlStateNormal];
    [btn setTitle:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doneSetTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.actionSheet addSubview:btn];
    btn = nil;//
    
    self.actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    self.datePic = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.f, 50.f, 0.f, 0.f)];
    self.datePic.datePickerMode = UIDatePickerModeTime;
    self.datePic.minuteInterval = 15;
    self.datePic.locale = [NSLocale currentLocale];
    [self.datePic addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventTouchUpInside];
    [self.actionSheet addSubview:self.datePic];
    
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:NO];
}

- (void) backSuperView:(id) sender{
    if (self.is_change) {
        if (self.startTime != nil && self.endTime != nil) {
            if ([self.startDateStr compare:self.endDateStr] == -1) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"ConfirmRecordTime", @STR_LOCALIZED_FILE_NAME, nil) message:[NSString stringWithFormat:@"%@ ~ %@",self.startDateStr,self.endDateStr] delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil), nil];
                alert.tag = 10;
                [alert show];
//                [alert release],alert = nil;
            }else{
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"SelectedRecordTime", @STR_LOCALIZED_FILE_NAME, nil) message:nil delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:[NSString stringWithFormat:@"00 : 00 ~ %@, %@ ~ 24 : 00",self.endDateStr,self.startDateStr], [NSString stringWithFormat:@"00 : 00 ~ %@",self.endDateStr], [NSString stringWithFormat:@"%@ ~ 24 : 00",self.startDateStr], nil];
                alert.tag = 11;
                [alert show];
//                [alert release],alert = nil;
            }
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) doneSetRecordTime:(id) sender{
    if (self.startTime == nil || self.endTime == nil) {
        UIAlertView* alert  = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"TimeNotEmpty", @STR_LOCALIZED_FILE_NAME, nil) message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil), nil];
        [alert show];
//        [alert release];
    }else{
        if ([self.startDateStr compare:self.endDateStr] == -1) {
            if (_delegate != nil) {
                [_delegate SetRecordTimeViewController:self withStarTimes:[NSArray arrayWithObject:self.startDateStr] EndDateTimes:[NSArray arrayWithObject:self.endDateStr] andRepeatDay:weeks OpenRecord:self.is_openRecord];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"SelectedRecordTime", @STR_LOCALIZED_FILE_NAME, nil) message:nil delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:[NSString stringWithFormat:@"00 : 00 ~ %@, %@ ~ 24 : 00",self.endDateStr,self.startDateStr], [NSString stringWithFormat:@"00 : 00 ~ %@",self.endDateStr], [NSString stringWithFormat:@"%@ ~ 24 : 00",self.startDateStr], nil];
            alert.tag = 11;
            [alert show];
//            [alert release],alert = nil;
        }
        
    }
}

- (void) dismissActionSheet{
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void) doneSetTime:(UIButton*) sender{
    if (self.is_startTime) {
        if (self.startTime == nil) {
            _is_change = YES;
        }else{
            if ([self.startTime compare:self.datePic.date] != NSOrderedSame) {
                _is_change = YES;
            }
        }
        
        self.startTime = self.datePic.date;
    }
    if (self.is_endTime) {
        if (self.endTime == nil) {
            _is_change = YES;
        }else{
            if ([self.endTime compare:self.datePic.date] != NSOrderedSame) {
                _is_change = YES;
            }
        }
        
        self.endTime = self.datePic.date;
    }
    
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    dispatch_async(dispatch_get_main_queue(),^{
        [self.aTabelView reloadData];
    });
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"buttonIndex  %d",buttonIndex);
    if (alertView.tag == 10) {
        if (buttonIndex == 0) {
            
        }else{
            if (_delegate != nil) {
                [_delegate SetRecordTimeViewController:self withStarTimes:[NSArray arrayWithObject:self.startDateStr] EndDateTimes:[NSArray arrayWithObject:self.endDateStr] andRepeatDay:weeks OpenRecord:self.is_openRecord];
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else if (alertView.tag == 11){
        if (buttonIndex == 0) {
            
        }else if (buttonIndex == 1){
            if (_delegate != nil) {
                [_delegate SetRecordTimeViewController:self withStarTimes:[NSArray arrayWithObjects:@"00 : 00",self.startDateStr, nil] EndDateTimes:[NSArray arrayWithObjects:self.endDateStr,@"24 : 00", nil] andRepeatDay:weeks OpenRecord:self.is_openRecord];
            }
        }else if (buttonIndex == 2){
            if (_delegate != nil) {
                self.startDateStr = @"00 : 00";
                [_delegate SetRecordTimeViewController:self withStarTimes:[NSArray arrayWithObject:self.startDateStr] EndDateTimes:[NSArray arrayWithObject:self.endDateStr] andRepeatDay:weeks OpenRecord:self.is_openRecord];
            }
        }else if (buttonIndex == 3){
            if (_delegate != nil) {
                self.endDateStr = @"24 : 00";
                [_delegate SetRecordTimeViewController:self withStarTimes:[NSArray arrayWithObject:self.startDateStr] EndDateTimes:[NSArray arrayWithObject:self.endDateStr] andRepeatDay:weeks OpenRecord:self.is_openRecord];
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    self.is_endTime = NO;
    self.is_startTime = NO;
}

- (void) changeDate:(UIDatePicker*) datePic{
    
}

#pragma mark -
#pragma mark UITableViewDelegate Or DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString* cellIden = @"OpenRecScheduleCell";
        OpenRecScheduleCell* cell = (OpenRecScheduleCell*)[tableView dequeueReusableCellWithIdentifier:cellIden];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"OpenRecScheduleCell" owner:self options:nil] lastObject];
        }
        cell.iconImg.is_Selected_Icon = _is_openRecord;
        cell.iconImg.tag = ICONIMG_TAG;
        cell.titleLabel.text = NSLocalizedStringFromTable(@"OpenRecord", @STR_LOCALIZED_FILE_NAME, nil);
        return cell;
    }else{
        static NSString* iden = @"IdenCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.row) {
            case 1:
            {
                cell.textLabel.text = NSLocalizedStringFromTable(@"StartTime", @STR_LOCALIZED_FILE_NAME, nil);
                if (self.startTime != nil) {
                    NSCalendar* calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                    NSDateComponents* components = [[NSDateComponents alloc] init];
                    NSInteger unitFlags =  NSHourCalendarUnit | NSMinuteCalendarUnit;
                    components = [calender components:unitFlags fromDate:self.startTime];
                    int hour = [components hour];
                    int min = [components minute];
                    NSString* hourStr = [NSString stringWithFormat:@"%d",hour];
                    NSString* minStr = [NSString stringWithFormat:@"%d",min];
                    if (hour < 10) {
                        hourStr = [NSString stringWithFormat:@"0%d",hour];
                    }
                    if (min < 10) {
                        minStr = [NSString stringWithFormat:@"0%d",min];
                    }
                    self.startDateStr = [NSString stringWithFormat:@"%@ : %@",hourStr,minStr];
                    cell.detailTextLabel.text = _startDateStr;
                }
            }
                break;
            case 2:
            {
                cell.textLabel.text = NSLocalizedStringFromTable(@"EndTime", @STR_LOCALIZED_FILE_NAME, nil);
                if (self.endTime != nil) {
                    NSCalendar* calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                    NSDateComponents* components = [[NSDateComponents alloc] init];
                    NSInteger unitFlags =  NSHourCalendarUnit | NSMinuteCalendarUnit;
                    components = [calender components:unitFlags fromDate:self.endTime];
                    int hour = [components hour];
                    int min = [components minute];
                    if (hour == 0 && min == 0) {
                        hour = 24;
                    }
                    
                    NSString* hourStr = [NSString stringWithFormat:@"%d",hour];
                    NSString* minStr = [NSString stringWithFormat:@"%d",min];
                    
                    if (hour < 10) {
                        hourStr = [NSString stringWithFormat:@"0%d",hour];
                    }
                    if (min < 10) {
                        minStr = [NSString stringWithFormat:@"0%d",min];
                    }
                    
                    self.endDateStr = [NSString stringWithFormat:@"%@ : %@",hourStr,minStr];
                    cell.detailTextLabel.text = _endDateStr;
                }
            }
                break;
            case 3:
            {
                cell.textLabel.text = NSLocalizedStringFromTable(@"Repeat", @STR_LOCALIZED_FILE_NAME, nil);
                NSString* weekStr = [NSString string];
                for (int i = 0; i < 7; i ++) {
                    if (weeks[i] == 1) {
                        switch (i) {
                            case 1:
                                if (weekStr == nil || [weekStr length] == 0) {
                                    weekStr = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"Monday", @STR_LOCALIZED_FILE_NAME, nil)];
                                }else{
                                    weekStr = [NSString stringWithFormat:@"%@,%@",weekStr,NSLocalizedStringFromTable(@"Monday", @STR_LOCALIZED_FILE_NAME, nil)];
                                }
                                
                                break;
                            case 2:
                                if (weekStr == nil || [weekStr length] == 0) {
                                    weekStr = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"Tuesday", @STR_LOCALIZED_FILE_NAME, nil)];
                                }else{
                                    weekStr = [NSString stringWithFormat:@"%@,%@",weekStr,NSLocalizedStringFromTable(@"Tuesday", @STR_LOCALIZED_FILE_NAME, nil)];
                                }
                                
                                break;
                            case 3:
                                if (weekStr == nil || [weekStr length] == 0) {
                                    weekStr = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"Wednesday", @STR_LOCALIZED_FILE_NAME, nil)];
                                }else{
                                    weekStr = [NSString stringWithFormat:@"%@,%@",weekStr,NSLocalizedStringFromTable(@"Wednesday", @STR_LOCALIZED_FILE_NAME, nil)];
                                }
                                
                                break;
                            case 4:
                                if (weekStr == nil || [weekStr length] == 0) {
                                    weekStr = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"Thursday", @STR_LOCALIZED_FILE_NAME, nil)];
                                }else{
                                    weekStr = [NSString stringWithFormat:@"%@,%@",weekStr,NSLocalizedStringFromTable(@"Thursday", @STR_LOCALIZED_FILE_NAME, nil)];
                                }
                                
                                break;
                            case 5:
                                if (weekStr == nil || [weekStr length] == 0) {
                                    weekStr = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"Friday", @STR_LOCALIZED_FILE_NAME, nil)];
                                }else{
                                    weekStr = [NSString stringWithFormat:@"%@,%@",weekStr,NSLocalizedStringFromTable(@"Friday", @STR_LOCALIZED_FILE_NAME, nil)];
                                }
                                
                                break;
                            case 6:
                                if (weekStr == nil || [weekStr length] == 0) {
                                    weekStr = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"Saturday", @STR_LOCALIZED_FILE_NAME, nil)];
                                }else{
                                    weekStr = [NSString stringWithFormat:@"%@,%@",weekStr,NSLocalizedStringFromTable(@"Saturday", @STR_LOCALIZED_FILE_NAME, nil)];
                                }
                                
                                break;
                            case 0:
                                if (weekStr == nil || [weekStr length] == 0) {
                                    weekStr = [NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"Sunday", @STR_LOCALIZED_FILE_NAME, nil)];
                                }else{
                                    weekStr = [NSString stringWithFormat:@"%@,%@",weekStr,NSLocalizedStringFromTable(@"Sunday", @STR_LOCALIZED_FILE_NAME, nil)];
                                }
                                
                                break;
                            default:
                                break;
                        }
                    }
                }
                self.weekStr = weekStr;
                cell.detailTextLabel.text = weekStr;
            }
                break;
            default:
                break;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        UIView* view = [self.view viewWithTag:ICONIMG_TAG];
        if ([view isKindOfClass:[RecordTimeMode class]]) {
            RecordTimeMode* recV = (RecordTimeMode*) view;
            recV.is_Selected_Icon = !recV.is_Selected_Icon;
            _is_openRecord = recV.is_Selected_Icon;
            _is_change = YES;
        }
    }else if (indexPath.row == 3){
        if (_selectedWeekView.repeatView_Show) {
            [_selectedWeekView dismissCustomRepeatView];
        }else{
            [_selectedWeekView.weeks removeAllObjects];
            for (int i = 0; i < 7; i++) {
                [_selectedWeekView.weeks addObject:[NSNumber numberWithInt:weeks[i]]];
            }
            [_selectedWeekView showCustomRepeatView];
        }
    }else if (indexPath.row == 1){
        /* CGSize winsize = [UIScreen mainScreen].applicationFrame.size;
         DatePickerCustomView* pick = [[DatePickerCustomView alloc] initWithFrame:CGRectMake(winsize.width/2 - 230.f, winsize.height/2 - 155.f, 460.f, 320.f)];
         pick.center = self.view.center;
         [self.view addSubview:pick];
         [pick release],pick = nil;*/
        self.is_startTime = YES;
        self.actionSheet.title = [NSString stringWithFormat:@"%@\n\n\n\n\n\n\n\n\n\n\n\n\n",NSLocalizedStringFromTable(@"StartTime", @STR_LOCALIZED_FILE_NAME, nil)];
        if (self.startTime != nil) {
            self.datePic.date = self.startTime;
        }else{
            self.datePic.date = [NSDate date];
        }
        [self.actionSheet showInView:self.view];
        /*if (!_singlePic.Pic_show) {
         [_singlePic showSingleView];
         }else{
         [_singlePic DismissSingleView];
         }*/
    }else if (indexPath.row == 2){
        self.is_endTime = YES;
        self.actionSheet.title = [NSString stringWithFormat:@"%@\n\n\n\n\n\n\n\n\n\n\n\n\n",NSLocalizedStringFromTable(@"EndTime", @STR_LOCALIZED_FILE_NAME, nil)];
        if (self.endTime != nil) {
            self.datePic.date = self.endTime;
        }else{
            self.datePic.date = [NSDate date];
        }
        [self.actionSheet showInView:self.view];
    }
}

//#pragma mark -
//#pragma mark SingleDatePicCustomViewDelegate
//- (void) sendDateToParentView:(SingleDatePicCustomView *)singView isStartTimeBigEndTime:(BOOL)is_startbigEnd is_selectedMiddle:(BOOL)is_seletedMid{
//    NSLog(@"SingleDatePicCustomView  %@   %@",singView.startTime,singView.endTime);
//}

#pragma mark -
#pragma mark CustomRepeatViewDelegate
- (void) sendCustomRepeatViewToParentView:(CustomRepeatView*) custom andSeletedItems:(int*) seleted{
    for (int i = 0; i < 7; i++) {
        weeks[i] = seleted[i];
    }
    _is_change = YES;
    dispatch_async(dispatch_get_main_queue(),^{
        [self.aTabelView reloadData];
    });
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
    [self.view removeGestureRecognizer:_swipeGes];
//    [_swipeGes release],_swipeGes = nil;
//    
//    [super dealloc];
    //self.aTabelView = nil;
    //[_aTabelView release],_aTabelView = nil;
//    [_selectedWeekView release],_selectedWeekView = nil;
    //[_actionSheet release],_actionSheet = nil;
    //[_datePic release],_datePic = nil;
}

@end
