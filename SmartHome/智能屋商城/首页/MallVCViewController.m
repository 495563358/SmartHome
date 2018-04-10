//
//  SmartMall.m
//  SmartMall
//
//  Created by Smart house on 2017/8/16.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "MallVCViewController.h"//商城首页

#import "BaseocHttpService.h"
#import <CoreLocation/CoreLocation.h>

//8个分类页面
#import "GeziView.h"

//通知
#import "NoticeView.h"

//每个商品的数据
#import "ModelData.h"

//网络
#import "ObjectTools.h"
#import "Reachability.h"

//8个分类点进去的页面
#import "TestViewController.h"

//单个商品的页面
#import "ProductViewControll.h"

//刷新
#import <MJRefresh/MJRefresh.h>

//用户中心
#import "UserCenterViewController.h"

//消息
#import "MessageViewController.h"

//登录
#import "LoadViewController.h"

//购物车列表
#import "ShopListViewController.h"

#import "UIView+Toast.h"

#define StaticCell  @"CollectionCell"

#define requestPath @"r=appindex.indexno"

//快速购买
#import "QuickbuyController.h"

#import "SearchViewController.h"

#import "CommssionViewController.h"

#import "MBProgressHUD.h"

#import "MerchantViewController.h"

#import "JZLocationConverter.h"

@interface MallVCViewController ()<SDCycleScrollViewDelegate,CLLocationManagerDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UIWebViewDelegate,UIScrollViewDelegate>{
    UIImageView *shopImg;
    UILabel *shopName;
    UILabel *shopAddr;
    NSDictionary *_shopInfo;
    CLLocationCoordinate2D _coord2D;
}

@property(nonatomic,copy)NSString *cityName;

@property(nonatomic,strong)CLLocationManager *manager;

@property(nonatomic,strong)UIView *headView;

@property(nonatomic,strong)NSMutableArray *Mdata;
@property(nonatomic,strong)NSMutableArray *shopData;

@property(nonatomic,strong)NSMutableArray *imageCache;//图片缓存池

@property(nonatomic,strong)NSMutableDictionary *opCache;

@property(nonatomic,strong)NSOperationQueue *queue;

@property (nonatomic,strong)SDCycleScrollView *scrollview;

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)NSMutableArray *noticeData;

@property(nonatomic,strong)NoticeView *noticeV;

@property(nonatomic,strong)UILabel *label;

@property(nonatomic,strong)NSMutableArray *detilData;

@property(nonatomic,assign)BOOL isConnect;

@property(nonatomic,strong)GeziView *gezi;

@property(nonatomic,strong)NSMutableArray *adviseID;

@property(nonatomic,strong)UIView *searchBack;

@end

@implementation MallVCViewController



-(void)viewDidAppear:(BOOL)animated{
    self.isConnect = [self getbool];
    NSLog(@" 网络状态 %i",_isConnect);
}

-(BOOL)getbool
{
    BOOL isConnectTheInternet = YES;
    Reachability *reachConnect = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reachConnect currentReachabilityStatus]) {
        case NotReachable:
            //没有网络
            isConnectTheInternet = NO;
            break;
        case ReachableViaWiFi:
            //使用WiFi网络
            isConnectTheInternet = YES;
        case ReachableViaWWAN:
            //使用3g网络
            isConnectTheInternet = YES;
        default:
            break;
    }
    return isConnectTheInternet;
}

-(NSMutableArray *)adviseID{
    if (!_adviseID) {
        _adviseID = [NSMutableArray array];
    }
    return _adviseID;
}


-(NSMutableArray *)detilData{
    if (!_detilData) {
        _detilData = [NSMutableArray array];
    }
    return _detilData;
}

