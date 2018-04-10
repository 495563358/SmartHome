//
//  AddPlanViewController.m
//  Eye4
//
//  Created by 黄甜 on 16/10/20.
//
//

#import "AddPlanViewController.h"
#import "PlanPickerView.h"
#import "PlanManagement.h"
#import "PlanModel.h"
#import "obj_common.h"
@interface AddPlanViewController ()<UIAlertViewDelegate>
{
    PlanPickerView *pickerView;
}

@end

@implementation AddPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"PlayViewHandleBgImageView"]];
    NSInteger width = [UIScreen mainScreen].bounds.size.width;
    NSInteger height = [UIScreen mainScreen].bounds.size.height;
    if (!self.isEdit)
    {
        UIButton *save = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        save.frame = CGRectMake(0, height-46-64, width, 44);
        save.backgroundColor = [UIColor whiteColor];
        save.titleLabel.font = [UIFont systemFontOfSize:18];
        [save addTarget:self action:@selector(saveBtnData) forControlEvents:UIControlEventTouchUpInside];
        [save setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [save setTitle:NSLocalizedStringFromTable(@"Save", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
        [self.view addSubview:save];
    }
    else
    {
        UIButton *del = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        del.backgroundColor = [UIColor colorWithRed:250/255.0 green:43/255.0 blue:38/255.0 alpha:1];
        del.layer.cornerRadius = 5;
        del.clipsToBounds = YES;
        del.frame = CGRectMake(20, height - 46-64, width/2-40, 44);
        [del addTarget:self action:@selector(delDate) forControlEvents:UIControlEventTouchUpInside];
        [del setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [del setTitle:NSLocalizedStringFromTable(@"Delete", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
        [self.view addSubview:del];
        
        UIButton *save = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        save.frame = CGRectMake(width/2+20, height - 46-64, width/2-40, 44);
        save.layer.cornerRadius = 5;
        save.clipsToBounds = YES;
        save.layer.borderWidth = 1;
        save.layer.borderColor = [[UIColor blackColor] CGColor];
        [save addTarget:self action:@selector(saveBtnData) forControlEvents:UIControlEventTouchUpInside];
        [save setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [save setTitle:NSLocalizedStringFromTable(@"Save", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
        [self.view addSubview:save];
    }
    
    pickerView = [[PlanPickerView alloc] initWithFrame:CGRectMake(0, 0, width, height - 44- 64) Str_DID:self.str_DID rowIndex:self.rowIndex IsEdit:self.isEdit Type:self.addPlanTyep];
    pickerView.m_PPPPChannelMgt = _m_PPPPChannelMgt;
    self.view.userInteractionEnabled = YES;
    [self.view addSubview:pickerView];
    
}

-(void) backToViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)delDate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTable(@"SureDelete", @STR_LOCALIZED_FILE_NAME, nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) otherButtonTitles:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil), nil];
    [alert show];
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if ([self.addPlanTyep isEqualToString:@"Add_Schedule_Recording"])
        {
            [self deleteRecordPlan];
        }
        else if ([self.addPlanTyep isEqualToString:@"Add_Motion_Recording_Schedule"])
        {
            [self deleteMotionPlan];
        }
        else if ([self.addPlanTyep isEqualToString:@"AddMotionPushPlan"])
        {
            [self deletePushPlan];
        }
        else if ([self.addPlanTyep isEqualToString:@"AddDefencePlan"])
        {
            [self deleteAlarmPlan];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)deleteAlarmPlan
{
    NSMutableArray *recordArry = [[NSMutableArray alloc] init];
    for (int i = 0; i < [PlanManagement shareManagement].AlarmPlanArray.count; i++)
    {
        PlanModel *model = [[PlanModel alloc] init];
        model = [PlanManagement shareManagement].AlarmPlanArray[i];
        NSString *sum = [NSString stringWithFormat:@"%ld", (long)model.sum];
        [recordArry addObject:sum];
    }
    if (recordArry.count < 21)
    {
        int num = 21 - (int)recordArry.count;
        for (int i = 0; i < num; i++)
        {
            NSString *sum = @"1";
            [recordArry addObject:sum];
        }
    }
    recordArry[self.rowIndex] = @"1";
    [[PlanManagement shareManagement].AlarmPlanArray removeObjectAtIndex:self.rowIndex];
    if ([PlanManagement shareManagement].AlarmPlanArray.count == 0)
    {
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"openRecordInTime" object:nil];
    }
    NSString *cgiStr = [NSString stringWithFormat:@"set_alarm.cgi?schedule_enable=1&schedule_sun_0=0&schedule_sun_1=0&schedule_sun_2=0&schedule_mon_0=0&schedule_mon_1=0&schedule_mon_2=0&schedule_tue_0=0&schedule_tue_1=0&schedule_tue_2=0&schedule_wed_0=0&schedule_wed_1=0&schedule_wed_2=0&schedule_thu_0=0&schedule_thu_1=0&schedule_thu_2=0&schedule_fri_0=0&schedule_fri_1=0&schedule_fri_2=0&schedule_sat_0=0&schedule_sat_1=0&schedule_sat_2=0&defense_plan1=%@&defense_plan2=%@&defense_plan3=%@&defense_plan4=%@&defense_plan5=%@&defense_plan6=%@&defense_plan7=%@&defense_plan8=%@&defense_plan9=%@&defense_plan10=%@&defense_plan11=%@&defense_plan12=%@&defense_plan13=%@&defense_plan14=%@&defense_plan15=%@&defense_plan16=%@&defense_plan17=%@&defense_plan18=%@&defense_plan19=%@&defense_plan20=%@&defense_plan21=%@&", recordArry[0], recordArry[1], recordArry[2], recordArry[3], recordArry[4], recordArry[5], recordArry[6], recordArry[7], recordArry[8], recordArry[9], recordArry[10], recordArry[11], recordArry[12], recordArry[13], recordArry[14], recordArry[15], recordArry[16], recordArry[17], recordArry[18], recordArry[19], recordArry[20]];
    _m_PPPPChannelMgt->GetJsonCGI([self.str_DID UTF8String], 2017, (char *)[cgiStr UTF8String]);
}

- (void)deleteRecordPlan
{
    NSMutableArray *recordArry = [[NSMutableArray alloc] init];
    for (int i = 0; i < [PlanManagement shareManagement].RecordPlanArray.count; i++)
    {
        PlanModel *model = [[PlanModel alloc] init];
        model = [PlanManagement shareManagement].RecordPlanArray[i];
        NSString *sum = [NSString stringWithFormat:@"%ld", (long)model.sum];
        [recordArry addObject:sum];
    }
    if (recordArry.count < 21)
    {
        int num = 21 - (int)recordArry.count;
        for (int i = 0; i < num; i++)
        {
            NSString *sum = @"-1";
            [recordArry addObject:sum];
        }
    }
    recordArry[self.rowIndex] = @"-1";
    NSString *record_plan_enable;
    [[PlanManagement shareManagement].RecordPlanArray removeObjectAtIndex:self.rowIndex];
    if ([PlanManagement shareManagement].RecordPlanArray.count == 0)
    {
        record_plan_enable = @"0";
    }
    else
        record_plan_enable = @"1";
    if ([PlanManagement shareManagement].RecordPlanArray.count == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openRecordInTime" object:nil];
    }
    NSString *cgiStr = [NSString stringWithFormat:@"trans_cmd_string.cgi?cmd=2017&command=3&mark=212&record_plan1=%@&record_plan2=%@&record_plan3=%@&record_plan4=%@&record_plan5=%@&record_plan6=%@&record_plan7=%@&record_plan8=%@&record_plan9=%@&record_plan10=%@&record_plan11=%@&record_plan12=%@&record_plan13=%@&record_plan14=%@&record_plan15=%@&record_plan16=%@&record_plan17=%@&record_plan18=%@&record_plan19=%@&record_plan20=%@&record_plan21=%@&record_plan_enable=%@&", recordArry[0], recordArry[1], recordArry[2], recordArry[3], recordArry[4], recordArry[5], recordArry[6], recordArry[7], recordArry[8], recordArry[9], recordArry[10], recordArry[11], recordArry[12], recordArry[13], recordArry[14], recordArry[15], recordArry[16], recordArry[17], recordArry[18], recordArry[19], recordArry[20], record_plan_enable];
    _m_PPPPChannelMgt->GetJsonCGI([self.str_DID UTF8String], 2017, (char *)[cgiStr UTF8String]);
}

- (void)deleteMotionPlan
{
    NSMutableArray *recordArry = [[NSMutableArray alloc] init];
    for (int i = 0; i < [PlanManagement shareManagement].MotionRecordPlanArray.count; i++)
    {
        PlanModel *model = [[PlanModel alloc] init];
        model = [PlanManagement shareManagement].MotionRecordPlanArray[i];
        NSString *sum = [NSString stringWithFormat:@"%ld", (long)model.sum];
        [recordArry addObject:sum];
    }
    if (recordArry.count < 21)
    {
        int num = 21 - (int)recordArry.count;
        for (int i = 0; i < num; i++)
        {
            NSString *sum = @"-1";
            [recordArry addObject:sum];
        }
    }
    recordArry[self.rowIndex] = @"-1";
    NSString *record_plan_enable;
    [[PlanManagement shareManagement].MotionRecordPlanArray removeObjectAtIndex:self.rowIndex];
//    if ([RecordPlanDatabase shareDatabase].MotionRecordPlanArray.count == 0)
//    {
//        record_plan_enable = @"0";
//    }
//    else
//        record_plan_enable = @"1";
    record_plan_enable = @"1";
    NSString *cgiStr = [NSString stringWithFormat:@"trans_cmd_string.cgi?cmd=2017&command=1&mark=212&motion_record_plan1=%@&motion_record_plan2=%@&motion_record_plan3=%@&motion_record_plan4=%@&motion_record_plan5=%@&motion_record_plan6=%@&motion_record_plan7=%@&motion_record_plan8=%@&motion_record_plan9=%@&motion_record_plan10=%@&motion_record_plan11=%@&motion_record_plan12=%@&motion_record_plan13=%@&motion_record_plan14=%@&motion_record_plan15=%@&motion_record_plan16=%@&motion_record_plan17=%@&motion_record_plan18=%@&motion_record_plan19=%@&motion_record_plan20=%@&motion_record_plan21=%@&motion_record_plan_enable=%@&", recordArry[0], recordArry[1], recordArry[2], recordArry[3], recordArry[4], recordArry[5], recordArry[6], recordArry[7], recordArry[8], recordArry[9], recordArry[10], recordArry[11], recordArry[12], recordArry[13], recordArry[14], recordArry[15], recordArry[16], recordArry[17], recordArry[18], recordArry[19], recordArry[20], record_plan_enable];
    _m_PPPPChannelMgt->GetJsonCGI([self.str_DID UTF8String], 2017, (char *)[cgiStr UTF8String]);
    
}

- (void)deletePushPlan
{
    NSMutableArray *recordArry = [[NSMutableArray alloc] init];
    for (int i = 0; i < [PlanManagement shareManagement].MotiondPushRecordPlanArray.count; i++)
    {
        PlanModel *model = [[PlanModel alloc] init];
        model = [PlanManagement shareManagement].MotiondPushRecordPlanArray[i];
        NSString *sum = [NSString stringWithFormat:@"%ld", (long)model.sum];
        [recordArry addObject:sum];
    }
    if (recordArry.count < 21)
    {
        int num = 21 - (int)recordArry.count;
        for (int i = 0; i < num; i++)
        {
            NSString *sum = @"-1";
            [recordArry addObject:sum];
        }
    }
    recordArry[self.rowIndex] = @"-1";
    NSString *record_plan_enable;
//    if ([RecordPlanDatabase shareDatabase].MotiondPushRecordPlanArray.count == 0)
//    {
//        record_plan_enable = @"0";
//    }
//    else
//        record_plan_enable = @"1";
    record_plan_enable = @"1";
    NSString *cgiStr = [NSString stringWithFormat:@"trans_cmd_string.cgi?cmd=2017&command=2&mark=212&motion_push_plan1=%@&motion_push_plan2=%@&motion_push_plan3=%@&motion_push_plan4=%@&motion_push_plan5=%@&motion_push_plan6=%@&motion_push_plan7=%@&motion_push_plan8=%@&motion_push_plan9=%@&motion_push_plan10=%@&motion_push_plan11=%@&motion_push_plan12=%@&motion_push_plan13=%@&motion_push_plan14=%@&motion_push_plan15=%@&motion_push_plan16=%@&motion_push_plan17=%@&motion_push_plan18=%@&motion_push_plan19=%@&motion_push_plan20=%@&motion_push_plan21=%@&motion_push_plan_enable=%@&", recordArry[0], recordArry[1], recordArry[2], recordArry[3], recordArry[4], recordArry[5], recordArry[6], recordArry[7], recordArry[8], recordArry[9], recordArry[10], recordArry[11], recordArry[12], recordArry[13], recordArry[14], recordArry[15], recordArry[16], recordArry[17], recordArry[18], recordArry[19], recordArry[20], record_plan_enable];
    _m_PPPPChannelMgt->GetJsonCGI([self.str_DID UTF8String], 2017, (char *)[cgiStr UTF8String]);
    [[PlanManagement shareManagement].MotiondPushRecordPlanArray removeObjectAtIndex:self.rowIndex];
}

-(void) saveBtnData{
    
    if ([self.addPlanTyep isEqualToString:@"Add_Schedule_Recording"]) //录像计划
    {
        if ([pickerView saveData])
        {
            if ([PlanManagement shareManagement].RecordPlanArray.count == 1)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"closeRecordInTime" object:nil];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if ([self.addPlanTyep isEqualToString:@"Add_Motion_Recording_Schedule"]) //移动侦测录像计划
    {
        if ([pickerView saveMotionRecordPlanData])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if ([self.addPlanTyep isEqualToString:@"AddMotionPushPlan"]) //移动侦测报警计划
    {
        if ([pickerView saveMotionPushPlanData])
        {
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
    else if ([self.addPlanTyep isEqualToString:@"AddDefencePlan"])
    {
        if ([pickerView saveAlarmPlanData])
        {
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
    
}

- (BOOL)shouldAutorotate{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
