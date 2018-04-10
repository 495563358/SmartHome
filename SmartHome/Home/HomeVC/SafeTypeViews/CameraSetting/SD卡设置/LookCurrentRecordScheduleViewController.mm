//
//  LookCurrentRecordScheduleViewController.m
//  P2PCamera
//
//  Created by yan luke on 13-6-26.
//
//

#import "LookCurrentRecordScheduleViewController.h"
#import "SetRecordScheduleCell.h"
#import "obj_common.h"
#import "SelectWeekCustomView.h"
#define SELECTEDICONTAG 1000
#define CELLTAG 2000
@interface LookCurrentRecordScheduleViewController ()
@property (nonatomic, assign) int SelectDay;
@end

@implementation LookCurrentRecordScheduleViewController
@synthesize select;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _SelectDay = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _aTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _aTableView.delegate = self;
    _aTableView.dataSource = self;
    [self.view addSubview:_aTableView];
    self.aTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
//    self.selectWeek = [[[SelectWeekCustomView alloc] initWithFrame:CGRectMake(3.f,5.f,size.width - 6.f,46.f)] autorelease];
    self.selectWeek.delegate = self;
    
    UIBarButtonItem* RightItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"selected", @STR_LOCALIZED_FILE_NAME, nil) style:UIBarButtonItemStylePlain target:self action:@selector(SelectAllDay:)];
    self.navigationItem.rightBarButtonItem = RightItem;
//    [RightItem release],RightItem = nil;
}

#pragma mark RightBarItem
- (void) SelectAllDay:(id) sender{
    
    UIBarButtonItem* RightItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"Invert", @STR_LOCALIZED_FILE_NAME, nil) style:UIBarButtonItemStylePlain target:self action:@selector(InvertAllDay:)];
    self.navigationItem.rightBarButtonItem = RightItem;
//    [RightItem release],RightItem = nil;
    
    for (int i = 0; i < 672; i++) {
        [select replaceObjectAtIndex:i withObject:@1];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.aTableView reloadData];
    });
}

- (void) InvertAllDay:(id) sender{
    
    UIBarButtonItem* RightItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"selected", @STR_LOCALIZED_FILE_NAME, nil) style:UIBarButtonItemStylePlain target:self action:@selector(SelectAllDay:)];
    self.navigationItem.rightBarButtonItem = RightItem;
//    [RightItem release],RightItem = nil;
    
    for (int i = 0; i < 672; i++) {
        [select replaceObjectAtIndex:i withObject:@0];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.aTableView reloadData];
    });
}

- (void) ChangeWeeks:(UISegmentedControl*) segmentCtr{
    dispatch_async(dispatch_get_main_queue(),^{
        [_aTableView reloadData];
    });
}
#pragma mark-
#pragma mark cellSwipe
- (void) swipeSelectRecordTime:(UISwipeGestureRecognizer*) swipeGes{
    int index = swipeGes.view.tag - CELLTAG;
    for (int i = 8; i < 12; i++) {
        [select replaceObjectAtIndex:(index * 4 + i - 8 + 96*_SelectDay) withObject:@1];
        UIView* view = [self.view viewWithTag:(index*4 + i + 96*_SelectDay)];
        if ([view isKindOfClass:[RecordTimeMode class]]) {
            NSLog(@"view.tag %d",view.tag);
            RecordTimeMode* re = (RecordTimeMode*) view;
            re.is_Selected = YES;
        }
    }
    UIView* view = [self.view viewWithTag:(index + 96*_SelectDay + SELECTEDICONTAG)];
    if ([view isKindOfClass:[RecordTimeMode class]]) {
        RecordTimeMode* re = (RecordTimeMode*) view;
        re.is_Selected_Icon = YES;
    }
    
}

- (void) swipeUnSelectRecordTime:(UISwipeGestureRecognizer*) swipeGes{
    int index = swipeGes.view.tag - CELLTAG;
    for (int i = 8; i < 12; i++) {
        [select replaceObjectAtIndex:(index * 4 + i - 8 + 96*_SelectDay) withObject:@0];
        UIView* view = [self.view viewWithTag:(index*4 + i + 96*_SelectDay)];
        if ([view isKindOfClass:[RecordTimeMode class]]) {
            NSLog(@"view.tag %d",view.tag);
            RecordTimeMode* re = (RecordTimeMode*) view;
            re.is_Selected = NO;
        }
    }
    UIView* view = [self.view viewWithTag:(index + 96*_SelectDay + SELECTEDICONTAG)];
    if ([view isKindOfClass:[RecordTimeMode class]]) {
        RecordTimeMode* re = (RecordTimeMode*) view;
        re.is_Selected_Icon = NO;
    }
}