-(NSMutableArray *)noticeData{
    if (!_noticeData) {
        _noticeData = [NSMutableArray array];
    }return _noticeData;
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


-(NSMutableArray *)Mdata{
    if (!_Mdata) {
        _Mdata = [NSMutableArray array];
        
    }return _Mdata;
}

-(NSMutableArray *)shopData{
    if (!_shopData) {
        _shopData = [NSMutableArray array];
        for (int i = 0; i<6; i++) {
            UIImage *thumb = [UIImage imageNamed:@"isloading"];
            NSString *title = @"";
            NSString *price = @"5200.00";
            NSString *productprice = @"9999.99";
            
            ModelData *model = [ModelData getModelData:thumb andTitle:title andPrcie:price andproductprice:productprice];
            [_shopData addObject:model];
        }
        
        
    }return _shopData;
}


-(NSMutableArray *)imageCache{
    if (!_imageCache) {
        _imageCache = [NSMutableArray array];
        [_imageCache addObject:[UIImage imageNamed:@"商城首页轮播图"]];
        [_imageCache addObject:[UIImage imageNamed:@"商城首页轮播图"]];
        [_imageCache addObject:[UIImage imageNamed:@"商城首页轮播图"]];
    }return _imageCache;
}

//测试使用  消息按钮
-(void)messageClick{
    MessageViewController *mess = [[MessageViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mess animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

//个人中心
-(void)mineClick{
    //偏好设置
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userToken = [user objectForKey:@"userToken"];
    NSLog(@"用户token = %@ \n APP位置 = %@",userToken,App_document);
    
    if (userToken) {
        UserCenterViewController *userCenter = [[UserCenterViewController alloc]init];
        
        userCenter.token = userToken;
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userCenter animated:YES];
        
        self.hidesBottomBarWhenPushed = NO;
        return;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    LoadViewController *newUser = [[LoadViewController alloc]init];
    [self.navigationController pushViewController:newUser animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

//购物车列表
-(void)shopList{
    ShopListViewController *vc = [[ShopListViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)locationClick{
    [_locationBtn setTitle:@"定位中..." forState:UIControlStateNormal];
    [self.manager requestWhenInUseAuthorization];//requestWhenInUseAuthorization  requestAlwaysAuthorization
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
            _cityName = placemark.locality;
            
            
            _coord2D = [JZLocationConverter wgs84ToBd09:placemark.location.coordinate];
            
            if (!_cityName) {
                _cityName = @"无法定位该位置";
            }
            _cityName = [NSString stringWithFormat:@"%@",placemark.name];
            [_locationBtn setTitle:placemark.locality forState:UIControlStateNormal];
            
        }
    }];
    [self.manager stopUpdatingLocation];
}

//定位失败弹出提示框，点击"打开定位"按钮,则会打开系统的设置，提示打开定位服务
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
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


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片",(long)index);
    
    
    if (index >= self.adviseID.count) {
        NSLog(@"广告图还没有加载完成");
        return;
    }
    
    ProductViewControll *vc = [[ProductViewControll alloc]init];
    vc.productID = self.adviseID[index];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self locationClick];//开始定位
    [self downLoadPict];//下载资源
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = color(14, 173, 254, 1);
    
    self.view.backgroundColor = My_gray;
    
    UIButton *mineBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 30)];
    [mineBtn setImage:[UIImage imageNamed:@"gerenzx"] forState:UIControlStateNormal];
    [mineBtn addTarget: self action:@selector(mineClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *mineBar = [[UIBarButtonItem alloc]initWithCustomView:mineBtn];
    
    UIButton *shopBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 30)];
    [shopBtn setImage:[UIImage imageNamed:@"gouwuc"] forState:UIControlStateNormal];
    [shopBtn addTarget: self action:@selector(shopList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shopBar = [[UIBarButtonItem alloc]initWithCustomView:shopBtn];
    self.navigationItem.rightBarButtonItems = @[mineBar,shopBar];
    
    
    self.scrollview = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, Sc_w, Sc_w*0.50) imagesGroup:self.imageCache];
    _scrollview.delegate = self;
    
    self.gezi = [[GeziView alloc]initWithFrame:CGRectMake(0, Sc_w*0.50+Sc_w/30, Sc_w, 2*(10+Sc_w/7+Sc_w/9))];
    _gezi.backgroundColor = [UIColor whiteColor];
    
    CGFloat hh = Sc_w * 0.50 + 2*(10+Sc_w/7+Sc_w/9)+Sc_w/30;
    
    UIButton *nearbyShop = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, Sc_w, Sc_w/10*3 - 20)];
    nearbyShop.backgroundColor = [UIColor whiteColor];
    [nearbyShop addTarget:self action:@selector(turntoShop) forControlEvents:UIControlEventTouchUpInside];
    
    shopImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, Sc_w/10*3-34, Sc_w/10*3-34)];
    [nearbyShop addSubview:shopImg];
    
    CGFloat per = Sc_w/320;
    shopName = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w/10*3-10, 12*per, Sc_w - (Sc_w/10*3+10), 25)];
    shopName.font = [UIFont systemFontOfSize:15];
    [nearbyShop addSubview:shopName];
    shopName.text = @"附近商户:深圳麦宝科技有限公司";
    
    shopAddr = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w/10*3-10, Sc_w/10*3-12*per - 45, Sc_w - (Sc_w/10*3+10), 25)];
    shopAddr.font = [UIFont systemFontOfSize:14];
    shopAddr.textColor = [UIColor grayColor];
    shopAddr.text = @"地址:深圳市龙华新区大浪街道华荣路";
    [nearbyShop addSubview:shopAddr];
    
    UIImageView *nextImgtip = [[UIImageView alloc]initWithFrame:CGRectMake(Sc_w - 20, Sc_w/10*3/2 - 17, 7, 13)];
    nextImgtip.image = [UIImage imageNamed:@"gengduo"];
    [nearbyShop addSubview:nextImgtip];
    
    UIView *shopView = [[UIView alloc]initWithFrame:CGRectMake(0, hh, Sc_w, Sc_w/10*3)];
    shopView.backgroundColor = My_gray;
    [shopView addSubview:nearbyShop];
    
    //设置商品列表
    hh += Sc_w/10 * 3;
    
    
    //设置headerView
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, hh)];
    NSLog(@"hhhhhhhh = %f",hh);
    [_headView addSubview:_scrollview];
    [_headView addSubview:_gezi];
    [_headView addSubview:shopView];
    
    
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.itemSize = CGSizeMake(Sc_w/2-5, (1.4) * (Sc_w/2 - 20));
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.footerReferenceSize = CGSizeMake(Sc_w, 108);
    flowLayout.headerReferenceSize = CGSizeMake(Sc_w,hh - 10);
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:StaticCell];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    [self.view addSubview:_collectionView];
    
    //定位
    self.locationBtn = [[UIButton alloc]initWithFrame:CGRectMake(-10, 4, Sc_w/5, 20)];
    _locationBtn.layer.cornerRadius = 5;
    _locationBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    [_locationBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [_locationBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 1, 0, 0)];
    [_locationBtn setImage:[UIImage imageNamed:@"dinwei"] forState:UIControlStateNormal];
    _locationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_locationBtn setTitle:@"定位" forState:UIControlStateNormal];
    [_locationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_locationBtn addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_locationBtn];
    
    self.searchBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 32)];
    _searchBack.backgroundColor = [UIColor whiteColor];
    _searchBack.hidden = YES;
    [self.view addSubview:_searchBack];
    
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, Sc_w - 150, 30)];
    [searchBtn setImage:[UIImage imageNamed:@"sousuo"] forState:UIControlStateNormal];
    searchBtn.backgroundColor = [UIColor colorWithRed:211/255.0 green:228/255.0 blue:243/255.0 alpha:0.4];
    searchBtn.alpha = 0.5;
    searchBtn.layer.cornerRadius = 10;
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 9, 0, 0);
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [searchBtn setTitle:@"智能屋主机" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = searchBtn;
    
    [self MyBlocks];
    
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self downLoadPict];
    }];
}

