//
//ShopListViewController.m


#import "ShopListViewController.h"

#import "MyTableViewCell.h"

#import "ShopCarModel.h"

#import "LoadingView.h"

#import "ProductViewControll.h"

#import <CommonCrypto/CommonDigest.h>

#import "ShopCarBuyViewCtr.h"

#import "MBProgressHUD.h"

#import "ObjectTools.h"

#import "UIView+Toast.h"
//购物车数据
#define ShopCarPath @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=member.appcart"

//立即购买
#define ShopCarBuy @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.appcreate.cartdata"

@interface ShopListViewController () <UITableViewDataSource,UITableViewDelegate>{
    //总价 全选
    float totalMoney;
    int flagAll;
}


@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIButton *allSelect;

@property(nonatomic,strong)UIButton *finsh;

@property(nonatomic,strong)UILabel *lastMoney;


//购物车数据
@property(nonatomic,strong)NSMutableArray *Mdata;

//组头视图合集
@property(nonatomic,strong)NSMutableDictionary *mdict;

//更新数据
@property(nonatomic,strong)NSMutableArray *updateNum;

//用户购买数据
@property(nonatomic,strong)NSMutableArray *userBuyData;

@end

@implementation ShopListViewController

-(NSMutableArray *)userBuyData{
    if (!_userBuyData) {
        _userBuyData = [NSMutableArray array];
    }
    return _userBuyData;
}

-(NSMutableDictionary *)mdict{
    if (!_mdict) {
        _mdict = [NSMutableDictionary dictionary];
        
    }return _mdict;
}

-(NSMutableArray *)Mdata{
    if (!_Mdata) {
        _Mdata = [NSMutableArray array];
    }return _Mdata;
}

-(NSMutableArray *)updateNum{
    if (!_updateNum) {
        _updateNum = [NSMutableArray array];
        
        NSMutableDictionary *marr = [NSMutableDictionary dictionary];
        
        [marr setValue:@"111" forKey:@"111"];
        
        [self.updateNum addObject:marr];
        [self.updateNum addObject:marr];
        [self.updateNum addObject:marr];
        [self.updateNum addObject:marr];
        [self.updateNum addObject:marr];
        [self.updateNum addObject:marr];
        [self.updateNum addObject:marr];
        [self.updateNum addObject:marr];
        [self.updateNum addObject:marr];
        [self.updateNum addObject:marr];
        [self.updateNum addObject:marr];
        [self.updateNum addObject:marr];
        [self.updateNum addObject:marr];
        [self.updateNum addObject:marr];
        [self.updateNum addObject:marr];
        [self.updateNum addObject:marr];
        [self.updateNum addObject:marr];
        [self.updateNum addObject:marr];
        
        
        NSLog(@"count = %ld",_updateNum.count);
        
    }return _updateNum;
}

-(void)viewDidLoad{
    self.navigationItem.title = @"我的购物车";
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    self.navigationController.navigationBarHidden = NO;
    self.tableView = [[UITableView alloc]initWithFrame:Sc_bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    self.view.backgroundColor = My_gray;
    
    [self.view addSubview:_tableView];
    
    [self initBottomView];
    
    [self requestShopCar];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    
}


-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//更新购物车数据 更改商品件数
-(void)updateShopCarData:(UIButton *)sender{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userToken = [user objectForKey:@"userToken"];
    
    if (!userToken) {
        [mainWindowss makeToast:@"请先登录"];
        return;
    }
    
    NSString *LoadPath = [NSString stringWithFormat:@"%@.update",ShopCarPath];
    NSString *nonce = [self GetNonce];
    NSString *timestamp = [self getNowTimeTimestamp];
    NSString *signStr = [NSString stringWithFormat:@"token=%@&12345",userToken];
    NSString *sign = [self MD5:signStr];
    
    NSArray *arr = _Mdata[sender.tag];
    
    NSMutableArray *Marr = [NSMutableArray array];
    NSInteger index = 0;
    for (NSDictionary *dict in arr) {
        
        NSDictionary *updateDict = @{@"goodsid":dict[@"goodsid"],@"id":dict[@"id"],@"total":[self.updateNum[sender.tag] objectForKey:[NSString stringWithFormat:@"%ld",index]]};
        [Marr addObject:updateDict];
        index ++;
    }
    
    
    NSLog(@"更新购物车数据 更改商品件数%@",Marr);
    
    NSData *data = [NSJSONSerialization
     dataWithJSONObject:Marr options:NSJSONWritingPrettyPrinted
     error:nil];
    
    NSString *datastr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *updict = @{@"nonce":nonce,@"timestamp":timestamp,@"token":userToken,@"sign":sign,@"data":datastr};
    
    
    
    [[ObjectTools sharedManager] POST:LoadPath parameters:updict progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        
        NSString *str = [dict[@"result"] objectForKey:@"message"];
        
        if (str) {
            [[UIApplication sharedApplication].keyWindow makeToast:str];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:@"请检查网络后重试"];
    }];
    
}


