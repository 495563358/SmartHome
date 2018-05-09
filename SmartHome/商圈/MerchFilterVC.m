//
//  MerchFilterVC.m
//  SmartHome
//
//  Created by Smart house on 2018/5/4.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import "MerchFilterVC.h"

#import "PlacePickerView.h"
#import "MerchIntroduceVC.h"
#import "DCSildeBarView.h"

#import "NewMerchCell.h"
//4个分类

#define normalPath [ResourceFront stringByAppendingString:@"r=merch.applist.merchuser"]
#define searchPath [ResourceFront stringByAppendingString:@"r=merch.applist.search"]
@interface MerchFilterVC ()<UITableViewDelegate,UITableViewDataSource,AYPlaceViewDelegate,UISearchBarDelegate>{
    
    UIView *_commonHeaderView;
    NSInteger currentPage;//记录当前页数
    UITextField *searchText;
}

@property(nonatomic,strong)NSMutableArray *mdata;
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray<UIButton *> *filterBtns;
@property(nonatomic,strong)PlacePickerView *areaPicker;//选择城市

//通知
@property (weak ,nonatomic) id dcObserve;

@end

@implementation MerchFilterVC

-(NSMutableArray *)mdata{
    if (!_mdata) {
        _mdata = [NSMutableArray array];
    }return _mdata;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = My_gray;
    
    if (_isSearch) {
        [self searchView];
    }else
        self.navigationItem.title = self.navigationTitle;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui(b)"] style:UIBarButtonItemStylePlain target:self action:@selector(backToFront)];
    
    currentPage = 1;
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, Sc_h - 64) style:UITableViewStylePlain];
    
    [self downLoadResource:normalPath];
    
    [self createFilterView];
    _tableview.tableHeaderView = _commonHeaderView;
    _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0.01)];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.view addSubview:_tableview];
    
    self.areaPicker = [[PlacePickerView alloc]initWithDelegate:self];
}

-(void)searchView{
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
    searchBar.placeholder = @"智能屋";
    [searchBar becomeFirstResponder];
    self.navigationItem.titleView = searchBar;
    
    UIButton *searchbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 40)];
    [searchbtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchbtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [searchbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchbtn addTarget:self action:@selector(startSearch) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:searchbtn];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self startSearch];
    [searchBar endEditing:YES];
}

-(void)startSearch{
    NSLog(@"text = %@",searchText.text);
    if (searchText.text.length == 0) {
        searchText.text = @"智能屋";
    }
    currentPage = 1;
    _currentSelect[@"page"] = @"1";
    _currentSelect[@"keyword"] = searchText.text;
    
    [self downLoadResource:searchPath];
    
    [self.view endEditing:YES];
}

-(void)backToFront{
    [self.navigationController popViewControllerAnimated:YES];
}

//_commonHeaderView 公共视图 筛选
-(void)createFilterView{
    _commonHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 84)];
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

