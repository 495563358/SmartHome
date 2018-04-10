//
//  AdressViewController.m
//  SmartMall
//
//  Created by Smart house on 2017/9/1.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "AdressViewController.h"

#import "AddAddressViewController.h"

#import "EditAddrViewController.h"

#import "ObjectTools.h"

#import "UIView+Toast.h"

//获取所有地址
#define requestPath @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=member.appinfo.address"

//设置默认
#define requestPath_setDefault @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=member.appinfo.setdefault"

//删除一条地址
#define requestPath_delete @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=member.appinfo.delete"


@interface AdressViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)UITableView *tableview;

@property(nonatomic,strong)NSMutableArray *Mdata;

@property(nonatomic,strong)NSMutableArray *editMdata;


@end

@implementation AdressViewController


-(NSMutableArray *)Mdata{
    if (!_Mdata) {
        _Mdata = [NSMutableArray array];
    }return _Mdata;
}

-(NSMutableArray *)editMdata{
    if (!_editMdata) {
        _editMdata = [NSMutableArray array];
    }return _editMdata;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的收获地址";
    self.view.backgroundColor = My_gray;
    self.navigationController.navigationBarHidden = NO;
    
    self.tableview = [[UITableView alloc]initWithFrame:Sc_bounds style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 120)];
    
    [self.view addSubview:_tableview];
    
    [self.view addSubview:[self creatFootView]];
    
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


- (UIView *)creatFootView{
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, Sc_h - 50 - 64, Sc_w, 50)];
    [btn setTitle:@" 新建地址 " forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"shebei"] forState:UIControlStateNormal];
    
    [btn setBackgroundColor:Color_system];
    [btn addTarget:self action:@selector(newAddress) forControlEvents:UIControlEventTouchUpInside];

    return btn;
}

