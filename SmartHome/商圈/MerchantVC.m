//
//  MerchantVC.m
//  SmartHome
//
//  Created by Smart house on 2018/4/23.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import "MerchantVC.h"
#import "MerchIntroduceVC.h"
#import "MapViewController.h"

//View
#import "NewMerchCell.h"

//vender
#import "MyOrderTopTabBar.h"
#import <CoreLocation/CoreLocation.h>
#import "JZLocationConverter.h"
#import "PlacePickerView.h"

@interface MerchantVC ()<MyOrderTopTabBarDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UISearchBarDelegate,AYPlaceViewDelegate>{
    UIView *_homePageView;
    UIView *_commonHeaderView;
}

@property(nonatomic,strong)CLLocationManager *manager;
@property (nonatomic,strong)UIButton *locationBtn;
@property (nonatomic,strong)MyOrderTopTabBar *topTabbar;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *mdata;

@property(nonatomic,strong)NSMutableDictionary *currentSelect;

@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)NSMutableArray<UIButton *> *filterBtns;

@property(nonatomic,strong)PlacePickerView *areaPicker;//选择城市

@end

#define GetNearbyInfo @"r=merch.applist.nearby"

@implementation MerchantVC

-(CLLocationManager *)manager{
    if (!_manager) {
        _manager = [[CLLocationManager alloc]init];
        [_manager requestWhenInUseAuthorization];
        _manager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _manager.distanceFilter = 10;
        _manager.delegate = self;
    }return _manager;
}

-(NSMutableArray *)mdata{
    if (!_mdata) {
        _mdata = [NSMutableArray array];
    }return _mdata;
}

-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 10 + 156*Percentage + 84)];
        [_headerView addSubview:_commonHeaderView];
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = My_gray;
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 114, Sc_w, Sc_h - 114 - 49) style:UITableViewStylePlain];
    //开始定位 根据定位获取公司数据
    [self startLocation];
    
    [self createNavigationView];
    
    [self createHeaderView];
    
    [self createFilterView];
    
    [self getMytableHeaderView:NO];
    
    _tableview.tableHeaderView = _headerView;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.view addSubview:_tableview];
    
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
    [header setRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.tableview.mj_header = header;
    
    self.areaPicker = [[PlacePickerView alloc]initWithDelegate:self];
}

-(void)headerRefresh{
    [self startLocation];
    [self.tableview.mj_header endRefreshing];
    NSArray *btnsName = @[@"综合",@"城市",@"最近",@"筛选"];
    
    for (UIButton *btn1 in self.filterBtns) {
        btn1.selected = NO;
        [btn1 setTitle:btnsName[btn1.tag] forState:UIControlStateNormal];
    }
}

//导航栏 - 定位 搜索 商户管理
- (void)createNavigationView{
    //定位
    self.locationBtn = [[UIButton alloc]initWithFrame:CGRectMake(-10, 2, Sc_w/5, 40)];
    _locationBtn.layer.cornerRadius = 5;
    _locationBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    [_locationBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [_locationBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 1, 0, 0)];
    [_locationBtn setImage:[UIImage imageNamed:@"merch_dinwei"] forState:UIControlStateNormal];
    _locationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_locationBtn setTitle:@"定位" forState:UIControlStateNormal];
    [_locationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_locationBtn addTarget:self action:@selector(lookupCurrentMaps) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_locationBtn];
    
    //搜索框
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Sc_w/2, 32)];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:titleView.bounds];
    searchBar.placeholder = @"智能家居";
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.barTintColor = My_gray;
    searchBar.delegate = self;
    [titleView addSubview:searchBar];
    self.navigationItem.titleView = titleView;
    
    UIButton *merchantBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Sc_w/5, 44)];
    [merchantBtn setImage:[UIImage imageNamed:@"shangq_shanghu"] forState:UIControlStateNormal];
    [merchantBtn addTarget: self action:@selector(merchantClick) forControlEvents:UIControlEventTouchUpInside];
    merchantBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    merchantBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    merchantBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    [merchantBtn setTitle:@"商户" forState:UIControlStateNormal];
    [merchantBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *mineBar = [[UIBarButtonItem alloc]initWithCustomView:merchantBtn];
    self.navigationItem.rightBarButtonItem = mineBar;
    
    NSArray* array  = @[@"首页",@"看方案",@"去体验",@"买材料",@"找装修"];
    //初始化顶部导航标题
    MyOrderTopTabBar* tabBar = [[MyOrderTopTabBar alloc] initWithArray:array];
    tabBar.frame = CGRectMake(0,64, Sc_w, 50);
    tabBar.backgroundColor = [UIColor whiteColor];
    tabBar.delegate = self;
    self.topTabbar = tabBar;
    [self.view addSubview:self.topTabbar];
}

