
//
//  DiscountViewController.m
//  SmartMall
//
//  Created by Smart house on 2017/9/2.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "DiscountViewController.h"

#import "DiscountCell.h"

#import "ObjectTools.h"

#import "UIView+Toast.h"

#import "MyOrderTopTabBar.h"

#define requestPath @"r=member.appinfo.coupon"

@interface DiscountViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,MyOrderTopTabBarDelegate>


@property (nonatomic,strong)UITableView *tableview;


@property(nonatomic,strong)NSMutableArray *Mdata;


@property(nonatomic,strong)NSMutableArray *usableData;


@property(nonatomic,strong)NSMutableArray *unableData;


@property(nonatomic,assign)BOOL usable;


@end


@implementation DiscountViewController

-(NSMutableArray *)Mdata{
    if (!_Mdata) {
        _Mdata = [NSMutableArray array];
    }return _Mdata;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的优惠券";
//    self.view.backgroundColor = My_gray;
    self.navigationController.navigationBarHidden = NO;
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, Sc_h - 64) style:UITableViewStylePlain];
    _tableview.backgroundColor = My_gray;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    
//    _tableview.sectionFooterHeight = 64;
    
    [self.view addSubview:_tableview];
    
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [self downLoadSource];
    
    MyOrderTopTabBar *toptabBar = [[MyOrderTopTabBar alloc]initWithArray:@[@"可使用",@"已失效"]];
    toptabBar.frame = CGRectMake(0,0, Sc_w, 50);
    toptabBar.backgroundColor = [UIColor whiteColor];
    toptabBar.delegate = self;
    
    _tableview.tableHeaderView = toptabBar;
    _tableview.sectionFooterHeight = 64;
    
    self.usable = YES;
    [self tabBar:toptabBar didSelectIndex:0];
    
}

-(NSMutableArray *)usableData{
    if (!_usableData) {
        _usableData = [NSMutableArray array];
    }
    return _usableData;
}


-(NSMutableArray *)unableData{
    if (!_unableData) {
        _unableData = [NSMutableArray array];
    }
    return _unableData;
}


-(void)downLoadSource{
    
    
    [_dict setValue:@"1" forKey:@"isuse"];
    
    [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:requestPath] parameters:self.dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSLog(@"可用返回 = %@",dict);
        NSArray *arr = [NSArray array];
        if ([dict[@"status"] intValue] > 0) {
            arr = dict[@"result"];
        }
        [self.usableData addObjectsFromArray:arr];
        
        self.Mdata = self.usableData;
        [self.tableview reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    [_dict setValue:@"2" forKey:@"isuse"];
    
    NSLog(@" 不可用 = %@",_dict);
    
    [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:requestPath] parameters:self.dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSLog(@"不可用返回 = %@",dict);
        NSArray *arr = [NSArray array];
        if ([dict[@"status"] intValue] > 0) {
            arr = dict[@"result"];
        }
        [self.unableData addObjectsFromArray:arr];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}




-(void)tabBar:(MyOrderTopTabBar *)tabBar didSelectIndex:(NSInteger)index{
    
    
//    [self.Mdata removeAllObjects];
    
    if (index == 0) {
        
        self.usable = YES;
        self.Mdata = self.usableData;
        if(self.Mdata.count == 0){
            [mainWindowss makeToast:@"暂无可用优惠券~"];
        }
    }
    
    else{
        self.usable = NO;
        
        self.Mdata = self.unableData;
        if(self.Mdata.count == 0){
            [mainWindowss makeToast:@"暂无失效优惠券~"];
        }
    }
    
    NSLog(@"%@",self.usableData);
    NSLog(@"%@",self.unableData);
    NSLog(@"%@",self.Mdata);
    
    
    [self.tableview reloadData];
    
}




-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.Mdata.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userPool"];
    if (!cell) {
        cell = [[DiscountCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"userPool"];
    }
    
    if (self.usable == YES) {
        cell.backView.image = [UIImage imageNamed:@"yhqBackW"];
        cell.staleImg.hidden = YES;
    }else{
        cell.backView.image = [UIImage imageNamed:@"yhqBackY"];
        cell.staleImg.hidden = NO;
    }
    
    
    NSDictionary *discountDict = self.Mdata[indexPath.row];
    
    cell.priceBigger.text = discountDict[@"deduct"];
    cell.moneyTitle.text = discountDict[@"couponname"];
    cell.deadLine.text = [NSString stringWithFormat:@"有效期：%@-%@",discountDict[@"timestart"],discountDict[@"timeend"]];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

@end