//删除购物车数据
-(void)deleteShopcar:(NSIndexPath *)indexpath{
    NSString *shopID = [[_Mdata[indexpath.section] objectAtIndex:indexpath.row] objectForKey:@"id"];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userToken = [user objectForKey:@"userToken"];
    
    if (!userToken) {
        [mainWindowss makeToast:@"请先登录"];
        return;
    }
    
    NSString *LoadPath = [NSString stringWithFormat:@"%@.remove",ShopCarPath];
    NSString *nonce = [self GetNonce];
    NSString *timestamp = [self getNowTimeTimestamp];
    NSString *signStr = [NSString stringWithFormat:@"token=%@&12345",userToken];
    NSString *sign = [self MD5:signStr];
    
    NSDictionary *dict = @{@"nonce":nonce,@"timestamp":timestamp,@"token":userToken,@"sign":sign,@"id":shopID};
    
    [[ObjectTools sharedManager] POST:LoadPath parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSLog(@"删除购物车数据 = %@",dict);
        NSLog(@"indexpath = %ld,%ld",indexpath.section,indexpath.row);
        
        
        int i = 0,j = 0;
        NSMutableArray *newData = [NSMutableArray array];
        for (NSArray *arr1 in self.Mdata) {
            
            NSMutableArray *newarr = [NSMutableArray array];
            for (NSDictionary *dict in arr1) {
                
                
                if (!(i == indexpath.section && j == indexpath.row)) {
                    
                    [newarr addObject:dict];
                }
                j++;
            }
            i++;
            
            [newData addObject:newarr];
        }
        
        [self.Mdata removeAllObjects];
        self.Mdata = nil;
        
        self.Mdata = newData;
        NSLog(@"%ld",[_Mdata[indexpath.section] count]);
        if ([_Mdata[indexpath.section] count] == 0) {
            [_Mdata removeObjectAtIndex:indexpath.section];
        }
        
        [self.view makeToast:@"删除成功"];
        
        [self.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:@"请检查网络后重试"];
    }];
    
}


//请求购物车数据
-(void)requestShopCar{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userToken = [user objectForKey:@"userToken"];
    
    if (!userToken) {
        [mainWindowss makeToast:@"请先登录"];
        return;
    }
    
    NSString *LoadPath = ShopCarPath;
    NSString *nonce = [self GetNonce];
    NSString *timestamp = [self getNowTimeTimestamp];
    NSString *signStr = [NSString stringWithFormat:@"token=%@&12345",userToken];
    NSString *sign = [self MD5:signStr];
    
    NSDictionary *dict = @{@"nonce":nonce,@"timestamp":timestamp,@"token":userToken,@"sign":sign};
    
    [[ObjectTools sharedManager] POST:LoadPath parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        //merchname merchid
        
        [self.Mdata removeAllObjects];
        
        NSLog(@"购物车数据 = %@",dict);
        
        NSArray *result = dict[@"result"];
        if ([dict[@"status"] intValue] == 1) {
            [self.Mdata addObjectsFromArray:result];
        }
        else if ([dict[@"status"] intValue] == 0){
            _tableView.hidden = YES;
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(Sc_w/2 - 30, 30, 60, 60)];
            imgV.image = [UIImage imageNamed:@"gaowuc"];
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake((Sc_w - 300)/2, 90, 300, 50)];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = [UIColor grayColor];
            lab.font = [UIFont systemFontOfSize:14];
            lab.text = @"购物车中空空如也~";
            [self.view addSubview:imgV];
            [self.view addSubview:lab];
            return;
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:@"请检查网络后重试"];
    }];
}


