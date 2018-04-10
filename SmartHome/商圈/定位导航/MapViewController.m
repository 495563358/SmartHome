//
//  MapViewController.m
//  MapDemo
//
//  Copyright © 2016年 qiye. All rights reserved.
//
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotationView.h>
#import "QYAnnotation.h"
#import "MKMapView+ZoomLevel.h"
#import "DestinationMode.h"

#import "UIView+Toast.h"
#import "ObjectTools.h"
#import "MBProgressHUD.h"
#import "MerchantViewController.h"

#import "JZLocationConverter.h"

@interface MapViewController ()<MKMapViewDelegate>

@end

@implementation MapViewController{
    UIView            *   uiView;
    CLLocationManager *   locationManager;
    MKMapView         *   maMapView;
    MKAnnotationView  *   annotationView;
//    DestinationMode   *   destinationMode;
    
    //商户名 地址 导航方式
    UILabel *label1;
    UILabel *label2;
    UIButton *btn1;
    UIButton *btn2;
    
    
    UIButton *moreInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商户定位";
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -24, 0, 0);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    self.view.backgroundColor = My_gray;

    [self initMap];
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) initMap
{
//    destinationMode = [DestinationMode initWithName:_merchInfo[2] desc:_merchInfo[3] latitude:_merchInfo[0] longitude:_merchInfo[1]];
    
    maMapView=[[MKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:maMapView];
    //设置代理
    maMapView.delegate=self;
    //请求定位服务
    locationManager=[[CLLocationManager alloc]init];
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [locationManager requestWhenInUseAuthorization];
    }
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    maMapView.userTrackingMode = MKUserTrackingModeFollow;
    //设置地图类型
    maMapView.mapType=MKMapTypeStandard;
    //添加大头针
    [self addAnnotation];
}

-(void)addAnnotation{
    
    for (int i = 0; i < _nearbyInfos.count; i++) {
        NSDictionary *annoInfo = _nearbyInfos[i];
        DestinationMode *newDest = [DestinationMode initWithName:annoInfo[@"merchname"] desc:annoInfo[@"address"] latitude:annoInfo[@"lat"] longitude:annoInfo[@"lng"]];
        
        CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(newDest.destinationLatitude.floatValue, newDest.destinationLongitude.floatValue);
        
        QYAnnotation *annotation1=[[QYAnnotation alloc]init];
        annotation1.title= newDest.destinationName;
        annotation1.subtitle= newDest.destinationDesc;
        annotation1.coordinate=location1;
        annotation1.tag = i;
        
        if(i == 0){
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, maMapView.frame.size.height - 130, Sc_w, 130)];
            
            view.backgroundColor = [UIColor whiteColor];
            label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, Sc_w - 20, 20)];
            label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, Sc_w - 20, 40)];
            
            label1.font = [UIFont systemFontOfSize:16];
            label2.font = [UIFont systemFontOfSize:15];
            label2.numberOfLines = 0;
            label2.textColor = [UIColor grayColor];
            [view addSubview:label1];
            [view addSubview:label2];
            
            
            btn1 = [[UIButton alloc]initWithFrame:CGRectMake(10, 85, Sc_w - 150, 28)];
            btn2 = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 120, 85, 100, 28)];
            
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            btn1.titleLabel.font = [UIFont systemFontOfSize:15];
            btn2.titleLabel.font = [UIFont systemFontOfSize:15];
            
//            btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btn1.layer.cornerRadius = 5.0;
            btn1.layer.borderWidth = 1;
            btn1.layer.borderColor = [UIColor grayColor].CGColor;
            btn1.backgroundColor = My_gray;
            
            btn2.layer.cornerRadius = 5.0;
            btn2.layer.borderWidth = 1;
            btn2.layer.borderColor = [UIColor grayColor].CGColor;
            btn2.backgroundColor = My_gray;
            
            NSString *telnum = annoInfo[@"tel"];
            if (![annoInfo[@"tel"] length]) {
                if (!annoInfo[@"mobile"]) {
                    telnum = @"商户暂未填写";
                }else{
                    telnum = annoInfo[@"mobile"];
                }
                
            }
            NSString *tele = [NSString stringWithFormat:@"电话:%@",telnum];
            
            [btn1 setTitle:tele forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(callShop:) forControlEvents:UIControlEventTouchUpInside];
            [btn2 setTitle:@"本机地图" forState:UIControlStateNormal];
            [btn2 addTarget:self action:@selector(doAppleNavigation:) forControlEvents:UIControlEventTouchUpInside];
            
            
            moreInfo = [[UIButton alloc] initWithFrame:CGRectMake(Sc_w - 30, 5, 30, 30)];
