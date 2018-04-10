//
//  ProductViewControll.m
//  SmartMall
//
//  Created by Smart house on 2017/8/22.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "ProductViewControll.h"
#import "MyOrderTopTabBar.h"
#import "LoadViewController.h"
#import "ChoseView.h"
#import "ShopListViewController.h"
#import "LoadingView.h"
#import "DiscountCell.h"
#import "QuickbuyController.h"

// Models
#import "DCCommentsItem.h"
// Views
#import "DCComHeadView.h"
#import "DCCommentsCntCell.h"
#import "ProductImageCell.h"
// Vendors
#import "MJExtension.h"
#import "CABasicAnimation+Category.h"
#import <CommonCrypto/CommonDigest.h>
#import "MBProgressHUD.h"
#import "SDCycleScrollView.h"
#import "ObjectTools.h"
#import "UIView+Toast.h"
#import "MJRefresh.h"

//友盟
#import <UShareUI/UShareUI.h>
#import <UMSocialCore/UMSocialCore.h>
#import "UMShareTypeViewController.h"

//检查是否登录
#define checkLoadAddr @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=member.appinfo"
//商品信息
#define ProductAdress @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=goods.product.iosgoods&id="
#define ShareAddress @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=goods.detail&id="
#define ProductAdress1 @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=goods.product.querygoods&id="
//是否收藏
#define ProductCollection @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=goods.product.queryfav"
//添加删除收藏
#define ProductAddCollection @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=goods.product.updatefav"
//添加到购物车
#define ShopCarAddPath @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=member.appcart.add"
//获取可用优惠券
#define FindDiscountCoupons @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=goods.product.querycoupons"
//获取可用优惠券
#define GetDiscountCoupons @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=goods.product.addcoupon"
//立即购买
#define NowBuy @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.appcreate"
//获取评论
#define getComment @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=goods.product.get_comment_list"

static NSString *const DCCommentsCntCellID = @"DCCommentsCntCell";
static NSString *const ProductImagesCellID = @"ProductImagesCell";

@interface ProductViewControll ()<UITableViewDataSource,UITableViewDelegate,MyOrderTopTabBarDelegate,TypeSeleteDelegete>
{
    BOOL _isLoad;
    NSString *_userToken;
    ChoseView *choseView;
    UIView *bgview;
    CGPoint center;
    NSMutableArray *sizearr;//型号数组
    NSMutableArray *colorarr;//分类数组
    NSDictionary *stockarr;//商品库存量
    int goodsStock;
    //颜色
    NSArray *specs;
    //套餐
    NSArray *options;
    //优惠券tableView
    UITableView *couponTableview;
    //优惠券
    UIView *couponView;
    //商品种类
    NSString *optionid;
    id shareImgUrlStr;//分享图片
    //加入购物车还是购买
    long isShopcarOrBuy;
    //获取评论的字段
    NSMutableString *commentStr;
    //记录上一次点击的评论
    UIButton *commentlastBtn;
}
//商品滚动
@property(nonatomic,strong)SDCycleScrollView *productScroll;
//图片列表
@property(nonatomic,strong)NSMutableArray *imageGroup;
//内容图片
@property(nonatomic,strong)NSMutableArray<UIImage *> *contentImage;
//评论视图
@property(nonatomic,strong)UIView *commentBtnView;
//没有评论提示label
@property(nonatomic,strong)UILabel *noCommentContentLab;
//主tableview
@property(nonatomic,strong)UITableView *tableview;
//评论tableview
@property(nonatomic,strong)UITableView *commentTabel;
//厂家指导价格
@property(nonatomic,copy)NSString *beforePrice;
//种类名称
@property(nonatomic,copy)NSString *typeName;
//产品名称
@property(nonatomic,copy)NSString *productName;
//当前售价
@property(nonatomic,copy)NSString *price;
//邮费
@property(nonatomic,copy)NSString *sendPrice;
//库存
@property(nonatomic,copy)NSString *haveCount;
//销量
@property(nonatomic,copy)NSString *saleCount;
//主tableview返回高度
@property(nonatomic,assign)CGFloat imageY;
//商品参数数据
@property(nonatomic,strong)NSArray *paramData;
//详情 参数 评价
@property(nonatomic,assign)NSInteger switchIndex;
//详情 参数 评价
@property(nonatomic,weak)MyOrderTopTabBar *TopTabBar;
//收藏
@property(nonatomic,strong)UIButton *likeBtn;
//收藏ID
@property(nonatomic,copy)NSString *favid;
//收藏数据
@property(nonatomic,copy)NSDictionary *favDict;
//是否收藏
@property(nonatomic,assign)int isfav;
//优惠券数据
@property(nonatomic,strong)NSMutableArray *discountData;
/* 评论数据 */
@property (strong , nonatomic)NSMutableArray<DCCommentsItem *> *commentsItem;
@end

@implementation ProductViewControll

#pragma mark - Lazy load
//评论数据
- (NSMutableArray<DCCommentsItem *> *)commentsItem
{
    if (!_commentsItem) {
        _commentsItem = [NSMutableArray array];
    }
    return _commentsItem;
}
//评论按钮
-(UIView *)commentBtnView{
    if (!_commentBtnView) {
        _commentBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Sc_w, 50)];
        NSArray *arr = @[@"全部",@"好评",@"中评",@"差评",@"晒图"];
        CGFloat btnW = Sc_w/5;
        for (int i = 0; i<5; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(btnW * i, 0, btnW, 40)];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:Color_system forState:UIControlStateSelected];
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [_commentBtnView addSubview:btn];
            btn.tag = i+1;
            [btn addTarget:self action:@selector(changecommentstr:) forControlEvents:UIControlEventTouchUpInside];
            if(i==0){
                btn.selected = YES;
                commentlastBtn = btn;
            }
        }
    }
    return _commentBtnView;
}
//评论视图
-(UITableView *)commentTabel{
    if (!_commentTabel) {
        _commentTabel = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, Sc_w,Sc_h - 230) style:UITableViewStylePlain];
        
        _commentTabel.dataSource = self;
        _commentTabel.delegate = self;
        _commentTabel.tag = 3;
        _commentTabel.separatorStyle = UITableViewCellSeparatorStyleNone;
        //注册
        [_commentTabel registerNib:[UINib nibWithNibName:NSStringFromClass([DCCommentsCntCell class]) bundle:nil] forCellReuseIdentifier:DCCommentsCntCellID];
    }
    return _commentTabel;
}
//没有评论提示
-(UILabel *)contentLab{
    if (!_noCommentContentLab) {
        _noCommentContentLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 51, Sc_w, 60)];
        _noCommentContentLab.textColor = [UIColor grayColor];
        _noCommentContentLab.text = @"暂时没有任何评价";
        _noCommentContentLab.font = [UIFont systemFontOfSize:14];
        _noCommentContentLab.textAlignment = NSTextAlignmentCenter;
    }
    return _noCommentContentLab;
}

