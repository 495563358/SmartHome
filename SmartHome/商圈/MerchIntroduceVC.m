//
//  MerchIntroduceVC.m
//  SmartHome
//
//  Created by Smart house on 2018/4/26.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import "MerchIntroduceVC.h"
#import "MerchRecommend.h"
#import "MapViewController.h"
#import "ProjectdesignVC.h"
#import "BusinesslicenceVC.h"

//View
#import "MerchentDescCell.h"
#import "MerchentIdeaCell.h"
#import "MerchantCommCell.h"
#import "HBCommentCell.h"

//vender
#import "JZLocationConverter.h"
#import <UShareUI/UShareUI.h>
#import <UMSocialCore/UMSocialCore.h>
#import "UMShareTypeViewController.h"


#define locationMerch @"r=merch.applist.nearby"

@interface MerchIntroduceVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *commentDatas;

@property (nonatomic,assign)BOOL showAll;

@end

#define CommentsInfo @"r=business.appindex.comment"
@implementation MerchIntroduceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@",self.infoDict);
    
    self.view.backgroundColor = My_gray;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, ScreenW, ScreenH+20) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionHeaderHeight = 10;
    _tableView.sectionFooterHeight = 1;
    [self.view addSubview:_tableView];
    
    [self createHeader];
    
    
    [BaseocHttpService postRequest:[ResourceFront stringByAppendingString:CommentsInfo] andParagram:@{@"merchid":_infoDict[@"id"],@"page":@"1",@"order":@""} success:^(id responseObject) {
        NSDictionary *resultInfo = (NSDictionary *)responseObject;
        NSLog(@"res = %@",resultInfo);
        
        if ([resultInfo[@"status"] intValue] == 1) {
            NSArray *arr = resultInfo[@"result"][@"list"];
            self.commentDatas = [NSMutableArray arrayWithArray:arr];
            [_tableView reloadData];
        }
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
    
    //公司名和进入店铺
    UIView *descView = [[UIView alloc]initWithFrame:CGRectMake(0, 202 * Percentage + 10, ScreenW, 74)];
    descView.backgroundColor = [UIColor whiteColor];
    UILabel *companyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, ScreenW - 110, 30)];
    companyNameLabel.text = _infoDict[@"merchname"];
    UILabel *spLabel = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 100, 5, 2, 40)];
    spLabel.backgroundColor = My_gray;
    
    UIButton *goShopBtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 90, 10, 90, 30)];
    goShopBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    goShopBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
    [goShopBtn setTitle:@"进入商铺" forState:UIControlStateNormal];
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
    [telephoneBtn addTarget:self action:@selector(callMerchent) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locaTouched)];
    [locationView addGestureRecognizer:tap];

    
    headerView.frame = CGRectMake(0, 0, ScreenW, locationView.dc_y + locationView.dc_height + 10);
    
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