-(void)turntoShop{
    if (!_shopInfo) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:@"r=business.appindex"] parameters:@{@"merchid":_shopInfo[@"id"]} progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        MerchantViewController *vc = [MerchantViewController new];
        vc.infoDict = [[(NSDictionary *)responseObject objectForKey:@"result"] objectForKey:@"list"];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//搜索
-(void)searchClick{
    SearchViewController *vc = [SearchViewController new];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
//    return _headView.frame.size;
//}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        reusableView = header;
        [reusableView addSubview:_headView];
    }
    if (kind == UICollectionElementKindSectionFooter)
    {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerview.backgroundColor = [UIColor whiteColor];
        NSLog(@"footview = %f",footerview.frame.size.height);
        reusableView = footerview;
    }
    return reusableView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shopData.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


//cell内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ModelData *model = [ModelData new];
    if (self.shopData.count <= indexPath.row) {
        UIImage *thumb = [UIImage imageNamed:@"isloading"];
        NSString *title = @"";
        NSString *price = @"5200.00";
        NSString *productprice = @"9999.99";
        NSLog(@"ceshi");
        model = [ModelData getModelData:thumb andTitle:title andPrcie:price andproductprice:productprice];
    }else{
        model = self.shopData[indexPath.row];
    }
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:StaticCell forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Sc_w/2 - 10, Sc_w/2 - 10)];
    imageView.image = (UIImage *)model.thumb;
    [cell.contentView addSubview:imageView];
    
    CGFloat hh = Sc_w/2-10;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, hh, hh-10,30)];
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.text = model.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:titleLabel];
    
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,hh + 25, hh/2, 30)];
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.font = [UIFont systemFontOfSize:14];
    priceLabel.textColor = [UIColor redColor];
    priceLabel.text = model.price;
    [cell.contentView addSubview:priceLabel];
    
    UILabel *prodPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(hh/2, hh + 25,hh/2, 30)];
    prodPriceLabel.textAlignment = NSTextAlignmentLeft;
    prodPriceLabel.font = [UIFont systemFontOfSize:14];
    prodPriceLabel.textColor = [UIColor grayColor];
    
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:model.productprice attributes:attribtDic];
    prodPriceLabel.attributedText = attribtStr;
    
    [cell.contentView addSubview:prodPriceLabel];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 0, 5, 0);//分别为上、左、下、右
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ModelData *model = self.shopData[indexPath.row];
    if (model.gid == nil) {
        return;
    }
    ProductViewControll *vc = [[ProductViewControll alloc]init];
    vc.productID = model.gid;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(Sc_w/2-5, (1.4) * (Sc_w/2 - 20));
}