-(void)shareBtnClick:(UIButton *)sender{
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self runShareWithType:platformType];
    }];
}


- (void)runShareWithType:(UMSocialPlatformType)type{
    UMShareTypeViewController *VC = [[UMShareTypeViewController alloc] initWithType:type];
    VC.titleName = _productName;
    VC.typeName = _typeName;
    VC.shareLink = [ShareAddress stringByAppendingString:self.productID];
    VC.imageUrl = shareImgUrlStr;
    [VC shareWebPageToPlatformType:type];
}

//优惠券信息
-(NSMutableArray *)discountData{
    if (!_discountData) {
        _discountData = [NSMutableArray array];
    }
    return _discountData;
}
//详情 参数 评价
-(NSInteger)switchIndex{
    if (!_switchIndex) {
        _switchIndex = 0;
    }return _switchIndex;
}

-(NSMutableArray *)imageGroup{
    if (!_imageGroup) {
        _imageGroup = [NSMutableArray array];
    }return _imageGroup;
}

-(NSMutableArray *)contentImage{
    if (!_contentImage) {
        _contentImage = [NSMutableArray array];
    }return _contentImage;
}

//判断登录是否有效
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    
    _isLoad = NO;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    _userToken = [user objectForKey:@"userToken"];
    if (!_userToken)
        return;
    
    NSString *nonce = [self GetNonce];
    NSString *timestamp = [self getNowTimeTimestamp];
    NSString *signStr = [NSString stringWithFormat:@"token=%@&12345",_userToken];
    NSString *sign = [self MD5:signStr];
    
    NSDictionary *dict1 = @{@"nonce":nonce,@"timestamp":timestamp,@"token":_userToken,@"sign":sign};
    //    获取token
    [[ObjectTools sharedManager] POST:checkLoadAddr parameters:dict1 progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *returnInfo = (NSDictionary *)responseObject;
        NSString *mobile = returnInfo[@"mobile"];
        //token过期
        if (mobile.length < 7) {
            NSString *userToken = nil;
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:userToken forKey:@"userToken"];
            [user synchronize];
        }else{
            _isLoad = YES;
            NSLog(@"登录状态有效");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:@"请检查网络后重试"];
    }];
    
    [self requestCollect];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品详情";
    self.navigationController.navigationBar.hidden = YES;
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, Sc_w, Sc_h+20) style:UITableViewStyleGrouped];
    
    _tableview.tag = 1;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableHeaderView = self.productScroll;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableview registerClass:[ProductImageCell class] forCellReuseIdentifier:ProductImagesCellID];
    [self.view addSubview:_tableview];
    
    [self downLoad];//下载图片数据资源
    _tableview.sectionFooterHeight = 0.1;
    
    NSLog(@"进入了商品详情页面ID = %@",self.productID);
    
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
    [header setRefreshingTarget:self refreshingAction:@selector(headerWay)];
    self.tableview.mj_header = header;
    
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
}

-(void)headerWay{
    self.switchIndex = 0;
    [self.tableview.mj_header endRefreshing];
}

-(void)backhuiClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//请求收藏
-(void)requestCollect{
    
    if (!_userToken)
        return;
    
    NSString *LoadPath = ProductCollection;
    NSString *nonce = [self GetNonce];
    NSString *timestamp = [self getNowTimeTimestamp];
    NSString *signStr = [NSString stringWithFormat:@"token=%@&12345",_userToken];
    NSString *sign = [self MD5:signStr];
    
    NSDictionary *dict = @{@"nonce":nonce,@"timestamp":timestamp,@"token":_userToken,@"sign":sign,@"goodsid":self.productID};
    
    
    [[ObjectTools sharedManager] POST:LoadPath parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSDictionary *result = dict[@"result"];
        NSLog(@"收藏返回 = %@",result);
        
        int flag = [result[@"isfav"] intValue];
        
        self.favid = result[@"favid"];
        
        NSLog(@"%@favid",_favid);
        
        self.isfav = flag;
        
        if (flag == 2) {
            [self.likeBtn setImage:[UIImage imageNamed:@"shouc-xuanz"] forState:UIControlStateNormal];
            self.likeBtn.tag++;
            NSLog(@"用户已经收藏");
        }else if(flag == 3){
            NSLog(@"用户以前收藏过");
        }else{
            NSLog(@"未收藏过");
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:@"请检查网络后重试"];
    }];
    
}

//收藏点击事件
-(void)likeClick:(UIButton *)sender{
    
    
    if (!_isLoad) {
        LoadViewController *vc = [[LoadViewController alloc]init];
        
        vc.isHideSelfOrTurntoUsercenter = YES;
        self.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    NSString *nonce = [self GetNonce];
    NSString *timestamp = [self getNowTimeTimestamp];
    NSString *signStr = [NSString stringWithFormat:@"token=%@&12345",_userToken];
    NSString *sign = [self MD5:signStr];
    NSLog(@"%i",_isfav);
    if (_isfav == 1) {
        //从未收藏过
        self.favDict = @{@"nonce":nonce,@"timestamp":timestamp,@"token":_userToken,@"sign":sign,@"goodsid":self.productID,@"isfav":@"1"};
        _isfav = 2;
    }else{
        
        if (_isfav == 2) {
            _isfav = 3;
        }else
            _isfav = 2;
        
        self.favDict = @{@"nonce":nonce,@"timestamp":timestamp,@"token":_userToken,@"sign":sign,@"isfav":[NSString stringWithFormat:@"%i",_isfav],@"favid":self.favid};
    }
    
    NSLog(@"%@",_favDict);
    
    [[ObjectTools sharedManager] POST:ProductAddCollection parameters:_favDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSLog(@"%@ -- ",dict);
        
        
        if ([dict[@"result"] objectForKey:@"favid"]) {
            self.favid = [dict[@"result"] objectForKey:@"favid"];
        }
        
        
        NSLog(@"favid = %@",_favid);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:@"请检查网络后重试"];
    }];
    
    if (sender.tag == 520) {
        [sender setImage:[UIImage imageNamed:@"shouc-xuanz"] forState:UIControlStateNormal];
        sender.tag++;
    }else{
        [sender setImage:[UIImage imageNamed:@"weishouc"] forState:UIControlStateNormal];
        sender.tag--;
    }
}