//底部结算显示界面
-(void)initBottomView{
    
    UIView *mybottomView = [[UIView alloc]initWithFrame:CGRectMake(0, Sc_h - 44 - 64, Sc_w, 44)];
    mybottomView.backgroundColor = [UIColor whiteColor];
    
    self.allSelect = [[UIButton alloc]initWithFrame:CGRectMake(10, 7, 60, 30)];
    [_allSelect setTitle:@"全选" forState:UIControlStateNormal];
    [_allSelect setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_allSelect setImage:[UIImage imageNamed:@"morensz"] forState:UIControlStateNormal];
    _allSelect.titleLabel.font = [UIFont systemFontOfSize:15];
    _allSelect.tag = 101;
    [_allSelect addTarget:self action:@selector(allSelectClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.lastMoney = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 250, 0, 140, 22)];
    _lastMoney.text = @"合计:￥0.00";
    _lastMoney.textAlignment = NSTextAlignmentRight;
    _lastMoney.textColor = [UIColor redColor];
    
    NSMutableAttributedString * attriStr=[[NSMutableAttributedString alloc]initWithString:_lastMoney.text];
    NSRange range = [_lastMoney.text rangeOfString:@"合计:"];
    [attriStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:range];
    _lastMoney.attributedText = attriStr;
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 100 - 80, 22, 70, 22)];
    label.text = @"不含运费";
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont systemFontOfSize:14];
    
    self.finsh = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 100, 0, 100, 44)];
    [_finsh setTitle:@"结算" forState:UIControlStateNormal];
    [_finsh addTarget:self action:@selector(finshed) forControlEvents:UIControlEventTouchUpInside];
    _finsh.backgroundColor = Color_system;
    
    
    [mybottomView addSubview:_allSelect];
    [mybottomView addSubview:_lastMoney];
    [mybottomView addSubview:_finsh];
    [mybottomView addSubview:label];
    
    [self.view addSubview:mybottomView];
}

//全选
-(void)allSelectClick:(UIButton *)sender{
    if (sender.tag == 101) {
        sender.tag = 100;
        [sender setImage:[UIImage imageNamed:@"morensz-xuanz"] forState:UIControlStateNormal];
        flagAll = 1;
    }else{
        sender.tag = 101;
        [sender setImage:[UIImage imageNamed:@"morensz"] forState:UIControlStateNormal];
        flagAll = 0;
    }
    
    [self.tableView reloadData];
    
}

//结算
-(void)finshed{
    
    if (totalMoney == 0) {
        [self.view makeToast:@"请先选择要购买的商品"];
        return;
    }
    
    NSLog(@"结算 跳往下一个页面");
    NSLog(@"data = %@",_userBuyData);
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (ShopCarModel *model in _userBuyData) {
        NSDictionary *dict = @{@"goodsid":model.goodsid,@"total":[_updateNum[model.section] objectForKey:[NSString stringWithFormat:@"%ld",model.row]],@"optionid":model.optionID,@"id":model.cartid};
        NSLog(@"dict = %@",dict);
        [arr addObject:dict];
    }
    
    [self nowbuy:arr];
}


/**
 立即购买按钮动作
*/

