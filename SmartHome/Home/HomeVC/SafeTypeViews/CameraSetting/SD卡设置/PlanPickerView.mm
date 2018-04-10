//
//  PlanPickerView.m
//  Eye4
//
//  Created by 黄甜 on 16/10/20.
//
//

#import "PlanPickerView.h"
#import "PlanModel.h"
#import "PlanManagement.h"
#import "mytoast.h"
#import "WeekButton.h"
#import "obj_common.h"

@interface PlanPickerView()
{
    UIView                      *timeBroadcastView;//定时播放显示视图
    MXSCycleScrollView          *yearScrollView;//年份滚动视图
    MXSCycleScrollView          *monthScrollView;//月份滚动视图
    MXSCycleScrollView          *hourScrollView;//时滚动视图
    MXSCycleScrollView          *minuteScrollView;//分滚动视图
    
    UILabel                     *startTimer;
    UILabel                     *nowPickerShowTimeLabel;//当前picker显示的时间
    UILabel                     *selectTimeIsNotLegalLabel;//所选时间是否合法
    UIButton                    *OkBtn;//自定义picker上的确认按钮
    NSMutableArray *saveBtnArray;
    NSInteger width;
    NSMutableArray *allSaveData;
    PlanModel *editModel;
    NSArray *currentDatabaseArray;
    
    BOOL color1 ;
    BOOL color2 ;
    BOOL color3 ;
    BOOL color4 ;
    BOOL color5 ;
    BOOL color6 ;
    BOOL color7 ;//各星期按钮显示颜色
}

@end

@implementation PlanPickerView
- (id)initWithFrame:(CGRect)frame Str_DID:(NSString *)str_DID rowIndex:(NSInteger)rowIndex IsEdit:(BOOL)isEdit Type:(NSString *)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.str_DID = str_DID;
        self.rowIndex = rowIndex;
        self.isEdit = isEdit;
        if ([type isEqualToString:@"Add_Schedule_Recording"] && self.isEdit)
        {
            if (rowIndex < [PlanManagement shareManagement].RecordPlanArray.count)
            {
                PlanModel *model = [PlanManagement shareManagement].RecordPlanArray[rowIndex];
                allSaveData = [[NSMutableArray alloc] init];
                [allSaveData addObject:model];
            }
            
        }
        else if ([type isEqualToString:@"Add_Motion_Recording_Schedule"] && self.isEdit)
        {
            if (rowIndex < [PlanManagement shareManagement].MotionRecordPlanArray.count)
            {
                PlanModel *model = [PlanManagement shareManagement].MotionRecordPlanArray[rowIndex];
                allSaveData = [[NSMutableArray alloc] init];
                [allSaveData addObject:model];
            }
        }
        else if ([type isEqualToString:@"AddMotionPushPlan"] && self.isEdit)
        {
            if (rowIndex < [PlanManagement shareManagement].MotiondPushRecordPlanArray.count)
            {
                PlanModel *model = [PlanManagement shareManagement].MotiondPushRecordPlanArray[rowIndex];
                allSaveData = [[NSMutableArray alloc] init];
                [allSaveData addObject:model];
            }
        }
        else if ([type isEqualToString:@"AddDefencePlan"] && self.isEdit)
        {
            if (rowIndex < [PlanManagement shareManagement].AlarmPlanArray.count)
            {
                PlanModel *model = [PlanManagement shareManagement].AlarmPlanArray[rowIndex];
                allSaveData = [[NSMutableArray alloc] init];
                [allSaveData addObject:model];
            }
        }
        
        width = [UIScreen mainScreen].bounds.size.width;
        saveBtnArray = [[NSMutableArray alloc] init];
        [self setTimeBroadcastView];
        [self createButton];
    }
    return self;
}

-(void) colorDefaultZero{
    color1 =0;
    color2 =0;
    color3 =0;
    color4 =0;
    color5 =0;
    color6 =0;
    color7 =0;
}

