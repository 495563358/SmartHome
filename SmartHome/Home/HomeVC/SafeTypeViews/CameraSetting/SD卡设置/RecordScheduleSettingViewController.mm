//
//  RecordScheduleSettingViewController.m
//  P2PCamera
//
//  Created by yan luke on 13-6-21.
//
//

#import "RecordScheduleSettingViewController.h"
#import "cmdhead.h"
#import "PPPPDefine.h"
#import "SDCardCell.h"
#import "SDStatusCell.h"
#import "obj_common.h"
#import "SetRecordTimeCell.h"
#import "RecordScheduleCell.h"
#import "SetRecordScheduleCell.h"
#import "SetRecordTimeViewController.h"
#import "AddPlanViewController.h"
#import "AddScheduleTimeCell.h"
#import "SetScheduleTimeCell.h"
#import "LookCurrentRecordScheduleViewController.h"
#import "PlanManagement.h"
#import "PlanModel.h"

#define KEYSTRATTIME @"STRATTIME"
#define KEYENDTIME @"ENDTIME"
#define KEYOPENRECORD @"OPENRECORD"
#define KEYREPEATDAY @"REPEATDAY"
#define KEYREPEATWEEK @"REPEATWEEK"
#define KEYSTRATDATE @"STARTDATE"
#define KEYENDDATE @"ENDDATE"
#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey :@"UIKeyboardBoundsUserInfoKey")

@interface RecordScheduleSettingViewController ()
@property (nonatomic) int SDCardTotal;
@property (nonatomic) int SDCardFree;
@property (nonatomic) int SDCardStatus;
@property (nonatomic) int timeLength;
@property (nonatomic) int coverEnable;
@property (nonatomic) int recordSize;//返回值一直为0，所以暂时不显示
@property (nonatomic) int ScheduleRecordEnable;
@property (nonatomic) BOOL SetRecordSchedule;//显示实时录像的时间表
@property (nonatomic) BOOL SetRecordTime;//设置实时录像时间
@property (nonatomic) int fixed_enable;
@property (nonatomic) BOOL is_LookRecSchedule;
@property (nonatomic, retain) UITapGestureRecognizer* resignKeyBoard;
@property (nonatomic, retain) UITextField* timeLengthTf;
@property (nonatomic, retain) UISwipeGestureRecognizer* swipeGes;
@property (nonatomic, retain) NSMutableArray* RecSchedule;
@property (nonatomic, retain) NSMutableArray* MotionRecSchedule;
@end

@implementation RecordScheduleSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _SDCardFree = 0;
        _SDCardStatus = 0;
        _SDCardTotal = 0;
        _timeLength = 0;
        _coverEnable = 0;
        _recordSize = 0;
        _ScheduleRecordEnable = 0;
        _SetRecordSchedule = NO;
        _SetRecordTime = NO;
        _is_LookRecSchedule = NO;
        _RecSchedule = [[NSMutableArray alloc] init];
        _MotionRecSchedule = [[NSMutableArray alloc] init];
        memset(&tmp, 0, sizeof(tmp));
        Schedule = [[NSMutableArray alloc] initWithCapacity:672];//[[NSMutableArray arrayWithCapacity:672] retain];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
        }
        self.resignKeyBoard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard:)];
        self.resignKeyBoard.numberOfTapsRequired = 1;
    }
    return self;
}

- (void) resignKeyboard:(UITapGestureRecognizer*) tapGes{
    [self.timeLengthTf resignFirstResponder];
}

#pragma mark -
#pragma mark KeyBoardNotifycation
- (void) keyBoardShow:(NSNotification*) notification{
    CGSize winsize = [UIScreen mainScreen].bounds.size;
    NSValue* keyboardValue = [[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [keyboardValue CGRectValue].size;
    
    NSIndexPath* patn = [NSIndexPath indexPathForRow:1 inSection:1];
    UITableViewCell* cell = [self.aTableView cellForRowAtIndexPath:patn];
    CGRect rect = [self.aTableView convertRect:cell.frame toView:self.view];
    NSLog(@"rect  %@",NSStringFromCGRect(rect));
    CGFloat height = keyboardSize.height - (winsize.height - rect.size.height - rect.origin.y - 20.f - 44.f);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [UIView animateWithDuration:0.5f animations:^{
            self.view.frame = CGRectMake(0.f, (height * (-1)), winsize.width, winsize.height);
        }];
    }
    [self.view addGestureRecognizer:_resignKeyBoard];
    //NSLog(@"Height  %f  loginBtn  %@",height,NSStringFromCGRect(self.loginBtn.frame));
}

- (void) keyBoardHide:(NSNotification*) notification{
    CGSize winsize = [UIScreen mainScreen].bounds.size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [UIView animateWithDuration:0.5f animations:^{
            self.view.frame = CGRectMake(0.f, 0.f, winsize.width, winsize.height);
        }];
    }
    [self.view removeGestureRecognizer:_resignKeyBoard];
}

- (void) saveSDSetting:(id) sender{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"ConfirmSaveSDSetting", @STR_LOCALIZED_FILE_NAME, nil) message:nil delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil), nil];
    alert.tag = 100;
    [alert show];
//    [alert release];
}

- (void) SetSDRecordParam:(id) sender{
    [self TwoAndTen];
    [self.timeLengthTf resignFirstResponder];
    if (_timeLength > 180) {
        _timeLength = 180;
    }else if (_timeLength < 5){
        _timeLength = 5;
    }
    NSLog(@"_timeLength  %d",_timeLength);
    _m_PPPPChannelMgt->SetSDcardScheduleParams((char*) [self.m_strDID UTF8String], _coverEnable, _timeLength, _ScheduleRecordEnable, RecordTime[0], RecordTime[1], RecordTime[2], RecordTime[3], RecordTime[4], RecordTime[5], RecordTime[6], RecordTime[7], RecordTime[8], RecordTime[9], RecordTime[10], RecordTime[11], RecordTime[12], RecordTime[13], RecordTime[14], RecordTime[15], RecordTime[16], RecordTime[17], RecordTime[18], RecordTime[19], RecordTime[20]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveSDSetting:)];
    self.navigationItem.rightBarButtonItem = item;
