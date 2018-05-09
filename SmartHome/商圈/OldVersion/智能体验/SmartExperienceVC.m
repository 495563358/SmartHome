//
//  SmartExperienceVC.m
//  SmartMall
//
//  Created by Smart house on 2017/11/3.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "SmartExperienceVC.h"
#import <CoreLocation/CoreLocation.h>
#import "BusinessCell.h"

#import "BusinessSearchVC.h"
#import "MerchantViewController.h"

#import "PlacePickerView.h"

#import "MJRefresh.h"

#import "ObjectTools.h"
#import "UIView+Toast.h"

//#define Subpath @"r=merch.applist.cate&pid=104"

@interface SmartExperienceVC ()<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,AYPlaceViewDelegate>{
    NSMutableArray *sortBtns;
    UIView *viewOne;
    UIView *viewtwo;
    UIView *viewThree;
    
    UIPickerView *typePicker;
    UIPickerView *levelPicker;
    UIPickerView *attendPicker;
    
    NSString *cityNamesort;
    NSInteger typeNamesort;
    NSInteger levelNamesort;
    NSInteger attendNamesort;
    
    UIButton *okBtn;
    UIButton *cancelBtn;
    
    NSInteger currentPage;
}

@property (nonatomic,strong)UIButton *locationBtn;


@property(nonatomic,strong)CLLocationManager *manager;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UIView *backView;



@property(nonatomic,strong)PlacePickerView *areaPicker;

@property(nonatomic,strong)UITableView *tableview;

@property(nonatomic,strong)NSMutableArray *mdata;
@property(nonatomic,strong)NSMutableArray *typeData;
@property(nonatomic,strong)NSMutableArray *levelData;
@property(nonatomic,strong)NSMutableArray *waysData;


@property(nonatomic,strong)NSMutableDictionary *currentSelect;

@end

@implementation SmartExperienceVC

-(NSMutableArray *)mdata{
    if (!_mdata) {
        _mdata = [NSMutableArray array];
    }return _mdata;
}

-(CLLocationManager *)manager{
    if (!_manager) {
        _manager = [[CLLocationManager alloc]init];
        [_manager requestWhenInUseAuthorization];
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        _manager.distanceFilter = 10;
        _manager.delegate = self;
    }return _manager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _titlename;
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    self.view.backgroundColor = My_gray;
    
    [self createViewone];
    [self createViewtwo];
    [self createViewthree];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 236)];
    headerView.backgroundColor = My_gray;
    [headerView addSubview:viewOne];
    [headerView addSubview:viewtwo];
    [headerView addSubview:viewThree];
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, Sc_h - 64) style:UITableViewStylePlain];
    [self.view addSubview:_tableview];
    _tableview.tableHeaderView = headerView;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    [self downLoadResource];
    
    self.areaPicker = [[PlacePickerView alloc]initWithDelegate:self];
    currentPage = 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mdata.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 94;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = _mdata[indexPath.row];
    NSString *poolname = dict[@"id"];
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:poolname];
    if (!cell) {
        cell = [[BusinessCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:poolname];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            UIImage *headImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"logo"]]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.headImage.image = headImage;
            });
        });
        cell.titleLabel.text = dict[@"merchname"];
        cell.mainworkLabel.text = [NSString stringWithFormat:@"主营:%@",dict[@"catename"]];
        cell.attendWays.text = [NSString stringWithFormat:@"体验方式:%@",dict[@"tastename"]];
        cell.alongTime.text = [NSString stringWithFormat:@"级别:%@",dict[@"levelname"]];
        cell.shopArea.text = [NSString stringWithFormat:@"区域:%@",dict[@"city"]];
        cell.distance.text = [NSString stringWithFormat:@"%@km",dict[@"distance"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:@"r=business.appindex"] parameters:@{@"merchid":_mdata[indexPath.row][@"id"]} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        MerchantViewController *vc = [MerchantViewController new];
        vc.infoDict = [[(NSDictionary *)responseObject objectForKey:@"result"] objectForKey:@"list"];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

-(void)createViewone{
    //定位
    self.locationBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 6, 150 * Percentage, 29)];
    _locationBtn.backgroundColor = color(217, 217, 217, 0.2);
    _locationBtn.layer.cornerRadius = 10.0;
    [_locationBtn setImage:[UIImage imageNamed:@"dinweiblue"] forState:UIControlStateNormal];
    [_locationBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    _locationBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_locationBtn setTitleColor:color(14, 173, 254, 1) forState:UIControlStateNormal];
    [_locationBtn setTitle:@"定位" forState:UIControlStateNormal];
    [_locationBtn addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 10 - 200 * Percentage, 6, 200 * Percentage,29)];
    searchBtn.backgroundColor = color(0, 0, 0, 0.1);
    searchBtn.layer.cornerRadius = 10.0;
    [searchBtn setImage:[UIImage imageNamed:@"sousuo"] forState:UIControlStateNormal];
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [searchBtn setTitle:@"体验馆" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    
    viewOne = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 41)];
    viewOne.backgroundColor = [UIColor whiteColor];
    [viewOne addSubview:searchBtn];
    [viewOne addSubview:_locationBtn];
    
}

