//
//  PlacePickerView.m
//  在定义日期地点键盘
//
//  Created by Yang on 2017/7/12.
//  Copyright © 2017年 Yang. All rights reserved.
//

#import "PlacePickerView.h"

@interface PlacePickerView()<UIPickerViewDelegate, UIPickerViewDataSource>
//选择器
@property (nonatomic, strong)UIPickerView *pickerView;
//顶部视图
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)UIButton *btnCancel;
@property (nonatomic, strong)UIButton *btnOK;
//背景视图
@property (strong, nonatomic) UIView *backgroundView;
//省市县字典
@property (nonatomic, retain)NSDictionary *provincesIndexDict;
//省份  市   县
@property (nonatomic, retain)NSMutableArray<NSString *> *provinces;
@property (nonatomic, retain)NSMutableDictionary<NSString *, NSArray *> *citysForProvince;
@property (nonatomic, retain)NSMutableDictionary<NSString *, NSArray *> *districtsForCity;

@property (nonatomic, retain)NSString *selectedProvince;
@property (nonatomic, retain)NSString *selectedCity;
@property (nonatomic, retain)NSString *selectedDistrict;

@end

@implementation PlacePickerView
//初始化
- (instancetype)initWithDelegate:(id)delegate
{
    if ([super init])
    {
        _delegate = delegate;
        [self setupDataSource];
        [self setupUI];
    }
    return self;
}

#pragma mark - method

- (void)setupUI
{
    //默认不显示
    _isHidden = YES;
    _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    _backgroundView.layer.masksToBounds = YES;
    
    self.frame = CGRectMake(0, _backgroundView.frame.size.height, _backgroundView.frame.size.width, 302);
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_backgroundView addSubview:self];
    
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _backgroundView.frame.size.width, 44)];
    [self addSubview:_topView];
    _topView.backgroundColor = [UIColor whiteColor];
    
    UILabel * placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 11, Sc_w - 100, 21)];
    placeLabel.textAlignment = NSTextAlignmentCenter;
    placeLabel.text = @"请选择地点";
    placeLabel.font = [UIFont systemFontOfSize:16];
    [_topView addSubview:placeLabel];
    
    _btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, _topView.frame.size.height)];
    [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    _btnCancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [_btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnCancel addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_btnCancel];
    
    _btnOK = [[UIButton alloc]initWithFrame:CGRectMake(_topView.frame.size.width - 60, 0, 60, _topView.frame.size.height)];
    [_btnOK setTitle:@"确定" forState:UIControlStateNormal];
    _btnOK.titleLabel.font = [UIFont systemFontOfSize:15];
    [_btnOK setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnOK addTarget:self action:@selector(clickOK) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_btnOK];
    
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_topView.frame) + 1,self.frame.size.width,self.frame.size.height - (CGRectGetMaxY(_topView.frame) + 1))];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self addSubview:_pickerView];
}

- (void)setupDataSource
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    _provincesIndexDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    int provinceIndex = 0;
    NSDictionary *dict1 = [_provincesIndexDict objectForKey:[NSString stringWithFormat:@"%d", provinceIndex]];
    while (dict1 != nil)
    {
        provinceIndex++;
        
        for (NSString *provinceName in dict1)
        {
            [self.provinces addObject:provinceName];
            
            NSDictionary *citysIndexDict = [dict1 objectForKey:provinceName];
            int cityIndex = 0;
            
            NSDictionary *dict2 = [citysIndexDict objectForKey:[NSString stringWithFormat:@"%d", cityIndex]];
            NSMutableArray *citys = [NSMutableArray arrayWithCapacity:dict2.count];
            
            while (dict2 != nil)
            {
                cityIndex++;
                
                for (NSString *cityName in dict2)
                {
                    [citys addObject:cityName];
                    
                    NSArray *districts = [dict2 objectForKey:cityName];
                    
                    [self.districtsForCity setObject:districts forKey:cityName];
                }
                dict2 = [citysIndexDict objectForKey:[NSString stringWithFormat:@"%d", cityIndex]];
            }
            
            [self.citysForProvince setObject:citys forKey:provinceName];
        }
        dict1 = [_provincesIndexDict objectForKey:[NSString stringWithFormat:@"%d", provinceIndex]];
    }
    
    self.selectedProvince = [self.provinces objectAtIndex:0];
    
    NSArray *citys = [self.citysForProvince objectForKey:self.selectedProvince];
    self.selectedCity = [citys objectAtIndex:0];
    
    NSArray *districts = [self.districtsForCity objectForKey:self.selectedCity];
    self.selectedDistrict = [districts objectAtIndex:0];
}