//    [item release],item = nil;
    
    _aTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _aTableView.delegate = self;
    _aTableView.dataSource = self;
    [self.view addSubview:_aTableView];
    self.aTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    _swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGes)];
    _swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:_swipeGes];
    
    _m_PPPPChannelMgt->PPPPSetSystemParams((char*)[self.m_strDID UTF8String], MSG_TYPE_GET_RECORD, NULL, 0);
    _m_PPPPChannelMgt->SetSDcardScheduleDelegate((char*)[self.m_strDID UTF8String], self);
    [[PlanManagement shareManagement].RecordPlanArray removeAllObjects];
    [[PlanManagement shareManagement].MotionRecordPlanArray removeAllObjects];
    [self getPlanStatus];
}

- (void)getPlanStatus
{
    //获取录像计划指令
    NSString *commandStr = [NSString stringWithFormat:@"trans_cmd_string.cgi?cmd=2017&command=11&mark=212&type=3&"];
    _m_PPPPChannelMgt->GetJsonCGI((char*)[self.m_strDID UTF8String], 2017, (char *)[commandStr UTF8String]);
    
    //获取移动侦测录像计划指令
    NSString *commandStr2 = [NSString stringWithFormat:@"trans_cmd_string.cgi?cmd=2017&command=11&mark=212&type=1&"];
    _m_PPPPChannelMgt->GetJsonCGI((char*)[self.m_strDID UTF8String], 2017, (char *)[commandStr2 UTF8String]);
    
    //移动侦测录像计划指令生效需把移动侦测功能打开
    //获取移动侦测状态
    _m_PPPPChannelMgt->SetAlarmDelegate((char*)[self.m_strDID UTF8String], self);
    _m_PPPPChannelMgt->PPPPSetSystemParams((char*)[self.m_strDID UTF8String], MSG_TYPE_GET_PARAMS, NULL, 0);
}

//获取到的移动侦测状态结果
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
    //默认打开移动侦测功能
    _m_PPPPChannelMgt->SetAlarm((char*)[_m_strDID UTF8String], 1, motion_sensitivity, input_armed, ioin_level, alarmpresetsit, iolinkage, ioout_level, mail, upload_interval,1);
}

