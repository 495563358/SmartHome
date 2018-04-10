//
//  BusinessAreaVC.m
//  SmartMall
//
//  Created by Smart house on 2017/10/31.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "BusinessAreaVC.h"

#import <CoreLocation/CoreLocation.h>
#import "BusinessCell.h"

#import "BusinessSearchVC.h"

#import "PlacePickerView.h"
//技术培训
#import "TechnologyViewController.h"
//加盟入驻
#import "WebcontentViewController.h"
//方案设计 用户指南
#import "ProjectdesignVC.h"
//智能装修 家居建材
#import "FitmentViewController.h"
//智能体验 经销代理
#import "SmartExperienceVC.h"

#import "MerchantViewController.h"

#import "MapViewController.h"

#import "ObjectTools.h"

#import "UIView+Toast.h"

#import "JZLocationConverter.h"

#import "MBProgressHUD.h"

#import "MJRefresh.h"

#define Subpath @"r=merch.applist.merchuser"

@interface BusinessAreaVC ()<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,AYPlaceViewDelegate>{
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

@property(nonatomic,copy)NSString *longit;
@property(nonatomic,copy)NSString *latit;

@end

@implementation BusinessAreaVC

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



-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"附近商圈";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = color(14, 173, 254, 1);
    
    self.view.backgroundColor = My_gray;
    
    [self createViewone];
    [self createViewtwo];
    [self createViewthree];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 339 - 42 - 208 * (1 - Percentage))];
    headerView.backgroundColor = My_gray;
//    [headerView addSubview:viewOne];
    [headerView addSubview:viewtwo];
    [headerView addSubview:viewThree];
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, Sc_h - 64 - 49) style:UITableViewStylePlain];
    [self.view addSubview:_tableview];
    _tableview.tableHeaderView = headerView;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    self.areaPicker = [[PlacePickerView alloc]initWithDelegate:self];
    
    currentPage = 1;
    
    [self startLocation];
    
    
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
    [header setRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.tableview.mj_header = header;
    
}

-(void)headerRefresh{
    self.currentSelect = [NSMutableDictionary new];
    
    if(self.longit && self.latit){
        [self.currentSelect setObject:self.longit forKey:@"lng"];
        [self.currentSelect setObject:self.latit forKey:@"lat"];
    }
    [self downLoadResource];
    [self.tableview.mj_header endRefreshing];
    NSArray *btnsName = @[@"城市",@"分类",@"授权级别",@"体验方式"];
    
    for (UIButton *btn1 in self->sortBtns) {
        btn1.selected = NO;
        [btn1 setTitle:btnsName[btn1.tag] forState:UIControlStateNormal];
    }
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
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:poolname];
    if (!cell) {
        cell = [[BusinessCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:poolname];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"logo"]]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.headImage.image = image;
            });
        });
        cell.titleLabel.text = dict[@"merchname"];
        cell.mainworkLabel.text = [NSString stringWithFormat:@"主营:%@",dict[@"catename"]];
        cell.attendWays.text = [NSString stringWithFormat:@"体验方式:%@",dict[@"tastename"]];
        cell.alongTime.text = [NSString stringWithFormat:@"级别:%@",dict[@"levelname"]];
        cell.shopArea.text = [NSString stringWithFormat:@"区域:%@",dict[@"city"]];
        cell.distance.text = [NSString stringWithFormat:@"%@km",dict[@"distance"]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:@"r=business.appindex"] parameters:@{@"merchid":_mdata[indexPath.row][@"id"]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        MerchantViewController *vc = [MerchantViewController new];
        vc.infoDict = [[(NSDictionary *)responseObject objectForKey:@"result"] objectForKey:@"list"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    }];
}