-(void)searchClick{
    BusinessSearchVC *vc = [BusinessSearchVC new];
    self.hidesBottomBarWhenPushed = YES;
    
    vc.userLocation = _userLocation;
    
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

-(void)createViewtwo{
    viewtwo = [[UIView alloc]initWithFrame:CGRectMake(0, 42, Sc_w, 105)];
    viewtwo.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 105)];
    imageV.image = [UIImage imageNamed:@"入驻"];
    [viewtwo addSubview:imageV];
    
}


-(void)createViewthree{
    viewThree = [[UIView alloc]initWithFrame:CGRectMake(0, 152, Sc_w, 84)];
    viewThree.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, Sc_w - 100, 39)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"———— 优选商户 ————";
    [viewThree addSubview:label];
    
    UIView *backline = [[UIView alloc]initWithFrame:CGRectMake(0, 39, Sc_w, 1)];
    backline.backgroundColor = My_gray;
    [viewThree addSubview:backline];
    
    NSArray *btnsName = [NSArray array];
    if ([_titlename isEqualToString:@"体验馆"]) {
        btnsName = @[@"城市",@"分类",@"授权级别"];
    }else{
        btnsName = @[@"城市",@"分类",@"体验方式"];
    }
    
    
    
    sortBtns = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(i * Sc_w/3, 40, Sc_w/3, 45)];
        btn1.tag = i;
        btn1.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn1 setTitle:btnsName[i] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn1 setTitleColor:Color_system forState:UIControlStateSelected];
        [btn1 setImage:[UIImage imageNamed:@"sort_default"] forState:UIControlStateNormal];
        [btn1 setImage:[UIImage imageNamed:@"shouqi"] forState:UIControlStateSelected];
        [btn1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
        btn1.imageEdgeInsets = UIEdgeInsetsMake(0, 110 * Percentage, 0, 0);
        btn1.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [sortBtns addObject:btn1];
        [viewThree addSubview:btn1];
    }
}

//筛选
-(void)btn1Click:(UIButton *)sender{
    
    if (self.typeData.count == 0) {
        return;
    }
    
    sender.selected = YES;
    //    for (UIButton *btn in sortBtns) {
    //        if (btn.tag != sender.tag) {
    //            btn.selected = NO;
    //        }
    //    }
    NSLog(@"title = %@",sender.currentTitle);
    
    self.backView.hidden = NO;
    
    if (!okBtn) {
        okBtn = [[UIButton alloc]initWithFrame:CGRectMake((Sc_w - 300)/2+250, (Sc_h - 110-200)/2+160, 40, 30)];
        [okBtn setTitle:@"确认" forState:UIControlStateNormal];
        [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [okBtn addTarget:self action:@selector(levelClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake((Sc_w - 300)/2 + 10, (Sc_h - 110-200)/2+160, 40, 30)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(levelClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:okBtn];
        [self.view addSubview:cancelBtn];
        
        okBtn.hidden = YES;
        cancelBtn.hidden = YES;
    }
    
    switch (sender.tag) {
        case 0:
            _backView.hidden = YES;
            [self sortByCity];
            return;
        case 1:
            [self sortByType];
            break;
        case 2:
            if ([_titlename isEqualToString:@"体验馆"])
                [self sortByLevel];
            else
                [self sortByWays];
            break;
        default:
            break;
    }
}

-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:Sc_bounds];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.5;
        [self.view addSubview:_backView];
    }return _backView;
}

//城市
-(void)sortByCity{
    _areaPicker.isHidden = NO;
}