-(void)newAddress{
    AddAddressViewController *vc = [[AddAddressViewController alloc]init];
    vc.dict = self.dict;
    
    vc.update = ^(){
        NSLog(@"1");
        
//        _Mdata = nil;
//        _editMdata = nil;
        
        
        NSString *nonce = _dict[@"nonce"];
        NSString *timestamp = [self getNowTimeTimestamp];
        NSString *sign = _dict[@"sign"];
        NSString *token = _dict[@"token"];
        
        
        NSDictionary *newDict = @{@"nonce":nonce,@"timestamp":timestamp,@"token":token,@"sign":sign};
        
        [[ObjectTools sharedManager] POST:requestPath parameters:newDict progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            //所有地址信息
            //        NSLog(@"dict = %@",dict);
            NSArray *arr = dict[@"result"];
            
            
            NSMutableArray *arr1 = [NSMutableArray array];
            NSMutableArray *arr2 = [NSMutableArray array];
            
            for (NSDictionary *resultDict in arr) {
                NSString *titleStr = [NSString stringWithFormat:@"%@   %@",resultDict[@"realname"],resultDict[@"mobile"]];
                
                NSString *addrStr = [NSString stringWithFormat:@"%@%@%@  %@",resultDict[@"province"],resultDict[@"city"],resultDict[@"area"],resultDict[@"address"]];
                NSString *addrID = resultDict[@"id"];
                NSArray *arr = @[titleStr,addrID,addrStr];
                [arr1 addObject:arr];
                
                NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:resultDict];
                
                [arr2 addObject:mdict];
                
            }
            
            NSLog(@"显示到屏幕上的信息 = %@",_Mdata);
            _Mdata = arr1;
            _editMdata = arr2;
            
            [self.tableview reloadData];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.view makeToast:@"网络错误,请检查网络后重试"];
        }];
        
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return 120;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.Mdata.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userPool"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"userPool"];
    }
    
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    NSArray *arr = self.Mdata[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, Sc_w, 25)];
    titleL.font = [UIFont systemFontOfSize:15.0];
    titleL.text = [arr firstObject];
    
    UILabel *addressL = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, Sc_w, 30)];
    addressL.font = [UIFont systemFontOfSize:14.0];
    addressL.textColor = color(113, 113, 113, 1.0);
    addressL.text = [arr lastObject];
    
    UIButton *setBtn = [[UIButton alloc]initWithFrame:CGRectMake( 0, 85, 100, 25)];
    
    [setBtn addTarget:self action:@selector(setClick:) forControlEvents:UIControlEventTouchUpInside];
    [setBtn setTitle:@"设置默认" forState:UIControlStateNormal];
    
    [setBtn setTitleColor:color(113, 113, 113, 1.0) forState:UIControlStateNormal];
    
    
    setBtn.tag = indexPath.row + 1000;
    if ([[self.editMdata[indexPath.row] objectForKey:@"isdefault"] isEqualToString:@"0"]) {
        [setBtn setImage:[UIImage imageNamed:@"morensz"] forState:UIControlStateNormal];
    }else{
        [setBtn setImage:[UIImage imageNamed:@"morensz-xuanz"] forState:UIControlStateNormal];
    }
    setBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    
    UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake( Sc_w - 140, 85, 65, 25)];
    
    editBtn.tag = indexPath.row + 1000;
    [editBtn addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setTitle:@" 编辑" forState:UIControlStateNormal];
    [editBtn setTitleColor:color(113, 113, 113, 1.0) forState:UIControlStateNormal];
    [editBtn setImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    
    UIButton *deleBtn = [[UIButton alloc]initWithFrame:CGRectMake( Sc_w - 75, 85, 65, 25)];
    deleBtn.tag = indexPath.row + 1000;
    [deleBtn addTarget:self action:@selector(deleClick:) forControlEvents:UIControlEventTouchUpInside];
    [deleBtn setTitle:@" 删除" forState:UIControlStateNormal];
    [deleBtn setTitleColor:color(113, 113, 113, 1.0) forState:UIControlStateNormal];
    [deleBtn setImage:[UIImage imageNamed:@"shanchu"] forState:UIControlStateNormal];
    deleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    
    [cell.contentView addSubview:titleL];
    [cell.contentView addSubview:addressL];
    [cell.contentView addSubview:setBtn];
    [cell.contentView addSubview:editBtn];
    [cell.contentView addSubview:deleBtn];

    return cell;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    if (self.editMdata.count == 0) {
        return;
    }
    
    NSLog(@"xinxi = %@",_editMdata);
    
    for (NSDictionary *dict in self.editMdata) {
        if ([dict[@"isdefault"] intValue] != 0) {
            //如果响应了代理方法就传默认地址回去
            if ([self.delegate respondsToSelector:@selector(setDefaultAddr:)]) {
                
                [self.delegate setDefaultAddr:dict];
                NSLog(@"响应了代理");
            }
            return;
        }
    }
}

-(void)downLoadSource{
    
    [[ObjectTools sharedManager] POST:requestPath parameters:self.dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        //所有地址信息
        NSLog(@"dict = %@",dict);
        
        if ([dict[@"status"] intValue] == 0) {
            [mainWindowss makeToast:@"您还未设置地址，去设置一下收货地址吧"];
            return ;
        }
        NSArray *arr = dict[@"result"];
        
        if (arr.count == 0) {
            [mainWindowss makeToast:@"您还未设置地址，去设置一下收货地址吧"];
            return ;
        }
        
        for (NSDictionary *resultDict in arr) {
            NSString *titleStr = [NSString stringWithFormat:@"%@   %@",resultDict[@"realname"],resultDict[@"mobile"]];
            
            NSString *addrStr = [NSString stringWithFormat:@"%@%@%@  %@",resultDict[@"province"],resultDict[@"city"],resultDict[@"area"],resultDict[@"address"]];
            NSString *addrID = resultDict[@"id"];
            NSArray *arr = @[titleStr,addrID,addrStr];
            [self.Mdata addObject:arr];
            
            NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:resultDict];
            
            [self.editMdata addObject:mdict];
            
        }
        
        NSLog(@"显示到屏幕上的信息 = %@",_Mdata);
        [self.tableview reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:@"网络错误,请检查网络后重试"];
    }];
    
}