//定位点击事件 查看当前周边的商户
- (void)lookupCurrentMaps{
    if (!_currentSelect[@"lng"] || !_currentSelect[@"lat"]){
        [self.view makeToast:@"暂时无法获取定位信息哦- -"];
        return;
    }
    [BaseocHttpService postRequest:[ResourceFront stringByAppendingString:GetNearbyInfo] andParagram:_currentSelect success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([dict[@"status"] intValue] == 1) {
            NSMutableArray *marr = [NSMutableArray array];
            
            NSArray *nearbyInfosBD09 = dict[@"result"][@"list"];
            for (NSDictionary *temp in nearbyInfosBD09) {
                CLLocationCoordinate2D addrBD09 = CLLocationCoordinate2DMake([temp[@"lat"] doubleValue], [temp[@"lng"] doubleValue]);
                CLLocationCoordinate2D addrChina = [JZLocationConverter bd09ToGcj02:addrBD09];
                NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:temp];
                [mdict setObject:[NSString stringWithFormat:@"%lf",addrChina.latitude] forKey:@"lat"];
                [mdict setObject:[NSString stringWithFormat:@"%lf",addrChina.longitude] forKey:@"lng"];
                [marr addObject:mdict];
            }
            NSLog(@"%@",marr);
            MapViewController *maps = [MapViewController new];
            maps.nearbyInfos = marr;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:maps animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
    }];
}


-(void)merchantClick{
    ShowMsg(@"商户后台目前暂不支持移动端操作，请登录电脑版进行访问");
}

//开始定位
- (void)startLocation{
    [self.manager requestWhenInUseAuthorization];
    if ([CLLocationManager locationServicesEnabled]) {
        [self.manager startUpdatingLocation];
        NSLog(@"开始定位");
    }else{
        NSLog(@"没有权限");
    }
}


//_homePageView 首页视图
- (void)createHeaderView{
    
    _homePageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 10 + 156*Percentage)];
    _homePageView.backgroundColor = My_gray;
    
    NSArray *mainArr = @[@"安装门锁",@"安装灯具",@"安装窗帘",@"安装监控"];
    NSArray *subArr = @[@"开锁换锁做房门",@"布线换开关插座",@"电机轨道遮阳帘",@"室内户外摄像头"];
    NSArray *imgArr = @[@"shangquan_suo",@"shangquan_dengju",@"shangquan_chuanglian",@"shangquan_shexiangt"];
    
    
    for (int i = 0; i < 2; i++ ) {
        
        for (int j = 0; j < 2; j++) {
            UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0 + j * (Sc_w/2 + 1), 10 + i * (78 * Percentage), Sc_w/2 - 1, 77 * Percentage)];
            btn1.backgroundColor = [UIColor whiteColor];
            
            int num = i * 2 + j;
            btn1.tag = num;
            UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgArr[num]]];
            
            if(imgView.dc_height > btn1.dc_height){
                CGFloat scale = btn1.dc_height/imgView.dc_height;
                CGSize imgSize = CGSizeMake(imgView.dc_width * scale, btn1.dc_height);
                imgView.dc_size = imgSize;
            }
            
            CGFloat centerX = btn1.mj_w - 42*Percentage;
            CGFloat centerY = btn1.mj_h/2;
            imgView.center = CGPointMake(centerX, centerY);
            
            UILabel *mainLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 18 * Percentage, 150, 14)];
            mainLab.font = [UIFont systemFontOfSize:14];
            mainLab.text = mainArr[num];
            UILabel *subLab  = [[UILabel alloc]initWithFrame:CGRectMake(15, 44 * Percentage, 150, 12)];
            subLab.font = [UIFont systemFontOfSize:12];
            subLab.text = subArr[num];
            subLab.textColor = [UIColor grayColor];
            
            [btn1 addSubview:imgView];
            [btn1 addSubview:mainLab];
            [btn1 addSubview:subLab];
            [btn1 addTarget:self action:@selector(homePageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_homePageView addSubview:btn1];
        }
        
    }
}