-(void) createButton{
    
    [self colorDefaultZero];
    
    UIView *bgButton = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(timeBroadcastView.frame) + 20, width, 60)];
    bgButton.userInteractionEnabled = YES;
    
    NSMutableArray *btnArray = [[NSMutableArray alloc] init];
    if (allSaveData.count != 0) {
        PlanModel *model = allSaveData[0];
        NSString *btnColor = model.week;
        for (NSInteger i = 0; i<btnColor.length; i++) {
            NSRange range = NSMakeRange(i, 1);
            [btnArray addObject:[btnColor substringWithRange:range]];
        }
    }
    
    
    NSArray *array = @[NSLocalizedStringFromTable(@"SUN", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"MON", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"TUE", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"WED", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"THU", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"FRI", @STR_LOCALIZED_FILE_NAME, nil),NSLocalizedStringFromTable(@"SAT", @STR_LOCALIZED_FILE_NAME, nil)];
    for (NSInteger i=0; i<7; i++) {
        WeekButton *weekB;
        if (i<4) {
            weekB = [[WeekButton alloc] initWithFrame:CGRectMake(i*(width/4), 0, width/4, 30) Title:array[i]];
        }else{
            weekB = [[WeekButton alloc] initWithFrame:CGRectMake((i-4)*(width/4), 30, width/4, 30) Title:array[i]];
        }
        if (i == 0) {
            weekB.tag = 7;
        }else{
            weekB.tag = i;
        }
        [weekB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        if (btnArray.count > 0) {
            NSInteger num = 0;
            if (i == 0) {
                num = 7;
            }else{
                num = i;
            }
            for (NSInteger j = 0; j<btnArray.count; j++) {
                if (num == [btnArray[j] integerValue]) {
                    [weekB setTitleColor:[UIColor colorWithRed:0/255.0 green:198.0/255.0 blue:243.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                    [self addBtn:num];
                    [self changeXQColor:num];
                }
            }
        }
        
        [weekB addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchDown];
        
        weekB.titleLabel.font = [UIFont systemFontOfSize:15];
        [bgButton addSubview:weekB];
    }
    
    //    for (NSInteger j = 0; j<btnArray.count; j++) {
    //        [self changeXQColor:[btnArray[j] integerValue]];
    //    }
    
    [self addSubview:bgButton];
}

-(void) changeColor:(UIButton *)btn{
    
    switch (btn.tag) {
        case 1:
        {
            if (color1) {
                color1 = 0;
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self delBtn:btn.tag];
            }else{
                color1 = 1;
                [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:198.0/255.0 blue:243.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [self addBtn:btn.tag];
            }
            
        }
            break;
        case 2:
        {
            if (color2) {
                color2 = 0;
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self delBtn:btn.tag];
            }else{
                color2 = 1;
                [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:198.0/255.0 blue:243.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [self addBtn:btn.tag];
            }
            
        }
            break;
        case 3:
        {
            if (color3) {
                color3 = 0;
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self delBtn:btn.tag];
            }else {
                color3 = 1;
                [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:198.0/255.0 blue:243.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [self addBtn:btn.tag];
            }
            
        }
            break;
        case 4:
        {
            if (color4) {
                color4 = 0;
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self delBtn:btn.tag];
            }else{
                color4 = 1;
                [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:198.0/255.0 blue:243.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [self addBtn:btn.tag];
            }
            
        }
            break;
        case 5:
        {
            if (color5) {
                color5 = 0;
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self delBtn:btn.tag];
            }else{
                color5 = 1;
                [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:198.0/255.0 blue:243.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [self addBtn:btn.tag];
            }
            
        }
            break;
        case 6:
        {
            if (color6) {
                color6 = 0;
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self delBtn:btn.tag];
            }else{
                color6 = 1;
                [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:198.0/255.0 blue:243.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [self addBtn:btn.tag];
            }
            
        }
            break;
        case 7:
        {
            if (color7) {
                color7 = 0;
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self delBtn:btn.tag];
            }else{
                color7 = 1;
                [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:198.0/255.0 blue:243.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                [self addBtn:btn.tag];
            }
            
        }
            break;
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeButtonColor" object:nil];
    
}

-(void) addBtn:(NSInteger) index{
    [saveBtnArray addObject:[NSString stringWithFormat:@"%ld",(long)index]];
}

-(void) delBtn:(NSInteger) index{
    [saveBtnArray removeObject:[NSString stringWithFormat:@"%ld",(long)index]];
}

-(void) changeXQColor:(NSInteger) color{
    switch (color) {
        case 1:
            color1 = 1;
            break;
        case 2:
            color2 = 1;
            break;
        case 3:
            color3 = 1;
            break;
        case 4:
            color4 = 1;
            break;
        case 5:
            color5 = 1;
            break;
        case 6:
            color6 = 1;
            break;
        case 7:
            color7 = 1;
            break;
        default:
            break;
    }
}

#pragma mark -custompicker
//设置自定义datepicker界面
- (void)setTimeBroadcastView
{
    startTimer = [[UILabel alloc] initWithFrame:CGRectMake(15, 15.0, width/2, 18)];
    [startTimer setBackgroundColor:[UIColor clearColor]];
    [startTimer setFont:[UIFont systemFontOfSize:18.0]];
    [startTimer setTextColor:[UIColor grayColor]];
    [startTimer setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:startTimer];
    
    nowPickerShowTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(width/2, 15.0, width/2-15, 18)];
    [nowPickerShowTimeLabel setBackgroundColor:[UIColor clearColor]];
    [nowPickerShowTimeLabel setFont:[UIFont systemFontOfSize:18.0]];
    [nowPickerShowTimeLabel setTextColor:[UIColor grayColor]];
    [nowPickerShowTimeLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:nowPickerShowTimeLabel];
    
    if (allSaveData.count != 0) {
        PlanModel *model = allSaveData[0];
        startTimer.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedStringFromTable(@"Start", @STR_LOCALIZED_FILE_NAME, nil),model.startTimer];
        nowPickerShowTimeLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedStringFromTable(@"End", @STR_LOCALIZED_FILE_NAME, nil),model.endTimer];
    }else{
        startTimer.text = [NSString stringWithFormat:@"%@: %@:%@",NSLocalizedStringFromTable(@"Start", @STR_LOCALIZED_FILE_NAME, nil),@"00",@"00"];
        nowPickerShowTimeLabel.text = [NSString stringWithFormat:@"%@: %@:%@",NSLocalizedStringFromTable(@"End", @STR_LOCALIZED_FILE_NAME, nil),@"24",@"00"];
    }
    
    timeBroadcastView = [[UIView alloc] initWithFrame:CGRectMake(15, 50, width-30, 190.0)];
    timeBroadcastView.layer.cornerRadius = 8;//设置视图圆角
    timeBroadcastView.layer.masksToBounds = YES;
    CGColorRef cgColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0].CGColor;
    timeBroadcastView.layer.borderColor = cgColor;
    timeBroadcastView.layer.borderWidth = 2.0;
    [self addSubview:timeBroadcastView];
    
    UIView *middleSepView = [[UIView alloc] initWithFrame:CGRectMake(0, 75, width-30, 38)];
    [middleSepView setBackgroundColor:RGBA(0.0, 198.0, 243.0, 1.0)];
    [timeBroadcastView addSubview:middleSepView];
    
    [self setYearScrollView];
    [self setMonthScrollView];
    
    [self setHourScrollView];
    [self setMinuteScrollView];
    
    
}