- (void)areaPickerView:(PlacePickerView *)areaPickerView didSelectArea:(NSString *)area
{
    NSArray *arr = [area componentsSeparatedByString:@"-"];
    cityNamesort = arr[1];
    NSLog(@"%@",cityNamesort);
    
    [self reloadDatas:@{@"city":arr[1]}];
    
    [(UIButton *)sortBtns[0] setTitle:arr[1] forState:UIControlStateNormal];
    
}

//分类
-(void)sortByType{
    typePicker = [[UIPickerView alloc]initWithFrame:CGRectMake((Sc_w - 300)/2, (Sc_h - 110-200)/2, 300, 200)];
    typePicker.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:typePicker];
    typePicker.delegate = self;
    typePicker.dataSource = self;
    typePicker.tag = 2;
    
    okBtn.tag = 2;
    cancelBtn.tag = 2;
    
    okBtn.hidden = NO;
    cancelBtn.hidden = NO;
    
    [self.view bringSubviewToFront:okBtn];
    [self.view bringSubviewToFront:cancelBtn];
}

//授权级别
-(void)sortByLevel{
    
    levelPicker = [[UIPickerView alloc]initWithFrame:CGRectMake((Sc_w - 300)/2, (Sc_h - 110-200)/2, 300, 200)];
    levelPicker.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:levelPicker];
    levelPicker.delegate = self;
    levelPicker.dataSource = self;
    levelPicker.tag = 3;
    
    okBtn.tag = 3;
    cancelBtn.tag = 3;
    
    okBtn.hidden = NO;
    cancelBtn.hidden = NO;
    
    [self.view bringSubviewToFront:okBtn];
    [self.view bringSubviewToFront:cancelBtn];
}

//体验方式
-(void)sortByWays{
    
    attendPicker = [[UIPickerView alloc]initWithFrame:CGRectMake((Sc_w - 300)/2, (Sc_h - 110-200)/2, 300, 200)];
    attendPicker.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:attendPicker];
    attendPicker.delegate = self;
    attendPicker.dataSource = self;
    attendPicker.tag = 4;
    
    okBtn.tag = 4;
    cancelBtn.tag = 4;
    
    okBtn.hidden = NO;
    cancelBtn.hidden = NO;
    
    [self.view bringSubviewToFront:okBtn];
    [self.view bringSubviewToFront:cancelBtn];
}

//取消 确认按钮
-(void)levelClick:(UIButton *)sender{
    
    okBtn.hidden = YES;
    cancelBtn.hidden = YES;
    _backView.hidden = YES;
    //确定
    if ([sender.currentTitle isEqualToString:@"确认"]) {
        if (sender.tag == 2) {
            NSLog(@"%@",_typeData[typeNamesort]);
            NSDictionary *dict1 = @{@"cateid":_typeData[typeNamesort][@"id"]};
            [self reloadDatas:dict1];
            
            UIButton *temp = sortBtns[sender.tag - 1];
            [temp setTitle:_typeData[typeNamesort][@"catename"] forState:UIControlStateNormal];
        }
        else if(sender.tag == 3){
            
            if ([_titlename isEqualToString:@"体验馆"]){
                NSLog(@"%@",_levelData[levelNamesort]);
                NSDictionary *dict2 = @{@"levelid":_levelData[levelNamesort][@"id"]};
                [self reloadDatas:dict2];
                
                UIButton *temp = sortBtns[sender.tag - 1];
                [temp setTitle:_levelData[levelNamesort][@"levelname"] forState:UIControlStateNormal];
                
            }else{
                NSLog(@"%@",_waysData[attendNamesort]);
                NSDictionary *dict3 = @{@"tasteid":_waysData[attendNamesort][@"id"]};
                [self reloadDatas:dict3];
                
                UIButton *temp = sortBtns[sender.tag - 1];
                [temp setTitle:_waysData[attendNamesort][@"catename"] forState:UIControlStateNormal];
            }
        }
    }
    //取消
    switch (sender.tag) {
        case 2:
            [typePicker removeFromSuperview];
            typePicker = nil;
            break;
        case 3:
            if ([_titlename isEqualToString:@"体验馆"]){
                [levelPicker removeFromSuperview];
                levelPicker = nil;
                break;
            }else{
                [attendPicker removeFromSuperview];
                attendPicker = nil;
                break;
            }
        default:
            break;
    }
}