//首页 @"安装门锁",@"安装灯具",@"安装窗帘",@"安装监控" 跳转搜索
- (void)homePageBtnClick:(UIButton *)sender{
    NSArray *mainArr = @[@"安装门锁",@"安装灯具",@"安装窗帘",@"安装监控"];
    [self.view makeToast:mainArr[sender.tag]];
}

- (void)getMytableHeaderView:(BOOL)isCommonHeader{
    if (!isCommonHeader) {
        self.headerView.frame = CGRectMake(0, 0, Sc_w, 10 + 156*Percentage + 84);
        
        _commonHeaderView.frame = CGRectMake(0, _homePageView.dc_height, Sc_w, 84);
        
        [self.headerView addSubview:_homePageView];
        
    }else{
        self.headerView.frame = CGRectMake(0, 0, Sc_w, 84);
        [_homePageView removeFromSuperview];
        _commonHeaderView.frame = CGRectMake(0, 0, Sc_w, 84);
    }
    
    [self.headerView reloadInputViews];
    self.tableview.tableHeaderView = _headerView;
    [_tableview setContentOffset:CGPointMake(0,0) animated:YES];
}


//_commonHeaderView 公共视图 筛选
-(void)createFilterView{
    _commonHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 156 * Percentage + 124, Sc_w, 84)];
    _commonHeaderView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 39)];
    label.backgroundColor = My_gray;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"—— 优选商户 ——";
    [_commonHeaderView addSubview:label];
    
    UIView *backline = [[UIView alloc]initWithFrame:CGRectMake(0, 39, Sc_w, 1)];
    backline.backgroundColor = My_gray;
    [_commonHeaderView addSubview:backline];
    
    NSArray *btnsName = @[@"综合",@"城市",@"最近",@"筛选"];
    self.filterBtns = [NSMutableArray new];
    for (int i = 0; i < 4; i++) {
        UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(i * Sc_w/4, 40, Sc_w/4, 43)];
        btn1.tag = i;
        btn1.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn1 setTitle:btnsName[i] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn1 setTitleColor:Color_system forState:UIControlStateSelected];
        
        [btn1 addTarget:self action:@selector(filterData:) forControlEvents:UIControlEventTouchUpInside];
        
        if(i == 1){
            [btn1 setImage:[UIImage imageNamed:@"sort_default"] forState:UIControlStateNormal];
            [btn1 setImage:[UIImage imageNamed:@"shouqi"] forState:UIControlStateSelected];
            btn1.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
            btn1.imageEdgeInsets = UIEdgeInsetsMake(0, 60 * Percentage, 0, 0);
        }
        if(i == 3){
            [btn1 setImage:[UIImage imageNamed:@"sort_default"] forState:UIControlStateNormal];
            [btn1 setImage:[UIImage imageNamed:@"shouqi"] forState:UIControlStateSelected];
            btn1.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
            btn1.imageEdgeInsets = UIEdgeInsetsMake(0, 60 * Percentage, 0, 0);
        }
        [self.filterBtns addObject:btn1];
        [_commonHeaderView addSubview:btn1];
    }
    UIView *backline2 = [[UIView alloc]initWithFrame:CGRectMake(0, 83, Sc_w, 1)];
    backline2.backgroundColor = My_gray;
    [_commonHeaderView addSubview:backline2];
}

-(void)filterData:(UIButton *)sender{
    
    for (UIButton *temp in self.filterBtns) {
        if (temp.tag == sender.tag) {
            temp.selected = YES;
        }else{
            temp.selected = NO;
        }
    }
    _currentSelect[@"range"] = @"0";
    _currentSelect[@"city"] = @"";
    
    if (sender.tag == 0) {
        [self headerRefresh];
    }
    if (sender.tag == 1) {
        self.areaPicker.isHidden = NO;
    }
    if (sender.tag == 2) {
        _currentSelect[@"range"] = @"1";
        [self downLoadResource];
    }
}