-(void)nowbuy:(NSMutableArray *)arr{
    
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userToken = [user objectForKey:@"userToken"];
    
    if (!userToken) {
        [mainWindowss makeToast:@"请先登录"];
        return;
    }
    
    
    NSString *nonce = [self GetNonce];
    NSString *timestamp = [self getNowTimeTimestamp];
    NSString *signStr = [NSString stringWithFormat:@"token=%@&12345",userToken];
    NSString *sign = [self MD5:signStr];
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //0快递  1自提
    NSDictionary *addDict = @{@"nonce":nonce,@"timestamp":timestamp,@"token":userToken,@"sign":sign,@"goodsdata":str,@"quickid":@"0"};
    
    NSLog(@"str = %@",str);
    
    ShopCarBuyViewCtr *vc = [[ShopCarBuyViewCtr alloc]init];
    
    
    
    [[ObjectTools sharedManager] POST:ShopCarBuy parameters:addDict progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSLog(@"shopcarbut = %@",dict);
        if([dict[@"status"] integerValue]== 1){
            
            vc.Mdict = dict[@"result"];
            if ([[dict[@"result"] objectForKey:@"zt"] integerValue] == 1) {
                vc.isZT = true;
            }else
                vc.isZT = false;
            
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        }else{
            [self.view makeToast:@"参数错误"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [self.view makeToast:@"请检查网络后重试"];
    }];
    
    
    NSLog(@"购买");
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.Mdata.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *arr = self.Mdata[section];
    
    return arr.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [self.Mdata[indexPath.section] objectAtIndex:indexPath.row];
    NSLog(@"商品内容 = %@",dict);
    ProductViewControll *vc = [[ProductViewControll alloc]init];
    vc.productID = dict[@"goodsid"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//cell内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [self.Mdata[indexPath.section] objectAtIndex:indexPath.row];
    ShopCarModel *model = [[ShopCarModel alloc]initWithDict:dict];
    model.section = indexPath.section;
    model.row = indexPath.row;
    model.optionID = dict[@"optionid"];
    model.cartid = dict[@"id"];
    
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:model.optionID];
    if (!cell) {
        cell = [[MyTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:model.optionID];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *imagePath = [NSString stringWithFormat:@"/%@%@%@.arch",model.goodsid,model.title,model.optiontitle];
            NSData *Cachadata = [NSData dataWithContentsOfFile:[App_document stringByAppendingString:imagePath]];
            if (Cachadata.length == 0) {
                NSString *imageUrl = [NSString stringWithFormat:@"%@%@",AddressPath,model.thumb];
                NSURL *url = [NSURL URLWithString:imageUrl];
                Cachadata = [NSData dataWithContentsOfURL:url];
                [Cachadata writeToFile:[App_document stringByAppendingString:imagePath] atomically:YES];
            }
            UIImage *image = [UIImage imageWithData:Cachadata];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.shoppingImgView.image = image;
            });
        });
        cell.choosedCount = [model.total integerValue];
        cell.optionstock = [model.optionstock integerValue];
        
        NSLog(@"[model.total integerValue] = %ld",[model.total integerValue]);
        cell.title.text = model.title;
        
        NSString *typenames = model.optiontitle;
        cell.typeName.text = @"所选规格 : ";
        [cell.colortype setTitle:typenames forState:UIControlStateNormal];
        
        cell.colortype.frame = CGRectMake(cell.title.frame.origin.x + 60, CGRectGetMaxY(cell.title.frame) + 10, 14 * typenames.length, 20);
        if (typenames.length <= 2) {
            cell.colortype.frame = CGRectMake(cell.title.frame.origin.x + 60, CGRectGetMaxY(cell.title.frame) + 10, 18 * typenames.length, 20);
        }

        
        cell.price.text = [NSString stringWithFormat:@"￥%@",model.marketprice];
        cell.countLab.text = [NSString stringWithFormat:@"x%@",model.total];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
    }
    
    __weak ShopListViewController *weakSelf = self;
    
    __block MyTableViewCell *weakcell = cell;
    
    //移除购物车商品block
    
    cell.removeBlock = ^{
        NSLog(@"remove");
        
        [weakSelf deleteShopcar:indexPath];
        
        //处于选中状态 删除用户购买数据中的这一条
        if (weakcell.selectBtn.selected) {
            
            totalMoney -= [model.marketprice floatValue] * [cell.buyCount.numberFD.text intValue];
            
            self.lastMoney.text = [NSString stringWithFormat:@"合计:￥%.2f",totalMoney];
            
            [self.userBuyData removeObject:model];
        }
        
        
    };
    
    //选中或者取消选中block
    
    cell.selectBlock = ^(NSInteger choosedCount){
        NSLog(@"%f",[model.marketprice floatValue] * choosedCount );
        
        totalMoney += [model.marketprice floatValue] * choosedCount;
        
        self.lastMoney.text = [NSString stringWithFormat:@"合计:￥%.2f",totalMoney];
        
        if (weakcell.selectBtn.selected) {
            NSLog(@"+");
            [self.userBuyData addObject:model];
        }else{
            [self.userBuyData removeObject:model];
            
            NSLog(@"-");
        }
    };
    