-(NSString *)GetNonce{
    NSArray *arr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    
    NSMutableString *mStr = [[NSMutableString alloc]init];
    for (int i = 0; i < 16; i++) {
        int x = arc4random()%36;
        [mStr appendString:arr[x]];
    }
    return mStr;
}

- (NSString *)MD5:(NSString *)mdStr{
    const char *original_str = [mdStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (int)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

- (NSString *)getNowTimeTimestamp{
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
    
}

//高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 2)
    {
        return 100;
    }
    else if (tableView.tag == 3)
    {
        return _commentsItem[indexPath.row].cellHeight;
    }
    
    //第二组
    if (indexPath.section == 1 && indexPath.row == 0){
        return 50;
    }
    else if (indexPath.section == 1 && indexPath.row >= 1)
    {
        //商品详情
        if (self.switchIndex == 0)
        {
            return self.contentImage[indexPath.row - 1].size.height/2;
        }
        return _imageY;
    }else
        return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 50;
    }
    return 0.1;
}

//有多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //优惠券和评论
    if (tableView.tag == 2 ||tableView.tag == 3)
    {
        return 1;
    }
    return 2;
}

//每组多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //优惠券
    if (tableView.tag == 2)
    {
        return self.discountData.count;
    }
    //评论
    else if (tableView.tag == 3)
    {
        return _commentsItem.count;
    }
    //商品详情
    if (section == 0)
    {
        return 2;
    }
    //详情 参数 评论
    switch (self.switchIndex) {
        case 0:
            return self.contentImage.count + 1;
        case 1:
            return 2;
        default:
            return 2;
    }
    
}


//cell内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //最外层表视图
    if (tableView.tag == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"pool%d%d%i",indexPath.section,indexPath.row,self.switchIndex]];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"pool%d%d%i",indexPath.section,indexPath.row,self.switchIndex]];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        //第一组
        if (indexPath.section == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (indexPath.row == 1) {
                cell.textLabel.text = @"领取优惠券";
            }else
                cell.textLabel.text = @"请选择套装、颜色数量等";
        }
        //第二组 第一列
        else if (indexPath.section == 1 && indexPath.row == 0){
            //如果存在就直接返回
            if(self.TopTabBar)  {
                [self.TopTabBar removeFromSuperview];
                [cell.contentView addSubview:self.TopTabBar];
                return cell;
            }
            NSArray* array  = @[@"详情",@"参数",@"评价"];
            //初始化顶部导航标题
            MyOrderTopTabBar* tabBar = [[MyOrderTopTabBar alloc] initWithArray:array];
            tabBar.frame = CGRectMake(0,0, Sc_w, 50);
            tabBar.backgroundColor = [UIColor whiteColor];
            tabBar.delegate = self;
            self.TopTabBar = tabBar;
            [cell.contentView addSubview:self.TopTabBar];
        }
        //第二组 第二列
        else if (indexPath.section == 1 && indexPath.row >= 1){
            
            if (self.switchIndex == 0) {
                ProductImageCell *contentCell = [tableView dequeueReusableCellWithIdentifier:ProductImagesCellID forIndexPath:indexPath];
                contentCell.mainImg = _contentImage[indexPath.row-1];
                return contentCell;
            }
            
            self.imageY = 0;
            
            for (UIView *view in cell.contentView.subviews) {
                [view removeFromSuperview];
            }
            
            if (self.switchIndex == 1){
                if (self.paramData.count > 0) {
                    for (NSDictionary *dict in _paramData) {
                        NSString *title = dict[@"title"];
                        NSString *value = dict[@"value"];
                        
                        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, _imageY, Sc_w/4, 40)];
                        titleLab.font = [UIFont systemFontOfSize:16];
                        titleLab.numberOfLines = 0;
                        titleLab.text = title;
                        
                        UILabel *valueLab = [[UILabel alloc]initWithFrame:CGRectMake(titleLab.frame.size.width + 10, _imageY, Sc_w - titleLab.frame.size.width - 20, 40)];
                        valueLab.numberOfLines = 0;
                        valueLab.font = [UIFont systemFontOfSize:15];
                        valueLab.textColor = [UIColor grayColor];
                        valueLab.text = value;
                        
                        _imageY += 40;
                        
                        [cell.contentView addSubview:titleLab];
                        [cell.contentView addSubview:valueLab];
                    }
                }
                
            }
            
            if (self.switchIndex == 2) {
                
                [cell.contentView addSubview:self.commentBtnView];
                
                [cell.contentView addSubview:self.commentTabel];
                
                [cell.contentView addSubview:self.noCommentContentLab];
                _imageY = Sc_h - 190;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    //优惠券
    if (tableView.tag == 2) {
        DiscountCell *discountCell = [tableView dequeueReusableCellWithIdentifier:@"pool2"];
        if (!discountCell) {
            discountCell = [[DiscountCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"pool2"];
        }
        NSDictionary *dict = self.discountData[indexPath.row];
        
        discountCell.getBtn.hidden = NO;
        
        discountCell.backView.image = [UIImage imageNamed:@"yhqBackW"];
        
        discountCell.staleImg.hidden = YES;
        
        discountCell.getBtn.tag = indexPath.row;
        
        discountCell.priceBigger.text = dict[@"backmoney"];
        discountCell.moneyTitle.text = dict[@"couponname"];
        discountCell.deadLine.text = [NSString stringWithFormat:@"有效期：%@",dict[@"timestr"]];
        
        
        discountCell.getBlock = ^(UIButton *sender){
            
            NSLog(@"sender.tag = %ld",sender.tag);
            
            [self getDicountCouponClick:sender];
            sender.backgroundColor = My_gray;
            sender.userInteractionEnabled = NO;
            [sender setTitle:@"已领取" forState:UIControlStateNormal];
            [sender setTitleColor:Color_system forState:UIControlStateNormal];
            
            
        };
        discountCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return discountCell;
    }
    
    //评论
    if(tableView.tag == 3){
        
        DCCommentsCntCell *cell = [tableView dequeueReusableCellWithIdentifier:DCCommentsCntCellID forIndexPath:indexPath];
        cell.commentsItem = _commentsItem[indexPath.row];
        return cell;
        
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pool3"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"pool3"];
    }
    return cell;
}

//查看什么类型的评论
-(void)changecommentstr:(UIButton *)sender{
    
    if(sender.selected)
        return;
    if(commentlastBtn){
        commentlastBtn.selected = NO;
    }
    sender.selected = YES;
    commentlastBtn = sender;
    commentStr = [NSMutableString new];
    if(sender.tag == 1)
        commentStr = [NSMutableString stringWithString:@""];
    else if(sender.tag == 2)
        commentStr = [NSMutableString stringWithString:@"good"];
    else if(sender.tag == 3)
        commentStr = [NSMutableString stringWithString:@"normal"];
    else if(sender.tag == 4)
        commentStr = [NSMutableString stringWithString:@"bad"];
    else if(sender.tag == 5)
        commentStr = [NSMutableString stringWithString:@"pic"];
    
    NSDictionary *dict = @{@"id":self.productID,@"page":@"1",@"level":commentStr};
    [[ObjectTools sharedManager] POST:getComment parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"评论 = %@",result);
        NSDictionary *commentData = result[@"result"];
        if([commentData[@"list"] count] == 0){
            _commentTabel.hidden = YES;
            self.noCommentContentLab.hidden = NO;
            [self.view makeToast:@"目前还没有评论信息 - - "];
        }else{
            [self.commentsItem removeAllObjects];
            for(NSDictionary *commentInfo in commentData[@"list"]){
                DCCommentsItem *item = [[DCCommentsItem alloc] initWithCommentInfo:commentInfo];
                [self.commentsItem addObject:item];
            }
            [_commentTabel reloadData];
            _commentTabel.hidden = NO;
            //            self.noCommentContentLab.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}




//选择事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1) {
        if (indexPath.section == 0) {
            //选择套餐，颜色
            if (indexPath.row == 0) {
                UIButton *isbtn = [UIButton new];
                isbtn.tag = 1;
                [self addShoppingCar:isbtn];
            }
            //领取优惠券
            if (indexPath.row == 1) {
                
                [self getDiscount];
            }
        }
    }
    
    
    
}


-(void)tabBar:(MyOrderTopTabBar *)tabBar didSelectIndex:(NSInteger)index{
    NSLog(@"%ld",index);
    self.switchIndex = index;
    
    if (index == 2) {
        [self changecommentstr:commentlastBtn];
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:1 inSection:1];
    }
    [self.tableview reloadData];
    //    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:1 inSection:1];
    //    [self.tableview reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationLeft];
}