#pragma mark - Delegate
-(void)tabBar:(MyOrderTopTabBar *)tabBar didSelectIndex:(NSInteger)index{
    
    [self getMytableHeaderView:index];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.mdata.count == 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return self.mdata.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 94;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = _mdata[indexPath.row];
    NSString *poolname = dict[@"id"];
    NewMerchCell *cell = [tableView dequeueReusableCellWithIdentifier:poolname];
    if (!cell) {
        cell = [[NewMerchCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:poolname andInfo:dict];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/* 选择事件 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [BaseocHttpService postRequest:[ResourceFront stringByAppendingString:@"r=business.appindex"] andParagram:@{@"merchid":_mdata[indexPath.row][@"id"]} success:^(id responseObject) {
        MerchIntroduceVC *vc = [MerchIntroduceVC new];
        vc.infoDict = [[(NSDictionary *)responseObject objectForKey:@"result"] objectForKey:@"list"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}

-(void)downLoadResource{
    NSString *path = [ResourceFront stringByAppendingString:@"r=merch.applist.merchuser"];
    [BaseocHttpService postRequest:path andParagram:self.currentSelect success:^(id responseObject) {
        NSDictionary *backresult = (NSDictionary *)responseObject;
        [self.mdata removeAllObjects];
        [self.mdata addObjectsFromArray:(NSArray *)backresult[@"result"][@"list"]];
        if (self.mdata.count == 0) {
            [self.view makeToast:@"所选分类当前还没有数据"];
        }
        //        _typeData = [NSMutableArray array];
        //        [_typeData addObjectsFromArray:backresult[@"result"][@"cate_list"]];
        //
        //        _levelData = [NSMutableArray array];
        //        [_levelData addObjectsFromArray:backresult[@"result"][@"level_list"]];
        //
        //        _waysData = [NSMutableArray array];
        //        [_waysData addObjectsFromArray:backresult[@"result"][@"taste_list"]];
        
        //        if(self.mdata.count%10 == 0){
        //            __block BusinessAreaVC *weakSelf = self;
        //            self.tableview.mj_footer = nil;
        //            self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //                [weakSelf addReloadDatas];
        //            }];
        //        }
        [_tableview reloadData];
    }];
    
}

//定位成功
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *currentLocation = [locations lastObject];
    NSLog(@"当前定位地址 = %@",currentLocation);
    
    CLLocationCoordinate2D currentBD09 = [JZLocationConverter wgs84ToBd09:currentLocation.coordinate];
    //经度 纬度
    CGFloat longitude = currentBD09.longitude;
    CGFloat latitude = currentBD09.latitude;
    self.currentSelect = [NSMutableDictionary dictionary];
    self.currentSelect[@"lng"] = [NSString stringWithFormat:@"%.6f",longitude];
    self.currentSelect[@"lat"]  = [NSString stringWithFormat:@"%.6f",latitude];
    
    [self downLoadResource];
    
    CLGeocoder *geoCoder = [CLGeocoder new];
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = placemarks[0];
            NSLog(@"地址 = %@",placemark);
            [self.locationBtn setTitle:placemark.locality forState:UIControlStateNormal];
        }
    }];
    [self.manager stopUpdatingLocation];
}

//定位失败
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
    _currentSelect = [NSMutableDictionary dictionary];
    [_currentSelect setObject:@"" forKey:@"lng"];
    [_currentSelect setObject:@"" forKey:@"lat"];
    [self downLoadResource];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"允许\"定位\"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开定位设置
        NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingURL];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    [self presentViewController:alertVC animated:YES completion:nil];
}
//搜索
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"跳转到搜索界面");
    return NO;
}
//选择地址
- (void)areaPickerView:(PlacePickerView *)areaPickerView didSelectArea:(NSString *)area
{
    NSArray *arr = [area componentsSeparatedByString:@"-"];
    NSLog(@"%@",arr[1]);
    _currentSelect[@"city"] = arr[1];
    [self downLoadResource];
    [self.filterBtns[1] setTitle:arr[1] forState:UIControlStateNormal];
    self.filterBtns[1].imageEdgeInsets = UIEdgeInsetsMake(0, 80 * Percentage, 0, 0);
    
    self.filterBtns[1].titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
}

@end