//            [moreInfo addTarget:self action:@selector(moreInfoClick:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *nextImgtip = [[UIImageView alloc]initWithFrame:CGRectMake(11, 8, 7, 13)];
            nextImgtip.image = [UIImage imageNamed:@"gengduo"];
            [moreInfo addSubview:nextImgtip];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreInfoClick:)];
            [view addGestureRecognizer:tap];
            
            [view addSubview:btn1];
            [view addSubview:btn2];
            [view addSubview:moreInfo];
            
            
            [self.view addSubview:view];
            
            label1.text = newDest.destinationName;
            label2.text = newDest.destinationDesc;
            
            [maMapView setCenterCoordinate:location1 zoomLevel:15 animated:NO];
            [maMapView selectAnnotation:annotation1 animated:NO];
        }
        [maMapView addAnnotation:annotation1];
    }
    
}

-(void)moreInfoClick:(UITapGestureRecognizer *)sender{
    NSDictionary *annoInfo = _nearbyInfos[sender.view.tag];
    
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [[AFHTTPSessionManager manager] POST:[ResourceFront stringByAppendingString:@"r=business.appindex"] parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        MerchantViewController *vc = [MerchantViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        vc.infoDict = [[(NSDictionary *)responseObject objectForKey:@"result"] objectForKey:@"list"];
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        }
    }];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if (![view.annotation isKindOfClass:[QYAnnotation class]]) {
        return;
    }
    NSDictionary *annoInfo = _nearbyInfos[view.tag];
    DestinationMode *newDest = [DestinationMode initWithName:annoInfo[@"merchname"] desc:annoInfo[@"address"] latitude:annoInfo[@"lat"] longitude:annoInfo[@"lng"]];
    
    label1.text = newDest.destinationName;
    label2.text = newDest.destinationDesc;
    btn1.tag = view.tag;
    btn2.tag = view.tag;
    moreInfo.tag = view.tag;
    moreInfo.superview.tag = view.tag;
    
    
    NSString *telnum = annoInfo[@"tel"];
    if (![annoInfo[@"tel"] length]) {
        if (!annoInfo[@"mobile"]) {
            telnum = @"商户暂未填写";
        }else{
            telnum = annoInfo[@"mobile"];
        }
    }
    
    NSString *tele = [NSString stringWithFormat:@"电话:%@",telnum];
    
    [btn1 setTitle:tele forState:UIControlStateNormal];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    //由于当前位置的标注也是一个大头针，所以此时需要判断，此代理方法返回nil使用默认大头针视图
    if ([annotation isKindOfClass:[QYAnnotation class]]) {
        
        QYAnnotation *anno = (QYAnnotation *)annotation;
        static NSString *key1=@"QYAnnotation";
        annotationView=[mapView dequeueReusableAnnotationViewWithIdentifier:key1];
        //如果缓存池中不存在则新建
        if (!annotationView) {
            annotationView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:key1];
            annotationView.frame = CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50);
            annotationView.canShowCallout=true;//允许交互点击
            annotationView.calloutOffset=CGPointMake(0, 1);//定义详情视图偏移量
            annotationView.tag = anno.tag;
            annotationView.canShowCallout = NO;
            if (anno.tag == 0) {
                annotationView.selected = YES;
            }else
                annotationView.selected = NO;
        }
        //修改大头针视图
        //重新设置此类大头针视图的大头针模型(因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置)
        annotationView.annotation=annotation;
        annotationView.image=[UIImage imageNamed:@"dituzuobiao"];//设置大头针视图的图片
        
        return annotationView;
    }else {
        return nil;
    }
}