- (NSMutableArray *)provinces
{
    if (_provinces == nil)
    {
        _provinces = [NSMutableArray arrayWithCapacity:30];
    }
    return _provinces;
}

- (NSMutableDictionary *)citysForProvince
{
    if (_citysForProvince == nil)
    {
        _citysForProvince = [NSMutableDictionary dictionaryWithCapacity:30];
    }
    return _citysForProvince;
}

- (NSMutableDictionary *)districtsForCity
{
    if (_districtsForCity == nil)
    {
        _districtsForCity = [NSMutableDictionary dictionaryWithCapacity:30];
    }
    return _districtsForCity;
}

#pragma mark - public method

- (void)setIsHidden:(BOOL)isHidden
{
    if (_isHidden != isHidden)
    {
        _isHidden = isHidden;
        
        if (!_isHidden)
        {
            [[UIApplication sharedApplication].keyWindow addSubview:self.backgroundView];
            
            [UIView animateWithDuration:0.2 animations:^{
                
                self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 302, [UIScreen mainScreen].bounds.size.width, 302);
                
                _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.2 animations:^{
                
                self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 302);
                
                _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
                
            } completion:^(BOOL finished) {
                
                [self.backgroundView removeFromSuperview];
            }];
        }
    }
}

#pragma mark - click

- (void)clickCancel
{
    self.isHidden = YES;
}

- (void)clickOK
{
    self.isHidden = YES;
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(areaPickerView:didSelectArea:)])
    {
        [self.delegate areaPickerView:self didSelectArea:[NSString stringWithFormat:@"%@-%@-%@", self.selectedProvince, self.selectedCity, self.selectedDistrict]];
    }
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.provinces.count;
    }
    else if (component == 1)
    {
        NSArray *citys = [self.citysForProvince objectForKey:self.selectedProvince];
        return citys.count;
    }
    else if (component == 2)
    {
        NSArray *districts = [self.districtsForCity objectForKey:self.selectedCity];
        return districts.count;
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [self.provinces objectAtIndex:row];
    }
    else if (component == 1)
    {
        NSArray *citys = [self.citysForProvince objectForKey:self.selectedProvince];
        return [citys objectAtIndex:row];
    }
    else if (component == 2)
    {
        NSArray *districts = [self.districtsForCity objectForKey:self.selectedCity];
        return [districts objectAtIndex:row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        self.selectedProvince = [self.provinces objectAtIndex:row];
        
        NSArray *citys = [self.citysForProvince objectForKey:self.selectedProvince];
        self.selectedCity = [citys objectAtIndex:0];
        
        NSArray *districts = [self.districtsForCity objectForKey:self.selectedCity];
        self.selectedDistrict = [districts objectAtIndex:0];
        
        [self.pickerView reloadComponent:1];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        [self.pickerView reloadComponent:2];
        [self.pickerView selectRow:0 inComponent:2 animated:YES];
    }
    else if (component == 1)
    {
        NSArray *citys = [self.citysForProvince objectForKey:self.selectedProvince];
        self.selectedCity = [citys objectAtIndex:row];
        
        NSArray *districts = [self.districtsForCity objectForKey:self.selectedCity];
        self.selectedDistrict = [districts objectAtIndex:0];
        
        [self.pickerView reloadComponent:2];
        [self.pickerView selectRow:0 inComponent:2 animated:YES];
    }
    else if (component == 2)
    {
        NSArray *districts = [self.districtsForCity objectForKey:self.selectedCity];
        self.selectedDistrict = [districts objectAtIndex:row];
    }
}

@end
