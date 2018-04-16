

//
//  TestViewController.m
//  SmartMall
//
//  Created by Smart house on 2017/8/21.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "TestViewController.h"
#import "ObjectTools.h"
#import "UIView+Toast.h"
#import "ModelData.h"
#import "ProductViewControll.h"
#import "Loadmore.h"

#import "MJRefresh.h"
#import "MJRefreshHeader.h"

#define StaticCell  @"CollectionCell"

@interface TestViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>{
    BOOL isMore;
    int requestPage;
}

@property(nonatomic,strong)NSMutableArray *shopData;

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)NSMutableArray *cacheData;

@property(nonatomic,strong)UIView *backview;

@property(nonatomic,strong)Loadmore *loadmore;

@property(nonatomic,strong)UIRefreshControl *refreshControl;


@property(nonatomic,copy)NSString *recommend;
@property(nonatomic,copy)NSString *nowProduct;
@property(nonatomic,copy)NSString *discount;
@property(nonatomic,copy)NSString *sendfree;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *hot;

@end

@implementation TestViewController


-(void)requestData:(UIButton *)sender{
    
    switch (sender.tag) {
        case 2000:
            self.recommend = @"&recommand=1";
            sender.tag -= 1000;
            break;
        case 2001:
            self.nowProduct = @"&new=1";
            sender.tag -= 1000;
            break;
        case 2002:
            self.hot = @"&hot=1";
            sender.tag -= 1000;
            break;
        case 2003:
            self.discount = @"&discount=1";
            sender.tag -= 1000;
            break;
        case 2004:
            self.sendfree = @"&sendfree=1";
            sender.tag -= 1000;
            break;
        case 2005:
            self.time = @"&time=1";
            sender.tag -= 1000;
            break;
        case 1000:
            self.recommend = @"&recommand=0";
            sender.tag += 1000;
            break;
        case 1001:
            self.nowProduct = @"&new=0";
            sender.tag += 1000;
            break;
        case 1002:
            self.hot = @"&hot=0";
            sender.tag += 1000;
            break;
        case 1003:
            self.discount = @"&discount=0";
            sender.tag += 1000;
            break;
        case 1004:
            self.sendfree = @"&sendfree=0";
            sender.tag += 1000;
            break;
        case 1005:
            self.time = @"&time=0";
            sender.tag += 1000;
            break;
            
        default:
            break;
    }
    
    
}


-(void)achieve{
    if (![_recommend isEqualToString:@"&recommand=1"]) {
        _recommend = @"&recommand=0";
    }
    if (![_nowProduct isEqualToString:@"&nowProduct=1"]) {
        _nowProduct = @"&nowProduct=0";
    }
    if (![_hot isEqualToString:@"&hot=1"]) {
        _hot = @"&hot=0";
    }
    if (![_discount isEqualToString:@"&discount=1"]) {
        _discount = @"&discount=0";
    }
    if (![_sendfree isEqualToString:@"&sendfree=1"]) {
        _sendfree = @"&sendfree=0";
    }
    if (![_time isEqualToString:@"&time=1"]) {
        _time = @"&time=0";
    }
    [self.cacheData removeAllObjects];
    [self.shopData removeAllObjects];
    requestPage = 1;
    NSString *finPath = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",_path,self.recommend,_nowProduct,_hot,_discount,_sendfree,_time];
    NSLog(@" path = %@",finPath);
    
    [self downLoadPict:finPath];
    
    _nowProduct = @"&nowProduct=0";
    _recommend = @"&recommand=0";
    _hot = @"&hot=0";
    _discount = @"&discount=0";
    _time = @"&time=0";
    _sendfree = @"&sendfree=0";
   
    [self hiddenBackView];
    
    [self.collectionView reloadData];
}

-(UIView *)backview{
    if (!_backview) {
        _backview = [[UIView alloc]initWithFrame:Sc_bounds];
        _backview.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenBackView)];
        [_backview addGestureRecognizer:recognizer];
        
        self.loadmore = [Loadmore sharedSingleton];
        _loadmore.backgroundColor = [UIColor whiteColor];
        _loadmore.center = CGPointMake(Sc_w/2, 64+44+_loadmore.frame.size.height/2);
        
        
        __block TestViewController *weakSelf = self;
        _loadmore.btnBlock = ^(UIButton *sender){
            if (sender.tag>1500) {
                [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                sender.layer.borderColor = [UIColor redColor].CGColor;
            }else{
                [sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                sender.layer.borderColor = [UIColor grayColor].CGColor;
            }
            [weakSelf requestData:sender];
            
        };
        [_backview addSubview:_loadmore];
        
        CGRect frame = _loadmore.frame;
        
        UIButton *achBtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w * 0.7 - 10, frame.origin.y + frame.size.height - 35, Sc_w * 0.3, 30)];
        [achBtn setTitle:@"确认" forState:UIControlStateNormal];
        [achBtn setTitleColor:Color_system forState:UIControlStateNormal];
        achBtn.layer.cornerRadius = 5.0;
        achBtn.layer.borderWidth = 1;
        achBtn.layer.borderColor = Color_system.CGColor;
        achBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [achBtn addTarget:self action:@selector(achieve) forControlEvents:UIControlEventTouchUpInside];
        achBtn.tag = 100;
        [_backview addSubview:achBtn];
        
        
        
    }
    return _backview;
}

