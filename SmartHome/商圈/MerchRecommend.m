//
//  MerchRecommend.m
//  SmartHome
//
//  Created by Smart house on 2018/5/3.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import "MerchRecommend.h"

#import "MerchschemeCell.h"
#import "CollectCell.h"

@interface MerchRecommend ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *schemesDatas;
@property (nonatomic,strong)NSMutableArray *goodsDatas;

@end

#define ProductsInfo @"r=business.appindex.goods"

@implementation MerchRecommend

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@",self.infoDict);
    
    self.schemesDatas = [NSMutableArray arrayWithArray:@[@1,@2]];
    
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
    UIImageView *merchBanner = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 172 * Percentage)];
    merchBanner.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[AddressPath stringByAppendingString:_infoDict[@"imgfile"]]]]];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 35, 40, 40)];
    backBtn.backgroundColor = My_gray;
    backBtn.layer.cornerRadius = 20;
    [backBtn setImage:[UIImage imageNamed:@"fanhui-hui"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToFront) forControlEvents:UIControlEventTouchUpInside];
    
    //公司名和商家简介
    UIView *descView = [[UIView alloc]initWithFrame:CGRectMake(0, 172 * Percentage + 10, ScreenW, 74)];
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

-(void)goShopBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
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
        MerchschemeCell *schemeCell = [tableView dequeueReusableCellWithIdentifier:@"schemesPool"];
        if (!schemeCell) {
            schemeCell = [[MerchschemeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"schemesPool"];
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
    
    
    
//    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            cell.imageView.image = [UIImage imageNamed:@"gongsijianz"];
//            cell.textLabel.text = @"公司简介";
//        }
//        else if (indexPath.row == 1){
//            //公司介绍
//            MerchentDescCell *descCell = [tableView dequeueReusableCellWithIdentifier:@"descCell"];
//            if (!descCell) {
//                descCell = [[MerchentDescCell alloc] initWithDesc:_infoDict[@"desc"]];
//            }
//            return descCell;
//        }
//    }
//    else if (indexPath.section == 1){
//        if (indexPath.row == 0) {
//            cell.imageView.image = [UIImage imageNamed:@"zhengshu"];
//            cell.textLabel.text = @"资质证书❤️";
//        }else if (indexPath.row == 1){
//            cell.imageView.image = [UIImage imageNamed:@"gongszcxx"];
//            cell.textLabel.text = @"工商注册信息";
//        }
//    }
//    else if (indexPath.section == 2){
//        //设计方案
//        MerchentIdeaCell *ideaCell = [tableView dequeueReusableCellWithIdentifier:@"ideaCell"];
//        if (!ideaCell) {
//            ideaCell = [[MerchentIdeaCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ideaCell"];
//        }
//        return ideaCell;
//    }
//    else if (indexPath.section == 3){
//        if (indexPath.row == 0) {
//            MerchantCommCell *commCell = [[MerchantCommCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"commcell"];
//            return commCell;
//        }
//        else{
//            HBCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"commentcell%d",indexPath.row]];
//            if (!commentCell) {
//                commentCell = [[HBCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"commentcell%d",indexPath.row] andInfoDict:_commentDatas[indexPath.row - 1]];
//            }
//            return commentCell;
//        }
//    }
    return cell;
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