#pragma mark -
#pragma mark RecordTimeMode Ges
- (void) selectRecordTime:(UITapGestureRecognizer*) TapGes{
    
    RecordTimeMode* view = (RecordTimeMode*) TapGes.view;
    if (TapGes.view.tag >= SELECTEDICONTAG) {
        view.is_Selected_Icon = !view.is_Selected_Icon;
        if (view.is_Selected_Icon) {
            for (int i = 8; i < 12; i++) {
                //select[(view.tag - SELECTEDICONTAG)*4 + i] = @1;
                [select replaceObjectAtIndex:((view.tag - SELECTEDICONTAG - 96*_SelectDay)*4 + i - 8 + 96*_SelectDay) withObject:@1];
                int k = (view.tag - SELECTEDICONTAG - 96*_SelectDay)*4 + i + 96*_SelectDay;
                UIView* view = [self.view viewWithTag:k];
                if ([view isKindOfClass:[RecordTimeMode class]]) {
                    RecordTimeMode* re = (RecordTimeMode*) view;
                    re.is_Selected = YES;
                }
            }
        }else{
            for (int i = 8; i < 12; i++) {
                //select[(view.tag - SELECTEDICONTAG)*4 + i] = @0;
                [select replaceObjectAtIndex:((view.tag - SELECTEDICONTAG - 96*_SelectDay)*4 + i - 8 + 96*_SelectDay) withObject:@0];
                int k = (view.tag - SELECTEDICONTAG - 96*_SelectDay)*4 + i + 96*_SelectDay;
                UIView* view = [self.view viewWithTag:k];
                if ([view isKindOfClass:[RecordTimeMode class]]) {
                    RecordTimeMode* re = (RecordTimeMode*) view;
                    re.is_Selected = NO;
                }
            }
            
        }
    }else{
        view.is_Selected = !view.is_Selected;
        if (!view.is_Selected) {
            //select[view.tag - 8] = @0;
            [select replaceObjectAtIndex:(view.tag - 8) withObject:@0];
            UIView* tmpv = [self.view viewWithTag:((view.tag - 96*_SelectDay) - (view.tag - 96*_SelectDay)%4 - 8)/4 + SELECTEDICONTAG + 96*_SelectDay];
            if ([tmpv isKindOfClass:[RecordTimeMode class]]) {
                RecordTimeMode* reView = (RecordTimeMode*) tmpv;
                reView.is_Selected_Icon = NO;
            }
        }else{
            //select[view.tag - 8] = @1;
            [select replaceObjectAtIndex:(view.tag - 8) withObject:@1];
            int i = (view.tag - 96*_SelectDay) - (view.tag - 96*_SelectDay)%4 - 8 + 96*_SelectDay;
            if ([[select objectAtIndex:i] isEqual:@1]&&[[select objectAtIndex:(i + 1)] isEqual:@1]&&[[select objectAtIndex:(i + 2)] isEqual:@1]&&[[select objectAtIndex:(i + 3)] isEqual:@1]) {
                NSLog(@"view.tag  %d  select[%d] = %@ select[%d] = %@ select[%d] = %@ select[%d] = %@",view.tag,i,[select objectAtIndex:i],i+1,[select objectAtIndex:(i+1)],i+2,[select objectAtIndex:(i+2)],i+3,[select objectAtIndex:(i+3)]);
                UIView* tmpV = [self.view viewWithTag:((i - 96*_SelectDay)/4 + SELECTEDICONTAG + 96*_SelectDay)];
                if ([tmpV isKindOfClass:[RecordTimeMode class]]) {
                    RecordTimeMode* reView = (RecordTimeMode*)tmpV;
                    reView.is_Selected_Icon = YES;
                }
            }
        }
    }
}


