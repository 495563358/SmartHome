//
//  MerchRecommend.m
//  SmartHome
//
//  Created by Smart house on 2018/5/3.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import "MerchRecommend.h"
#import "MapViewController.h"
#import "ProductViewControll.h"
#import "ProjectdesignVC.h"

#import "MerchschemeCell.h"
#import "CollectCell.h"

//vender
#import "JZLocationConverter.h"
#import <UShareUI/UShareUI.h>
#import <UMSocialCore/UMSocialCore.h>
#import "UMShareTypeViewController.h"

@interface MerchRecommend ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *schemesDatas;
@property (nonatomic,strong)NSMutableArray *goodsDatas;

@end

#define locationMerch @"r=merch.applist.nearby"
#define ProductsInfo @"r=business.appindex.goods"
#define ShopInfo @"r=business.appindex"

@implementation MerchRecommend

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@",self.infoDict);
    
    if ([self.infoDict[@"article"] isKindOfClass:NSArray.class]) {
        self.schemesDatas = self.infoDict[@"article"];
    }else{
        self.schemesDatas = [NSMutableArray new];
    }
    
    self.view.backgroundColor = My_gray;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, ScreenW, ScreenH+20) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionHeaderHeight = 40;
    _tableView.sectionFooterHeight = 1;
    [self.view addSubview:_tableView];
    
    [self createHeader];
    
    
    
    [BaseocHttpService postRequest:[ResourceFront stringByAppendingString:ProductsInfo] andParagram:@{@"merchid":_infoDict[@"id"]} success:^(id responseObject) {
        NSDictionary *resultInfo = (NSDictionary *)responseObject;
        NSLog(@"res = %@",resultInfo);
        if ([resultInfo[@"status"] intValue] == 1) {
            NSArray *arr = resultInfo[@"result"][@"goods"];
            self.goodsDatas = [NSMutableArray arrayWithArray:arr];
        }
        [_tableView reloadData];
    }];
    

}

- (void)createHeader{
    UIView *headerView = [UIView new];
    headerView.backgroundColor = My_gray;
    //图片展示
    UIImageView *merchBanner = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 202 * Percentage)];
    merchBanner.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[AddressPath stringByAppendingString:_infoDict[@"imgfile"]]]]];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 25, 40, 40)];
//    backBtn.backgroundColor = My_gray;
//    backBtn.layer.cornerRadius = 20;
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenW - 40 - 15, 25, 40, 40)];
    [shareBtn setImage:[UIImage imageNamed:@"fenxiang_bai"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareToOther) forControlEvents:UIControlEventTouchUpInside];
    
    //公司名和商家简介
    UIView *descView = [[UIView alloc]initWithFrame:CGRectMake(0, 202 * Percentage + 10, ScreenW, 74)];
    descView.backgroundColor = [UIColor whiteColor];
    UILabel *companyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, ScreenW - 110, 30)];
    companyNameLabel.text = _infoDict[@"merchname"];
    UILabel *spLabel = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 100, 5, 2, 40)];
    spLabel.backgroundColor = My_gray;
    
    UIButton *goShopBtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 90, 10, 90, 30)];
    goShopBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    goShopBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
    [goShopBtn setTitle:@"商家简介" forState:UIControlStateNormal];
    [goShopBtn addTarget:self action:@selector(goShopBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [goShopBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    UIImageView *nextImgtip = [[UIImageView alloc]initWithFrame:CGRectMake(Sc_w - 20, 18, 7, 13)];
    nextImgtip.image = [UIImage imageNamed:@"gengduo"];
    
    [self createFlagAndScore:_infoDict andView:descView];
    //位置 电话
    UIView *locationView = [[UIView alloc]initWithFrame:CGRectMake(0, descView.dc_y + descView.dc_height + 1, ScreenW, 47)];
    locationView.backgroundColor = [UIColor whiteColor];
    UIImageView *locaImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 13, 16, 20)];
    locaImage.image = [UIImage imageNamed:@"weiz"];
    
    UILabel *detilAddr = [[UILabel alloc]initWithFrame:CGRectMake(48, 13, Sc_w - 100, 20)];
    detilAddr.font = [UIFont systemFontOfSize:13];
    detilAddr.text = _infoDict[@"address"];
    
    UIButton *telephoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenW - 60, 0, 47, 47)];
    [telephoneBtn setImage:[UIImage imageNamed:@"merch_dianhua"] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locaTouched)];
    [locationView addGestureRecognizer:tap];
    
    
    headerView.frame = CGRectMake(0, 0, ScreenW, locationView.dc_y + locationView.dc_height);
    
    [headerView addSubview:merchBanner];
    [headerView addSubview:backBtn];
    [headerView addSubview:shareBtn];
    [descView addSubview:companyNameLabel];
    [descView addSubview:spLabel];
    [descView addSubview:goShopBtn];
    [descView addSubview:nextImgtip];
    [headerView addSubview:descView];
    [locationView addSubview:locaImage];
    [locationView addSubview:detilAddr];
    [locationView addSubview:telephoneBtn];
    [locationView addSubview:locaImage];
    [headerView addSubview:locationView];
    
    _tableView.tableHeaderView = headerView;
}