- (void) handleSwipeGes{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_is_LookRecSchedule) {
        _is_LookRecSchedule = !_is_LookRecSchedule;
        [self SetSDRecordParam:nil];
    }
    [_RecSchedule removeAllObjects];
    [_MotionRecSchedule removeAllObjects];
    [_RecSchedule addObjectsFromArray:[PlanManagement shareManagement].RecordPlanArray];
    [_MotionRecSchedule addObjectsFromArray:[PlanManagement shareManagement].MotionRecordPlanArray];
    if (_SetRecordSchedule) {
        [self.aTableView reloadData];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidUnload{
    [super viewDidUnload];
    _m_PPPPChannelMgt->SetSDcardScheduleDelegate((char*)[self.m_strDID UTF8String], nil);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)weekStr:(NSString *)weekStr
{
    NSArray *array = [weekStr componentsSeparatedByString:@","];
    NSMutableString *weeksStr = [[NSMutableString alloc] init];
    NSString *weekStr02;
    for (int i = 0; i < array.count; i++)
    {
        switch ([array[i] integerValue])
        {
            case 6:
                weekStr02 = NSLocalizedStringFromTable(@"Saturday", @STR_LOCALIZED_FILE_NAME, nil);
                break;
            case 5:
                weekStr02 = NSLocalizedStringFromTable(@"Friday", @STR_LOCALIZED_FILE_NAME, nil);
                break;
            case 4:
                weekStr02 = NSLocalizedStringFromTable(@"Thursday", @STR_LOCALIZED_FILE_NAME, nil);
                break;
            case 3:
                weekStr02 = NSLocalizedStringFromTable(@"Wednesday", @STR_LOCALIZED_FILE_NAME, nil);
                break;
            case 2:
                weekStr02 = NSLocalizedStringFromTable(@"Tuesday", @STR_LOCALIZED_FILE_NAME, nil);
                break;
            case 1:
                weekStr02 = NSLocalizedStringFromTable(@"Monday", @STR_LOCALIZED_FILE_NAME, nil);
                break;
            default:
                weekStr02 = NSLocalizedStringFromTable(@"Sunday", @STR_LOCALIZED_FILE_NAME, nil);
                break;
        }
        NSString *str = [NSString stringWithFormat:@" %@", weekStr02];
        [weeksStr appendString:str];
    }
    return weeksStr;
}

#pragma mark -
#pragma mark UITableView Dalegate  Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_SetRecordSchedule) {
        return 4;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (_SDCardStatus == PPPP_SDCARD_STATUS_NON) {
            return 3;
        }else{
            return 4;
        }
    }else if (section == 1){
        return 4;
    }else if (section == 2){
        return [_RecSchedule count] + 1;
    }else {
        return [_MotionRecSchedule count] + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            static NSString* statusCell = @"StatusCell";
            SDStatusCell* cell = (SDStatusCell*)[tableView dequeueReusableCellWithIdentifier:statusCell];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SDStatusCell" owner:self options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.keyLabel.text = NSLocalizedStringFromTable(@"状态", @STR_LOCALIZED_FILE_NAME, nil);
            cell.keyLabel.autoresizingMask = UIViewAutoresizingNone;
            cell.contentLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
            if (_SDCardStatus == PPPP_SDCARD_STATUS_NON) {
                cell.contentLabel.text = NSLocalizedStringFromTable(@"未检测到", @STR_LOCALIZED_FILE_NAME, nil);
            }else if (_SDCardStatus == PPPP_SDCARD_STATUS_RECORDING){
                cell.contentLabel.text = NSLocalizedStringFromTable(@"停止录像", @STR_LOCALIZED_FILE_NAME, nil);
            }else if (_SDCardStatus == PPPP_SDCARD_STATUS_STOP_RECORD){
                cell.contentLabel.text = NSLocalizedStringFromTable(@"录像中", @STR_LOCALIZED_FILE_NAME, nil);
            }
            return cell;
        }else if (indexPath.row == 3){
            static NSString* formatterCell = @"FormatterCellIden";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:formatterCell];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:formatterCell];
            }
            cell.textLabel.text = NSLocalizedStringFromTable(@"SDFormat", @STR_LOCALIZED_FILE_NAME, nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }else{
            static NSString* SDcell = @"SDCell";
            SDCardCell* cell = (SDCardCell*)[tableView dequeueReusableCellWithIdentifier:SDcell];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SDCardCell" owner:self options:nil] lastObject];
            }
            switch (indexPath.row) {
                case 0:
                    cell.keyLabel.text = NSLocalizedStringFromTable(@"总量", @STR_LOCALIZED_FILE_NAME, nil);
                    cell.contentLabel.text = [NSString stringWithFormat:@"%d",_SDCardTotal];
                    break;
                case 1:
                    cell.keyLabel.text = NSLocalizedStringFromTable(@"剩余", @STR_LOCALIZED_FILE_NAME, nil);
                    cell.contentLabel.text = [NSString stringWithFormat:@"%d",_SDCardFree];
                    break;
                    //              case 3:
                    //                  cell.keyLabel.text = NSLocalizedStringFromTable(@"RecordSize", @STR_LOCALIZED_FILE_NAME, nil);
                    //                  cell.contentLabel.text = [NSString stringWithFormat:@"%d",_recordSize];
                    break;
                default:
                    break;
            }
            cell.keyLabel.autoresizingMask = UIViewAutoresizingNone;
            cell.contentLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
            cell.unitLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 1) {
            static NSString* recordTimecell = @"RecordCellTime";
            SetRecordTimeCell* cell = (SetRecordTimeCell*)[tableView dequeueReusableCellWithIdentifier:recordTimecell];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SetRecordTimeCell" owner:self options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.keyLabel.text = NSLocalizedStringFromTable(@"RecordTime", @STR_LOCALIZED_FILE_NAME, nil);
            cell.keyLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
            cell.timeRangeLabel.text = NSLocalizedStringFromTable(@"TimeRange", @STR_LOCALIZED_FILE_NAME, nil);
            cell.timeRangeLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            cell.timeRangeLabel.numberOfLines = 0;
            [cell.timeRangeLabel setAdjustsFontSizeToFitWidth:YES];
            cell.recordTime.text = [NSString stringWithFormat:@"%d",_timeLength];
            cell.recordTime.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            cell.recordTime.keyboardType = UIKeyboardTypeNumberPad;
            cell.recordTime.delegate = self;
            self.timeLengthTf = cell.recordTime;
            return cell;
        }
        
        if (indexPath.row == 3) {
            static NSString* cellIden = @"cellIdenIcon";
            RecordScheduleCell* cell = (RecordScheduleCell*)[tableView dequeueReusableCellWithIdentifier:cellIden];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"RecordScheduleCell" owner:self options:nil] lastObject];
            }
            cell.iconImg.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            cell.iconImg.contentMode = UIViewContentModeScaleAspectFit;
            cell.keyLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
            cell.keyLabel.text = NSLocalizedStringFromTable(@"RecordSchedule", @STR_LOCALIZED_FILE_NAME, nil);
            if (_SetRecordSchedule) {
                cell.iconImg.image = [UIImage imageNamed:@"common_stretch_arrow_downward"];
            }else{
                cell.iconImg.image = [UIImage imageNamed:@"common_stretch_arrow_upward"];
            }
            return cell;
        }
        
        
        static NSString* recordInfo = @"ReocrdInfomation";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:recordInfo];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recordInfo];
        }
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = NSLocalizedStringFromTable(@"Looprewrite", @STR_LOCALIZED_FILE_NAME, nil);
                if (_coverEnable == 0) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                break;
            case 2:
                cell.textLabel.text = NSLocalizedStringFromTable(@"Schedulerecording", @STR_LOCALIZED_FILE_NAME, nil);
                if (_ScheduleRecordEnable == 0) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                break;
            default:
                break;
        }
        return cell;
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            if (_RecSchedule.count == 0)
            {
                static NSString* AddcellIden = @"AddScheduleTimeCell";
                AddScheduleTimeCell* cell = (AddScheduleTimeCell*)[tableView dequeueReusableCellWithIdentifier:AddcellIden];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"AddScheduleTimeCell" owner:self options:nil] lastObject];
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.titleLabel.text = NSLocalizedStringFromTable(@"AddRecordSchedule", @STR_LOCALIZED_FILE_NAME, nil);
                return cell;
            }
            else
            {
                static NSString *recordPlanCell = @"recordPlanCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recordPlanCell];
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:recordPlanCell];
                }
                PlanModel *model = [[PlanModel alloc] init];
                model = _RecSchedule[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"  %@-%@", model.startTimer, model.endTimer];
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                NSString *weeksStr = [self weekStr:model.week];
                cell.detailTextLabel.text = weeksStr;
                cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
        }
        else
        {
            if (indexPath.row < _RecSchedule.count)
            {
                static NSString *recordPlanCell = @"recordPlanCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recordPlanCell];
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:recordPlanCell];
                }
                PlanModel *model = [[PlanModel alloc] init];
                model = _RecSchedule[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"  %@-%@", model.startTimer, model.endTimer];
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                NSString *weeksStr = [self weekStr:model.week];
                cell.detailTextLabel.text = weeksStr;
                cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
            else
            {
                static NSString* AddcellIden = @"AddScheduleTimeCell";
                AddScheduleTimeCell* cell = (AddScheduleTimeCell*)[tableView dequeueReusableCellWithIdentifier:AddcellIden];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"AddScheduleTimeCell" owner:self options:nil] lastObject];
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.titleLabel.text = NSLocalizedStringFromTable(@"AddRecordSchedule", @STR_LOCALIZED_FILE_NAME, nil);
                return cell;
            }
        }
    }
    else{
        if (indexPath.row == 0)
        {
            if (_MotionRecSchedule.count == 0)
            {
                static NSString* AddcellIden = @"AddScheduleTimeCell";
                AddScheduleTimeCell* cell = (AddScheduleTimeCell*)[tableView dequeueReusableCellWithIdentifier:AddcellIden];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"AddScheduleTimeCell" owner:self options:nil] lastObject];
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.titleLabel.text = NSLocalizedStringFromTable(@"AddRecordSchedule", @STR_LOCALIZED_FILE_NAME, nil);
                return cell;
            }
            else
            {
                static NSString *recordPlanCell = @"motionRecordPlanCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recordPlanCell];
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:recordPlanCell];
                }
                PlanModel *model = [[PlanModel alloc] init];
                model = _MotionRecSchedule[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"  %@-%@", model.startTimer, model.endTimer];
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                NSString *weeksStr = [self weekStr:model.week];
                cell.detailTextLabel.text = weeksStr;
                cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
        }
        else
        {
            if (indexPath.row < _MotionRecSchedule.count)
            {
                static NSString *recordPlanCell = @"motionRecordPlanCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recordPlanCell];
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:recordPlanCell];
                }
                PlanModel *model = [[PlanModel alloc] init];
                model = _MotionRecSchedule[indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"  %@-%@", model.startTimer, model.endTimer];
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                NSString *weeksStr = [self weekStr:model.week];
                cell.detailTextLabel.text = weeksStr;
                cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
            else
            {
                static NSString* AddcellIden = @"AddScheduleTimeCell";
                AddScheduleTimeCell* cell = (AddScheduleTimeCell*)[tableView dequeueReusableCellWithIdentifier:AddcellIden];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"AddScheduleTimeCell" owner:self options:nil] lastObject];
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.titleLabel.text = NSLocalizedStringFromTable(@"AddRecordSchedule", @STR_LOCALIZED_FILE_NAME, nil);
                return cell;
            }
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"SDFormatTitle", @STR_LOCALIZED_FILE_NAME, nil) message:NSLocalizedStringFromTable(@"SDFormatDescription", @STR_LOCALIZED_FILE_NAME, nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil), nil];
            alert.tag = 101;
            [alert show];
