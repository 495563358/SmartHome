//
//  MerchantViewController.m
//  SmartMall
//
//  Created by Smart house on 2017/11/6.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "MerchantViewController.h"

#import "MyOrderTopTabBar.h"

#import "ProjectdesignVC.h"

#import "BusinesslicenceVC.h"

#import "UIView+Toast.h"
#import "MapViewController.h"

#import "ObjectTools.h"

#import "JZLocationConverter.h"

//商品
#import "CollectCell.h"
#import "ProductViewControll.h"

#define ProductsInfo @"r=business.appindex.goods"

#define CommentsInfo @"r=business.appindex.comment"

@interface MerchantViewController ()<UITableViewDelegate,UITableViewDataSource,MyOrderTopTabBarDelegate>{
    UIButton *commentlastBtn;
    
    UILabel *contentLab;
    
    UIView *commentView;
    
    UILabel *nodataLabel;
}

@property(nonatomic,strong)UITableView *tableview;

@property(nonatomic,strong)MyOrderTopTabBar *topBar;

@property(nonatomic,strong)NSMutableArray *mdata1;

@property(nonatomic,strong)NSMutableArray *mdata2;


@end

@implementation MerchantViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",_infoDict);
    self.navigationItem.title = _infoDict[@"merchname"];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -24, 0, 0);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    self.view.backgroundColor = My_gray;
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, Sc_h - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableview];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    
    [self createHead];
    
    nodataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 260, Sc_w, 30)];
    nodataLabel.textAlignment = NSTextAlignmentCenter;
    nodataLabel.text = @"暂时还没有数据";
    nodataLabel.hidden = YES;
    [self.view addSubview:nodataLabel];
}

-(void)createHead{
    UIImageView *merchBanner = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 150)];
    merchBanner.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[AddressPath stringByAppendingString:_infoDict[@"imgfile"]]]]];
    
    _topBar = [[MyOrderTopTabBar alloc]initWithArray:@[@"商户",@"产品",@"评价"]];
    _topBar.frame = CGRectMake(0, 160, Sc_w, 49);
    _topBar.delegate = self;
    _topBar.backgroundColor = [UIColor whiteColor];
    
    
    UIView *headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 210)];
    headerV.backgroundColor = My_gray;
    [headerV addSubview:merchBanner];
    [headerV addSubview:_topBar];
    
    _tableview.tableHeaderView = headerV;
    
}

-(void)tabBar:(MyOrderTopTabBar *)tabBar didSelectIndex:(NSInteger)index{
    
    _tableview.tag = index;
    
    
    nodataLabel.hidden = YES;
    
    _topBar.superview.frame = CGRectMake(0, 0, Sc_w, 210);
    _tableview.tableHeaderView = _topBar.superview;
    commentView.hidden = YES;
    
    if (index == 0) {
        [_tableview reloadData];
        return;
    }
    
    if (index == 1) {
        if (_mdata1.count != 0) {
            [_tableview reloadData];
            return;
        }
        [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:ProductsInfo] parameters:@{@"merchid":_infoDict[@"id"]} progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *resultInfo = (NSDictionary *)responseObject;
            NSLog(@"res = %@",resultInfo);
            
            if ([resultInfo[@"status"] intValue] == 1) {
                NSArray *arr = resultInfo[@"result"][@"goods"];
                self.mdata1 = [NSMutableArray arrayWithArray:arr];
            }else{
                nodataLabel.hidden = NO;
            }
            [_tableview reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.view makeToast:@"网络错误,请检查网络后重试"];
        }];
        
        
    }
    if (index == 2) {
        
        if (!commentView) {
            commentView = [[UIView alloc]initWithFrame:CGRectMake(0, 210, Sc_w, 40)];
            commentView.backgroundColor = [UIColor whiteColor];
            NSArray *arr = @[@"全部",@"好评",@"中评",@"差评",@"晒图"];
            commentView.tag = 1;
            CGFloat btnW = Sc_w/5;
            for (int i = 0; i<5; i++) {
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(btnW * i, 0, btnW, 40)];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn setTitleColor:Color_system forState:UIControlStateSelected];
                [btn setTitle:arr[i] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
                [commentView addSubview:btn];
                btn.tag = i+1;
                [btn addTarget:self action:@selector(changecommentstr:) forControlEvents:UIControlEventTouchUpInside];
                if(i==0){
                    btn.selected = YES;
                    commentlastBtn = btn;
                }
            }
        }
        commentView.hidden = NO;
        _topBar.superview.frame = CGRectMake(0, 0, Sc_w, 250);
        [_topBar.superview addSubview:commentView];
        _tableview.tableHeaderView = _topBar.superview;
        
        
        if (_mdata2.count != 0) {
            [_tableview reloadData];
            return;
        }
        
        [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:CommentsInfo] parameters:@{@"merchid":_infoDict[@"id"]} progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *resultInfo = (NSDictionary *)responseObject;
            NSLog(@"res = %@",resultInfo);
            
            if ([resultInfo[@"status"] intValue] == 1) {
                NSArray *arr = resultInfo[@"result"][@"list"];
                self.mdata2 = [NSMutableArray arrayWithArray:arr];
            }else{
                nodataLabel.hidden = NO;
            }
            [_tableview reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}


