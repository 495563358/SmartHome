//
//  UserCenterViewController.m
//  SmartMall
//
//  Created by Smart house on 2017/8/27.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "UserCenterViewController.h"
#import "LoadingView.h"
#import "CABasicAnimation+Category.h"

#import "ObjectTools.h"

#import "UIView+Toast.h"

#import <CommonCrypto/CommonDigest.h>

#import "LoadingView.h"

#import "CABasicAnimation+Category.h"

#import "UserSetViewController.h"

#import "AdressViewController.h"

#import "CollectViewController.h"

#import "DiscountViewController.h"

#import "LoadViewController.h"

#import "UserOrderViewController.h"

#import "WalletViewController.h"

#import "MessageViewController.h"

#import "MBProgressHUD.h"

#import "SecurityViewController.h"


#define requestPath @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=member.appinfo"


@interface UserCenterViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSString *city;
    NSString *nickname;
    NSString *realname;
    NSString *birthday;
    NSString *mobile;
    NSString *credit2;
}


@property(nonatomic,strong)UIView *topView;

@property(nonatomic,strong)UIView *midView;

@property(nonatomic,strong)UIView *bottomView;

@property(nonatomic,strong)UIButton *headImgBtn;

@property(nonatomic,strong)UILabel *userName;


@property(nonatomic,strong) UITableView *tableview;


@property(nonatomic,strong)UILabel *yueLabel;

@property(nonatomic,strong)UILabel *payLabel;



@property(nonatomic,strong)NSMutableDictionary *userInfo;

@end

@implementation UserCenterViewController

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self initTopView];
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, Sc_w, Sc_h+20) style:UITableViewStyleGrouped];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableHeaderView = _topView;
    
    
    _tableview.tableFooterView = [self creatFootView];
    
    [self.view addSubview:_tableview];
    
    _tableview.sectionFooterHeight = 0;
    [self initMyOrder];
    [self initMyMoney];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (UIView *)creatFootView{
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, Sc_w - 20, 38)];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    
    btn.layer.cornerRadius = 5.0;
    btn.layer.masksToBounds = YES;
    
    [btn setBackgroundColor:Color_system];
    [btn addTarget:self action:@selector(exitClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 60)];
    [view addSubview:btn];
    
    
    return view;
}

-(void)exitClick{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:nil forKey:@"userToken"];
    //同步到本地文件
    [user synchronize];
    [self.navigationController popViewControllerAnimated:YES];
    
}