-(void)downLoadResource{
    NSString *path = [ResourceFront stringByAppendingString:_subpath];
    [[ObjectTools sharedManager] POST:path parameters:_userLocation progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *backresult = (NSDictionary *)responseObject;
        NSLog(@"%@",backresult);
        [self.mdata addObjectsFromArray:(NSArray *)backresult[@"result"][@"list"]];
        
        if (self.mdata.count == 0) {
            [self.view makeToast:@"所选分类当前还没有数据"];
        }
        
        _typeData = [NSMutableArray array];
        [_typeData addObjectsFromArray:backresult[@"result"][@"cate_list"]];
        
        _levelData = [NSMutableArray array];
        if (_levelData) {
            [_levelData addObjectsFromArray:backresult[@"result"][@"level_list"]];
        }
        _waysData = [NSMutableArray array];
        if (_waysData) {
            [_waysData addObjectsFromArray:backresult[@"result"][@"taste_list"]];
        }
        if(self.mdata.count%10 == 0){
            __block SmartExperienceVC *weakSelf = self;
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter new];
            [footer setRefreshingTarget:weakSelf refreshingAction:@selector(addReloadDatas)];
            self.tableview.mj_footer = footer;
        }
        
        [_tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)reloadDatas:(NSDictionary *)dict{
    currentPage = 1;
    if (self.currentSelect) {
        for (NSString *key in dict.allKeys) {
            [_currentSelect setObject:dict[key] forKey:key];
        }
        [_currentSelect setObject:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    }else
        self.currentSelect = [[NSMutableDictionary alloc]initWithDictionary:dict];
    
    NSLog(@"筛选数据 = %@",_currentSelect);
    
    NSString *path = [ResourceFront stringByAppendingString:_subpath];
    
    [[ObjectTools sharedManager] POST:path parameters:_currentSelect progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *backresult = (NSDictionary *)responseObject;
        [self.mdata removeAllObjects];
        [self.mdata addObjectsFromArray:(NSArray *)backresult[@"result"][@"list"]];
        
        
        if (_mdata.count % 10 != 0 || _mdata.count == 0) {
            [_tableview.mj_footer removeFromSuperview];
        }
        
        [_tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)addReloadDatas{
    
    if (self.currentSelect.allKeys.count == 0) {
        //        return;
        NSLog(@"未筛选刷新");
        _currentSelect = [NSMutableDictionary dictionary];
        
    }
    currentPage ++;
    NSString *path = [ResourceFront stringByAppendingString:_subpath];
    [_currentSelect setObject:[NSString stringWithFormat:@"%ld",currentPage] forKey:@"page"];
    
    
    [[ObjectTools sharedManager] POST:path parameters:_currentSelect progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *backresult = (NSDictionary *)responseObject;
        [self.mdata addObjectsFromArray:(NSArray *)backresult[@"result"][@"list"]];
        [_tableview.mj_footer endRefreshing];
        if (_mdata.count % 10 != 0) {
            [_tableview.mj_footer removeFromSuperview];
        }
        [_tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    switch (pickerView.tag) {
        case 2:
            return _typeData.count;
        case 3:
            if ([_titlename isEqualToString:@"体验馆"])
                return _levelData.count;
            else
                return _waysData.count;
        default:
            break;
    }
    return 0;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component __TVOS_PROHIBITED{
    return 150;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED{
    return 50;
}


- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED{
    switch (pickerView.tag) {
        case 2:
            return _typeData[row][@"catename"];
        case 3:
            if ([_titlename isEqualToString:@"体验馆"])
                return _levelData[row][@"levelname"];
            else
                return _waysData[row][@"catename"];
        default:
            break;
    }
    return @"暂无数据";
}

//代理选择事件
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED{
    
    switch (pickerView.tag) {
        case 2:
            typeNamesort = row;
        case 3:
            if ([_titlename isEqualToString:@"体验馆"])
                levelNamesort = row;
            else
                attendNamesort = row;
        default:
            break;
    }
}


- (void)locationClick{
    [_locationBtn setTitle:@"定位中..." forState:UIControlStateNormal];
    [self.manager requestWhenInUseAuthorization];
    if ([CLLocationManager locationServicesEnabled]) {
        [self.manager startUpdatingLocation];
        NSLog(@"开始定位");
    }else{
        NSLog(@"没有权限");
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [CLGeocoder new];
    
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = placemarks[0];
            [_locationBtn setTitle:placemark.locality forState:UIControlStateNormal];
        }
    }];
    [self.manager stopUpdatingLocation];
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