//查看什么类型的评论
-(void)changecommentstr:(UIButton *)sender{
    
    nodataLabel.hidden = YES;
    if(sender.selected)
        return;
    
    if(commentlastBtn){
        commentlastBtn.selected = NO;
    }
    
    sender.selected = YES;
    
    commentlastBtn = sender;
    
    
    NSMutableString *commentStr = [NSMutableString new];
    
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
    
    commentView.tag = sender.tag;
    
    NSDictionary *dict = @{@"merchid":_infoDict[@"id"],@"page":@"1",@"order":commentStr};
    
    [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:CommentsInfo] parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultInfo = (NSDictionary *)responseObject;
        NSLog(@"res = %@",resultInfo);
        
        if ([resultInfo[@"status"] intValue] == 1) {
            NSArray *arr = resultInfo[@"result"][@"list"];
            self.mdata2 = [NSMutableArray arrayWithArray:arr];
        }else{
            [self.mdata2 removeAllObjects];
            nodataLabel.hidden = NO;
        }
        [_tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}



-(void)downloadRes{
    [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:@"r=merch.applist.nearby"] parameters:@{@"lng":_infoDict[@"lng"],@"lat":_infoDict[@"lat"]} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"详细信息 = %@",responseObject);
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
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1) {
        return self.mdata1.count;
    }else if (tableView.tag == 2) {
        return self.mdata2.count;
    }
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1) {
        return 115;
    }else if(tableView.tag == 2){
        CGFloat hh = 100;
        NSDictionary *dict = _mdata2[indexPath.row];
        if ([dict[@"images"] length] > 10) {
            hh += 90;
        }
        if ([dict[@"replay_content"] length] > 0) {
            hh += 50;
        }
        if ([dict[@"append_content"] length] > 0) {
            hh += 50;
        }
        if ([dict[@"append_images"] length] > 10) {
            hh += 90;
        }
        if ([dict[@"append_replay_content"] length] > 0) {
            hh += 30;
        }
        NSLog(@"hh = %f",hh);
        return hh;
    }
    return 50;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 2) {
        UITableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)commentView.tag]];
        
        if(!cell3){
            cell3 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%ld",(long)commentView.tag]];
            
            NSDictionary *commentinfo = _mdata2[indexPath.row];
            
            UIImageView *headimg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 9, 28, 28)];
            headimg.layer.cornerRadius = 14;
            headimg.layer.masksToBounds = YES;
            
            UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(50, 14, 200, 20)];
            name.font = [UIFont systemFontOfSize:15];
            
            UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 200, 14, 180, 20)];
            time.textAlignment = NSTextAlignmentRight;
            time.font = [UIFont systemFontOfSize:13];
            time.textColor = [UIColor grayColor];
            
            for(int i = 0;i<[commentinfo[@"level"] intValue];i++){
                UIButton *starView = [[UIButton alloc]initWithFrame:CGRectMake(10 + 16 * i, 45, 14, 14)];
                [starView setImage:[UIImage imageNamed:@"pingfen-xuanz"] forState:UIControlStateNormal];
                [cell3.contentView addSubview:starView];
            }
            
            NSString *str = commentinfo[@"images"];
            
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            
            NSArray *images = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            CGFloat height = [commentinfo[@"content"] length]/25 + 1;
            
            UILabel *commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 65, Sc_w - 20, 25 * height)];
            commentLabel.font = [UIFont systemFontOfSize:15];
            commentLabel.numberOfLines = 0;
            
            CGFloat hh = commentLabel.frame.origin.y + commentLabel.frame.size.height + 10;
            if ([commentinfo[@"images"] length] > 10) {
                hh += 90;
                for(int j = 0 ;j<images.count;j++){
                    UIButton *imgBtns = [[UIButton alloc]initWithFrame:CGRectMake(10 + 87 * j , commentLabel.frame.origin.y + commentLabel.frame.size.height + 10, 77, 77)];
                    [cell3.contentView addSubview:imgBtns];
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        UIImage *immm = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[AddressPath stringByAppendingString:images[j]] ]]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [imgBtns setImage:immm forState:UIControlStateNormal];
                        });
                    });
                }
            }
            if ([commentinfo[@"replay_content"] length] > 0) {
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, hh, Sc_w - 20, 20)];
                label.font = [UIFont systemFontOfSize:14];
                label.text = [@"掌柜回复:" stringByAppendingString:commentinfo[@"replay_content"]];
                label.backgroundColor = My_gray;
                [cell3.contentView addSubview:label];
                hh += 30;
            }
            if ([commentinfo[@"append_content"] length] > 0) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, hh, Sc_w - 20, 20)];
                label.font = [UIFont systemFontOfSize:14];
                label.text = [@"用户追加评价:" stringByAppendingString:commentinfo[@"append_content"]];
                [cell3.contentView addSubview:label];
                hh += 30;
            }
            if ([commentinfo[@"append_images"] length] > 10) {
                NSString *str = commentinfo[@"append_images"];
                
                NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                
                NSArray *images = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                
                for(int j = 0 ;j<images.count;j++){
                    UIButton *imgBtns = [[UIButton alloc]initWithFrame:CGRectMake(10 + 87 * j , hh, 77, 77)];
                    [cell3.contentView addSubview:imgBtns];
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        UIImage *immm = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[AddressPath stringByAppendingString:images[j]] ]]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [imgBtns setImage:immm forState:UIControlStateNormal];
                        });
                    });
                }
                hh += 90;
            }
            
            if ([commentinfo[@"append_replay_content"] length] > 0) {
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, hh, Sc_w - 20, 20)];
                label.font = [UIFont systemFontOfSize:14];
                label.text = [@"掌柜回复:" stringByAppendingString:commentinfo[@"append_replay_content"]];
                label.backgroundColor = My_gray;
                [cell3.contentView addSubview:label];
                hh += 30;
            }
            
            [cell3.contentView addSubview:headimg];
            [cell3.contentView addSubview:name];
            [cell3.contentView addSubview:time];
            [cell3.contentView addSubview:commentLabel];
            
            headimg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:commentinfo[@"headimgurl"]]]];
            name.text = commentinfo[@"nickname"];
            time.text = commentinfo[@"createtime"];
            commentLabel.text = commentinfo[@"content"];
            
            cell3.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        return cell3;
    }
    
    
    
    if (tableView.tag == 1) {
        CollectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userPool"];
        if (!cell) {
            cell = [[CollectCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"userPool"];
        }
        
        NSDictionary *collectDict = self.mdata1[indexPath.row];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[AddressPath stringByAppendingString:collectDict[@"thumb"]]]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageview.image = image;
            });
        });
        cell.titleL.text = collectDict[@"title"];
        cell.price.text = [ NSString stringWithFormat:@"￥ %@",collectDict[@"marketprice"]];
        
        
        cell.shareBtn.hidden = YES;
        cell.deldBtn.hidden = YES;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pool"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"pool"];
        NSArray *arr1 = @[@"gongs",@"dianhua",@"weizhi",@"gongsijianz",@"gongszcxx",@"shouquan",@"zhengshu"];
        NSArray *arr2 = @[_infoDict[@"merchname"],_infoDict[@"mobile"],_infoDict[@"address"],@"公司简介",@"工商注册信息",[@"已入驻智能屋  区域:" stringByAppendingString:_infoDict[@"city"]],@"资质证书"];
        cell.imageView.image = [UIImage imageNamed:arr1[indexPath.row]];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = arr2[indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0||indexPath.row == 1||indexPath.row == 2||indexPath.row == 3||indexPath.row == 4||indexPath.row == 6) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 2)
        return;
    if (tableView.tag == 1) {
        ProductViewControll *vc = [[ProductViewControll alloc]init];
        vc.productID = _mdata1[indexPath.row][@"id"];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (indexPath.row == 0||indexPath.row == 1||indexPath.row == 2||indexPath.row == 3||indexPath.row == 4) {
        
        ProjectdesignVC *vc = [ProjectdesignVC new];
        if (indexPath.row == 0) {
            vc.urlStr = _infoDict[@"shopurl"];
            vc.titlename = @"商户店铺";
        }
        if(indexPath.row == 1){
            NSString *telstr = [NSString stringWithFormat:@"tel:%@",_infoDict[@"mobile"]];
            UIWebView * callWebview = [[UIWebView alloc]init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:telstr]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
            return;
        }
        
        if (indexPath.row == 2) {
            
            [self downloadRes];
            
            return;
        }
        if (indexPath.row == 3) {
            vc.urlStr = _infoDict[@"merchurl"];
            vc.titlename = @"公司简介";
        }
        if (indexPath.row == 4) {
            vc.urlStr = _infoDict[@"busurl"];
            vc.titlename = @"工商注册信息";
        }
        NSLog(@"1");
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 6){
        
        BusinesslicenceVC *busvc = [BusinesslicenceVC new];
        busvc.images = _infoDict[@"bus_licence"];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:busvc animated:YES];
    }
    
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