//    将需要每次刷新的东西放在外面
    
    //默认不在编辑状态
    cell.countLab.hidden = NO;
    cell.buyCount.hidden = YES;
    cell.removeBtn.hidden = YES;
    
    
    //获取每组头部视图
    UIView *headView = [self.mdict objectForKey:[NSString stringWithFormat:@"%ld",indexPath.section]];
    
//    最下端全选按钮，只控制每组组头的全选按钮
    if (flagAll == 1) {
        for (UIButton *btn in headView.subviews){
            if (btn.tag == 10086) {//非选中状态
                btn.tag = 10085;
                btn.selected = YES;
            }
        }
        if (indexPath.section == self.Mdata.count) {
            
            flagAll = 2;
        }
        
        
    }else if(flagAll == 0){
        for (UIButton *btn in headView.subviews){
            if (btn.tag == 10085) {//非选中状态
                btn.tag = 10086;
                btn.selected = NO;
            }
        }
        if (indexPath.section == self.Mdata.count) {
            
            flagAll = 2;
        }
    }
    
    
    for (UIButton *btn in headView.subviews) {
        //判断是编辑状态还是默认
        if (btn.tag == 10000 + indexPath.section) {//编辑状态
            cell.countLab.hidden = YES;
            cell.buyCount.hidden = NO;
            cell.removeBtn.hidden = NO;
        }
        
        //一组全选状态
        if (btn.tag == 10085) {
            //如果商品没有选中  1.选中 2.总价+ 3.用户购买数据+
            if (!cell.selectBtn.selected) {
                
                cell.selectBtn.selected = !cell.selectBtn.selected;
                NSInteger num = [cell.buyCount.numberFD.text integerValue];
                totalMoney += [model.marketprice floatValue] * num;
                self.lastMoney.text = [NSString stringWithFormat:@"合计:￥%.2f",totalMoney];
                [self.userBuyData addObject:model];
                
                NSLog(@"一组全选 添加商品 第%ld行",indexPath.row);
            }
        }
        
        //一组全不选状态
        else if (btn.tag == 10086){
            //如果商品选中  1.取消选中 2.总价- 3.用户购买数据-
            if (cell.selectBtn.selected) {
                cell.selectBtn.selected = !cell.selectBtn.selected;
                NSInteger num = [cell.buyCount.numberFD.text integerValue];
                totalMoney -= [model.marketprice floatValue] * num;
                self.lastMoney.text = [NSString stringWithFormat:@"合计:￥%.2f",totalMoney];
                NSMutableArray *modelArr = [NSMutableArray array];
                
                for (ShopCarModel *carmodel in _userBuyData) {
                    if ([carmodel.title isEqualToString:model.title] && [carmodel.optiontitle isEqualToString:model.optiontitle]) {
                        
                    }else
                        [modelArr addObject:carmodel];
                }
                
                [_userBuyData removeAllObjects];
                [_userBuyData addObjectsFromArray:modelArr];
                
                NSLog(@"减少了购买商品%@",model);
            }
        }
    }
    
    
    cell.countLab.text = [NSString stringWithFormat:@"x%i",[cell.buyCount.numberFD.text intValue]];
    [self.updateNum[indexPath.section] setObject:cell.buyCount.numberFD.text forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
    
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [self.mdict objectForKey:[NSString stringWithFormat:@"%lu", (long)section]];
    
    if (headView != nil) {
        return headView;
    }
    headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 40)];
    
    headView.backgroundColor = [UIColor whiteColor];
    
    UIImage *normolImg = [UIImage imageNamed:@"morensz"];
    UIImage *selectImg = [UIImage imageNamed:@"morensz-xuanz"];
    
    //    选中按钮
    UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    
    [selectBtn addTarget:self action:@selector(allclickSelect:) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn setImage:normolImg forState:UIControlStateNormal];
    [selectBtn setImage:selectImg forState:UIControlStateSelected];
    selectBtn.tag = 10086;
    
    [headView addSubview:selectBtn];
    
    
    UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 300, 20)];
    companyLabel.font = [UIFont systemFontOfSize:15];
    
    //编辑按钮
    UIButton *editBt = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 60, 5, 50, 30)];
    [editBt setTitle:@"编辑" forState:UIControlStateNormal];
    editBt.titleLabel.font = [UIFont systemFontOfSize:15];
    [editBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [editBt addTarget:self action:@selector(shopeditClick:) forControlEvents:UIControlEventTouchUpInside];
    [editBt setTitle:@"完成" forState:UIControlStateSelected];
    [editBt setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    editBt.tag = section;
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 65, 10, 2, 20)];
    label.backgroundColor = My_gray;
    [headView addSubview:label];
    [headView addSubview:editBt];
    
    NSString *sectionTitle = [[_Mdata[section] firstObject] objectForKey:@"merchname"];
    
    int sectionID = [[[_Mdata[section] firstObject] objectForKey:@"merchid"] intValue];
    
    NSLog(@"%@ -%@-",sectionTitle,[NSString new]);
    if (sectionID == 0) {
        companyLabel.text = @"深圳智能屋";
    }else{
        companyLabel.text = sectionTitle;
    }
    
    [headView addSubview:companyLabel];
    
    [self.mdict setObject:headView forKey:[NSString stringWithFormat:@"%lu", (long)section]];
    return headView;
}

//每组头视图 编辑按钮 编辑状态是 10000+section 非编辑状态是section
-(void)shopeditClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    
    if (sender.selected) {
        sender.tag += 10000;
        [self.tableView reloadData];
        
    }else{
        sender.tag -= 10000;
        [UIView animateWithDuration:0.1 animations:^{
            [self.tableView reloadData];
        } completion:^(BOOL finished) {
            [self updateShopCarData:sender];
        }];
        
        
    }
    
}

//每组头视图 全选按钮 编辑状态是 10085 非编辑状态是10086
-(void)allclickSelect:(UIButton *)bt{
    bt.selected = !bt.selected;
    
    flagAll = 2;
    
    if(bt.tag == 10086)
        bt.tag = 10085;
    else
        bt.tag = 10086;
    
    [self.tableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 40;
    }
    else
    {
        return 40;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 1)
        return 110;
    return 10;
}

-(NSString *)GetNonce{
    NSArray *arr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    
    NSMutableString *mStr = [[NSMutableString alloc]init];
    for (int i = 0; i < 16; i++) {
        int x = arc4random()%36;
        [mStr appendString:arr[x]];
    }
    //    NSLog(@"mStr = %@",mStr);
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