-(void)shareToOther{
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self runShareWithType:platformType];
    }];
}


- (void)runShareWithType:(UMSocialPlatformType)type{
    UMShareTypeViewController *VC = [[UMShareTypeViewController alloc] initWithType:type];
    VC.titleName = _infoDict[@"merchname"];
    VC.typeName = _infoDict[@"salecate"];
    VC.shareLink = _infoDict[@"shopurl"];
    VC.imageUrl = [AddressPath stringByAppendingString:_infoDict[@"logo"]];
    [VC shareWebPageToPlatformType:type];
}

-(void)createFlagAndScore:(NSDictionary *)dict andView:(UIView *)parentView{
    CGFloat hh = 50;
    CGFloat spaceX = 15;
    if ([dict[@"istop"] intValue] == 1) {
        UIImageView *top = [[UIImageView alloc]initWithFrame:CGRectMake(spaceX, hh, 45, 15)];
        top.image = [UIImage imageNamed:@"sq_renzheng"];
        spaceX += 50;
        [parentView addSubview:top];
    }
    
    if ([dict[@"levelname"] isEqualToString:@"加盟"] || [dict[@"levelname"] isEqualToString:@"代理"]) {
        UILabel *level = [[UILabel alloc]initWithFrame:CGRectMake(spaceX, hh, 49, 15)];
        level.layer.cornerRadius = 2;
        level.layer.masksToBounds = YES;
        level.layer.borderWidth = 1;
        level.layer.borderColor = [UIColor colorWithRed:254.0/255.0 green:166.0/255.0 blue:14.0/255.0 alpha:1.0].CGColor;
        level.textColor = [UIColor colorWithRed:254.0/255.0 green:166.0/255.0 blue:14.0/255.0 alpha:1.0];
        level.font = [UIFont systemFontOfSize:11];
        level.textAlignment = NSTextAlignmentCenter;
        level.text = [NSString stringWithFormat:@"%@%@年",dict[@"levelname"],dict[@"year"]];
        
        spaceX += 55;
        [parentView addSubview:level];
    }
    
    if ([dict[@"tastename"] isEqualToString:@"体验馆"]) {
        UILabel *recommand = [[UILabel alloc] initWithFrame:CGRectMake(spaceX, hh, 70, 15)];
        recommand.font = [UIFont systemFontOfSize:11];
        recommand.text = @"智能屋体验馆";
        recommand.layer.cornerRadius = 2;
        recommand.layer.masksToBounds = YES;
        recommand.layer.borderWidth = 1;
        recommand.layer.borderColor = [UIColor colorWithRed:253.0/255.0 green:104.0/255.0 blue:104.0/255.0 alpha:1.0].CGColor;
        recommand.textColor = [UIColor colorWithRed:253.0/255.0 green:104.0/255.0 blue:104.0/255.0 alpha:1.0];
        recommand.textAlignment = NSTextAlignmentCenter;
        
        spaceX += 76;
        [parentView addSubview:recommand];
    }
    
    int starNum = [dict[@"start"] intValue];
    if (starNum) {
        for (int i = 0; i<5; i++) {
            UIImageView *starImg = [[UIImageView alloc] initWithFrame:CGRectMake(spaceX, hh+1, 13, 13)];
            [parentView addSubview:starImg];
            spaceX += 15;
            
            if (i < starNum) {
                starImg.image = [UIImage imageNamed:@"merch_pinggjia_hongs"];
            }else
                starImg.image = [UIImage imageNamed:@"merch_pingjia_weixuan"];
            
        }
        UILabel *scoreL = [[UILabel alloc]initWithFrame:CGRectMake(spaceX, hh, 250, 15)];
        scoreL.textColor = [UIColor grayColor];
        scoreL.font = [UIFont systemFontOfSize:12];
        scoreL.text = [NSString stringWithFormat:@"%i分",starNum];
        [parentView addSubview:scoreL];
    }else{
        UILabel *scoreL = [[UILabel alloc]initWithFrame:CGRectMake(spaceX, hh, 250, 15)];
        scoreL.textColor = [UIColor grayColor];
        scoreL.font = [UIFont systemFontOfSize:12];
        scoreL.text = @"评分不足";
        [parentView addSubview:scoreL];
    }
    
}