//设置为默认地址
-(void)setClick:(UIButton *)sender{
    
    long index = sender.tag - 1000;
    
    int flag = 0;
    
    for (NSMutableDictionary *dict in self.editMdata) {
        
        
        if (index == flag) {
            [dict setValue:@"1" forKeyPath:@"isdefault"];
        }else{
            [dict setValue:@"0" forKeyPath:@"isdefault"];
        }
        flag ++ ;
    }
    [self.tableview reloadData];
    
    
    NSLog(@"%@",self.editMdata);
    
    NSString *nonce = _dict[@"nonce"];
    NSString *timestamp = [self getNowTimeTimestamp];
    NSString *sign = _dict[@"sign"];
    NSString *token = _dict[@"token"];
    NSString *addressID = [_editMdata[sender.tag - 1000] objectForKey:@"id"];
    
    
    NSDictionary *newDict = @{@"nonce":nonce,@"timestamp":timestamp,@"token":token,@"sign":sign,@"id":addressID};
    
    NSLog(@"newDict = %@",newDict);
    
    [[ObjectTools sharedManager] POST:requestPath_setDefault parameters:newDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSLog(@"默认地址返回 = %@",dict);
        [self.view makeToast:@"已修改默认地址"];
        
        //如果响应了代理方法就传默认地址回去
        if ([self.delegate respondsToSelector:@selector(setDefaultAddr:)]) {
            
            for (NSDictionary *addrDict in dict[@"result"]) {
                if ([addrDict[@"isdefault"] integerValue] == 1) {
                    
                    [self.delegate setDefaultAddr:addrDict];
                    NSLog(@"响应了代理");
                    break;
                }
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:@"网络错误,请检查网络后重试"];
    }];
    
}

- (NSString *)getNowTimeTimestamp{
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
    
}

-(void)editClick:(UIButton *)sender{
    
    
    EditAddrViewController *vc = [[EditAddrViewController alloc]init];
    
    vc.dict = _dict;
    
    vc.info = self.editMdata[sender.tag - 1000];
    
    NSLog(@"info = %@",vc.info);
    
    vc.editBlock = ^(NSMutableDictionary *editInfo){
        NSLog(@"edit info = %@",editInfo);
        [_editMdata replaceObjectAtIndex:sender.tag - 1000 withObject:editInfo];
        
        NSString *titleStr = [NSString stringWithFormat:@"%@   %@",editInfo[@"realname"],editInfo[@"mobile"]];
        
        NSString *addrStr = [NSString stringWithFormat:@"%@%@%@  %@",editInfo[@"province"],editInfo[@"city"],editInfo[@"area"],editInfo[@"address"]];
        NSString *addrID = editInfo[@"id"];
        
        NSArray *arr = @[titleStr,addrID,addrStr];
        
        [_Mdata replaceObjectAtIndex:sender.tag - 1000 withObject:arr];
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:sender.tag - 1000 inSection:0];
        
        [_tableview reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationRight];
        
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


//删除地址
-(void)deleClick:(UIButton *)sender{
    NSLog(@"%ld -----------  ",sender.tag);
    [self tableView:_tableview commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag - 1000 inSection:0]];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        
        NSLog(@"tag = = %ld",alertView.tag);
        
        NSString *addressID = [_editMdata[alertView.tag] objectForKey:@"id"];
        
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:alertView.tag inSection:0];
        [self.Mdata removeObjectAtIndex:indexpath.row];
        [self.editMdata removeObjectAtIndex:indexpath.row];
        [self.tableview deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationRight];
        
        
        NSString *nonce = _dict[@"nonce"];
        NSString *timestamp = [self getNowTimeTimestamp];
        NSString *sign = _dict[@"sign"];
        NSString *token = _dict[@"token"];
        
        
        NSDictionary *newDict = @{@"nonce":nonce,@"timestamp":timestamp,@"token":token,@"sign":sign,@"id":addressID};
        
        NSLog(@"newDict = %@",newDict);
        
        [[ObjectTools sharedManager] POST:requestPath_delete parameters:newDict progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            
            [self.view makeToast:@"已成功删除地址"];
            [self.tableview reloadData];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.view makeToast:@"网络错误,请检查网络后重试"];
        }];
        
    }
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


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}



-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}


@end