//数据筛选
-(void)filterData:(UIButton *)sender{
    
    for (UIButton *temp in self.filterBtns) {
        if (temp.tag == sender.tag) {
            temp.selected = YES;
        }else{
            temp.selected = NO;
        }
    }
    currentPage = 1;
    _currentSelect[@"range"] = @"0";
    _currentSelect[@"city"] = @"";
//    _currentSelect[@"cateid"] = @"";
    _currentSelect[@"levelid"] = @"";
    _currentSelect[@"tasteid"] = @"";
    _currentSelect[@"page"] = @"1";
    
    [self.filterBtns[1] setTitle:@"城市" forState:UIControlStateNormal];
    if (sender.tag == 0) {
        [self downLoadResource:normalPath];
    }
    if (sender.tag == 1) {
        self.areaPicker.isHidden = NO;
    }
    if (sender.tag == 2) {
        _currentSelect[@"range"] = @"1";
        [self downLoadResource:normalPath];
    }
    if (sender.tag == 3) {
        [DCSildeBarView dc_showSildBarViewController];
        __weak typeof(self)weakSlef = self;
        
        if (_dcObserve) {
            [[NSNotificationCenter defaultCenter] removeObserver:_dcObserve];
        }
        _dcObserve = [[NSNotificationCenter defaultCenter]addObserverForName:@"filterResult" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            NSLog(@"筛选结果 = %@",note.userInfo[@"filterResult"]);
            
            NSArray *result = note.userInfo[@"filterResult"];
            if (result.count != 3 || self.VerificationDatas.count != 3) {
                ShowMsg(@"🤒发生错误了- -");
                return;
            }
            
            if ([result[0] count]) {
                for (NSDictionary *typeInfo in self.VerificationDatas[0]) {
                    if ([result[0][0] isEqualToString:typeInfo[@"catename"]]) {
                        NSLog(@"%@",typeInfo);
                        _currentSelect[@"cateid"] = typeInfo[@"id"];
                    }
                }
            }
            
            if ([result[1] count]) {
                for (NSDictionary *typeInfo in self.VerificationDatas[1]) {
                    if ([result[1][0] isEqualToString:typeInfo[@"levelname"]]) {
                        NSLog(@"%@",typeInfo);
                        _currentSelect[@"levelid"] = typeInfo[@"id"];
                    }
                }
            }
            
            if ([result[2] count]) {
                for (NSDictionary *typeInfo in self.VerificationDatas[2]) {
                    if ([result[2][0] isEqualToString:typeInfo[@"catename"]]) {
                        NSLog(@"%@",typeInfo);
                        _currentSelect[@"tasteid"] = typeInfo[@"id"];
                    }
                }
            }
            
            
            [weakSlef downLoadResource:normalPath];
            
        }];
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
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }];
}

-(void)downLoadResource:(NSString *)path{
    [BaseocHttpService postRequest:path andParagram:self.currentSelect success:^(id responseObject) {
        NSDictionary *backresult = (NSDictionary *)responseObject;
        [self.mdata removeAllObjects];
        [self.mdata addObjectsFromArray:(NSArray *)backresult[@"result"][@"list"]];
        if (self.mdata.count == 0) {
            [self.view makeToast:@"所选分类当前还没有数据"];
            [_tableview reloadData];
            return;
        }
        
        if(self.mdata.count%10 == 0){
            __block MerchFilterVC *weakSelf = self;
            self.tableview.mj_footer = nil;
            self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelf addReloadDatas];
            }];
        }
//
        [_tableview reloadData];
    }];
    
}

-(void)addReloadDatas{
    
    if (self.currentSelect.allKeys.count == 0) {
        NSLog(@"未筛选刷新");
        _currentSelect = [NSMutableDictionary dictionary];
    }
    currentPage ++;
    NSString *path = [ResourceFront stringByAppendingString:@"r=merch.applist.merchuser"];
    _currentSelect[@"page"] = [NSString stringWithFormat:@"%ld",(long)currentPage];
    [BaseocHttpService postRequest:path andParagram:_currentSelect success:^(id responseObject) {
        NSDictionary *backresult = (NSDictionary *)responseObject;
        [self.mdata addObjectsFromArray:(NSArray *)backresult[@"result"][@"list"]];
        [_tableview.mj_footer endRefreshing];
        if (_mdata.count % 10 != 0) {
            [_tableview.mj_footer removeFromSuperview];
        }
        [_tableview reloadData];
    }];
}

//选择地址
- (void)areaPickerView:(PlacePickerView *)areaPickerView didSelectArea:(NSString *)area
{
    NSArray *arr = [area componentsSeparatedByString:@"-"];
    NSLog(@"%@",arr[1]);
    _currentSelect[@"city"] = arr[1];
    [self downLoadResource:normalPath];
    [self.filterBtns[1] setTitle:arr[1] forState:UIControlStateNormal];
    self.filterBtns[1].imageEdgeInsets = UIEdgeInsetsMake(0, 80 * Percentage, 0, 0);
    
    self.filterBtns[1].titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
}

@end