//设置年月日时分的滚动视图
- (void)setYearScrollView
{
    yearScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, 73.0, 190.0)];
    NSInteger yearint = [self setNowTimeShow:0];
    [yearScrollView setCurrentSelectPage:yearint];
    yearScrollView.delegate = self;
    yearScrollView.datasource = self;
    [self setAfterScrollShowView:yearScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:yearScrollView];
}
//设置年月日时分的滚动视图
- (void)setMonthScrollView
{
    monthScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(73.0, 0, 40.5, 190.0)];
    NSInteger monthint = [self setNowTimeShow:1];
    [monthScrollView setCurrentSelectPage:monthint];
    monthScrollView.delegate = self;
    monthScrollView.datasource = self;
    [self setAfterScrollShowView:monthScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:monthScrollView];
}

//设置年月日时分的滚动视图
- (void)setHourScrollView
{
    hourScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-150, 0, 39.0, 190.0)];
    NSInteger hourint = [self setNowTimeShow:2];
    [hourScrollView setCurrentSelectPage:hourint];
    hourScrollView.delegate = self;
    hourScrollView.datasource = self;
    [self setAfterScrollShowView:hourScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:hourScrollView];
}
//设置年月日时分的滚动视图
- (void)setMinuteScrollView
{
    minuteScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-100, 0, 37.0, 190.0)];
    NSInteger minuteint = [self setNowTimeShow:3];
    [minuteScrollView setCurrentSelectPage:minuteint];
    minuteScrollView.delegate = self;
    minuteScrollView.datasource = self;
    [self setAfterScrollShowView:minuteScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:minuteScrollView];
}

- (void)setAfterScrollShowView:(MXSCycleScrollView*)scrollview  andCurrentPage:(NSInteger)pageNumber
{
    UILabel *oneLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber];
    [oneLabel setFont:[UIFont systemFontOfSize:14]];
    [oneLabel setTextColor:RGBA(186.0, 186.0, 186.0, 1.0)];
    UILabel *twoLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+1];
    [twoLabel setFont:[UIFont systemFontOfSize:16]];
    [twoLabel setTextColor:RGBA(113.0, 113.0, 113.0, 1.0)];
    
    UILabel *currentLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+2];
    [currentLabel setFont:[UIFont systemFontOfSize:18]];
    [currentLabel setTextColor:[UIColor whiteColor]];
    
    UILabel *threeLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+3];
    [threeLabel setFont:[UIFont systemFontOfSize:16]];
    [threeLabel setTextColor:RGBA(113.0, 113.0, 113.0, 1.0)];
    UILabel *fourLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+4];
    [fourLabel setFont:[UIFont systemFontOfSize:14]];
    [fourLabel setTextColor:RGBA(186.0, 186.0, 186.0, 1.0)];
}

#pragma mark mxccyclescrollview delegate
#pragma mark mxccyclescrollview databasesource
- (NSInteger)numberOfPages:(MXSCycleScrollView*)scrollView
{
    if (scrollView == yearScrollView) {
        return 24;
    }
    else if (scrollView == monthScrollView)
    {
        return 60;
    }
    else if (scrollView == hourScrollView)
    {
        return 24;
    }
    else if (scrollView == minuteScrollView)
    {
        return 60;
    }
    return 60;
}