-(void)goShopBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}


//商户导航
-(void)locaTouched{
    NSDictionary *postInfo = @{@"lng":_infoDict[@"lng"],@"lat":_infoDict[@"lat"]};
    [BaseocHttpService postRequest:[ResourceFront stringByAppendingString:locationMerch] andParagram:postInfo success:^(id responseObject) {
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
            MapViewController *maps = [MapViewController new];
            maps.nearbyInfos = marr;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:maps animated:YES];
        }
    }];
}

//打电话
-(void)callMerchent{
    NSString *telstr = [NSString stringWithFormat:@"tel:%@",_infoDict[@"mobile"]];
    UIWebView * callWebview = [[UIWebView alloc]init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:telstr]]];
    [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.schemesDatas.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == self.schemesDatas.count) {
        return self.goodsDatas.count;
    }
    
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section < self.schemesDatas.count) {
        return [MerchschemeCell getCellHeight];
    }
    
    if (indexPath.section == self.schemesDatas.count) {
        return 115;
    }
    
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 && self.schemesDatas.count != 0) return 40;
    if (section == self.schemesDatas.count) return 40;
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[NSString stringWithFormat:@"headerViewsecion=%i",section]];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:[NSString stringWithFormat:@"headerViewsecion=%i",section]];
        if (section == 0 && self.schemesDatas.count != 0) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 39)];
            label.backgroundColor = My_gray;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = Color_system;
            label.font = [UIFont systemFontOfSize:14];
            label.text = @"—— 店铺推荐 ——";
            [headerView addSubview:label];
        }
        if (section == self.schemesDatas.count) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 39)];
            label.backgroundColor = My_gray;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = Color_system;
            label.font = [UIFont systemFontOfSize:14];
            label.text = @"—— 全部产品 ——";
            [headerView addSubview:label];
        }
        
    }
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pool"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"pool"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    //设计方案
    if (indexPath.section < self.schemesDatas.count) {
        NSDictionary *schemeInfo = self.schemesDatas[indexPath.section];
        
        MerchschemeCell *schemeCell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"schemesPool=%@",schemeInfo[@"id"]]];
        if (!schemeCell) {
            schemeCell = [[MerchschemeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"schemesPool=%@",schemeInfo[@"id"]]];
            schemeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (![schemeInfo[@"id"] isEqualToString:@"default"]) {
                [schemeCell configcell:schemeInfo];
            }
        }
        return schemeCell;
    }
    //店铺商品数据
    if (indexPath.section == self.schemesDatas.count) {
        CollectCell *goodsCell = [tableView dequeueReusableCellWithIdentifier:@"goodsPool"];
        if (!goodsCell) {
            goodsCell = [[CollectCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"goodsPool"];
        }
        
        NSDictionary *goodsInfo = self.goodsDatas[indexPath.row];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[AddressPath stringByAppendingString:goodsInfo[@"thumb"]]]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                goodsCell.imageview.image = image;
            });
        });
        goodsCell.titleL.text = goodsInfo[@"title"];
        goodsCell.price.text = [ NSString stringWithFormat:@"￥ %@",goodsInfo[@"marketprice"]];
        goodsCell.shareBtn.hidden = YES;
        goodsCell.deldBtn.hidden = YES;
        goodsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return goodsCell;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == self.schemesDatas.count){
        ProductViewControll *vc = [[ProductViewControll alloc]init];
        vc.productID = _goodsDatas[indexPath.row][@"id"];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    else{
        NSDictionary *schemeDict = self.schemesDatas[indexPath.section];
        if (![schemeDict[@"id"] isEqualToString:@"default"]) {
            ProjectdesignVC *vc = [ProjectdesignVC new];
            vc.urlStr = [NSString stringWithFormat:@"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=article&aid=%@",schemeDict[@"id"]];
            vc.titlename = schemeDict[@"article_title"];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
    }
}

-(void)backToFront{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    //    self.navigationController.navigationBar.translucent = YES;
    //    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    //    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

@end