//跳转到商铺推荐商品页面
-(void)goShopBtnClick{
    MerchRecommend *vc = [MerchRecommend new];
    vc.infoDict = self.infoDict;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 2;
        case 3:
            return self.commentDatas.count + 1;
        default:
            return 1;
    }
    
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            
            CGFloat descHeight = [DCSpeedy dc_calculateTextSizeWithText:_infoDict[@"desc"] WithTextFont:13 WithMaxW:ScreenW - 35].height;
            if (descHeight <= 58.8) {
                //描述少于三行
                return [DCSpeedy dc_calculateTextSizeWithText:_infoDict[@"desc"] WithTextFont:13 WithMaxW:ScreenW - 35].height + 20;
            }else{
                if (_showAll) {
                    //描述展开
                    int line = [DCSpeedy dc_calculateTextSizeWithText:_infoDict[@"desc"] WithTextFont:13 WithMaxW:ScreenW - 35].height/18 - 1 ;
                    
                    if (line == -1) {
                        line = 0;
                    }
                    CGFloat extalH = line * 6;
                    
                    return [DCSpeedy dc_calculateTextSizeWithText:_infoDict[@"desc"] WithTextFont:13 WithMaxW:ScreenW - 35].height + 40 + extalH;
                }else{
                    //描述收起
                    return 58.8 + 40;
                }
            }
            
        }
    }
    
    if (indexPath.section == 2) {
        return 50 + 152 * Percentage + 10;
    }
    
    if (indexPath.section == 3){
        if (indexPath.row != 0) {
            return [self getHeightFormCommentDict:self.commentDatas[indexPath.row - 1]];
        }
    }
    
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pool"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"pool"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
//            cell.imageView.image = [UIImage imageNamed:@"gongsijianz"];
            cell.textLabel.text = @"公司简介";
        }
        else if (indexPath.row == 1){
            //公司介绍
            MerchentDescCell *descCell = [tableView dequeueReusableCellWithIdentifier:@"descpool"];
            if (!descCell) {
                descCell = [[MerchentDescCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"descpool" andDesc:_infoDict[@"desc"] andShow:_showAll];
                descCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            descCell.changeCellHeight = ^(BOOL showAll) {
                _showAll = showAll;
//                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView reloadData];
            };
            return descCell;
        }
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0) {
//            cell.imageView.image = [UIImage imageNamed:@"zhengshu"];
            cell.textLabel.text = @"资质证书";
        }else if (indexPath.row == 1){
//            cell.imageView.image = [UIImage imageNamed:@"gongszcxx"];
            cell.textLabel.text = @"工商注册信息";
        }
    }
    else if (indexPath.section == 2){
        //设计方案
        MerchentIdeaCell *ideaCell = [tableView dequeueReusableCellWithIdentifier:@"ideaCell"];
        if (!ideaCell) {
            ideaCell = [[MerchentIdeaCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ideaCell"];
            ideaCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (_infoDict[@"total"]) {
            ideaCell.totalLab.text = [NSString stringWithFormat:@"全部%@个",_infoDict[@"total"]];
        }
        
        return ideaCell;
    }
    else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            MerchantCommCell *commCell = [[MerchantCommCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"commcell"];
            commCell.totalLab.text = [NSString stringWithFormat:@"共%lu个",(unsigned long)self.commentDatas.count];
            return commCell;
        }
        else{
            HBCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"commentcell%ld",(long)indexPath.row]];
            if (!commentCell) {
                commentCell = [[HBCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"commentcell%ld",(long)indexPath.row] andInfoDict:_commentDatas[indexPath.row - 1]];
            }
            return commentCell;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        ProjectdesignVC *vc = [ProjectdesignVC new];
        vc.urlStr = _infoDict[@"merchurl"];
        vc.titlename = @"公司简介";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            BusinesslicenceVC *busvc = [BusinesslicenceVC new];
            busvc.images = _infoDict[@"bus_licence"];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:busvc animated:YES];
            return;
        }
        else if(indexPath.row == 1){
            ProjectdesignVC *vc = [ProjectdesignVC new];
            vc.urlStr = _infoDict[@"busurl"];
            vc.titlename = @"工商注册信息";
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (indexPath.section == 2){
        //设计方案
        if (_infoDict[@"total"]) {
            if ([_infoDict[@"total"] intValue] > 0) {
                [self goShopBtnClick];
            }
        }
    }
    
}

-(CGFloat)getHeightFormCommentDict:(NSDictionary *)commentinfo{
    
    
    CGFloat height = [commentinfo[@"content"] length]/25 + 1;
    
    CGFloat hh = 65 + 25 * height + 10;
    if ([commentinfo[@"images"] length] > 10) {
        hh += 90;
    }
    if ([commentinfo[@"replay_content"] length] > 0) {
        hh += 30;
    }
    if ([commentinfo[@"append_content"] length] > 0) {
        hh += 30;
    }
    if ([commentinfo[@"append_images"] length] > 10) {
        hh += 90;
    }
    if ([commentinfo[@"append_replay_content"] length] > 0) {
        hh += 30;
    }
    return hh;
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