- (UIView *)pageAtIndex:(NSInteger)index andScrollView:(MXSCycleScrollView *)scrollView
{
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, scrollView.bounds.size.width, scrollView.bounds.size.height/5)];
    l.tag = index+1;
    if (scrollView == yearScrollView) {
        if (index < 10) {
            l.text = [NSString stringWithFormat:@"0%ld",(long)index];
        }
        else
            l.text = [NSString stringWithFormat:@"%ld",(long)index];
    }
    else if (scrollView == monthScrollView)
    {
        if (index < 10) {
            l.text = [NSString stringWithFormat:@"0%ld",(long)index];
        }
        else
            l.text = [NSString stringWithFormat:@"%ld",(long)index];
    }
    else if (scrollView == hourScrollView)
    {
        if (index < 10) {
            l.text = [NSString stringWithFormat:@"0%ld",(long)index];
        }
        else
            l.text = [NSString stringWithFormat:@"%ld",(long)index];
    }
    else if (scrollView == minuteScrollView)
    {
        if (index < 10) {
            l.text = [NSString stringWithFormat:@"0%ld",(long)index];
        }
        else
            l.text = [NSString stringWithFormat:@"%ld",(long)index];
    }
    
    l.font = [UIFont systemFontOfSize:12];
    l.textAlignment = NSTextAlignmentCenter;
    l.backgroundColor = [UIColor clearColor];
    return l;
}

-(NSString *) changeStartTime:(NSString *)startString{
    NSInteger start = [startString integerValue];
    NSString *string1;
    if (start < 2) {
        if (start == 1) {
            string1 = @"23";
        }else{
            string1 = @"22";
        }
    }else{
        start = start - 2;
        if (start < 10) {
            string1 = [NSString stringWithFormat:@"0%ld",(long)start];
        }else{
            string1 = [NSString stringWithFormat:@"%ld",(long)start];
        }
    }
    return string1;
}

-(NSString *) changeEndTime:(NSString *)endString{
    NSInteger end = [endString integerValue];
    NSString *string2;
    if (end < 2) {
        if (end == 1) {
            string2 = @"59";
        }else{
            string2 = @"58";
        }
    }else{
        end = end - 2;
        if (end < 10) {
            string2 = [NSString stringWithFormat:@"0%ld",(long)end];
        }else{
            string2 = [NSString stringWithFormat:@"%ld",(long)end];
        }
    }
    return string2;
}

-(void) TheSorting{
    NSString *tem;
    for (NSInteger i=0; i<saveBtnArray.count-1; i++) {
        for (NSInteger j=i+1; j<saveBtnArray.count; j++) {
            if ([saveBtnArray[i] integerValue] > [saveBtnArray[j] integerValue]) {
                tem = saveBtnArray[i];
                saveBtnArray[i]=saveBtnArray[j];
                saveBtnArray[j] = tem;
            }
        }
    }
}

- (void) TenAndTwo:(NSInteger) num index:(NSInteger ) i{
    
    NSLog(@"  发送分钟转换 %ld",(long)num);
    NSInteger jj = i;
    NSInteger j;
    if (num < 0) {
        j = ABS(num + 1);
    }else{
        j = num;
    }
    
    while (j) {
        tmp[i] = j%2;
        i++;
        j = j/2;
    }
    for ( ; i < jj+12; i++) {
        tmp[i] = 0;
    }
}

- (void) TwoAndTen{
    int ll = 0;
    int sum = 0;
    for (int m = 0; m<31; m++) {
        ll = tmp[m] * pow(2, m);
        sum += ll;
    }
    if (self.rowIndex >= 0) {
        RecordTime[self.rowIndex] = [NSString stringWithFormat:@"%d",sum];
    }else{
        RecordTime[currentDatabaseArray.count] = [NSString stringWithFormat:@"%d",sum];
    }
    
    NSLog(@" sum = %d",sum);
}

-(void) minAndTwo:(NSString *)week index:(NSInteger )i{
    NSInteger temp[7];
    for (NSInteger j = 0; j<week.length; j++) {
        temp[j] = [[week substringWithRange:NSMakeRange(j, 1)] integerValue];
    }
    
    for (NSInteger j=0; j<7; j++) {
        NSInteger m=0,num = 0;
        if (j == 0) {
            num = 7;
        }else{
            num = j;
        }
        for (; m < week.length; m++) {
            if (num == temp[m]) {
                tmp[i] = 1;
                break;
            }
        }
        if (m == week.length) {
            tmp[i] = 0;
        }
        i++;
    }
    tmp[31]= 0;
}