- (void)MyBlocks{
    
    __block MallVCViewController *weakSelf = self;
    self.gezi.BtnCLickBlock = ^(NSString *path,NSString *name){
        TestViewController *detilVC = [[TestViewController alloc]init];
        detilVC.path = path;
        detilVC.name = name;
        
        weakSelf.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:detilVC animated:YES];
        weakSelf.hidesBottomBarWhenPushed = NO;
    };
    
    
    self.gezi.commssionBlock = ^(){
        
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *userToken = [user objectForKey:@"userToken"];
        
        if (!userToken) {
            [weakSelf.view makeToast:@"登录后才能查看个人分销信息"];
            return;
        }
        
        CommssionViewController *vc = [CommssionViewController new];
        
        weakSelf.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        weakSelf.hidesBottomBarWhenPushed = NO;
    };
}

-(void)viewDidDisappear:(BOOL)animated{
    self.gezi.userInteractionEnabled = YES;
}

- (void)downLoadPict{
    
    double lat = _coord2D.latitude;
    double lng = _coord2D.longitude;
    
    NSString *latstr = [NSString stringWithFormat:@"%.6lf",lat];
    NSString *lngstr = [NSString stringWithFormat:@"%.6lf",lng];
    NSLog(@"%@",[ResourceFront stringByAppendingString:requestPath]);
    
//    [BaseocHttpService postRequest:[ResourceFront stringByAppendingString:requestPath] andParagram:@{@"lat":latstr,@"lng":lngstr} success:^(id responseObject) {
//        NSArray *arr = (NSArray *)responseObject;
//        NSLog(@"%@",arr);
//    }];
    [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:requestPath] parameters:@{@"lat":latstr,@"lng":lngstr} progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"已经获取商城主页网址");
        
        NSArray *arr = (NSArray *)responseObject;
        
        //广告信息
        NSDictionary *bannerDict = arr[0];
        //分类数据
        NSDictionary *detil = arr[1];
        //公告信息
        NSDictionary *noticeDict = arr[2];
        //商品数据
        NSDictionary *shopDict = arr[3];
        //购物车数量
        NSDictionary *shopcount = arr[4];
        //分销数据
        _shopInfo = arr[5][@"data"][0];
        
        
        //分类数据
        for (UIButton *btn in _gezi.subviews) {
            if (btn.tag == 101)
                btn.tag = 4677;
            else if (btn.tag == 102)
                btn.tag = 4676;
            else if (btn.tag == 103)
                btn.tag = 4678;
            else if (btn.tag == 104)
                btn.tag = 4679;
            else if (btn.tag == 105)
                btn.tag = 4688;
            else if (btn.tag == 106)
                btn.tag = 4680;
            else if (btn.tag == 107)
                btn.tag = 0;
            else if (btn.tag == 108)
                btn.tag = 1;
        }
        
        //附近商铺信息
        shopImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_shopInfo[@"logo"]]]];
        shopName.text = [NSString stringWithFormat:@"附近商户:%@",_shopInfo[@"merchname"]];
        shopAddr.text = [NSString stringWithFormat:@"地址:%@",_shopInfo[@"address"]];
        
        //广告信息
        if (self.Mdata.count != [bannerDict[@"data"] count]) {
            [self.Mdata removeAllObjects];
            NSLog(@"下载广告 = %@",bannerDict);
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                for (NSDictionary *dic in bannerDict[@"data"]) {
                    
                    NSString *spStr = [[dic[@"imgurl"] substringToIndex:[dic[@"imgurl"] length] - 4] stringByAppendingString:@".arch"];
                    
                    NSString *imagePath = [NSString stringWithFormat:@"/%@",[spStr stringByReplacingOccurrencesOfString:@"/" withString:@"SP"]];
                    NSLog(@"imagePath = %@",imagePath);
                    NSString *substr = dic[@"linkurl"];
                    
                    [self.adviseID addObject:[substr substringFromIndex:substr.length - 5]];
                    
                    NSLog(@"广告ID = %@",[dic[@"linkurl"] substringFromIndex:substr.length - 5]);
                    
                    
                    NSData *Cachadata = [NSData dataWithContentsOfFile:[App_document stringByAppendingString:imagePath]];
                    if (Cachadata.length == 0) {
                        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",AddressPath,dic[@"imgurl"]];
                        NSURL *url = [NSURL URLWithString:imageUrl];
                        Cachadata = [NSData dataWithContentsOfURL:url];
                        BOOL writeOk = [Cachadata writeToFile:[App_document stringByAppendingString:imagePath] atomically:YES];
                        NSLog(@"data = %i %@ %@",writeOk,imageUrl,[App_document stringByAppendingString:imagePath]);
                    }
                    UIImage *image = [UIImage imageWithData:Cachadata];
                    NSLog(@"image = %@",image);
                    [self.Mdata addObject:image];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"广告图数量 = %li",(unsigned long)_Mdata.count);
                    if(self.Mdata.count){
                        _scrollview.imagesGroup = self.Mdata;
                        
                        [self.scrollview reloadInputViews];
                    }
                });
            });
        }
        
        
        //下载商品信息
        if (self.shopData.count != shopDict.count) {
            
            [self.shopData removeAllObjects];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                for (NSDictionary *dic2 in shopDict[@"data"]) {
                    
                    NSString *imagePath2 = [NSString stringWithFormat:@"/%@.arch",dic2[@"title"]];
                    NSData *Cachadata1 = [NSData dataWithContentsOfFile:[App_document stringByAppendingString:imagePath2]];
                    if (Cachadata1.length == 0) {
                        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",AddressPath,dic2[@"thumb"]];
                        NSURL *url = [NSURL URLWithString:imageUrl];
                        Cachadata1 = [NSData dataWithContentsOfURL:url];
                        [Cachadata1 writeToFile:[App_document stringByAppendingString:imagePath2] atomically:YES];
                    }
                    UIImage *thumb = [UIImage imageWithData:Cachadata1];
                    NSString *title = dic2[@"title"];
                    NSString *price = dic2[@"price"];
                    NSString *productprice = dic2[@"productprice"];
                    ModelData *model = [ModelData getModelData:thumb andTitle:title andPrcie:price andproductprice:productprice];
                    model.gid = dic2[@"gid"];
                    [self.shopData addObject:model];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                    [self.collectionView.mj_header endRefreshing];
                });
                NSLog(@"商品列表下载 : %ld",(unsigned long)_shopData.count);
                
            });
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_locationBtn setTitle:@"定位失败" forState:UIControlStateNormal];
        [self.view makeToast:@"似乎没网哦,请检查您的网络设置"];
        [self.collectionView.mj_header endRefreshing];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    
}
@end