//我的订单
-(void)initMyOrder{
    
    CGFloat maginY = (Sc_w - 45 - 5 * 50)/4 + 50;
    
    CGFloat startX = 22;
    
    if (Sc_w < 375) {
        startX = 10;
        maginY = (Sc_w - 20 - 5 * 50)/4 + 50;
    }
    
    UIButton *aBtn = [[UIButton alloc]initWithFrame:CGRectMake(startX, 10, 50, 70)];
    [aBtn setImage:[UIImage imageNamed:@"daifuk"] forState:UIControlStateNormal];
    [aBtn setTitle:@"待付款" forState:UIControlStateNormal];
    [aBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    aBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    aBtn.tag = 0;
    [aBtn addTarget:self action:@selector(lookupMyorder:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *bBtn = [[UIButton alloc]initWithFrame:CGRectMake(startX + maginY, 10, 50, 70)];
    [bBtn setImage:[UIImage imageNamed:@"daifah"] forState:UIControlStateNormal];
    [bBtn setTitle:@"待发货" forState:UIControlStateNormal];
    [bBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    bBtn.tag = 1;
    [bBtn addTarget:self action:@selector(lookupMyorder:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cBtn = [[UIButton alloc]initWithFrame:CGRectMake(startX + 2*maginY, 10, 50, 70)];
    [cBtn setImage:[UIImage imageNamed:@"daishouh"] forState:UIControlStateNormal];
    [cBtn setTitle:@"待收货" forState:UIControlStateNormal];
    [cBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    cBtn.tag = 2;
    [cBtn addTarget:self action:@selector(lookupMyorder:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *dBtn = [[UIButton alloc]initWithFrame:CGRectMake(startX + 3*maginY, 10, 50, 70)];
    [dBtn setImage:[UIImage imageNamed:@"daipingjia"] forState:UIControlStateNormal];
    [dBtn setTitle:@"待评价" forState:UIControlStateNormal];
    [dBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    dBtn.tag = 3;
    [dBtn addTarget:self action:@selector(lookupMyorder:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *eBtn = [[UIButton alloc]initWithFrame:CGRectMake(startX + 4*maginY, 10, 50, 70)];
    [eBtn setImage:[UIImage imageNamed:@"shouhou"] forState:UIControlStateNormal];
    [eBtn setTitle:@"售后" forState:UIControlStateNormal];
    [eBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    eBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    eBtn.tag = 4;
    [eBtn addTarget:self action:@selector(lookupMyorder:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.midView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 90)];
    [_midView addSubview:aBtn];
    [_midView addSubview:bBtn];
    [_midView addSubview:cBtn];
    [_midView addSubview:dBtn];
    [_midView addSubview:eBtn];
    
    CGSize imageSize = aBtn.currentImage.size;
    
    for (UIButton *btn in _midView.subviews) {
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
        
        CGSize titleSize = [btn.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
        
        CGFloat leftImage = (btn.frame.size.width - imageSize.width)/2;
        CGFloat leftTitle = (btn.frame.size.width - titleSize.width)/2 - imageSize.width;
        
        btn.imageEdgeInsets = UIEdgeInsetsMake(7, leftImage, 10, 0);
        btn.titleEdgeInsets = UIEdgeInsetsMake(20 + imageSize.height, leftTitle, 0, 0);
        if ([btn.currentTitle isEqualToString:@"待发货"]) {
            btn.titleEdgeInsets = UIEdgeInsetsMake(20 + imageSize.height, leftTitle - 3, 0, 0);
        }
    }
}

//我的钱包
-(void)initMyMoney{
    
    CGFloat startX = 70 * Sc_w/375;
    
    self.yueLabel = [[UILabel alloc]initWithFrame:CGRectMake(startX - 20, 15, 80 + 40, 30)];
    
    _yueLabel.textColor = Color_system;
    _yueLabel.textAlignment = NSTextAlignmentCenter;
    _yueLabel.text = @"0.00";
    
    UILabel *name1 = [[UILabel alloc]initWithFrame:CGRectMake(startX, 19+ 30, 80, 30)];
    name1.text = @"余额";
    name1.textAlignment = NSTextAlignmentCenter;
    name1.font = [UIFont systemFontOfSize:15];
    
    
    
    self.payLabel = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - startX - 80, 15, 80, 30)];
    _payLabel.textColor = Color_system;
    _payLabel.textAlignment = NSTextAlignmentCenter;
    _payLabel.text = @"0.00";
    
    UILabel *name2 = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - startX - 80, 19+ 30, 80, 30)];
    name2.text = @"预付款";
    name2.textAlignment = NSTextAlignmentCenter;
    name2.font = [UIFont systemFontOfSize:15];
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 90)];
    [_bottomView addSubview:_yueLabel];
    [_bottomView addSubview:name1];
    [_bottomView addSubview:_payLabel];
    
    [_bottomView addSubview:name2];
    
    
    [self downLoadSource];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 90;
    }else if (indexPath.section == 1 && indexPath.row == 1){
        return 90;
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 3;
    }
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 0.1;
    }
    return 0;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userPool"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"userPool"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0 && indexPath.row == 1) {
        
        [cell.contentView addSubview:_midView];
        
        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 1){
        
        
        [cell.contentView addSubview:_bottomView];
        
        return cell;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
            cell.textLabel.text = @"我的订单";
        else{
            
        }
        
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"我的钱包";
        }
        else{
            
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"youhuiquan"];
            cell.textLabel.text = @"我的优惠券";
        }else if (indexPath.row == 1){
            
            cell.imageView.image = [UIImage imageNamed:@"shoucheng"];
            cell.textLabel.text = @" 我的收藏";
        }else{
            
            cell.imageView.image = [UIImage imageNamed:@"weizhi"];
            cell.textLabel.text = @"  我的收货地址";
        }
    }
    
    
    return cell;
}



-(void)initTopView{
    
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 190)];
    _topView.backgroundColor = Color_system;
//    [self.view addSubview:_topView];
    
    
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 35, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:backBtn];
    
    
    
    
    
    UIButton *setBtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 30 - 5, 35, 30, 30)];
    [setBtn setImage:[UIImage imageNamed:@"shez"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:setBtn];
    
    
    
    
    UIButton *messageBtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 30 - 5 - 30 - 21, 35, 30, 30)];
    [messageBtn setImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];
    [messageBtn addTarget:self action:@selector(messageClick) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:messageBtn];
    
    
    
    self.headImgBtn = [[UIButton alloc]initWithFrame:CGRectMake((Sc_w -70)/2, 67, 70, 70)];
    _headImgBtn.layer.cornerRadius = 35;
    _headImgBtn.layer.masksToBounds = YES;
    
    _headImgBtn.backgroundColor = [UIColor whiteColor];
//    [_headImgBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_headImgBtn];
    
    
    self.userName = [[UILabel alloc]initWithFrame:CGRectMake(100, 67 + 70 + 8, Sc_w - 200, 20)];
    _userName.textColor = [UIColor whiteColor];
    _userName.font = [UIFont systemFontOfSize:18];
    _userName.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_userName];
    
    
}