-(void)shopList{
    
    ShopListViewController *car = [[ShopListViewController alloc]init];
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:car animated:YES];
    
}

/**
 领取优惠券点击事件
 */
-(void)getDicountCouponClick:(UIButton *)sender{
    
    if (!_isLoad) {
        LoadViewController *vc = [[LoadViewController alloc]init];
        
        vc.isHideSelfOrTurntoUsercenter = YES;
        self.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    
    
    NSString *LoadPath = GetDiscountCoupons;
    NSString *nonce = [self GetNonce];
    NSString *timestamp = [self getNowTimeTimestamp];
    NSString *signStr = [NSString stringWithFormat:@"token=%@&12345",_userToken];
    NSString *sign = [self MD5:signStr];
    
    NSString *couponID = [self.discountData[sender.tag] objectForKey:@"id"];
    
    NSDictionary *dict = @{@"nonce":nonce,@"timestamp":timestamp,@"token":_userToken,@"sign":sign,@"id":couponID};
    
    
    [[ObjectTools sharedManager] POST:LoadPath parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        
        NSLog(@" 领取返回结果----%@",dict);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:@"请检查网络后重试"];
        
    }];
    
}


/**
 获取可领取的优惠券
 */
-(void)getDiscount{
    
    [self createGetDiscountCoupons];
    
    
    if (self.discountData.count > 0) {
        return;
    }
    
    
    if (!_isLoad) {
        LoadViewController *vc = [[LoadViewController alloc]init];
        
        vc.isHideSelfOrTurntoUsercenter = YES;
        self.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    NSString *LoadPath = FindDiscountCoupons;
    NSString *nonce = [self GetNonce];
    NSString *timestamp = [self getNowTimeTimestamp];
    NSString *signStr = [NSString stringWithFormat:@"token=%@&12345",_userToken];
    NSString *sign = [self MD5:signStr];
    
    NSDictionary *dict = @{@"nonce":nonce,@"timestamp":timestamp,@"token":_userToken,@"sign":sign,@"goodsid":self.productID};
    
    
    [[ObjectTools sharedManager] POST:LoadPath parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        
        NSLog(@" 可领取的优惠券----%@",dict);
        
        if (dict[@"result"]) {
            NSLog(@"res = %@",dict[@"result"]);
            
            BOOL isture = [dict[@"result"] isKindOfClass:[NSArray class]];
            
            if (isture) {
                
                [self.discountData addObjectsFromArray:dict[@"result"]];
            }
            
            [couponTableview reloadData];
            
            if(_discountData.count == 0){
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 50)];
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
                [btn setTitle:@"暂无可用优惠券哦" forState:UIControlStateNormal];
                [btn setTitleColor:Color_system forState:UIControlStateNormal];
                [couponTableview addSubview:btn];
            }
            
            NSLog(@" 优惠券数据----%@",_discountData);
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:@"请检查网络后重试"];
        
    }];
    
    
}

//构造可领取优惠券的界面
-(void)createGetDiscountCoupons{
    
    bgview = [[UIView alloc] initWithFrame:Sc_bounds];
    bgview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bgview];
    
    bgview.alpha = 0.8;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(couponDismiss)];
    [bgview addGestureRecognizer:tap];
    
    if (couponView) {
        [self.view addSubview:couponView];
        NSLog(@"sad");
        return;
    }
    
    couponView = [[UIView alloc]initWithFrame:CGRectMake(0, Sc_h/3, Sc_w, Sc_h/3 * 2)];
    
    couponTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 50 , Sc_w, Sc_h/3 * 2 - 100) style:UITableViewStylePlain];
    
    UIButton *title = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 50)];
    [title setTitle:@"店铺优惠券" forState:UIControlStateNormal];
    [title setTitleColor:Color_system forState:UIControlStateNormal];
    title.titleLabel.font = [UIFont systemFontOfSize:15];
    title.backgroundColor = [UIColor whiteColor];
    
    UIButton *footBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, Sc_h/3 * 2 - 50, Sc_w, 50)];
    footBtn.backgroundColor = Color_system;
    footBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [footBtn setTitle:@"完成" forState:UIControlStateNormal];
    [footBtn addTarget:self action:@selector(couponDismiss) forControlEvents:UIControlEventTouchUpInside];
    
    couponTableview.delegate = self;
    couponTableview.dataSource = self;
    couponTableview.tag = 2;
    
    [couponView addSubview:title];
    [couponView addSubview:couponTableview];
    [couponView addSubview:footBtn];
    
    [self.view addSubview:couponView];
    
}