-(void)createViewone{
    //定位
//    self.locationBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 6, 150 * Percentage, 29)];
//    _locationBtn.backgroundColor = color(217, 217, 217, 0.2);
//    _locationBtn.layer.cornerRadius = 10.0;
//    [_locationBtn setImage:[UIImage imageNamed:@"dinweiblue"] forState:UIControlStateNormal];
//    [_locationBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
//    _locationBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
//    [_locationBtn setTitleColor:color(14, 173, 254, 1) forState:UIControlStateNormal];
//    [_locationBtn setTitle:@"定位" forState:UIControlStateNormal];
//    [_locationBtn addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.locationBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    _locationBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    [_locationBtn setImage:[UIImage imageNamed:@"dinwei"] forState:UIControlStateNormal];
    [_locationBtn addTarget:self action:@selector(lookupCurrentMaps) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_locationBtn];
    
    
//    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 10 - 200 * Percentage, 6, 200 * Percentage,29)];
//    searchBtn.backgroundColor = color(0, 0, 0, 0.1);
//    searchBtn.layer.cornerRadius = 10.0;
//    [searchBtn setImage:[UIImage imageNamed:@"sousuo"] forState:UIControlStateNormal];
//    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
//    searchBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
//    [searchBtn setTitle:@"体验馆" forState:UIControlStateNormal];
//    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    searchBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 0);
    [searchBtn setImage:[UIImage imageNamed:@"sousuo"] forState:UIControlStateNormal];
    
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    
//    viewOne = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 41)];
//    viewOne.backgroundColor = [UIColor whiteColor];
//    [viewOne addSubview:searchBtn];
//    [viewOne addSubview:_locationBtn];
    
}

-(void)searchClick{
    BusinessSearchVC *vc = [BusinessSearchVC new];
    vc.hidesBottomBarWhenPushed = YES;
    
    vc.userLocation = @{@"lng":_currentSelect[@"lng"],@"lat":_currentSelect[@"lat"]};
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)createViewtwo{
    viewtwo = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 208 * Percentage)];
    viewtwo.backgroundColor = [UIColor whiteColor];
    
    CGFloat btnW = Sc_w/7;
    CGFloat maginY = btnW * 3 / 5 - Sc_w/37.5/2;
    
    CGFloat addMagin = maginY + btnW + Sc_w/37.5;
    
    NSArray *titleArray = @[@"智能装修",@"智能体验",@"方案设计",@"技术培训",@"家居建材",@"经销代理",@"申请入驻",@"用户指南"];
    NSArray *imageArray = @[@"zhinengzhuangx",@"zhinengty",@"fanganshej",@"jishujn",@"jiajujc",@"jinxiaodl",@"shenqingruz",@"yonghuzhinan"];
    
    for (int i = 0; i < 8 ; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(maginY + addMagin * (i%4), 10 + (i/4) * (btnW + 45), btnW, btnW)];
        btn.tag = i;
        [btn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [viewtwo addSubview:btn];
        
        
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        
        UILabel *decLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Sc_w/5, 30)];
        decLabel.center = CGPointMake(btn.center.x-2, btn.center.y+btnW/5*4);
        decLabel.text = titleArray[i];
        decLabel.font = [UIFont systemFontOfSize:15.0];
        decLabel.textAlignment = NSTextAlignmentCenter;
        [viewtwo addSubview:decLabel];
    }
}

