//
//  CollectViewController.m
//  SmartMall
//
//  Created by Smart house on 2017/9/2.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "CollectViewController.h"

#import "CollectCell.h"

#define requestPath @"r=member.appinfo.favorite"

#define requestPath_remove @"r=member.appinfo.favremove1"

#import "ProductViewControll.h"

//友盟
#import <UShareUI/UShareUI.h>


#import <UMSocialCore/UMSocialCore.h>

#import "UMShareTypeViewController.h"


#import "ObjectTools.h"
#import "UIView+Toast.h"


#define ShareAddress @"r=goods.detail&id="

@interface CollectViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)UITableView *tableview;


@property(nonatomic,strong)NSMutableArray *Mdata;

@property(nonatomic,strong)NSMutableArray *imgData;


@end

@implementation CollectViewController

-(NSMutableArray *)Mdata{
    if (!_Mdata) {
        _Mdata = [NSMutableArray array];
    }return _Mdata;
}


-(NSMutableArray *)imgData{
    if (!_imgData) {
        _imgData = [NSMutableArray array];
    }return _imgData;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的收藏";
    self.view.backgroundColor = My_gray;
    self.navigationController.navigationBarHidden = NO;
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, Sc_h - 64) style:UITableViewStylePlain];
    _tableview.backgroundColor = My_gray;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    _tableview.sectionFooterHeight = 0.01;
    
    [self.view addSubview:_tableview];
    
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [self downLoadSource];
    
}


-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 115;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.Mdata.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CollectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userPool"];
    if (!cell) {
        cell = [[CollectCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"userPool"];
    }
    
    NSDictionary *collectDict = self.Mdata[indexPath.row];
    
    cell.imageview.image = self.imgData[indexPath.row];
    cell.titleL.text = collectDict[@"title"];
    cell.price.text = [ NSString stringWithFormat:@"￥ %@",collectDict[@"marketprice"]];
    
    
    cell.shareBtn.tag = indexPath.row + 1000;
    cell.deldBtn.tag = indexPath.row + 1000;
    
    
    [cell.shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.deldBtn addTarget:self action:@selector(deleClick:) forControlEvents:UIControlEventTouchUpInside];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}


//分享
-(void)shareBtnClick:(UIButton *)sender{
    NSLog(@"收藏分享 %ld",sender.tag);
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_Tim),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Sina)]];
    //    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
    //         根据获取的platformType确定所选平台进行下一步操作
    //    }];9
    
    
    [UMSocialUIManager removeAllCustomPlatformWithoutFilted];
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRadius;

    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        UMShareTypeViewController *VC = [[UMShareTypeViewController alloc] initWithType:platformType];
        
        NSDictionary *collectDict = self.Mdata[sender.tag - 1000];
        
        VC.titleName = collectDict[@"title"];
        VC.typeName = @"---";
        
        
        NSString *prodId = [self.Mdata[sender.tag - 1000] objectForKey:@"goodsid"];
        
        VC.shareLink = [[ResourceFront stringByAppendingString:ShareAddress] stringByAppendingString:prodId];
        VC.imageUrl = self.imgData[sender.tag - 1000];
        
        
        [VC shareWebPageToPlatformType:platformType];
        
    }];
    
}


//删除
-(void)deleClick:(UIButton *)sender{
    NSLog(@"删除按钮%ld",sender.tag);
    [self tableView:_tableview commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag - 1000 inSection:0]];
}


//点击

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *prodId = [self.Mdata[indexPath.row] objectForKey:@"goodsid"];
    ProductViewControll *vc = [[ProductViewControll alloc]init];
    vc.productID = prodId;
    [self.navigationController pushViewController:vc animated:YES];
    
}




//a.设置编辑风格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{   if(self.tableview.editing)
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    return UITableViewCellEditingStyleDelete;
}

//b.单行删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除后无法恢复,确认删除吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        
        alert.tag = indexPath.row;
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        
    }
}

//c.删除显示样式 默认delete英文
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"tag = %ld",alertView.tag);
    
    if (buttonIndex == 1) {
        
        NSString *goodsid = [_Mdata[alertView.tag] objectForKey:@"id"];
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:alertView.tag inSection:0];
        [self.Mdata removeObjectAtIndex:indexpath.row];
//        [self.editMdata removeObjectAtIndex:indexpath.row];
        [self.tableview deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationRight];
        [self.imgData removeObjectAtIndex:alertView.tag];
        
        NSString *nonce = _dict[@"nonce"];
        NSString *timestamp = [self getNowTimeTimestamp];
        NSString *sign = _dict[@"sign"];
        NSString *token = _dict[@"token"];
        
        NSDictionary *newDict = @{@"nonce":nonce,@"timestamp":timestamp,@"token":token,@"sign":sign,@"id":goodsid};
        
        
        [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:requestPath_remove] parameters:newDict progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"删除结果返回 = %@",responseObject);
            [self.view makeToast:@"已为您删除"];
            
            //刷新tableview 重新给删除分享按钮赋值
            [self.tableview reloadData];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        
        
    }
}


- (NSString *)getNowTimeTimestamp{
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}

     
-(void)downLoadSource{
    
    [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:requestPath] parameters:self.dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSLog(@"收藏返回信息 = %@",dict);
        
        if ([dict[@"status"] intValue] == 0) {
            [mainWindowss makeToast:dict[@"result"]];
            return ;
        }
        
        NSArray *arr = dict[@"result"];
        for (NSDictionary *resultDict in arr) {
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:resultDict[@"thumb"]]];
                UIImage *image = [UIImage imageWithData:data];
                [self.imgData addObject:image];
                [self.Mdata addObject:resultDict];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableview reloadData];
                });
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

     
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

@end