//设置现在时间
- (NSInteger)setNowTimeShow:(NSInteger)timeType
{
    NSMutableString *dateString;
    //NSArray *selectData = [[ProtectionAndRemoval shareDatabase] selectDataID:self.ID];
    if (allSaveData.count != 0) {
        PlanModel *model = allSaveData[0];
        NSArray *startT1 = [model.startTimer componentsSeparatedByString:@":"];
        NSArray *endT1 = [model.endTimer componentsSeparatedByString:@":"];
        dateString = [NSMutableString stringWithFormat:@"%@%@%@%@",[self changeStartTime:startT1[0]],[self changeEndTime:startT1[1]],[self changeStartTime:endT1[0]],[self changeEndTime:endT1[1]]];
        NSLog(@" dateString %@",dateString);
    }else{
        dateString = [NSMutableString stringWithString:@"22582258"];
    }
    
    switch (timeType) {
        case 0:
        {
            NSRange range = NSMakeRange(0, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 1:
        {
            NSRange range = NSMakeRange(2, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 2:
        {
            NSRange range = NSMakeRange(4, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 3:
        {
            NSRange range = NSMakeRange(6, 2);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        default:
            break;
    }
    return 0;
}
//选择设置的播报时间
- (void)selectSetBroadcastTime
{
    UILabel *yearLabel = [[(UILabel*)[[yearScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:0];
    UILabel *monthLabel = [[(UILabel*)[[monthScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:0];
    
    UILabel *hourLabel = [[(UILabel*)[[hourScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:0];
    UILabel *minuteLabel = [[(UILabel*)[[minuteScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:0];
    
    
    NSInteger yearInt = yearLabel.tag;
    NSInteger monthInt = monthLabel.tag;
    
    NSInteger hourInt = hourLabel.tag - 1;
    NSInteger minuteInt = minuteLabel.tag - 1;
    
    NSString *taskDateString = [NSString stringWithFormat:@"%ld:%02ld:%02ld:%02ld",(long)yearInt,(long)monthInt,(long)hourInt,(long)minuteInt];
    NSLog(@"Now----%@",taskDateString);
}
//滚动时上下标签显示(当前时间和是否为有效时间)
- (void)scrollviewDidChangeNumber
{
    UILabel *yearLabel = [[(UILabel*)[[yearScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *monthLabel = [[(UILabel*)[[monthScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    
    UILabel *hourLabel = [[(UILabel*)[[hourScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    UILabel *minuteLabel = [[(UILabel*)[[minuteScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
    
    
    NSInteger yearInt = yearLabel.tag-1;
    NSInteger monthInt = monthLabel.tag-1;
    
    NSInteger hourInt = hourLabel.tag - 1;
    NSInteger minuteInt = minuteLabel.tag - 1;
    
    startTimer.text = [NSString stringWithFormat:@"%@: %02ld:%02ld",NSLocalizedStringFromTable(@"Start", @STR_LOCALIZED_FILE_NAME, nil),(long)yearInt,(long)monthInt];
    if (hourInt == 0 && minuteInt == 0) {
        nowPickerShowTimeLabel.text = [NSString stringWithFormat:@"%@: 24:00",NSLocalizedStringFromTable(@"End", @STR_LOCALIZED_FILE_NAME, nil)];
    }else{
        nowPickerShowTimeLabel.text = [NSString stringWithFormat:@"%@: %02ld:%02ld",NSLocalizedStringFromTable(@"End", @STR_LOCALIZED_FILE_NAME, nil),(long)hourInt,(long)minuteInt];
    }
    
}

-(BOOL) saveMotionPushPlanData
{
    if (saveBtnArray.count < 1) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"PleaseSelectADate", @STR_LOCALIZED_FILE_NAME, nil)];
        return NO;
    }
    
    NSArray *endT = [nowPickerShowTimeLabel.text componentsSeparatedByString:@": "];
    NSArray *startT = [startTimer.text componentsSeparatedByString:@": "];
    
    PlanModel *par = [[PlanModel alloc] init];
    par.devicedID = self.str_DID;
    if ([endT[1] integerValue] != 0) {
        par.endTimer = endT[1];
    }else{
        par.endTimer = @"24:00";
    }
    
    par.startTimer = startT[1];
    NSMutableString *weeks = [[NSMutableString alloc] init];
    NSMutableString *weeksDetail = [[NSMutableString alloc] init];
    [self TheSorting];  //    排序
    for (NSInteger i=0; i<saveBtnArray.count; i++) {
        if (i == saveBtnArray.count - 1)
        {
            NSString *string = [NSString stringWithFormat:@"%@", saveBtnArray[i]];
            [weeks appendString:string];
            [weeksDetail appendString:string];
        }
        else
        {
            NSString *string = [NSString stringWithFormat:@"%@,", saveBtnArray[i]];
            [weeks appendString:string];
            NSString *string2 = [NSString stringWithFormat:@"%@", saveBtnArray[i]];
            [weeksDetail appendString:string2];
        }
        
    }
    
    par.week = [NSString stringWithString:weeks];
    NSLog(@" par.week = %@",par.week);
    
    NSArray *startT1 = [par.startTimer componentsSeparatedByString:@":"];
    NSArray *endT1 = [par.endTimer componentsSeparatedByString:@":"];
    NSInteger start = [startT1[0] integerValue] * 60 + [startT1[1] integerValue];
    NSInteger end = [endT1[0] integerValue] * 60 + [endT1[1] integerValue];
    RecordTime = [[NSMutableArray alloc] init];
    for (NSInteger i =0; i<22; i++) {
        RecordTime[i] = @"1";
    }
    
    memset(&tmp, 0, sizeof(tmp));
    [self TenAndTwo:start index:0];
    [self TenAndTwo:end index:12];
    [self minAndTwo:weeksDetail index:24];
    [self TwoAndTen];
    [[NSUserDefaults standardUserDefaults] setBool:1 forKey:@"setAlarmPAR"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    par.sum = [RecordTime[self.rowIndex] integerValue];
    NSLog(@"sum:%ld", (long)par.sum);
    if (self.isEdit == YES && self.rowIndex < [PlanManagement shareManagement].MotiondPushRecordPlanArray.count)
    {
        [PlanManagement shareManagement].MotiondPushRecordPlanArray[self.rowIndex] = par;
    }
    else
    {
        [[PlanManagement shareManagement].MotiondPushRecordPlanArray addObject:par];
    }
    
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
    NSString *cgiStr = [NSString stringWithFormat:@"trans_cmd_string.cgi?cmd=2017&command=2&mark=212&motion_push_plan1=%@&motion_push_plan2=%@&motion_push_plan3=%@&motion_push_plan4=%@&motion_push_plan5=%@&motion_push_plan6=%@&motion_push_plan7=%@&motion_push_plan8=%@&motion_push_plan9=%@&motion_push_plan10=%@&motion_push_plan11=%@&motion_push_plan12=%@&motion_push_plan13=%@&motion_push_plan14=%@&motion_push_plan15=%@&motion_push_plan16=%@&motion_push_plan17=%@&motion_push_plan18=%@&motion_push_plan19=%@&motion_push_plan20=%@&motion_push_plan21=%@&motion_push_plan_enable=1&", recordArry[0], recordArry[1], recordArry[2], recordArry[3], recordArry[4], recordArry[5], recordArry[6], recordArry[7], recordArry[8], recordArry[9], recordArry[10], recordArry[11], recordArry[12], recordArry[13], recordArry[14], recordArry[15], recordArry[16], recordArry[17], recordArry[18], recordArry[19], recordArry[20]];
    _m_PPPPChannelMgt->GetJsonCGI([self.str_DID UTF8String], 2017, (char *)[cgiStr UTF8String]);
    return YES;
}

-(BOOL)saveMotionRecordPlanData
{
    if (saveBtnArray.count < 1) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"PleaseSelectADate", @STR_LOCALIZED_FILE_NAME, nil)];
        return NO;
    }
    
    NSArray *endT = [nowPickerShowTimeLabel.text componentsSeparatedByString:@": "];
    NSArray *startT = [startTimer.text componentsSeparatedByString:@": "];
    
    PlanModel *par = [[PlanModel alloc] init];
    par.devicedID = self.str_DID;
    if ([endT[1] integerValue] != 0) {
        par.endTimer = endT[1];
    }else{
        par.endTimer = @"24:00";
    }
    
    par.startTimer = startT[1];
    NSMutableString *weeks = [[NSMutableString alloc] init];
    NSMutableString *weeksDetail = [[NSMutableString alloc] init];
    [self TheSorting];  //    排序
    for (NSInteger i=0; i<saveBtnArray.count; i++) {
        if (i == saveBtnArray.count - 1)
        {
            NSString *string = [NSString stringWithFormat:@"%@", saveBtnArray[i]];
            [weeks appendString:string];
            [weeksDetail appendString:string];
        }
        else
        {
            NSString *string = [NSString stringWithFormat:@"%@,", saveBtnArray[i]];
            [weeks appendString:string];
            NSString *string2 = [NSString stringWithFormat:@"%@", saveBtnArray[i]];
            [weeksDetail appendString:string2];
        }
        
    }
    
    
    par.week = [NSString stringWithString:weeks];
    NSLog(@" par.week = %@",par.week);
    
    NSArray *startT1 = [par.startTimer componentsSeparatedByString:@":"];
    NSArray *endT1 = [par.endTimer componentsSeparatedByString:@":"];
    NSInteger start = [startT1[0] integerValue] * 60 + [startT1[1] integerValue];
    NSInteger end = [endT1[0] integerValue] * 60 + [endT1[1] integerValue];
    RecordTime = [[NSMutableArray alloc] init];
    for (NSInteger i =0; i<22; i++) {
        RecordTime[i] = @"1";
    }
    
    memset(&tmp, 0, sizeof(tmp));
    [self TenAndTwo:start index:0];
    [self TenAndTwo:end index:12];
    [self minAndTwo:weeksDetail index:24];
    [self TwoAndTen];
    [[NSUserDefaults standardUserDefaults] setBool:1 forKey:@"setAlarmPAR"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    par.sum = [RecordTime[self.rowIndex] integerValue];
    NSLog(@"sum:%ld", (long)par.sum);
    if (self.isEdit == YES && self.rowIndex < [PlanManagement shareManagement].MotionRecordPlanArray.count)
    {
        [PlanManagement shareManagement].MotionRecordPlanArray[self.rowIndex] = par;
    }
    else
    {
        [[PlanManagement shareManagement].MotionRecordPlanArray addObject:par];
    }
    
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
    NSString *cgiStr = [NSString stringWithFormat:@"trans_cmd_string.cgi?cmd=2017&command=1&mark=212&motion_record_plan1=%@&motion_record_plan2=%@&motion_record_plan3=%@&motion_record_plan4=%@&motion_record_plan5=%@&motion_record_plan6=%@&motion_record_plan7=%@&motion_record_plan8=%@&motion_record_plan9=%@&motion_record_plan10=%@&motion_record_plan11=%@&motion_record_plan12=%@&motion_record_plan13=%@&motion_record_plan14=%@&motion_record_plan15=%@&motion_record_plan16=%@&motion_record_plan17=%@&motion_record_plan18=%@&motion_record_plan19=%@&motion_record_plan20=%@&motion_record_plan21=%@&motion_record_plan_enable=1&", recordArry[0], recordArry[1], recordArry[2], recordArry[3], recordArry[4], recordArry[5], recordArry[6], recordArry[7], recordArry[8], recordArry[9], recordArry[10], recordArry[11], recordArry[12], recordArry[13], recordArry[14], recordArry[15], recordArry[16], recordArry[17], recordArry[18], recordArry[19], recordArry[20]];
    _m_PPPPChannelMgt->GetJsonCGI([self.str_DID UTF8String], 2017, (char *)[cgiStr UTF8String]);
    return YES;
}

-(BOOL) saveData
{
    if (saveBtnArray.count < 1) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"PleaseSelectADate", @STR_LOCALIZED_FILE_NAME, nil)];
        return NO;
    }
    
    NSArray *endT = [nowPickerShowTimeLabel.text componentsSeparatedByString:@": "];
    NSArray *startT = [startTimer.text componentsSeparatedByString:@": "];
    
    PlanModel *par = [[PlanModel alloc] init];
    par.devicedID = self.str_DID;
    if ([endT[1] integerValue] != 0) {
        par.endTimer = endT[1];
    }else{
        par.endTimer = @"24:00";
    }
    
    par.startTimer = startT[1];
    NSMutableString *weeks = [[NSMutableString alloc] init];
    NSMutableString *weeksDetail = [[NSMutableString alloc] init];
    [self TheSorting];  //    排序
    for (NSInteger i=0; i<saveBtnArray.count; i++) {
        if (i == saveBtnArray.count - 1)
        {
            NSString *string = [NSString stringWithFormat:@"%@", saveBtnArray[i]];
            [weeks appendString:string];
            [weeksDetail appendString:string];
        }
        else
        {
            NSString *string = [NSString stringWithFormat:@"%@,", saveBtnArray[i]];
            [weeks appendString:string];
            NSString *string2 = [NSString stringWithFormat:@"%@", saveBtnArray[i]];
            [weeksDetail appendString:string2];
        }
        
    }
    
    par.week = [NSString stringWithString:weeks];
    NSLog(@" par.week = %@",par.week);
    
    NSArray *startT1 = [par.startTimer componentsSeparatedByString:@":"];
    NSArray *endT1 = [par.endTimer componentsSeparatedByString:@":"];
    NSInteger start = [startT1[0] integerValue] * 60 + [startT1[1] integerValue];
    NSInteger end = [endT1[0] integerValue] * 60 + [endT1[1] integerValue];
    RecordTime = [[NSMutableArray alloc] init];
    for (NSInteger i =0; i<22; i++) {
        RecordTime[i] = @"1";
    }
    
    memset(&tmp, 0, sizeof(tmp));
    [self TenAndTwo:start index:0];
    [self TenAndTwo:end index:12];
    [self minAndTwo:weeksDetail index:24];
    [self TwoAndTen];
    [[NSUserDefaults standardUserDefaults] setBool:1 forKey:@"setAlarmPAR"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    par.sum = [RecordTime[self.rowIndex] integerValue];
    NSLog(@"sum:%ld", (long)par.sum);
    if (self.isEdit == YES && self.rowIndex < [PlanManagement shareManagement].RecordPlanArray.count)
    {
        [PlanManagement shareManagement].RecordPlanArray[self.rowIndex] = par;
    }
    else
    {
        [[PlanManagement shareManagement].RecordPlanArray addObject:par];
    }
    
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
    NSString *cgiStr = [NSString stringWithFormat:@"trans_cmd_string.cgi?cmd=2017&command=3&mark=212&record_plan1=%@&record_plan2=%@&record_plan3=%@&record_plan4=%@&record_plan5=%@&record_plan6=%@&record_plan7=%@&record_plan8=%@&record_plan9=%@&record_plan10=%@&record_plan11=%@&record_plan12=%@&record_plan13=%@&record_plan14=%@&record_plan15=%@&record_plan16=%@&record_plan17=%@&record_plan18=%@&record_plan19=%@&record_plan20=%@&record_plan21=%@&record_plan_enable=1&", recordArry[0], recordArry[1], recordArry[2], recordArry[3], recordArry[4], recordArry[5], recordArry[6], recordArry[7], recordArry[8], recordArry[9], recordArry[10], recordArry[11], recordArry[12], recordArry[13], recordArry[14], recordArry[15], recordArry[16], recordArry[17], recordArry[18], recordArry[19], recordArry[20]];
    _m_PPPPChannelMgt->GetJsonCGI([self.str_DID UTF8String], 2017, (char *)[cgiStr UTF8String]);
    return YES;
    
}

-(BOOL) saveAlarmPlanData
{
    if (saveBtnArray.count < 1) {
        [mytoast showWithText:NSLocalizedStringFromTable(@"PleaseSelectADate", @STR_LOCALIZED_FILE_NAME, nil)];
        return NO;
    }
    
    NSArray *endT = [nowPickerShowTimeLabel.text componentsSeparatedByString:@": "];
    NSArray *startT = [startTimer.text componentsSeparatedByString:@": "];
    
    PlanModel *par = [[PlanModel alloc] init];
    par.devicedID = self.str_DID;
    if ([endT[1] integerValue] != 0) {
        par.endTimer = endT[1];
    }else{
        par.endTimer = @"24:00";
    }
    
    par.startTimer = startT[1];
    NSMutableString *weeks = [[NSMutableString alloc] init];
    NSMutableString *weeksDetail = [[NSMutableString alloc] init];
    [self TheSorting];  //    排序
    for (NSInteger i=0; i<saveBtnArray.count; i++) {
        if (i == saveBtnArray.count - 1)
        {
            NSString *string = [NSString stringWithFormat:@"%@", saveBtnArray[i]];
            [weeks appendString:string];
            [weeksDetail appendString:string];
        }
        else
        {
            NSString *string = [NSString stringWithFormat:@"%@,", saveBtnArray[i]];
            [weeks appendString:string];
            NSString *string2 = [NSString stringWithFormat:@"%@", saveBtnArray[i]];
            [weeksDetail appendString:string2];
        }
        
    }
    
    par.week = [NSString stringWithString:weeks];
    NSLog(@" par.week = %@",par.week);
    
    NSArray *startT1 = [par.startTimer componentsSeparatedByString:@":"];
    NSArray *endT1 = [par.endTimer componentsSeparatedByString:@":"];
    NSInteger start = [startT1[0] integerValue] * 60 + [startT1[1] integerValue];
    NSInteger end = [endT1[0] integerValue] * 60 + [endT1[1] integerValue];
    RecordTime = [[NSMutableArray alloc] init];
    for (NSInteger i =0; i<22; i++) {
        RecordTime[i] = @"1";
    }
    
    memset(&tmp, 0, sizeof(tmp));
    [self TenAndTwo:start index:0];
    [self TenAndTwo:end index:12];
    [self minAndTwo:weeksDetail index:24];
    [self TwoAndTen];
    [[NSUserDefaults standardUserDefaults] setBool:1 forKey:@"setAlarmPAR"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    par.sum = [RecordTime[self.rowIndex] integerValue];
    NSLog(@"sum:%ld", (long)par.sum);
    if (self.isEdit == YES && self.rowIndex < [PlanManagement shareManagement].AlarmPlanArray.count)
    {
        [PlanManagement shareManagement].AlarmPlanArray[self.rowIndex] = par;
    }
    else
    {
        [[PlanManagement shareManagement].AlarmPlanArray addObject:par];
    }
    
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
            NSString *sum = @"-1";
            [recordArry addObject:sum];
        }
    }
    NSString *cgiStr = [NSString stringWithFormat:@"set_alarm.cgi?schedule_enable=1&schedule_sun_0=0&schedule_sun_1=0&schedule_sun_2=0&schedule_mon_0=0&schedule_mon_1=0&schedule_mon_2=0&schedule_tue_0=0&schedule_tue_1=0&schedule_tue_2=0&schedule_wed_0=0&schedule_wed_1=0&schedule_wed_2=0&schedule_thu_0=0&schedule_thu_1=0&schedule_thu_2=0&schedule_fri_0=0&schedule_fri_1=0&schedule_fri_2=0&schedule_sat_0=0&schedule_sat_1=0&schedule_sat_2=0&defense_plan1=%@&defense_plan2=%@&defense_plan3=%@&defense_plan4=%@&defense_plan5=%@&defense_plan6=%@&defense_plan7=%@&defense_plan8=%@&defense_plan9=%@&defense_plan10=%@&defense_plan11=%@&defense_plan12=%@&defense_plan13=%@&defense_plan14=%@&defense_plan15=%@&defense_plan16=%@&defense_plan17=%@&defense_plan18=%@&defense_plan19=%@&defense_plan20=%@&defense_plan21=%@&", recordArry[0], recordArry[1], recordArry[2], recordArry[3], recordArry[4], recordArry[5], recordArry[6], recordArry[7], recordArry[8], recordArry[9], recordArry[10], recordArry[11], recordArry[12], recordArry[13], recordArry[14], recordArry[15], recordArry[16], recordArry[17], recordArry[18], recordArry[19], recordArry[20]];
    _m_PPPPChannelMgt->GetJsonCGI([self.str_DID UTF8String], 2017, (char *)[cgiStr UTF8String]);
    
    return YES;
}

@end