//出现backview后点击其他地方的手势动作(隐藏backview并移除)
-(void)hiddenBackView{
    __weak TestViewController *weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.backview.alpha = 0;
        isMore = !isMore;
    } completion:^(BOOL finished) {
        [weakSelf.backview removeFromSuperview];
        weakSelf.backview = nil;
    }];
    for (UIButton *btn in _loadmore.subviews) {
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColor grayColor].CGColor;
    }
}


- (void)sortBytogether:(UIButton *)sender {
    
    NSMutableArray *arr = self.shopData;
    for (int i = 0; i<arr.count; i++) {
        for (int j = i; j<arr.count; j++) {
            
            ModelData *model1 = arr[i];
            ModelData *model2 = arr[j];
            if ( model1.index > model2.index ) {
                [arr exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    self.shopData = arr;
    [self.collectionView reloadData];
    
}

- (void)sortBySale:(UIButton *)sender {
    NSMutableArray *arr = self.shopData;
    for (int i = 0; i<arr.count; i++) {
        for (int j = i; j<arr.count; j++) {
            
            ModelData *model1 = arr[i];
            ModelData *model2 = arr[j];
            if ( [model1.salesreal integerValue] > [model2.salesreal integerValue] ) {
                [arr exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    self.shopData = arr;
    [self.collectionView reloadData];
    
}
- (void)sortByPrice:(UIButton *)sender {
    NSMutableArray *arr = self.shopData;
    
    
    if (sender.tag == 10000) {
        for (int i = 0; i<arr.count; i++) {
            for (int j = i; j<arr.count; j++) {
                
                ModelData *model1 = arr[i];
                ModelData *model2 = arr[j];
                
                if ( [[model1.price substringFromIndex:1] integerValue] < [[model2.price substringFromIndex:1] integerValue] ) {
                    [arr exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
            }
        }
        self.shopData = arr;
        [self.collectionView reloadData];
        sender.tag = 1000;
        return;
    }
    
    for (int i = 0; i<arr.count; i++) {
        for (int j = i; j<arr.count; j++) {
            
            ModelData *model1 = arr[i];
            ModelData *model2 = arr[j];
            
            if ( [[model1.price substringFromIndex:1] integerValue] > [[model2.price substringFromIndex:1] integerValue] ) {
                [arr exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    self.shopData = arr;
    [self.collectionView reloadData];
    sender.tag = 10000;
    
}
- (void)sortByChoose:(UIButton *)sender {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.backview];
    __weak TestViewController *weakSelf = self;
    self.backview.alpha = 0;
    if (!isMore) {
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.backview.alpha = 0.8;
            isMore = !isMore;
        }];
    }
}

-(NSMutableArray *)shopData{
    if (!_shopData) {
        _shopData = [NSMutableArray array];
    }return _shopData;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = My_gray;
    
    self.navigationItem.title = _name;
    
    
    UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 40)];
    btnView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnView];
    
    UIButton *aBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Sc_w/4, 40)];
    [aBtn setTitleColor:Color_system forState:UIControlStateNormal];
    [aBtn setTitle:@"综合" forState:UIControlStateNormal];
    aBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [aBtn addTarget:self action:@selector(sortBytogether:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:aBtn];
    
    CGFloat btnX = Sc_w/4;
    UIButton *bBtn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, 0, Sc_w/4, 40)];
    [bBtn setTitleColor:Color_system forState:UIControlStateNormal];
    [bBtn setTitle:@"销量" forState:UIControlStateNormal];
    bBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [bBtn addTarget:self action:@selector(sortBySale:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:bBtn];
    
    btnX += Sc_w/4;
    UIButton *cBtn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, 0, Sc_w/4, 40)];
    [cBtn setTitleColor:Color_system forState:UIControlStateNormal];
    [cBtn setTitle:@"价格" forState:UIControlStateNormal];
    cBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cBtn addTarget:self action:@selector(sortByPrice:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:cBtn];
    
    btnX += Sc_w/4;
    UIButton *dBtn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, 0, Sc_w/4, 40)];
    [dBtn setTitleColor:Color_system forState:UIControlStateNormal];
    [dBtn setTitle:@"筛选" forState:UIControlStateNormal];
    dBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [dBtn addTarget:self action:@selector(sortByChoose:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:dBtn];
    
    
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.itemSize = CGSizeMake(Sc_w/2-5, (1.4) * (Sc_w/2 - 20));
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGRect Frame = CGRectMake(0, Sc_bounds.origin.y + 40, Sc_w, Sc_h-60);
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:Frame collectionViewLayout:flowLayout];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:StaticCell];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.alwaysBounceVertical = YES;
    
    
    flowLayout.footerReferenceSize = CGSizeMake(Sc_w, 60);
    
    [self.view addSubview:_collectionView];
    
    
    requestPage = 1;
    [self downLoadPict:self.path];
    NSLog(@"1the view height is %f", self.view.frame.size.width);
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    
}


-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)controlEventValueChanged{
    [self.collectionView reloadData];
    NSLog(@"%s",__func__);
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shopData.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


//cell内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ModelData *model = self.shopData[indexPath.row];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:StaticCell forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        
        [view removeFromSuperview];
        
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Sc_w/2 - 10, Sc_w/2 - 10)];
    imageView.image = (UIImage *)model.thumb;
    [cell.contentView addSubview:imageView];
    
    CGFloat hh = Sc_w/2-10;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, hh, hh,30)];
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.text = model.title;
    [cell.contentView addSubview:titleLabel];
    
    //    hh += 30;
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,hh + 25, 71, 30)];
    priceLabel.font = [UIFont systemFontOfSize:14];
    priceLabel.textColor = [UIColor redColor];
    priceLabel.text = model.price;
    [cell.contentView addSubview:priceLabel];
    
    UILabel *prodPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(76, hh + 25,71, 30)];
    prodPriceLabel.font = [UIFont systemFontOfSize:14];
    prodPriceLabel.textColor = [UIColor grayColor];
    NSUInteger length = [model.productprice length];
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc]initWithString:model.productprice];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [newPrice addAttribute:NSStrikethroughColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, length)];
    
    //    [prodPriceLabel setAttributedText:newPrice];
    prodPriceLabel.text = model.productprice;
    
    [cell.contentView addSubview:prodPriceLabel];
    
    CGSize titlesize = [model.productprice boundingRectWithSize:CGSizeMake(MAXFLOAT, 44)
                        //根据Font确定
                                                        options:NSStringDrawingUsesFontLeading
                        //属性:{nssting,id}
                                                     attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
    
    
    CGPoint center = prodPriceLabel.center;
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,titlesize.width, 1)];
    lineLabel.backgroundColor = [UIColor grayColor];
    
    lineLabel.center = center;
    [cell.contentView addSubview:lineLabel];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 0, 5, 0);//分别为上、左、下、右
}
//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ModelData *model = self.shopData[indexPath.row];
    if (model.gid == nil) {
        return;
    }
    ProductViewControll *vc = [[ProductViewControll alloc]init];
    
    vc.productID = model.gid;
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(Sc_w/2-5, (1.4) * (Sc_w/2 - 20));
}

