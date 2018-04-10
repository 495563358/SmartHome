//
//  BusinessSearchVC.m
//  SmartMall
//
//  Created by Smart house on 2017/11/7.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "BusinessSearchVC.h"

#import "BusinessCell.h"

#import "PlacePickerView.h"

#import "MerchantViewController.h"

#import "MJRefresh.h"

#import "ObjectTools.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"

#define Subpath @"r=merch.applist.merchuser"
#define SearchPath @"r=merch.applist.search"

@interface BusinessSearchVC ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,AYPlaceViewDelegate,UISearchBarDelegate>{
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
    
    UITextField *searchText;
}

@property (nonatomic,strong)UIButton *locationBtn;


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

@implementation BusinessSearchVC

-(NSMutableArray *)mdata{
    if (!_mdata) {
        _mdata = [NSMutableArray array];
    }return _mdata;
}


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
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
    [self createViewthree];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 142)];
    headerView.backgroundColor = My_gray;
    [headerView addSubview:viewOne];
    [headerView addSubview:viewThree];
    
    self.tableview = [[UITableView alloc]initWithFrame:Sc_bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableview];
    _tableview.tableHeaderView = headerView;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    self.areaPicker = [[PlacePickerView alloc]initWithDelegate:self];
    currentPage = 1;
    
    _currentSelect = [[NSMutableDictionary alloc]initWithDictionary:_userLocation];
    [self downLoadResource];
    
}
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:@"r=business.appindex"] parameters:@{@"merchid":_mdata[indexPath.row][@"id"]} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        MerchantViewController *vc = [MerchantViewController new];
        vc.infoDict = [[(NSDictionary *)responseObject objectForKey:@"result"] objectForKey:@"list"];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    }];
    
}

//-(void)createViewone{
//    //定位
//    self.locationBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 6, 150, 29)];
//    _locationBtn.backgroundColor = color(217, 217, 217, 0.2);
//    _locationBtn.layer.cornerRadius = 10.0;
//    [_locationBtn setImage:[UIImage imageNamed:@"dinweiblue"] forState:UIControlStateNormal];
//    [_locationBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
//    _locationBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
//    [_locationBtn setTitleColor:color(14, 173, 254, 1) forState:UIControlStateNormal];
//    [_locationBtn setTitle:@"定位" forState:UIControlStateNormal];
//    [_locationBtn addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
//
//
//    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 210, 6, 200,29)];
//    searchBtn.backgroundColor = color(0, 0, 0, 0.1);
//    searchBtn.layer.cornerRadius = 10.0;
//    [searchBtn setImage:[UIImage imageNamed:@"sousuo"] forState:UIControlStateNormal];
//    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
//    searchBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
//    [searchBtn setTitle:@"体验馆" forState:UIControlStateNormal];
//    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    //    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
//
//    viewOne = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 41)];
//    viewOne.backgroundColor = [UIColor whiteColor];
//    [viewOne addSubview:searchBtn];
//    [viewOne addSubview:_locationBtn];
//
//}

-(void)createViewone{
    
    viewOne = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 41)];
    viewOne.backgroundColor = [UIColor whiteColor];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui-hui"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [viewOne addSubview:backBtn];
    
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(40, 5, Sc_w - 90, 30)];
    searchBar.barTintColor = [UIColor whiteColor];
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.showsCancelButton = NO;
    
    searchBar.delegate = self;
    
    for (UIView *subView in searchBar.subviews) {
        if ([subView isKindOfClass:[UIView  class]]) {
            [[subView.subviews objectAtIndex:0] removeFromSuperview];
            if ([[subView.subviews objectAtIndex:0] isKindOfClass:[UITextField class]]) {
                searchText = [subView.subviews objectAtIndex:0];
                searchText.layer.cornerRadius = 5;
                searchText.font = [UIFont systemFontOfSize:14];
                searchText.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
                searchText.returnKeyType = UIReturnKeySearch;
            }
        }
    }
    searchBar.placeholder = @"体验馆";
    [searchBar becomeFirstResponder];
    [viewOne addSubview:searchBar];
    
    
    UIButton *searchbtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 50, 0, 40, 40)];
    [searchbtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchbtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [searchbtn setTitleColor:Color_system forState:UIControlStateNormal];
    [searchbtn addTarget:self action:@selector(startSearch) forControlEvents:UIControlEventTouchUpInside];
    [viewOne addSubview:searchbtn];
    
}


-(void)startSearch{
    NSLog(@"text = %@",searchText.text);
    if (searchText.text.length == 0) {
        searchText.text = @"体验馆";
    }
    NSDictionary *dict = @{@"keyword":searchText.text};
    
    self.currentSelect = [[NSMutableDictionary alloc]initWithDictionary:_userLocation];
    [_currentSelect setObject:searchText.text forKey:@"keyword"];
    
    [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:SearchPath] parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *backresult = (NSDictionary *)responseObject;
        [self.mdata removeAllObjects];
        [self.mdata addObjectsFromArray:(NSArray *)backresult[@"result"][@"list"]];
        
        if (self.mdata.count == 0) {
            [self.view makeToast:@"您搜索的内容当前还没有数据"];
        }
        _typeData = [NSMutableArray array];
        [_typeData addObjectsFromArray:backresult[@"result"][@"cate_list"]];
        
        _levelData = [NSMutableArray array];
        [_levelData addObjectsFromArray:backresult[@"result"][@"level_list"]];
        
        _waysData = [NSMutableArray array];
        [_waysData addObjectsFromArray:backresult[@"result"][@"taste_list"]];
        
        if(self.mdata.count%10 == 0 && self.mdata.count != 0){
            __block BusinessSearchVC *weakSelf = self;
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter new];
            [footer setRefreshingTarget:weakSelf refreshingAction:@selector(addReloadDatas)];
            self.tableview.mj_footer = footer;
        }
        
        [_tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

-(void)createViewthree{
    viewThree = [[UIView alloc]initWithFrame:CGRectMake(0, 42+10, Sc_w, 84)];
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
        btn1.imageEdgeInsets = UIEdgeInsetsMake(0, 80 * Percentage, 0, 0);
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
            __block BusinessSearchVC *weakSelf = self;
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

//代理选择事件
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

@end