-(void)couponDismiss{
    
    [couponView removeFromSuperview];
    //    couponView = nil;
    
    [bgview removeFromSuperview];
    bgview = nil;
}


/**
 立即购买按钮动作
 */
-(void)nowBuy:(id)sender{
    
    
    
    if (!_isLoad) {
        LoadViewController *vc = [[LoadViewController alloc]init];
        
        vc.isHideSelfOrTurntoUsercenter = YES;
        self.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    NSString *totalCount = choseView.countView.tf_count.text;
    
    NSString *nonce = [self GetNonce];
    NSString *timestamp = [self getNowTimeTimestamp];
    NSString *signStr = [NSString stringWithFormat:@"token=%@&12345",_userToken];
    NSString *sign = [self MD5:signStr];
    //    NSLog(@"%i",_isfav);
    
    if (!(optionid && totalCount)) {
        NSLog(@"选项错误");
        return;
    }
    
    NSDictionary *addDict = @{@"nonce":nonce,@"timestamp":timestamp,@"token":_userToken,@"sign":sign,@"goodsid":_productID,@"total":totalCount,@"optionid":optionid,@"quickid":@"0"};
    
    
    QuickbuyController *vc = [[QuickbuyController alloc]init];
    
    [[ObjectTools sharedManager] POST:NowBuy parameters:addDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        
        if([dict[@"status"] integerValue]== 1){
            
            vc.Mdict = dict[@"result"];
            NSLog(@"byself = %@ ",dict);
            NSDictionary *addDict2 = @{@"nonce":nonce,@"timestamp":timestamp,@"token":_userToken,@"sign":sign,@"goodsid":_productID,@"total":totalCount,@"optionid":optionid,@"quickid":@"1"};
            [[ObjectTools sharedManager] POST:NowBuy parameters:addDict2 progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *dict = (NSDictionary *)responseObject;
                
                NSLog(@"byself = %@ ",dict);
                
                if([dict[@"status"] integerValue]== 1){
                    vc.goodsid = _productID;
                    vc.byselfDict = dict[@"result"];
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                    
                }else{
                    [self.view makeToast:@"参数错误"];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //        [LoadingView hide];
                [self.view makeToast:@"请检查网络后重试"];
            }];
        }else{
            [self.view makeToast:@"参数错误"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        [LoadingView hide];
        [self.view makeToast:@"请检查网络后重试"];
    }];
    
    
    NSLog(@"购买");
    
}


-(void)callKefu{
    UIWebView * callWebview = [[UIWebView alloc]init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel:4001068100"]]];
    [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
}



/**
 添加底部购买按钮和加入购物车按钮的view
 */
-(void)initBottomView{
    CGFloat BottomH = 49;
    UIView* view = [[UIView alloc] init];
    view.frame = CGRectMake(0, Sc_h- BottomH , Sc_w, BottomH);
    view.backgroundColor = [UIColor whiteColor];
    
    CGFloat btnW = Sc_w * 0.3;
    CGFloat btnH = BottomH;
    CGFloat abtnW = Sc_w * 0.133;
    UIButton *kefuBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, abtnW, btnH)];
    UIImage *kefuImage = [UIImage imageNamed:@"kefu"];
    
    [kefuBtn setImage:kefuImage forState:UIControlStateNormal];
    
    
    [kefuBtn setTitle:@"客服" forState:UIControlStateNormal];
    [kefuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [kefuBtn addTarget:self action:@selector(callKefu) forControlEvents:UIControlEventTouchUpInside];
    kefuBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    
    
    [self initButton:kefuBtn];
    
    [view addSubview:kefuBtn];
    
    
    
    UIButton *shopBtn = [[UIButton alloc]initWithFrame:CGRectMake(abtnW, 0, abtnW, btnH)];
    [shopBtn setTitle:@"购物车" forState:UIControlStateNormal];
    shopBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [shopBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shopBtn setImage:[UIImage imageNamed:@"gaowuc"] forState:UIControlStateNormal];
    [shopBtn addTarget:self action:@selector(shopList) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self initButton:shopBtn];
    
    [view addSubview:shopBtn];
    
    
    
    self.likeBtn = [[UIButton alloc]initWithFrame:CGRectMake(abtnW*2, 0, abtnW, btnH)];
    _likeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_likeBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [_likeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_likeBtn setImage:[UIImage imageNamed:@"weishouc"] forState:UIControlStateNormal];
    
    _likeBtn.tag = 520;
    [_likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self initButton:_likeBtn];
    
    
    [view addSubview:_likeBtn];
    
    //加入购物车按钮
    CGFloat aX = Sc_w - 2*btnW;
    UIButton* aBtn = [[UIButton alloc] init];
    aBtn.frame = CGRectMake(aX, 0, btnW, btnH);
    [aBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [aBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    aBtn.backgroundColor = color(100.0, 203, 255, 1.0);
    aBtn.tag = 1;
    [aBtn addTarget:self action:@selector(addShoppingCar:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:aBtn];
    
    //立即购买按钮
    CGFloat bX = Sc_w - btnW;
    UIButton* bBtn = [[UIButton alloc] init];
    bBtn.frame = CGRectMake(bX, 0, btnW, btnH);
    [bBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [bBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bBtn.backgroundColor = color(14, 173, 254, 1.0);
    bBtn.tag = 2;
    [bBtn addTarget:self action:@selector(addShoppingCar:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:bBtn];
    
    
    [self.view addSubview:view];
    
    [self requestCollect];
}


-(void)initButton:(UIButton*)btn{
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height + 10.0,-btn.imageView.frame.size.width, 5.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    CGSize titleSize = [btn.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 44) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,16.0, -titleSize.width)];//图片距离右边框距离减少文字的宽度，其它不边
}


//添加中间的视图
-(void)initMidView{
    CGRect scrollFrame = CGRectMake(0, 0, Sc_w, Sc_w);
    self.productScroll = [SDCycleScrollView cycleScrollViewWithFrame:scrollFrame imagesGroup:self.imageGroup];
    
    
    UILabel *spLabel = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 80, 5, 2, 40)];
    spLabel.backgroundColor = My_gray;
    
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 70, 10, 70, 30)];
    [shareBtn setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [shareBtn setTitle:@"  分享" forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    
    UILabel *productNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 30)];
    productNameLabel.text = _productName;
    
    
    UILabel *subLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 200, 30)];
    subLabel.text = _typeName;
    subLabel.font = [UIFont systemFontOfSize:15];
    subLabel.textColor = Color_system;
    
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 100, 30)];
    priceLabel.text = [NSString stringWithFormat:@"￥%@",_price];
    priceLabel.textColor = [UIColor redColor];
    
    UILabel *beforePriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 60, 100, 30)];
    beforePriceLabel.text = [NSString stringWithFormat:@"%@",_beforePrice];
    beforePriceLabel.textColor = [UIColor grayColor];
    beforePriceLabel.font = [UIFont systemFontOfSize:14];
    
    CGSize titlesize = [beforePriceLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 44)
                        //根据Font确定
                                                           options:NSStringDrawingUsesFontLeading
                        //属性:{nssting,id}
                                                        attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
    
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 75,titlesize.width, 1)];
    lineLabel.backgroundColor = [UIColor grayColor];
    
    float percent = Sc_w/375;
    
    UILabel *sendLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, 100, 25)];
    sendLabel.text = [NSString stringWithFormat:@"快递费: %@",_sendPrice];
    sendLabel.textColor = [UIColor grayColor];
    sendLabel.font = [UIFont systemFontOfSize:14];
    
    UILabel *repertoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(150 * percent, 90, 100, 25)];
    repertoryLabel.text = [NSString stringWithFormat:@"库存: %@件",_haveCount];
    repertoryLabel.textColor = [UIColor grayColor];
    repertoryLabel.font = [UIFont systemFontOfSize:14];
    
    UILabel *saleLabel = [[UILabel alloc]initWithFrame:CGRectMake(280 * percent, 90, 100, 25)];
    saleLabel.text = [NSString stringWithFormat:@"销量: %@件",_saleCount];
    saleLabel.textColor = [UIColor grayColor];
    saleLabel.font = [UIFont systemFontOfSize:14];
    
    UIView *descView = [[UIView alloc]initWithFrame:CGRectMake(0, Sc_w+2, Sc_w, 120)];
    descView.backgroundColor = [UIColor whiteColor];
    
    [descView addSubview:productNameLabel];
    [descView addSubview:priceLabel];
    [descView addSubview:sendLabel];
    [descView addSubview:repertoryLabel];
    [descView addSubview:saleLabel];
    [descView addSubview:spLabel];
    [descView addSubview:shareBtn];
    [descView addSubview:beforePriceLabel];
    [descView addSubview:subLabel];
    [descView addSubview:lineLabel];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, Sc_w + descView.frame.size.height)];
    [headerView addSubview:_productScroll];
    [headerView addSubview:descView];
    
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 35, 40, 40)];
    backBtn.backgroundColor = My_gray;
    backBtn.layer.cornerRadius = 20;
    
    
    [backBtn setImage:[UIImage imageNamed:@"fanhui-hui"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backhuiClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [headerView addSubview:backBtn];
    
    
    self.tableview.tableHeaderView = headerView;
    
}


-(void)downLoad{
    
    [[ObjectTools sharedManager] GET:[ProductAdress stringByAppendingString:self.productID] parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        //商品信息
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (NSString *imageAdress in dic[@"thumbs"]) {
                
                
                NSString *subStr1 = [imageAdress substringToIndex:imageAdress.length - 4];
                NSString *subStr = [subStr1 substringFromIndex:subStr1.length - 20];
                
                NSString *imagePath = [NSString stringWithFormat:@"/%@.arch",subStr];
                
                NSData *Cachadata = [NSData dataWithContentsOfFile:[App_document stringByAppendingString:imagePath]];
                if (Cachadata.length == 0) {
                    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",AddressPath,imageAdress];
                    NSURL *url = [NSURL URLWithString:imageUrl];
                    Cachadata = [NSData dataWithContentsOfURL:url];
                    [Cachadata writeToFile:[App_document stringByAppendingString:imagePath] atomically:YES];
                }
                UIImage *image = [UIImage imageWithData:Cachadata];
                [self.imageGroup addObject:image];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self initBottomView];
                
                [self initMidView];
                
                [self.tableview reloadData];
                
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                
            });
        });
        
        NSString *headPath = @"http://mall.znhomes.com/attachment/";
        
        NSString *allPath = [NSString stringWithFormat:@"%@%@",headPath,[dic[@"thumbs"] firstObject]];
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:allPath]];
        
        shareImgUrlStr = imageData;
        
        
        //商品详情
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (NSString *imagePath in dic[@"content"]) {
                
                NSData *Cachadata = [NSData dataWithContentsOfFile:[App_document stringByAppendingString:imagePath]];
                if (Cachadata.length == 0) {
                    
                    NSURL *url = [NSURL URLWithString:imagePath];
                    Cachadata = [NSData dataWithContentsOfURL:url];
                    [Cachadata writeToFile:[App_document stringByAppendingString:imagePath] atomically:YES];
                }
                UIImage *image = [UIImage imageWithData:Cachadata];
                if(image)
                    [self.contentImage addObject:image];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.contentImage.count inSection:1];
                    [self.tableview reloadData];
                    //                    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                });
                
            }
            
        });
        
        self.productName = dic[@"title"];
        self.price = dic[@"marketprice"];
        
        self.sendPrice = @"包邮";
        self.haveCount = dic[@"total"];
        self.saleCount = dic[@"sales"];
        self.beforePrice = dic[@"productprice"];
        self.typeName = dic[@"subtitle"];
        
        self.paramData = dic[@"params"];
        
        specs = dic[@"specs"];
        options = dic[@"options"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}

