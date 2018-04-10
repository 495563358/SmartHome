//
//  CameraSettingMoreTableViewController.m
//  SmartHome
//
//  Created by Smart house on 2018/1/12.
//  Copyright © 2018年 sunzl. All rights reserved.
//

#import "CameraSettingMoreTableViewController.h"

#import "UserPwdSetViewController.h"

#import "WifiSettingViewController.h"

#import "SystemUpgradeViewController.h"

#import "DateTimeController.h"

#import "AlarmController.h"

#import "RecordScheduleSettingViewController.h"

#import "MotionPushPlanViewController.h"

#import "FtpSettingViewController.h"

#import "MailSettingViewController.h"


@interface CameraSettingMoreTableViewController (){
    NSArray *names;
}

@end

@implementation CameraSettingMoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhui(b)"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    
    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backClick)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGes];
    self.navigationItem.title = @"摄像头设置";
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 1)];
    names = @[@"修改密码",@"WIFI设置",@"时间设置",@"报警系统",@"移动侦测报警计划",@"SD卡管理"];
    
    
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:{
            //修改摄像头密码
            UserPwdSetViewController *UserPwdSettingView = [[UserPwdSetViewController alloc] init];
            UserPwdSettingView.m_pChannelMgt = _m_pPPPPChannelMgt;
            UserPwdSettingView.cameraListMgt = _cameraListMgt;
            UserPwdSettingView.m_strDID = _temp.equipID;
            UserPwdSettingView.cameraName = _temp.name;
            UserPwdSettingView.equip = _temp;
            [self.navigationController pushViewController:UserPwdSettingView animated:YES];
            break;
        }
        case 1:{
            
            //WIFI 列表
            WifiSettingViewController *wifiSettingView = [[WifiSettingViewController alloc] init];
            wifiSettingView.m_pPPPPChannelMgt = _m_pPPPPChannelMgt;
            wifiSettingView.m_strDID = _m_strDID;
            [self.navigationController pushViewController:wifiSettingView animated:YES];
            break;
        }
        case 2:{
            //时间设置
            DateTimeController *DateTimeSettingView = [[DateTimeController alloc] init];
            DateTimeSettingView.m_pChannelMgt = _m_pPPPPChannelMgt;
            DateTimeSettingView.m_strDID = _m_strDID;
            [self.navigationController pushViewController:DateTimeSettingView animated:YES];
            break;
        }
        case 3:{
            //报警系统
            AlarmController *AlarmSettingView = [[AlarmController alloc] init];
            AlarmSettingView.m_pChannelMgt = _m_pPPPPChannelMgt;
            AlarmSettingView.m_strDID = _m_strDID;
            [self.navigationController pushViewController:AlarmSettingView animated:YES];
            break;
        }
        case 4:{
            //移动侦测报警计划设置
            MotionPushPlanViewController *motionPushPlan = [[MotionPushPlanViewController alloc] init];
            motionPushPlan.m_PPPPChannelMgt = _m_pPPPPChannelMgt;
            motionPushPlan.m_strDID = _m_strDID;
            motionPushPlan.navigationItem.title = @"移动侦测报警计划";
            [self.navigationController pushViewController:motionPushPlan animated:YES];
            break;
        }
        case 5:{
            //SD卡
            RecordScheduleSettingViewController* sdcardSet = [[RecordScheduleSettingViewController alloc] initWithNibName:@"RecordScheduleSettingViewController" bundle:nil];
            sdcardSet.m_PPPPChannelMgt = _m_pPPPPChannelMgt;
            sdcardSet.m_strDID = _m_strDID;
            sdcardSet.navigationItem.title = NSLocalizedStringFromTable(@"SD卡管理", @STR_LOCALIZED_FILE_NAME, nil);
            [self.navigationController pushViewController:sdcardSet animated:YES];
            break;
        }
        case 6:{
            //邮件设置
            MailSettingViewController *mailSettingView = [[MailSettingViewController alloc] init];
            mailSettingView.m_pChannelMgt = _m_pPPPPChannelMgt;
            mailSettingView.m_strDID = _m_strDID;
            [self.navigationController pushViewController:mailSettingView animated:YES];
            break;
        }
        case 7:{
            //FTP设置
            FtpSettingViewController *ftpSettingView = [[FtpSettingViewController alloc] init];
            ftpSettingView.m_pChannelMgt = _m_pPPPPChannelMgt;
            ftpSettingView.m_strDID = _m_strDID;
            [self.navigationController pushViewController:ftpSettingView animated:YES];
            break;
        }
        case 8:{
            
            //系统固件升级
            SystemUpgradeViewController* sysUpgrade = [[SystemUpgradeViewController alloc] initWithNibName:@"SystemUpgradeViewController" bundle:nil];
            sysUpgrade.navigationItem.title = NSLocalizedStringFromTable(@"FirmwareUpgrade", @STR_LOCALIZED_FILE_NAME, nil);
            sysUpgrade.m_pPPPPChannelMgt = _m_pPPPPChannelMgt;
            sysUpgrade.str_uid = _m_strDID;
            sysUpgrade.str_pwd = _m_strPWD;
            [self.navigationController pushViewController:sysUpgrade animated:YES];
            break;
        }
            
            
        default:
            break;
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return names.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pool"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"pool"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = names[indexPath.row];
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