//            [alert release];
        }
    }else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                if (_coverEnable == 0) {
                    _coverEnable = 1;
                }else{
                    _coverEnable = 0;
                }
                [tableView beginUpdates];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [tableView endUpdates];
            }
                break;
            case 2:
            {
                if (0 == _ScheduleRecordEnable) {
                    _ScheduleRecordEnable = 1;
                }else{
                    _ScheduleRecordEnable = 0;
                }
                [tableView beginUpdates];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [tableView endUpdates];
            }
                break;
            case 3:
            {
                _SetRecordSchedule = !_SetRecordSchedule;
                [tableView beginUpdates];
                if (!_SetRecordSchedule) {
                    [tableView deleteSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
                    [tableView deleteSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
                }else{
                    [tableView insertSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
                    [tableView insertSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
                }
                
                
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                //[tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
                [tableView endUpdates];
            }
                break;
            default:
                break;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0)
        {
            AddPlanViewController *addPlanVC = [[AddPlanViewController alloc] init];
            if (_RecSchedule.count == 0)
            {
                addPlanVC.isEdit = NO;
            }
            else
            {
                addPlanVC.rowIndex = indexPath.row;
                addPlanVC.isEdit = YES;
            }
            addPlanVC.navigationItem.title = NSLocalizedStringFromTable(@"录像计划", @STR_LOCALIZED_FILE_NAME, nil);
            addPlanVC.addPlanTyep = @"Add_Schedule_Recording";
            addPlanVC.str_DID = self.m_strDID;
            addPlanVC.m_PPPPChannelMgt = _m_PPPPChannelMgt;
            [self.navigationController pushViewController:addPlanVC animated:YES];
//            [addPlanVC release], addPlanVC = nil;
        }
        else
        {
            AddPlanViewController *addPlanVC = [[AddPlanViewController alloc] init];
            if (indexPath.row < _RecSchedule.count)
            {
                addPlanVC.rowIndex = indexPath.row;
                addPlanVC.isEdit = YES;
            }
            else
            {
                addPlanVC.isEdit = NO;
            }
            addPlanVC.navigationItem.title = NSLocalizedStringFromTable(@"录像计划", @STR_LOCALIZED_FILE_NAME, nil);
            addPlanVC.addPlanTyep = @"Add_Schedule_Recording";
            addPlanVC.str_DID = self.m_strDID;
            addPlanVC.m_PPPPChannelMgt = _m_PPPPChannelMgt;
            [self.navigationController pushViewController:addPlanVC animated:YES];
//            [addPlanVC release], addPlanVC = nil;
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            AddPlanViewController *addPlanVC = [[AddPlanViewController alloc] init];
            if (_MotionRecSchedule.count == 0)
            {
                addPlanVC.isEdit = NO;
            }
            else
            {
                addPlanVC.rowIndex = indexPath.row;
                addPlanVC.isEdit = YES;
            }
            addPlanVC.navigationItem.title = NSLocalizedStringFromTable(@"移动侦测录像计划", @STR_LOCALIZED_FILE_NAME, nil);
            addPlanVC.addPlanTyep = @"Add_Motion_Recording_Schedule";
            addPlanVC.str_DID = self.m_strDID;
            addPlanVC.m_PPPPChannelMgt = _m_PPPPChannelMgt;
            [self.navigationController pushViewController:addPlanVC animated:YES];
//            [addPlanVC release], addPlanVC = nil;
        }
        else
        {
            AddPlanViewController *addPlanVC = [[AddPlanViewController alloc] init];
            if (indexPath.row < _MotionRecSchedule.count)
            {
                addPlanVC.rowIndex = indexPath.row;
                addPlanVC.isEdit = YES;
            }
            else
            {
                addPlanVC.isEdit = NO;
            }
            addPlanVC.navigationItem.title = NSLocalizedStringFromTable(@"移动侦测录像计划", @STR_LOCALIZED_FILE_NAME, nil);
            addPlanVC.addPlanTyep = @"Add_Motion_Recording_Schedule";
            addPlanVC.str_DID = self.m_strDID;
            addPlanVC.m_PPPPChannelMgt = _m_PPPPChannelMgt;
            [self.navigationController pushViewController:addPlanVC animated:YES];
//            [addPlanVC release], addPlanVC = nil;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return NSLocalizedStringFromTable(@"存储卡信息", @STR_LOCALIZED_FILE_NAME, nil);
    }else if(section == 1){
        return NSLocalizedStringFromTable(@"Record", @STR_LOCALIZED_FILE_NAME, nil);
    }else if(section == 2){
        return NSLocalizedStringFromTable(@"录像计划", @STR_LOCALIZED_FILE_NAME, nil);
    }else
        return @"移动侦测录像";
}
#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"BOOL textField  %@",textField.text);
    _timeLength = [textField.text intValue];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textField  %@",textField.text);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.length == 1) {
        return YES;
    }
    NSCharacterSet* characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSRange timelength = [string rangeOfCharacterFromSet:characterSet];
    NSLog(@"textField  %@   string  %@  Range  %d  %d",textField.text,string,range.location,range.length);
    
    if (timelength.location == NSNotFound) {
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark UIAlertViewDalegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        if (buttonIndex == 1) {
            _m_PPPPChannelMgt->GetCGI((char*) [self.m_strDID UTF8String], CGI_IEFORMATSD);
        }
    }else if (alertView.tag == 100){
        if (buttonIndex == 1) {
            [self SetSDRecordParam:nil];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


#pragma mark -
#pragma mark CellIconImage TapGestureRecognizer
- (void) clickIconImg:(UITapGestureRecognizer*) tapges{
    RecordTimeMode* view = (RecordTimeMode*)[tapges view];
    view.is_Selected_Icon = !view.is_Selected_Icon;
    NSMutableDictionary* dic = [self.RecSchedule objectAtIndex:(view.tag - 2)];
    NSLog(@"dic  %@",dic);
    NSMutableArray* weeks = [dic objectForKey:KEYREPEATWEEK];
    NSString* startStr = [dic objectForKey:KEYSTRATTIME];
    NSString* endStr = [dic objectForKey:KEYENDTIME];
    int starthour = [[startStr substringWithRange:NSMakeRange(0, 2)] intValue];
    int startmin = [[startStr substringWithRange:NSMakeRange(5, 2)] intValue];
    int endhour = [[endStr substringWithRange:NSMakeRange(0, 2)] intValue];
    int endmin = [[endStr substringWithRange:NSMakeRange(5, 2)] intValue];
    int startIndex = starthour*4 + startmin/15 + (startmin%15 ? 1 : 0);
    int endIndex = endhour*4 + endmin/15 + (endmin%15 ? 1 : 0);
    
    //NSLog(@"startIndex  %d   endIndex   %d",startIndex,endIndex);
    if (view.is_Selected_Icon) {
        for (int i = 0; i < 7; i++) {
            if ([(NSNumber*)[weeks objectAtIndex:i] isEqualToNumber:@1]) {
                for (int j = startIndex + 96 * i; j < endIndex + 96 * i; j ++) {
                    Schedule[j] = @1;
                    //NSLog(@"Schedule[%d] = %d",j,Schedule[j]);
                }
            }
        }
        [dic setObject:[NSNumber numberWithBool:YES] forKey:KEYOPENRECORD];
    }else{
        for (int i = 0; i < 7; i++) {
            if ([(NSNumber*)[weeks objectAtIndex:i] isEqualToNumber:@1]) {
                for (int j = startIndex + 96 * i; j < endIndex + 96 * i; j ++) {
                    Schedule[j] = @0;
                    // NSLog(@"Schedule[%d] = %d",j,Schedule[j]);
                }
            }
        }
        [dic setObject:[NSNumber numberWithBool:NO] forKey:KEYOPENRECORD];
    }
    [self.RecSchedule replaceObjectAtIndex:(view.tag - 2) withObject:dic];
    [self SetSDRecordParam:nil];
}

#pragma mark -
#pragma mark SdcardScheduleProtocol
-(void)sdcardScheduleParams:(NSString *)did Tota:(int)total  RemainCap:(int)remain SD_status:(int)status Cover:(int) cover_enable TimeLength:(int)timeLength FixedTimeRecord:(int)ftr_enable RecordSize:(int)recordSize record_schedule_sun_0:(int) record_schedule_sun_0 record_schedule_sun_1:(int) record_schedule_sun_1 record_schedule_sun_2:(int) record_schedule_sun_2 record_schedule_mon_0:(int) record_schedule_mon_0 record_schedule_mon_1:(int) record_schedule_mon_1 record_schedule_mon_2:(int) record_schedule_mon_2 record_schedule_tue_0:(int) record_schedule_tue_0 record_schedule_tue_1:(int) record_schedule_tue_1 record_schedule_tue_2:(int) record_schedule_tue_2 record_schedule_wed_0:(int) record_schedule_wed_0 record_schedule_wed_1:(int) record_schedule_wed_1 record_schedule_wed_2:(int) record_schedule_wed_2 record_schedule_thu_0:(int) record_schedule_thu_0 record_schedule_thu_1:(int) record_schedule_thu_1 record_schedule_thu_2:(int) record_schedule_thu_2 record_schedule_fri_0:(int) record_schedule_fri_0 record_schedule_fri_1:(int) record_schedule_fri_1 record_schedule_fri_2:(int) record_schedule_fri_2 record_schedule_sat_0:(int) record_schedule_sat_0 record_schedule_sat_1:(int) record_schedule_sat_1 record_schedule_sat_2:(int) record_schedule_sat_2{
    _SDCardTotal = total;
    _SDCardFree = remain;
    _recordSize = recordSize;
    _timeLength = timeLength;
    _coverEnable = cover_enable;
    _ScheduleRecordEnable = ftr_enable;
    if (status == 0) {
        _SDCardStatus = PPPP_SDCARD_STATUS_NON;
    }else if (status == 1){
        _SDCardStatus = PPPP_SDCARD_STATUS_RECORDING;
    }else if (status == 2){
        _SDCardStatus = PPPP_SDCARD_STATUS_STOP_RECORD;
    }
    dispatch_async(dispatch_get_main_queue(),^{
        [_aTableView reloadData];
    });
    [self TenAndTwo:record_schedule_sun_0 atIndex:0];
    RecordTime[0] = record_schedule_sun_0;
    [self TenAndTwo:record_schedule_sun_1 atIndex:1];
    RecordTime[1] = record_schedule_sun_1;
    [self TenAndTwo:record_schedule_sun_2 atIndex:2];
    RecordTime[2] = record_schedule_sun_2;
    [self TenAndTwo:record_schedule_mon_0 atIndex:3];
    RecordTime[3] = record_schedule_mon_0;
    [self TenAndTwo:record_schedule_mon_1 atIndex:4];
    RecordTime[4] = record_schedule_mon_1;
    [self TenAndTwo:record_schedule_mon_2 atIndex:5];
    RecordTime[5] = record_schedule_mon_2;
    [self TenAndTwo:record_schedule_tue_0 atIndex:6];
    RecordTime[6] = record_schedule_tue_0;
    [self TenAndTwo:record_schedule_tue_1 atIndex:7];
    RecordTime[7] = record_schedule_tue_1;
    [self TenAndTwo:record_schedule_tue_2 atIndex:8];
    RecordTime[8] = record_schedule_tue_2;
    [self TenAndTwo:record_schedule_wed_0 atIndex:9];
    RecordTime[9] = record_schedule_wed_0;
    [self TenAndTwo:record_schedule_wed_1 atIndex:10];
    RecordTime[10] = record_schedule_wed_1;
    [self TenAndTwo:record_schedule_wed_2 atIndex:11];
    RecordTime[11] = record_schedule_wed_2;
    [self TenAndTwo:record_schedule_thu_0 atIndex:12];
    RecordTime[12] = record_schedule_thu_0;
    [self TenAndTwo:record_schedule_thu_1 atIndex:13];
    RecordTime[13] = record_schedule_thu_1;
    [self TenAndTwo:record_schedule_thu_2 atIndex:14];
    RecordTime[14] = record_schedule_thu_2;
    [self TenAndTwo:record_schedule_fri_0 atIndex:15];
    RecordTime[15] = record_schedule_fri_0;
    [self TenAndTwo:record_schedule_fri_1 atIndex:16];
    RecordTime[16] = record_schedule_fri_1;
    [self TenAndTwo:record_schedule_fri_2 atIndex:17];
    RecordTime[17] = record_schedule_fri_2;
    [self TenAndTwo:record_schedule_sat_0 atIndex:18];
    RecordTime[18] = record_schedule_sat_0;
    [self TenAndTwo:record_schedule_sat_1 atIndex:19];
    RecordTime[19] = record_schedule_sat_1;
    [self TenAndTwo:record_schedule_sat_2 atIndex:20];
    RecordTime[20] = record_schedule_sat_2;
    for (int i = 0; i < 21; i ++) {
        NSLog(@"RecordTime[%d] = %ld",i,RecordTime[i]);
    }
    //NSLog(@"recordSize %d",recordSize);
    //[self TwoAndTen];
}

- (void) TenAndTwo:(int) num atIndex:(int)index{
    memset(&tmp, 0, sizeof(tmp));
    int i = 0;
    int j;
    if (num < 0) {
        j = ABS(num + 1);
    }else{
        j = num;
    }
    
    while (j) {
        tmp[i] = j%2;
        //NSLog(@"i  %d  j %d",i,j);
        i++;
        j = j/2;
    }
    if (num < 0) {
        tmp[31] = 1;
        for (i = 0; i < 31; i ++) {
            if (tmp[i] == 0) {
                tmp[i] = 1;
            }else{
                tmp[i] = 0;
            }
            //NSLog(@"tmp[%d] = %d",i,tmp[i]);//111100000000001100000
        }
    }else{
        tmp[i] = 0;
    }
    for (i = index*32; i < (index+1) * 32; i ++) {
        Schedule[i] = [NSNumber numberWithInt:tmp[i - 32 * index]];
    }
}

- (void) TwoAndTen{
    int tmpe = 0;
    int k = 0;
    int t = 1;
    int item = 0;
    for (int i = 0; i < 21; i++) {
        int j = [Schedule[(i+1) * 32 - 1] intValue];
        t = 1;
        tmpe = 0;
        for (k = 0; k < 31; k ++) {
            if (j == 1) {
                if ([Schedule[i * 32 + k] isEqual:@0]) {
                    item = 1;
                }else{
                    item = 0;
                }
            }else{
                item = [Schedule[i*32 + k] intValue];
            }
            //NSLog(@"tmpe  %d  item   %dv   Schedule[%d] = %@",tmpe,item,i*32+k,Schedule[i*32+k]);
            tmpe += (item * t);
            t = t * 2;
        }
        if (j == 0) {
            
        }else{
            tmpe += 1;
            tmpe = tmpe * (-1);
        }
        RecordTime[i] = tmpe;
        //NSLog(@"RecordTime[%d] = %ld",i,RecordTime[i]);
    }
}

- (void)recordSchedule:(NSString *)cameraUID Record_plan1:(int)record_plan1 Record_plan2:(int)record_plan2 Record_plan3:(int)record_plan3 Record_plan4:(int)record_plan4 Record_plan5:(int)record_plan5 Record_plan6:(int)record_plan6 Record_plan7:(int)record_plan7 Record_plan8:(int)record_plan8 Record_plan9:(int)record_plan9 Record_plan10:(int)record_plan10 Record_plan11:(int)record_plan11 Record_plan12:(int)record_plan12 Record_plan13:(int)record_plan13 Record_plan14:(int)record_plan14 Record_plan15:(int)record_plan15 Record_plan16:(int)record_plan16 Record_plan17:(int)record_plan17 Record_plan18:(int)record_plan18 Record_plan19:(int)record_plan19 Record_plan20:(int)record_plan20 Record_plan21:(int)record_plan21 Record_plan_enable:(int)record_plan_enable
{
    if ([cameraUID isEqualToString:self.m_strDID])
    {
        [[PlanManagement shareManagement].RecordPlanArray removeAllObjects];

        if (record_plan1)
        {
            [self TenAndTwo:record_plan1 andIsRecordSchedule:YES];
        }
        if (record_plan2)
        {
            [self TenAndTwo:record_plan2 andIsRecordSchedule:YES];
        }
        if (record_plan3)
        {
            [self TenAndTwo:record_plan3 andIsRecordSchedule:YES];
        }
        if (record_plan4)
        {
            [self TenAndTwo:record_plan4 andIsRecordSchedule:YES];
        }
        if (record_plan5)
        {
            [self TenAndTwo:record_plan5 andIsRecordSchedule:YES];
        }
        if (record_plan6)
        {
            [self TenAndTwo:record_plan6 andIsRecordSchedule:YES];
        }
        if (record_plan7)
        {
            [self TenAndTwo:record_plan7 andIsRecordSchedule:YES];
        }
        if (record_plan8)
        {
            [self TenAndTwo:record_plan8 andIsRecordSchedule:YES];
        }
        if (record_plan9)
        {
            [self TenAndTwo:record_plan9 andIsRecordSchedule:YES];
        }
        if (record_plan10)
        {
            [self TenAndTwo:record_plan10 andIsRecordSchedule:YES];
        }
        if (record_plan11)
        {
            [self TenAndTwo:record_plan11 andIsRecordSchedule:YES];
        }
        if (record_plan12)
        {
            [self TenAndTwo:record_plan12 andIsRecordSchedule:YES];
        }
        if (record_plan13)
        {
            [self TenAndTwo:record_plan13 andIsRecordSchedule:YES];
        }
        if (record_plan14)
        {
            [self TenAndTwo:record_plan14 andIsRecordSchedule:YES];
        }
        if (record_plan15)
        {
            [self TenAndTwo:record_plan15 andIsRecordSchedule:YES];
        }
        if (record_plan16)
        {
            [self TenAndTwo:record_plan16 andIsRecordSchedule:YES];
        }
        if (record_plan17)
        {
            [self TenAndTwo:record_plan17 andIsRecordSchedule:YES];
        }
        if (record_plan18)
        {
            [self TenAndTwo:record_plan18 andIsRecordSchedule:YES];
        }
        if (record_plan19)
        {
            [self TenAndTwo:record_plan19 andIsRecordSchedule:YES];
        }
        if (record_plan20)
        {
            [self TenAndTwo:record_plan20 andIsRecordSchedule:YES];
        }
        if (record_plan21)
        {
            [self TenAndTwo:record_plan21 andIsRecordSchedule:YES];
        }
        [_RecSchedule removeAllObjects];
        [_RecSchedule addObjectsFromArray:[PlanManagement shareManagement].RecordPlanArray];
        if (_SetRecordSchedule) {
            [self.aTableView reloadData];
        }
        
    }
    
}

- (void)motionRecordSchedule:(NSString *)cameraUID motion_record_plan1:(int)motion_record_plan1 motion_record_plan2:(int)motion_record_plan2 motion_record_plan3:(int)motion_record_plan3 motion_record_plan4:(int)motion_record_plan4 motion_record_plan5:(int)motion_record_plan5 motion_record_plan6:(int)motion_record_plan6 motion_record_plan7:(int)motion_record_plan7 motion_record_plan8:(int)motion_record_plan8 motion_record_plan9:(int)motion_record_plan9 motion_record_plan10:(int)motion_record_plan10 motion_record_plan11:(int)motion_record_plan11 motion_record_plan12:(int)motion_record_plan12 motion_record_plan13:(int)motion_record_plan13 motion_record_plan14:(int)motion_record_plan14 motion_record_plan15:(int)motion_record_plan15 motion_record_plan16:(int)motion_record_plan16 motion_record_plan17:(int)motion_record_plan17 motion_record_plan18:(int)motion_record_plan18 motion_record_plan19:(int)motion_record_plan19 motion_record_plan20:(int)motion_record_plan20 motion_record_plan21:(int)motion_record_plan21 Motion_record_plan_enable:(int)motion_record_plan_enable
{
    if ([cameraUID isEqualToString:self.m_strDID])
    {
        [[PlanManagement shareManagement].MotionRecordPlanArray removeAllObjects];
        
        if (motion_record_plan1)
        {
            [self TenAndTwo:motion_record_plan1 andIsRecordSchedule:NO];
        }
        if (motion_record_plan2)
        {
            [self TenAndTwo:motion_record_plan2 andIsRecordSchedule:NO];
        }
        if (motion_record_plan3)
        {
            [self TenAndTwo:motion_record_plan3 andIsRecordSchedule:NO];
        }
        if (motion_record_plan4)
        {
            [self TenAndTwo:motion_record_plan4 andIsRecordSchedule:NO];
        }
        if (motion_record_plan5)
        {
            [self TenAndTwo:motion_record_plan5 andIsRecordSchedule:NO];
        }
        if (motion_record_plan6)
        {
            [self TenAndTwo:motion_record_plan6 andIsRecordSchedule:NO];
        }
        if (motion_record_plan7)
        {
            [self TenAndTwo:motion_record_plan7 andIsRecordSchedule:NO];
        }
        if (motion_record_plan8)
        {
            [self TenAndTwo:motion_record_plan8 andIsRecordSchedule:NO];
        }
        if (motion_record_plan9)
        {
            [self TenAndTwo:motion_record_plan9 andIsRecordSchedule:NO];
        }
        if (motion_record_plan10)
        {
            [self TenAndTwo:motion_record_plan10 andIsRecordSchedule:NO];
        }
        if (motion_record_plan11)
        {
            [self TenAndTwo:motion_record_plan11 andIsRecordSchedule:NO];
        }
        if (motion_record_plan12)
        {
            [self TenAndTwo:motion_record_plan12 andIsRecordSchedule:NO];
        }
        if (motion_record_plan13)
        {
            [self TenAndTwo:motion_record_plan13 andIsRecordSchedule:NO];
        }
        if (motion_record_plan14)
        {
            [self TenAndTwo:motion_record_plan14 andIsRecordSchedule:NO];
        }
        if (motion_record_plan15)
        {
            [self TenAndTwo:motion_record_plan15 andIsRecordSchedule:NO];
        }
        if (motion_record_plan16)
        {
            [self TenAndTwo:motion_record_plan16 andIsRecordSchedule:NO];
        }
        if (motion_record_plan17)
        {
            [self TenAndTwo:motion_record_plan17 andIsRecordSchedule:NO];
        }
        if (motion_record_plan18)
        {
            [self TenAndTwo:motion_record_plan18 andIsRecordSchedule:NO];
        }
        if (motion_record_plan19)
        {
            [self TenAndTwo:motion_record_plan19 andIsRecordSchedule:NO];
        }
        if (motion_record_plan20)
        {
            [self TenAndTwo:motion_record_plan20 andIsRecordSchedule:NO];
        }
        if (motion_record_plan21)
        {
            [self TenAndTwo:motion_record_plan21 andIsRecordSchedule:NO];
        }
        
        [_MotionRecSchedule removeAllObjects];
        [_MotionRecSchedule addObjectsFromArray:[PlanManagement shareManagement].MotionRecordPlanArray];
        if (_SetRecordSchedule) {
            [self.aTableView reloadData];
        }
    }
    
}

- (void) TenAndTwo:(int) num andIsRecordSchedule:(BOOL) isRecordSchedule
{
    int tmps[32];
    if (num == 0 || num == -1 || num == 1) {
        return ;
    }
    //    notesLabel.hidden = YES;
    
    int i = 0;
    int j;
    if (num < 0) {
        j = ABS(num);
    }else{
        j = num;
    }
    
    while (j) {
        tmps[i] = j%2;
        i++;
        j = j/2;
    }
    
    for (; i<31; i++) {
        tmps[i] = 0;
    }
    
    if (num < 0) {
        tmps[31] = 1;
    }else{
        tmps[31] = 0;
    }
    
    int start = 0;
    int end = 0;
    NSMutableString *week = [[NSMutableString alloc] init];
    int ll = 0;
    for (int m = 0; m < 12; m++)
    {
        ll = tmps[m] * pow(2, m);
        start += ll;
    }
    
    for (int m = 12,n = 0; m<24; m++,n++) {
        
        ll = tmps[m] * pow(2, n);
        end += ll;
    }
    
    for (int m = 24,n=0; m<31; m++,n++) {
        if (tmps[m] != 0) {
            [week appendFormat:@"%d,",n];
        }
    }
    [week deleteCharactersInRange:NSMakeRange(week.length - 1, 1)];
    NSLog(@"week : %@", week);
    [self saveDatabase:[self MinutesTurnHour:start] endT:[self MinutesTurnHour:end] week:week isOn:tmps[31] Sum:num isRecordSchedule:isRecordSchedule];
}

-(NSString *) MinutesTurnHour:(int) MTH{
    NSString *starts;
    int mm = MTH;
    int rem = 0;
    if (mm<10) {
        starts = [NSString stringWithFormat:@"00:0%d",mm];
    }else if (mm >= 10 && mm < 60){
        starts = [NSString stringWithFormat:@"00:%d",mm];
    }else{
        mm = mm / 60;
        if (mm * 60 == MTH) {
            rem = 0;
        }else{
            rem = MTH % 60;
        }
        
        if (mm < 10) {
            if (rem < 10) {
                starts = [NSString stringWithFormat:@"0%d:0%d",mm,rem];
            }else{
                starts = [NSString stringWithFormat:@"0%d:%d",mm,rem];
            }
        }else{
            if (rem < 10) {
                starts = [NSString stringWithFormat:@"%d:0%d",mm,rem];
            }else{
                starts = [NSString stringWithFormat:@"%d:%d",mm,rem];
            }
        }
    }
    return starts;
}

-(void) saveDatabase:(NSString *)startT endT:(NSString *)endT week:(NSString *)week isOn:(int )isOn Sum:(int)sum isRecordSchedule:(BOOL) isRecordSchedule{
    
    PlanModel *par = [[PlanModel alloc] init];
    par.devicedID = self.m_strDID;
    par.startTimer = startT;
    par.endTimer = endT;
    par.week = week;
    par.isOn = [NSString stringWithFormat:@"%d",isOn];
    par.sum = sum;
    if (isRecordSchedule)
    {
        [[PlanManagement shareManagement].RecordPlanArray addObject:par];
    }
    else
    {
        [[PlanManagement shareManagement].MotionRecordPlanArray addObject:par];
    }
    
}

#pragma mark -
#pragma mark SetRecordTimeViewControllerDelegate
- (void) SetRecordTimeViewController:(SetRecordTimeViewController*) recordTime withStarTimes:(NSArray*) startDates EndDateTimes:(NSArray*) endDates andRepeatDay:(int*) weeks OpenRecord:(BOOL) openRecord{
    for (int i = 0; i < [startDates count]; i ++) {
        
        NSMutableArray* ws = [NSMutableArray array];
        NSString* startStr = [startDates objectAtIndex:i];
        NSString* endstr = [endDates objectAtIndex:i];
        int starthour = [[startStr substringWithRange:NSMakeRange(0, 2)] intValue];
        int startmin = [[startStr substringWithRange:NSMakeRange(5,2)] intValue];
        int endhour = [[endstr substringWithRange:NSMakeRange(0, 2)] intValue];
        int endmin = [[endstr substringWithRange:NSMakeRange(5,2)] intValue];
        int startIndex = starthour*4 + startmin/15 + (startmin%15 ? 1 : 0);
        int endIndex = endhour*4 + endmin/15 + (endmin%15 ? 1 : 0);
        
        //NSLog(@"startindex  %d, endIndex  %d", startIndex,endIndex);
        
        for (int j = 0; j < 7; j++) {
            [ws addObject:[NSNumber numberWithInt:weeks[j]]];
            if (weeks[j] == 1) {
                for (int i = startIndex + (j*96); i < endIndex + (j*96); i++) {
                    Schedule[i] = @1;
                    //NSLog(@"Schedule[%d] = %@",i,Schedule[i]);
                }
            }
        }
        
        if (endhour == 24) {
            endhour = 0;
            endmin = 0;
        }
        
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        df.dateFormat =  @"yyyy-MM-dd HH:mm:ss";
        NSString* dateStr = [[df stringFromDate:[NSDate date]] substringWithRange:NSMakeRange(0, 10)];
        NSString* startDateStr = [NSString stringWithFormat:@"%@ %d:%d:00",dateStr,starthour,startmin];
        NSString* endDateStr = [NSString stringWithFormat:@"%@ %d:%d:00",dateStr,endhour,endmin];
        
        NSDate* startDate = [df dateFromString:startDateStr];
        NSDate* endDate = [df dateFromString:endDateStr];
        // NSLog(@"endDateStr  %@  endDate  %@",endDateStr,endDate);
//        [df release];
        NSArray* objs = [NSArray arrayWithObjects:[startDates objectAtIndex:i], [endDates objectAtIndex:i], recordTime.weekStr, [NSNumber numberWithBool:openRecord], ws, startDate, endDate,nil];
        NSArray* keys = [NSArray arrayWithObjects:KEYSTRATTIME, KEYENDTIME, KEYREPEATDAY, KEYOPENRECORD, KEYREPEATWEEK, KEYSTRATDATE, KEYENDDATE,nil];
        
        //  NSLog(@"objs %@\n keyS %@",objs,keys);
        
        NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObjects:objs forKeys:keys];
        if (recordTime.bAddRecordTime) {
            [self.RecSchedule addObject:dic];
        }else{
            if (i == 0) {
                [self.RecSchedule replaceObjectAtIndex:recordTime.replaceIndex withObject:dic];
            }else{
                [self.RecSchedule addObject:dic];
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.aTableView reloadData];
    });
    //- (void) SetSDRecordParam:(id) sender
    [self SetSDRecordParam:nil];
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


- (void) dealloc{
    [self.view removeGestureRecognizer:_swipeGes];
//    [_swipeGes release],_swipeGes = nil;
//    
//    [super dealloc];
//    [Schedule release],Schedule = nil;
//    [_RecSchedule release],_RecSchedule = nil;
//    [_MotionRecSchedule release], _MotionRecSchedule = nil;
//    [_aTableView release],_aTableView = nil;
//    [_resignKeyBoard release],_resignKeyBoard = nil;
    _m_PPPPChannelMgt->SetSDcardScheduleDelegate((char*)[self.m_strDID UTF8String], nil);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}



@end