/**
 加入购物车按钮点击动作
 */
-(void)addShoppingCar:(UIButton *)sender{
    
    if(specs.count == 0){
        [self.view makeToast:@"暂时没有可选项"];
        return;
    }
    
    NSLog(@"加入购物车");
    
    NSLog(@"参数 = %@",specs);
    
    isShopcarOrBuy = sender.tag;
    
    NSArray *da = [[specs firstObject] objectForKey:@"items"];
    sizearr = [NSMutableArray array];
    for (NSDictionary *dic1 in da) {
        [sizearr addObject:dic1[@"title"]];
    }
    
    NSArray *das = [[specs lastObject] objectForKey:@"items"];
    colorarr = [NSMutableArray array];
    for (NSDictionary *dic2 in das) {
        [colorarr addObject:dic2[@"title"]];
    }
    
    NSLog(@"%@ /r %@",sizearr,colorarr);
    
    [self initview];
}


#pragma mark-method
-(void)initview
{
    /**
     *  商品信息页面内容
     */
    self.view.backgroundColor = [UIColor blackColor];
    //淘宝点击加入购物车时商品信息页面会缩小，中心点上移，背景为黑色，弹出视图为全屏，露出的一部分商品信息页面也有一层很浅的黑色透明视图盖着，所以我对商品信息页面做了以下布局，上导航栏隐藏，self.view作为那个黑色背景，bgview盖在self.view上，所有商品信息都在bgview上，choseView是弹出视图，放在屏幕下方，当点击加入购物车时从下方进入，同时bgview缩小，中心点上移
    bgview = [[UIView alloc] initWithFrame:Sc_bounds];
    bgview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bgview];
    
    [self initChoseView];
    [self btnselete];
    
    bgview.alpha = 0.8;
}
/**
 *  初始化弹出视图
 */