//模块点击事件
-(void)btnClick:(UIButton *)sender{
    //智能装修
    if (sender.tag == 0) {
        FitmentViewController *vc = [FitmentViewController new];
        vc.titlename = @"智能装修";
        vc.subpath = @"r=merch.applist.cate&pid=160";
        vc.userLocation = @{@"lng":_currentSelect[@"lng"],@"lat":_currentSelect[@"lat"]};
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    else if (sender.tag == 4) {
        FitmentViewController *vc = [FitmentViewController new];
        vc.titlename = @"家居建材";
        vc.subpath = @"r=merch.applist.cate&pid=161";
        vc.userLocation = @{@"lng":_currentSelect[@"lng"],@"lat":_currentSelect[@"lat"]};
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    else if (sender.tag == 1) {
        SmartExperienceVC *vc = [SmartExperienceVC new];
        vc.titlename = @"体验馆";
        vc.subpath = @"r=merch.applist.taste&pid=1";
        vc.userLocation = @{@"lng":_currentSelect[@"lng"],@"lat":_currentSelect[@"lat"]};
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sender.tag == 5) {
        SmartExperienceVC *vc = [SmartExperienceVC new];
        vc.titlename = @"经销代理";
        vc.subpath = @"r=merch.applist.level&pid=4";
        vc.userLocation = @{@"lng":_currentSelect[@"lng"],@"lat":_currentSelect[@"lat"]};
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //方案设计
    else if (sender.tag == 2){
        ProjectdesignVC *vc = [ProjectdesignVC new];
        vc.urlStr = @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=article.list.categorylist&cateid=74";
        vc.titlename = @"方案设计";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //技术培训
    else if (sender.tag == 3){
        TechnologyViewController *vc = [TechnologyViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //加盟入驻
    else if (sender.tag == 6) {
        WebcontentViewController *vc = [WebcontentViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //用户指南
    else if (sender.tag == 7) {
        ProjectdesignVC *vc = [ProjectdesignVC new];
        vc.urlStr = @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=article.list.categorylist&cateid=75";
        vc.titlename = @"用户指南";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)createViewthree{
    viewThree = [[UIView alloc]initWithFrame:CGRectMake(0, 208 * Percentage + 5, Sc_w, 84)];
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
    
    NSArray *btnsName = @[@"城市",@"分类",@"授权级别",@"体验方式"];
    sortBtns = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(i * Sc_w/4, 40, Sc_w/4, 45)];
        btn1.tag = i;
        btn1.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn1 setTitle:btnsName[i] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn1 setTitleColor:Color_system forState:UIControlStateSelected];
        [btn1 setImage:[UIImage imageNamed:@"sort_default"] forState:UIControlStateNormal];
        [btn1 setImage:[UIImage imageNamed:@"shouqi"] forState:UIControlStateSelected];
        [btn1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
        
        if(i<2){
            btn1.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
            btn1.imageEdgeInsets = UIEdgeInsetsMake(0, 60 * Percentage, 0, 0);
        }
        else{
            btn1.imageEdgeInsets = UIEdgeInsetsMake(0, 80 * Percentage, 0, 0);
            btn1.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        }
        [sortBtns addObject:btn1];
        [viewThree addSubview:btn1];
    }
}

//点击左上角
-(void)lookupCurrentMaps{
    if(_currentSelect[@"lng"] && _currentSelect[@"lat"]){
        [MBProgressHUD showHUDAddedTo:mainWindowss animated:YES];
        [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:@"r=merch.applist.nearby"] parameters:@{@"lng":_currentSelect[@"lng"],@"lat":_currentSelect[@"lat"]} progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
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
                [MBProgressHUD hideHUDForView:mainWindowss animated:YES];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:mainWindowss animated:YES];
        }];
    }
}

//筛选
-(void)btn1Click:(UIButton *)sender{
    if (self.typeData.count == 0) {
        return;
    }
    sender.selected = YES;
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
            [self sortByLevel];
            break;
        case 3:
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
    ((UIButton *)sortBtns[0]).imageEdgeInsets = UIEdgeInsetsMake(0, 80 * Percentage, 0, 0);
    
    ((UIButton *)sortBtns[0]).titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
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
            temp.imageEdgeInsets = UIEdgeInsetsMake(0, 80 * Percentage, 0, 0);
            temp.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        }
        else if(sender.tag == 3){
            NSLog(@"%@",_levelData[levelNamesort]);
            NSDictionary *dict2 = @{@"levelid":_levelData[levelNamesort][@"id"]};
            [self reloadDatas:dict2];
            
            UIButton *temp = sortBtns[sender.tag - 1];
            [temp setTitle:_levelData[levelNamesort][@"levelname"] forState:UIControlStateNormal];
        }
        else if (sender.tag == 4){
            NSLog(@"%@",_waysData[attendNamesort]);
            NSDictionary *dict3 = @{@"tasteid":_waysData[attendNamesort][@"id"]};
            [self reloadDatas:dict3];
         
            UIButton *temp = sortBtns[sender.tag - 1];
            [temp setTitle:_waysData[attendNamesort][@"catename"] forState:UIControlStateNormal];
        }
    }
    //取消
    switch (sender.tag) {
        case 2:
            [typePicker removeFromSuperview];
            typePicker = nil;
            break;
        case 3:
            [levelPicker removeFromSuperview];
            levelPicker = nil;
            break;
        case 4:
            [attendPicker removeFromSuperview];
            attendPicker = nil;
            break;
            
        default:
            break;
    }
}

//三种刷新数据方式
-(void)downLoadResource{
    NSString *path = [ResourceFront stringByAppendingString:Subpath];
    
    [[ObjectTools sharedManager] POST:path parameters:_currentSelect progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *backresult = (NSDictionary *)responseObject;
        NSLog(@"%@",path);
        [self.mdata removeAllObjects];
        [self.mdata addObjectsFromArray:(NSArray *)backresult[@"result"][@"list"]];
        
        if (self.mdata.count == 0) {
            [self.view makeToast:@"所选分类当前还没有数据"];
        }
        _typeData = [NSMutableArray array];
        [_typeData addObjectsFromArray:backresult[@"result"][@"cate_list"]];
        
        _levelData = [NSMutableArray array];
        [_levelData addObjectsFromArray:backresult[@"result"][@"level_list"]];
        
        _waysData = [NSMutableArray array];
        [_waysData addObjectsFromArray:backresult[@"result"][@"taste_list"]];
        
        if(self.mdata.count%10 == 0){
            __block BusinessAreaVC *weakSelf = self;
            self.tableview.mj_footer = nil;
            self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelf addReloadDatas];
            }];
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
        [_currentSelect setObject:[NSString stringWithFormat:@"%ld",(long)currentPage] forKey:@"page"];
    }else
        self.currentSelect = [[NSMutableDictionary alloc]initWithDictionary:dict];
    
    NSLog(@"筛选数据 = %@",_currentSelect);
    NSString *path = [ResourceFront stringByAppendingString:Subpath];
    
    [[ObjectTools sharedManager] POST:path parameters:_currentSelect progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *backresult = (NSDictionary *)responseObject;
        [self.mdata removeAllObjects];
        [self.mdata addObjectsFromArray:(NSArray *)backresult[@"result"][@"list"]];
        
        if (self.mdata.count == 0) {
            [self.view makeToast:@"所选分类当前还没有数据"];
        }
        if (_mdata.count % 10 != 0 || _mdata.count == 0) {
            [_tableview.mj_footer removeFromSuperview];
        }
        [_tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

-(void)addReloadDatas{
    
    if (self.currentSelect.allKeys.count == 0) {
        NSLog(@"未筛选刷新");
        _currentSelect = [NSMutableDictionary dictionary];
    }
    currentPage ++;
    NSString *path = [ResourceFront stringByAppendingString:Subpath];
    [_currentSelect setObject:[NSString stringWithFormat:@"%ld",(long)currentPage] forKey:@"page"];
    
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
            return _levelData.count;
        case 4:
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
            return _levelData[row][@"levelname"];
        case 4:
            return _waysData[row][@"catename"];
        default:
            break;
    }
    return @"暂无数据";
}

//代理选择事件 分类筛选
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED{
    
    switch (pickerView.tag) {
        case 2:
            typeNamesort = row;
        case 3:
            levelNamesort = row;
        case 4:
            attendNamesort = row;
        default:
            break;
    }
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

//定位成功
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *currentLocation = [locations lastObject];
    
    NSLog(@"当前定位地址 = %@",currentLocation);
    
    CLLocationCoordinate2D currentBD09 = [JZLocationConverter wgs84ToBd09:currentLocation.coordinate];
    //经度 纬度
    CGFloat longitude = currentBD09.longitude;
    CGFloat latitude = currentBD09.latitude;
    
    _longit = [NSString stringWithFormat:@"%.6f",longitude];
    _latit = [NSString stringWithFormat:@"%.6f",latitude];
    
    _currentSelect = [NSMutableDictionary dictionary];
    
    
    [_currentSelect setObject:_longit forKey:@"lng"];
    [_currentSelect setObject:_latit forKey:@"lat"];
    
    [self downLoadResource];
    
    CLGeocoder *geoCoder = [CLGeocoder new];
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = placemarks[0];
            NSLog(@"地址 = %@",placemark);
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

@end
