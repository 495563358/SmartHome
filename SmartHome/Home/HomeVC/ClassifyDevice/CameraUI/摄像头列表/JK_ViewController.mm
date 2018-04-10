//
//  JK_ViewController.m
//  ZNJD2
//
//  Created by he on 14-7-19.
//
//

#import "JK_ViewController.h"
#import "JK_LineTableViewCell.h"
#import "OnekeyViewController.h"
//#import "MonitorViewController.h"

#import "HTCameras.h"
#import "HTCameraStatus.h"

#import "UIView+Toast.h"

@interface JK_ViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UITextField *deviceAddress;
@property (nonatomic,strong) UITextField *userName;
@property (nonatomic,strong) UITextField *passWord;
@end

@implementation JK_ViewController
@synthesize dataArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       // _moblieDict = [[SockectManager defaultManager] readMobileFile];
        dataArray = [[NSMutableArray alloc]init];
    prefixDataArray = [[NSMutableArray alloc]init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *it =  [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"添加", "") style:UIBarButtonItemStylePlain target:self action:@selector(addDeviceWithAddress)];
    self.navigationItem.rightBarButtonItems = @[it];
    self.navigationItem.title = @"添加智能屋摄像头";
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 0.1)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanhui(b)"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    
    [self startSearch];
    
    [self.view makeToast:@"正在搜索已配置的设备，请稍后"];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, Sc_h - 100 - 64 - 40, Sc_w - 60, 50)];
    label.textColor = Color_system;
    label.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:label];
    label.text = @"    温馨提示:请先配置WIFI后,再添加摄像头。";
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    label.layer.cornerRadius = 5.0;
    label.layer.masksToBounds = YES;
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addDeviceWithAddress
{


    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"请输入密码", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    _deviceAddress =[alert textFieldAtIndex:0];
    _deviceAddress.placeholder = @"ID";
   
    _passWord =[alert textFieldAtIndex:1];
    _passWord.placeholder = NSLocalizedString(@"密码",nil);
    _passWord.keyboardType =UIKeyboardTypeNumbersAndPunctuation;
    [alert show];
    
}
#pragma mark --UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 1:
        {
            NSDictionary *dict = @{@"roomCode":self.roomCode,
                                   @"deviceAddress":self.deviceAddress.text,
                                   @"nickName":self.deviceAddress.text,
                                   @"ico":@"list_camera",
                                   @"deviceType":@"100",
                                  @"validationCode":self.passWord.text,
                                   @"deviceCode":@"commonsxt"};
            __weak typeof(self) weakSelf = self;
    
            [BaseHttpService sendRequestAccess:[NSString stringWithFormat:@"%@/smarthome.IMCPlatform/xingUser/setDeviceInfo.action",BaseHttpUrl] parameters:dict success:^(id _Nonnull) {
                //摄像头里这个字段存的是账号 及密码
                // equip.icon = _userName.text;
                Equip *eq = [[Equip alloc]initWithEquipID:weakSelf.deviceAddress.text];
                eq.type = @"100";
                eq.name  = self.userName.text;
                eq.hostDeviceCode = @"commonsxt";
                eq.num = weakSelf.passWord.text;
                
                eq.roomCode = weakSelf.roomCode;
                [eq saveEquip];
                [[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"添加成功", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"我知道了", nil) otherButtonTitles:nil, nil]show];
                [weakSelf startSearch];
            }];
        }
            break;
            
        default:
            
            break;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
  //  [self.tabBarController.tabBar setHidden:NO];
 
    
}
- (void)handleTimer:(NSTimer *)timer{
    [self stopSearch];
    [self.tableView reloadData];
}

- (void) startSearch
{
    [dataArray removeAllObjects];
    [prefixDataArray removeAllObjects];
    [self stopSearch];
    NSLog(@"-----%d",[DataWrapper getCameras].count);
    [prefixDataArray addObjectsFromArray:[DataWrapper getCameras]];
    dvs = new CSearchDVS();
    dvs->searchResultDelegate = self;
    dvs->Open();
    
    //create the start timer
    _searchTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
}
#pragma mark -
#pragma mark SearchCameraResultProtocol

- (void) SearchCameraResult:(NSString *)mac Name:(NSString *)name Addr:(NSString *)addr Port:(NSString *)port DID:(NSString*)did{
    NSLog(@"name %@ did  %@",name, did);

    
    //剔除重复
   BOOL isExist = NO;
    
        for (Equip *e in prefixDataArray) {
            if ( [e.equipID isEqualToString:did] ) {
                isExist = YES;
                break;
            }
        }
   
   
    if (!isExist) {
       Equip *e=[[Equip alloc]initWithEquipID:did];
       // e.Name = @"admin";
        e.name = name;
        e.type = @"100";
        e.roomCode =  @"";
        [prefixDataArray addObject:e];
        [dataArray addObject:e];
    }
   
   
}
- (void) stopSearch
{
    if (dvs != NULL) {
        SAFE_DELETE(dvs);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (dataArray.count) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    }
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pool"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"pool"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"WiFi配置";
        return cell;
    }
    
    static NSString *str = @"JK_LineTableViewCell";
    JK_LineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JK_LineTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    Equip *equip= [dataArray objectAtIndex:[indexPath row]];
    equip.roomCode = self.roomCode;
    [cell setModel:equip];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        OnekeyViewController *vc = [OnekeyViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (IBAction)doRightButtonAction:(UIButton *)sender {
//    MonitorViewController *moniVC = [[MonitorViewController alloc] init];
//    [self.navigationController pushViewController:moniVC animated:YES];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
@end