-(void)messageClick{
    
    MessageViewController *mess = [[MessageViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mess animated:YES];
}

-(void)backClick{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
}

-(void)changeUserinfo{
    
    UserSetViewController *set = [[UserSetViewController alloc]init];
    
    set.headImg = [self.headImgBtn currentImage];
    set.mobile = mobile;
    set.realname = realname;
    set.nickname = nickname;
    set.birthdayStr = birthday;
    set.city = city;
    
    NSString *nonce = [self GetNonce];
    NSString *signStr = [NSString stringWithFormat:@"token=%@&12345",_token];
    NSString *sign = [self MD5:signStr];
    
    set.nonce = nonce;
    set.sign = sign;
    set.token = _token;
    
    
    set.changeMemberInfoBlock = ^(NSDictionary *memberInfo){
        realname = memberInfo[@"realname"];
        nickname = memberInfo[@"nickname"];
        birthday = memberInfo[@"birthday"];
        city = memberInfo[@"city"];
    };
    
    set.changeHeadImgInfoBlock = ^(UIImage *editedImg){
        
        [self.headImgBtn setImage:editedImg forState:UIControlStateNormal];
    };
    
    set.changeMobileInfoBlock = ^(NSString *changedmobile){
        
        _userName.text = changedmobile;
        mobile = changedmobile;
        
    };
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:set animated:YES];
}

//设置
-(void)setClick{
    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"个人信息修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self changeUserinfo];
    }]];
    
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"安全设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SecurityViewController *vc = [SecurityViewController new];
        vc.userInfo = _userInfo;
        
        vc.moblie = _userName.text;
        vc.headImg = _headImgBtn.currentImage;
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }]];
    
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertCtr animated:YES completion:nil];
}

//查看订单
-(void)lookupMyorder:(UIButton *)sender{
    UserOrderViewController *vc = [UserOrderViewController new];
    vc.userInfo = _userInfo;
    vc.status = [NSString stringWithFormat:@"%ld",sender.tag];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//tableview 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSLog(@"订单");
        UserOrderViewController *vc = [UserOrderViewController new];
        vc.userInfo = _userInfo;
        vc.status = nil;
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        NSLog(@"钱包");
        
        WalletViewController *vc = [WalletViewController new];
        vc.userInfo = _userInfo;
        vc.credit = credit2;
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    if (indexPath.section == 2) {
        //优惠券
        if (indexPath.row == 0) {
            DiscountViewController *vc = [[DiscountViewController alloc]init];
            vc.dict = _userInfo;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        //我的收藏
        else if (indexPath.row == 1){
            CollectViewController *vc = [[CollectViewController alloc]init];
            vc.dict = _userInfo;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        //我的收货地址
        else{
            AdressViewController *vc = [[AdressViewController alloc]init];
            vc.dict = _userInfo;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

//个人中心数据源
- (void)downLoadSource{
    
    NSString *LoadPath = requestPath;
    NSString *nonce = [self GetNonce];
    NSString *timestamp = [self getNowTimeTimestamp];
    NSString *signStr = [NSString stringWithFormat:@"token=%@&12345",_token];
    NSString *sign = [self MD5:signStr];
    
    NSDictionary *dict1 = @{@"nonce":nonce,@"timestamp":timestamp,@"token":self.token,@"sign":sign};
    
    self.userInfo = [NSMutableDictionary dictionaryWithDictionary:dict1];
    
    //    获取token
    [[ObjectTools sharedManager] POST:LoadPath parameters:dict1 progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *returnInfo = (NSDictionary *)responseObject;
        mobile = returnInfo[@"mobile"];
        //token过期
        if (mobile.length < 7) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            [self.view makeToast:@"您的登录已失效,请重新登录"];
            [self performSelector:@selector(animation) withObject:nil afterDelay:2.0];
            
            NSString *userToken = nil;
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:userToken forKey:@"userToken"];
            [user synchronize];
        }
        
        NSLog(@"个人中心全部信息 = %@",returnInfo);
        city = returnInfo[@"city"];
        nickname = returnInfo[@"nickname"];
        realname = returnInfo[@"realname"];
        birthday = [NSString stringWithFormat:@"%@-%@-%@",returnInfo[@"birthyear"],returnInfo[@"birthmonth"],returnInfo[@"birthday"]];
        
        credit2 = returnInfo[@"credit2"];
        _yueLabel.text = credit2;
        _payLabel.text = returnInfo[@"credit1"];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *headPath = returnInfo[@"avatar"];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:headPath]];
            UIImage *headImg = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.headImgBtn setImage:headImg forState:UIControlStateNormal];
                self.userName.text = mobile;
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [self.view makeToast:@"请检查网络后重试"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

-(void)animation{
    
    LoadViewController *vc = [[LoadViewController alloc]init];
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
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


- (NSString *)MD5:(NSString *)mdStr
{
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

@end