-(void)initChoseView
{
    
    if (specs.count == 2) {
        //选择组合颜色的视图
        choseView = [[ChoseView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:choseView];
        //组合size
        NSDictionary *compent = [specs firstObject];
        choseView.sizeView = [[TypeView alloc] initWithFrame:CGRectMake(0, 0, choseView.frame.size.width, 50) andDatasource:sizearr :compent[@"title"]];
        choseView.sizeView.delegate = self;
        [choseView.mainscrollview addSubview:choseView.sizeView];
        choseView.sizeView.frame = CGRectMake(0, 0, choseView.frame.size.width, choseView.sizeView.height);
        
        //颜色分类color
        NSDictionary *colorData = [specs lastObject];
        choseView.colorView = [[TypeView alloc] initWithFrame:CGRectMake(0, choseView.sizeView.frame.size.height, choseView.frame.size.width, 50) andDatasource:colorarr :colorData[@"title"]];
        choseView.colorView.delegate = self;
        [choseView.mainscrollview addSubview:choseView.colorView];
        choseView.colorView.frame = CGRectMake(0, choseView.sizeView.frame.size.height, choseView.frame.size.width, choseView.colorView.height);
        
        
        choseView.countView.frame = CGRectMake(0, choseView.colorView.frame.size.height+choseView.colorView.frame.origin.y, choseView.frame.size.width, 50);
        
        
        choseView.lb_detail.text = @"请选择 组合+颜色";
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    else if (specs.count == 1){
        //选择组合颜色的视图
        choseView = [[ChoseView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:choseView];
        //组合
        
        NSDictionary *compent = [specs firstObject];
        
        choseView.sizeView = [[TypeView alloc] initWithFrame:CGRectMake(0, 0, choseView.frame.size.width, 50) andDatasource:sizearr :compent[@"title"]];
        choseView.sizeView.delegate = self;
        [choseView.mainscrollview addSubview:choseView.sizeView];
        choseView.sizeView.frame = CGRectMake(0, 0, choseView.frame.size.width, choseView.sizeView.height);
        
        choseView.countView.frame = CGRectMake(0, choseView.sizeView.frame.size.height+choseView.sizeView.frame.origin.y, choseView.frame.size.width, 50);
        
        
        choseView.lb_detail.text = @"请选择 型号";
    }
    
    
    
    
    
    
    
    
    //购买数量
    
    choseView.mainscrollview.contentSize = CGSizeMake(self.view.frame.size.width, choseView.countView.frame.size.height+choseView.countView.frame.origin.y);
    
    choseView.lb_price.text = [NSString stringWithFormat:@"￥%@",_price];
    choseView.lb_stock.text = [NSString stringWithFormat:@"库存%@件",_haveCount];
    choseView.stock = [_haveCount intValue];
    choseView.img.image = _imageGroup[0];
    
    [choseView.bt_cancle addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [choseView.bt_sure addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    //点击黑色透明视图choseView会消失
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [choseView.alphaiView addGestureRecognizer:tap];
    //点击图片放大图片
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImage:)];
    choseView.img.userInteractionEnabled = YES;
    [choseView.img addGestureRecognizer:tap1];
    
    
    __weak ProductViewControll *weakSelf = self;
    
    choseView.bt_sure.userInteractionEnabled = NO;
    
    [choseView.bt_sure setBackgroundColor:My_gray];
    [choseView.bt_sure setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    choseView.okClickBlock = ^(){
        
        
        
        if(isShopcarOrBuy == 1){
            NSLog(@"购物车确定");
            
            
            [weakSelf addCommoditytoShopCar];
        }
        else if(isShopcarOrBuy == 2){
            [weakSelf nowBuy:@1];
        }
        
        
        
    };
}



//添加商品到网络

-(void)addCommoditytoShopCar{
    
    if (!_isLoad) {
        LoadViewController *vc = [[LoadViewController alloc]init];
        vc.isHideSelfOrTurntoUsercenter = YES;
        self.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    
    NSString *totalCount = choseView.countView.tf_count.text;
    
    NSString *nonce = [self GetNonce];
    NSString *timestamp = [self getNowTimeTimestamp];
    NSString *signStr = [NSString stringWithFormat:@"token=%@&12345",_userToken];
    NSString *sign = [self MD5:signStr];
    
    if (!(optionid && totalCount)) {
        NSLog(@"没有商品ID或者数量为0");
        return;
    }
    
    NSDictionary *addDict = @{@"nonce":nonce,@"timestamp":timestamp,@"token":_userToken,@"sign":sign,@"id":_productID,@"total":totalCount,@"optionid":optionid};
    
    
    
    [[ObjectTools sharedManager] POST:ShopCarAddPath parameters:addDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        if(dict[@"msg"])
            [self.view makeToast:dict[@"msg"]];
        NSLog(@"%@ -- ",dict);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:@"请检查网络后重试"];
    }];
    
}



/**
 *  此处嵌入浏览图片代码
 */
-(void)showBigImage:(UITapGestureRecognizer *)tap
{
    NSLog(@"放大图片");
}
/**
 *  点击按钮弹出
 */
-(void)btnselete
{
    
    [UIView animateWithDuration: 0.35 animations: ^{
        //        bgview.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.8,0.8);
        bgview.center = CGPointMake(self.view.center.x, self.view.center.y-50);
        choseView.center = self.view.center;
        choseView.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion: nil];
    
    
}
/**
 *  点击半透明部分或者取消按钮，弹出视图消失
 */
-(void)dismiss
{
    center.y = center.y+self.view.frame.size.height;
    [UIView animateWithDuration: 0.35 animations: ^{
        choseView.frame =CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        
        bgview.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
        bgview.center = self.view.center;
    } completion: ^(BOOL finished) {
        [bgview removeFromSuperview];
        bgview = nil;
    }];
    
}





#pragma mark-typedelegete
-(void)btnindex:(int)tag
{
    //通过seletIndex是否>=0来判断组合和颜色是否被选择，－1则是未选择状态
    
    
    choseView.bt_sure.userInteractionEnabled = NO;
    
    [choseView.bt_sure setBackgroundColor:My_gray];
    [choseView.bt_sure setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if(specs.count == 2){
        //1.如果组合和颜色都选择的时候
        if (choseView.sizeView.seletIndex >= 0 && choseView.colorView.seletIndex >= 0) {
            
            NSString *size =[sizearr objectAtIndex:choseView.sizeView.seletIndex];
            NSString *color =[colorarr objectAtIndex:choseView.colorView.seletIndex];
            
            NSArray *arr1 = [[specs firstObject] objectForKey:@"items"];
            NSDictionary *dic1 = arr1[choseView.sizeView.seletIndex];
            NSString *id1 = dic1[@"id"];
            
            NSArray *arr2 = [[specs lastObject] objectForKey:@"items"];
            NSDictionary *dic2 = arr2[choseView.colorView.seletIndex];
            NSString *id2 = dic2[@"id"];
            
            NSString *shopId = [NSString stringWithFormat:@"%@_%@",id1,id2];
            
            NSLog(@"option = %@",options);
            
            for (NSDictionary *dict in options) {
                if ([dict[@"specs"] isEqualToString:shopId]) {
                    
                    optionid = dict[@"id"];
                    choseView.bt_sure.userInteractionEnabled = YES;
                    
                    [choseView.bt_sure setBackgroundColor:[UIColor redColor]];
                    
                    
                    [choseView.bt_sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    
                    choseView.lb_price.text = [NSString stringWithFormat:@"￥%@",dict[@"marketprice"]];
                    choseView.lb_stock.text = [NSString stringWithFormat:@"库存%@件",dict[@"stock"]];
                    
                    choseView.lb_detail.text = [NSString stringWithFormat:@"已选 \"%@\" \"%@\"",size,color];
                    choseView.stock =[dict[@"stock"] intValue];
                    
                    NSString *urlStr = [NSString stringWithFormat:@"%@%@",AddressPath,dict[@"thumb"]];
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            choseView.img.image = [UIImage imageWithData:imgData];
                        });
                        
                    });
                    
                    break;
                }
            }
            [self resumeBtn:sizearr :choseView.sizeView];
            [self resumeBtn:colorarr :choseView.colorView];
            
            
        }
        //2.组合和颜色都没选的时候
        else if (choseView.sizeView.seletIndex == -1 && choseView.colorView.seletIndex == -1){
            choseView.lb_price.text = [NSString stringWithFormat:@"￥%@",_price];
            choseView.lb_stock.text = [NSString stringWithFormat:@"库存:%@件",_haveCount];
            choseView.lb_detail.text = @"请选择 组合 颜色";
            choseView.stock = [_haveCount intValue];
            //全部恢复可点击状态
            [self resumeBtn:colorarr :choseView.colorView];
            [self resumeBtn:sizearr :choseView.sizeView];
        }
        //3.选择了组合，没选择颜色
        else if (choseView.sizeView.seletIndex >= 0&&choseView.colorView.seletIndex == -1){
            choseView.lb_detail.text = @"请选择 颜色";
            
            [self resumeBtn:colorarr :choseView.colorView];
            [self resumeBtn:sizearr :choseView.sizeView];
        }
        //4.选择了颜色，没选择组合
        else if (choseView.sizeView.seletIndex == -1&&choseView.colorView.seletIndex >= 0){
            
            [self resumeBtn:colorarr :choseView.colorView];
            [self resumeBtn:sizearr :choseView.sizeView];
            choseView.lb_detail.text = @"请选择 颜色";
        }
        
    }
    
    
    
    
    
    
    
    else if (specs.count == 1) {
        NSLog(@"只有一种可选");
        
        
        if (choseView.sizeView.seletIndex >= 0){
            
            NSLog(@"option = %@",options);
            
            NSArray *arr1 = [[specs firstObject] objectForKey:@"items"];
            NSDictionary *dic1 = arr1[choseView.sizeView.seletIndex];
            NSString *id1 = dic1[@"id"];
            
            for (NSDictionary *dict in options) {
                if ([dict[@"specs"] isEqualToString:id1]){
                    optionid = dict[@"id"];
                }
            }
            
            NSLog(@"%@",optionid);
            
            NSString *color =[colorarr objectAtIndex:choseView.sizeView.seletIndex];
            choseView.lb_detail.text = [NSString stringWithFormat:@"已选 %@ ",color];
            
            choseView.bt_sure.userInteractionEnabled = YES;
            [choseView.bt_sure setBackgroundColor:[UIColor redColor]];
            [choseView.bt_sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            choseView.lb_detail.text = @"请选择 种类";
        }
        [self resumeBtn:sizearr :choseView.sizeView];
    }
}


//恢复按钮的原始状态
-(void)resumeBtn:(NSArray *)arr :(TypeView *)view
{
    for (int i = 0; i< arr.count; i++) {
        UIButton *btn =(UIButton *) [view viewWithTag:100+i];
        btn.enabled = YES;
        btn.selected = NO;
        [btn setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
        [btn setTitleColor:[UIColor blackColor] forState:0];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        if (view.seletIndex == i) {
            btn.selected = YES;
            [btn setBackgroundColor:[UIColor redColor]];
        }
    }
}


//根据所选的组合或者颜色对应库存量 确定哪些按钮不可选
-(void)reloadTypeBtn:(NSDictionary *)dic :(NSArray *)arr :(TypeView *)view
{
    for (int i = 0; i<arr.count; i++) {
        int count = [[dic objectForKey:[arr objectAtIndex:i]] intValue];
        UIButton *btn =(UIButton *)[view viewWithTag:100+i];
        btn.selected = NO;
        [btn setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
        //库存为零 不可点击
        if (count == 0) {
            btn.enabled = NO;
            [btn setTitleColor:[UIColor lightGrayColor] forState:0];
        }else
        {
            btn.enabled = YES;
            [btn setTitleColor:[UIColor blackColor] forState:0];
        }
        //根据seletIndex 确定用户当前点了那个按钮
        if (view.seletIndex == i) {
            btn.selected = YES;
            [btn setBackgroundColor:[UIColor redColor]];
        }
    }
}

@end