#pragma mark -
#pragma mark UITableView Dalegate  Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 24;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIden = @"cellIdenSetRecordTime";
    SetRecordScheduleCell* cell = (SetRecordScheduleCell*)[tableView dequeueReusableCellWithIdentifier:cellIden];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SetRecordScheduleCell" owner:self options:nil] lastObject];
    }
    
    cell.firIv.tag = indexPath.row * 4 + 8 + 96*_SelectDay;
    cell.secIv.tag = indexPath.row * 4 + 9 + 96*_SelectDay;
    cell.thirdIv.tag = indexPath.row * 4 + 10 + 96*_SelectDay;
    cell.fourIv.tag = indexPath.row * 4 + 11 + 96*_SelectDay;
    cell.SelectIcon.tag = SELECTEDICONTAG + indexPath.row + 96*_SelectDay;
    
    int iden = 1;//判断是否此行Cell全选
    
    if ([select[cell.firIv.tag - 8] isEqual:@1]) {
        cell.firIv.is_Selected = YES;
    }else{
        iden = 0;
    }
    if ([select[cell.secIv.tag - 8] isEqual:@1]) {
        cell.secIv.is_Selected = YES;
    }else{
        iden = 0;
    }
    if ([select[cell.thirdIv.tag - 8] isEqual:@1]) {
        cell.thirdIv.is_Selected = YES;
    }else{
        iden = 0;
    }
    if ([select[cell.fourIv.tag - 8] isEqual:@1]) {
        cell.fourIv.is_Selected = YES;
    }else{
        iden = 0;
    }
    
    if (iden == 1) {
        cell.SelectIcon.is_Selected_Icon = YES;
    }else{
        cell.SelectIcon.is_Selected_Icon = NO;
    }
    
    cell.tag = indexPath.row + CELLTAG;
    
    UISwipeGestureRecognizer* swipeGes= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeSelectRecordTime:)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionRight;
    [cell addGestureRecognizer:swipeGes];
//    [swipeGes release],swipeGes = nil;
    
    swipeGes= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUnSelectRecordTime:)];
    swipeGes.direction = UISwipeGestureRecognizerDirectionLeft;
    [cell addGestureRecognizer:swipeGes];
//    [swipeGes release],swipeGes = nil;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer* TapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectRecordTime:)];
    TapGes.numberOfTapsRequired = 1;
    [cell.firIv addGestureRecognizer:TapGes];
//    [TapGes release],TapGes = nil;
    
    TapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectRecordTime:)];
    TapGes.numberOfTapsRequired = 1;
    [cell.secIv addGestureRecognizer:TapGes];
//    [TapGes release],TapGes = nil;
    
    TapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectRecordTime:)];
    TapGes.numberOfTapsRequired = 1;
    [cell.thirdIv addGestureRecognizer:TapGes];
//    [TapGes release],TapGes = nil;
    
    TapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectRecordTime:)];
    TapGes.numberOfTapsRequired = 1;
    [cell.fourIv addGestureRecognizer:TapGes];
//    [TapGes release],TapGes = nil;
    
    TapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectRecordTime:)];
    TapGes.numberOfTapsRequired = 1;
    [cell.SelectIcon addGestureRecognizer:TapGes];
//    [TapGes release],TapGes = nil;
    NSString* startdateStr = [NSString stringWithFormat:@"%d",indexPath.row];
    NSString* endDateStr = [NSString stringWithFormat:@"%d",indexPath.row+1];
    if (indexPath.row < 10){
        startdateStr = [NSString stringWithFormat:@"0%d",indexPath.row];
    }
    if (indexPath.row+1 < 10) {
        endDateStr = [NSString stringWithFormat:@"0%d",indexPath.row + 1];
    }
    cell.timeLabel.text = [NSString stringWithFormat:@"%@ ~ %@",startdateStr,endDateStr];
    return cell;
}
//_m_PPPPChannelMgt->GetCGI((char*) [self.m_strDID UTF8String], CGI_IEFORMATSD);//格式化SD卡
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return _selectWeek;
}

#pragma mark -
#pragma mark SelectWeekCustomViewDelegate
- (void) SelectWeekCustomView:(SelectWeekCustomView*) selectWeekView ChangeSelectIndex:(int) Selectindex{
    _SelectDay = Selectindex;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.aTableView reloadData];
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
//    [super dealloc];
//    [_aTableView release],_aTableView = nil;
//    [_selectWeek release],_selectWeek = nil;
    //self.select = nil;
}

@end