//联系方式
-(void)callShop:(UIButton *)sender{
    NSDictionary * annoInfo= _nearbyInfos[sender.tag];
    NSString *telnum = annoInfo[@"tel"];
    if (![annoInfo[@"tel"] length]) {
        if (annoInfo[@"mobile"]) {
            telnum = annoInfo[@"mobile"];
        }
    }
    
    NSString *telstr = [NSString stringWithFormat:@"tel:%@",telnum];
    UIWebView * callWebview = [[UIWebView alloc]init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:telstr]]];
    [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
}



//开始导航
-(void)doAppleNavigation:(UIButton *)sender{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //中国坐标转bd09 起点
    CLLocationCoordinate2D fromCoordinateChina = maMapView.userLocation.location.coordinate;
    CLLocationCoordinate2D fromCoordinate = [JZLocationConverter gcj02ToBd09:fromCoordinateChina];
    
    NSDictionary *annoInfo = _nearbyInfos[sender.tag];
    DestinationMode *newDest = [DestinationMode initWithName:annoInfo[@"merchname"] desc:annoInfo[@"address"] latitude:annoInfo[@"lat"] longitude:annoInfo[@"lng"]];
    
    //中国坐标转bd09 终点
    CLLocationCoordinate2D toCoordinateChina   = CLLocationCoordinate2DMake(newDest.destinationLatitude.floatValue, newDest.destinationLongitude.floatValue);
    CLLocationCoordinate2D toCoordinate = [JZLocationConverter gcj02ToBd09:toCoordinateChina];
    
    
    //调用系统导航
    [alertVC addAction:[UIAlertAction actionWithTitle:@"使用系统自带地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *options=@{MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard),MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving};
        //出发位置 中国标准
        CLLocationCoordinate2D fromCoordinate   = maMapView.userLocation.location.coordinate;
        
        NSDictionary *annoInfo = _nearbyInfos[sender.tag];
        DestinationMode *newDest = [DestinationMode initWithName:annoInfo[@"merchname"] desc:annoInfo[@"address"] latitude:annoInfo[@"lat"] longitude:annoInfo[@"lng"]];
        
        //目的地址 中国标准
        CLLocationCoordinate2D toCoordinate = CLLocationCoordinate2DMake(newDest.destinationLatitude.floatValue, newDest.destinationLongitude.floatValue);
        
        
        MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:fromCoordinate
                                                           addressDictionary:nil];
        
        MKPlacemark *toPlacemark   = [[MKPlacemark alloc] initWithCoordinate:toCoordinate
                                                           addressDictionary:nil];
        
        MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:fromPlacemark];
        fromItem.name =@"当前位置";
        MKMapItem *toItem=[[MKMapItem alloc]initWithPlacemark:toPlacemark];
        toItem.name = newDest.destinationName;
        [MKMapItem openMapsWithItems:@[fromItem,toItem] launchOptions:options];
    }]];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]){
        // -- 使用 canOpenURL 判断需要在info.plist 的 LSApplicationQueriesSchemes 添加 baidumap 。
        [alertVC addAction:[UIAlertAction actionWithTitle:@"使用百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *url = [[NSString stringWithFormat:@"baidumap://map/direction?origin=name:%@|latlng:%lf,%lf&destination=name:%@|latlng:%lf,%lf&mode=%@&src=深圳智能屋电子科技有限公司|智能屋",@"出发位置",fromCoordinate.latitude,fromCoordinate.longitude,newDest.destinationName,toCoordinate.latitude,toCoordinate.longitude,@"driving"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            bool isBaiduOpen = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            NSLog(@"打开百度APP = %i",isBaiduOpen);
        }]];
        
    }
    
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        // -- 使用 canOpenURL 判断需要在info.plist 的 LSApplicationQueriesSchemes 添加 baidumap 。
        [alertVC addAction:[UIAlertAction actionWithTitle:@"使用高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *url = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%lf&slon=%lf&sname=我的位置&did=BGVIS2&dlat=%lf&dlon=%lf&dname=%@&dev=0&m=0&t=%@&backScheme=%@",fromCoordinateChina.latitude,fromCoordinateChina.longitude,toCoordinateChina.latitude,toCoordinateChina.longitude,newDest.destinationName,@"0",@"SmerHomer2016"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            bool isBaiduOpen = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            NSLog(@"打开高德APP = %i",isBaiduOpen);
        }]];
        
    }
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