- (void)downLoadPict:(NSString *)path{
    
    [[ObjectTools sharedManager] GET:path parameters:@{@"page":[NSString stringWithFormat:@"%i",requestPage]} progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"图片下载资源%@",path);
        NSArray *arr = (NSArray *)responseObject;
        __block int tag = 0;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (NSDictionary *dic2 in arr) {
                tag++;
                NSString *imagePath2 = [NSString stringWithFormat:@"/%@.arch",dic2[@"title"]];
                NSData *Cachadata1 = [NSData dataWithContentsOfFile:[App_document stringByAppendingString:imagePath2]];
                if (Cachadata1.length == 0) {
                    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",AddressPath,dic2[@"thumb"]];
                    NSURL *url = [NSURL URLWithString:imageUrl];
                    Cachadata1 = [NSData dataWithContentsOfURL:url];
                    [Cachadata1 writeToFile:[App_document stringByAppendingString:imagePath2] atomically:YES];
                }
                UIImage *thumb = [UIImage imageWithData:Cachadata1];
                NSString *title = dic2[@"title"];
                NSString *price = dic2[@"marketprice"];
                NSString *productprice = dic2[@"productprice"];
                NSString *salesreal = dic2[@"salesreal"];
                
                ModelData *model = [ModelData getModelData:thumb andTitle:title andPrcie:price andproductprice:productprice];
                model.salesreal = salesreal;
                model.index = tag;
                model.gid = dic2[@"id"];
                [self.shopData addObject:model];
            }
            self.cacheData = self.shopData;
            
            NSLog(@"商品列表下载 : %ld",_shopData.count);
            
            if (_shopData.count%10 == 0) {
                
                __weak TestViewController *weakSelf = self;
                MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter new];
                [footer setRefreshingTarget:weakSelf refreshingAction:@selector(footerWays)];
                self.collectionView.mj_footer = footer;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collectionView reloadData];
                requestPage ++ ;
                [self.collectionView.mj_footer endRefreshing];
                [self.collectionView.mj_footer removeFromSuperview];
                if (_shopData.count%10 == 0) {
                    
                    __weak TestViewController *weakSelf = self;
                    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter new];
                    [footer setRefreshingTarget:weakSelf refreshingAction:@selector(footerWays)];
                    self.collectionView.mj_footer = footer;
                }
            });
            
        });
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

-(void)footerWays{
    [self downLoadPict:self.path];
}

@end
