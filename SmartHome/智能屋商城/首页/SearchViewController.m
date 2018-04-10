//
//  SearchViewController.m
//  SmartMall
//
//  Created by Smart house on 2017/10/16.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "SearchViewController.h"

#import "Loadmore.h"

#import "ModelData.h"

#import "ObjectTools.h"

#import "UIView+Toast.h"
#import "ProductViewControll.h"

#import "MBProgressHUD.h"

#define StaticCell  @"CollectionCell"

//搜索路径
#define searchPath @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=search.getlist"

//热门搜索

@interface SearchViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UISearchBarDelegate>{
    UITextField *searchText;
    BOOL isMore;
}


@property(nonatomic,strong)UICollectionView *collectionView;


@property(nonatomic,strong)UIView *backview;

@property(nonatomic,strong)Loadmore *loadmore;

@property(nonatomic,strong)UIView *historyView;



//显示数据
@property(nonatomic,strong)NSMutableArray *showData;

//下载缓存总数据
@property(nonatomic,strong)NSMutableArray *cacheData;

@property(nonatomic,strong)NSMutableArray *historyData;


@property(nonatomic,copy)NSString *recommend;
@property(nonatomic,copy)NSString *nowProduct;
@property(nonatomic,copy)NSString *discount;
@property(nonatomic,copy)NSString *sendfree;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *hot;

@end

@implementation SearchViewController


-(NSMutableArray *)showData{
    if (!_showData) {
        _showData = [NSMutableArray array];
    }return _showData;
}

-(NSMutableArray *)cacheData{
    if (!_cacheData) {
        _cacheData = [NSMutableArray array];
    }return _cacheData;
}

-(NSMutableArray *)historyData{
    if (!_historyData) {
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        _historyData = [NSMutableArray array];
        [_historyData addObjectsFromArray:[user objectForKey:@"historyData"]];
        
    }return _historyData;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = My_gray;
    
    [self createHead];
    
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.itemSize = CGSizeMake(Sc_w/2-5, (1.4) * (Sc_w/2 - 20));
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGRect Frame = CGRectMake(0, Sc_bounds.origin.y + 105, Sc_w, Sc_h-105);
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:Frame collectionViewLayout:flowLayout];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:StaticCell];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.hidden = YES;
    
    flowLayout.footerReferenceSize = CGSizeMake(Sc_w, 20);
    
    [self.view addSubview:_collectionView];
    
    
}

-(void)createHotsearch{
    
    NSArray *arr = @[@"智能屋主机",@"门锁",@"电动窗帘"];
    
    
    CGFloat hh = 0;
    
    self.historyView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, Sc_w, 100 + hh)];
    _historyView.backgroundColor = [UIColor whiteColor];
    
    NSLog(@" history = %@",self.historyData);
    
    if (self.historyData.count != 0) {
        
        NSInteger section = _historyData.count/4 + 1;
        
        NSInteger row = _historyData.count % 4;
        
        if (row == 0 && section != 0) {
            section --;
        }
        
        hh = 72 + 40 * ( section);
        _historyView.frame = CGRectMake(0, 60, Sc_w, 100 + hh);
        
        
        UIView *bule2 = [[UIView alloc]initWithFrame:CGRectMake(10, 65 + 47, 2, 15)];
        bule2.backgroundColor = Color_system;
        [_historyView addSubview:bule2];
        
        UILabel *historyL = [[UILabel alloc]initWithFrame:CGRectMake(18, 65 + 47, 100, 15)];
        historyL.font = [UIFont systemFontOfSize:14];
        historyL.text = @"历史搜索";
        [_historyView addSubview:historyL];
        
        UIButton *emptyHist = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 70, 65 + 42, 60, 25)];

        [emptyHist setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [emptyHist setTitleColor:Color_system forState:UIControlStateNormal];
        [emptyHist setTitle:@"清空记录" forState:UIControlStateNormal];
        [emptyHist addTarget:self action:@selector(emptyhistory) forControlEvents:UIControlEventTouchUpInside];
        emptyHist.titleLabel.font = [UIFont systemFontOfSize:14];
        [_historyView addSubview:emptyHist];
        
        
        for (int i = 0; i< _historyData.count ; i++) {
            
            NSInteger section1 = i/4;
            
            NSInteger row1 = i % 4;
            
//            if (row1 == 0 && section1 != 0) {
//                section1 --;
//            }
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10 + 91 * row1, 147 + 40 * section1, 81, 30)];
            btn.layer.cornerRadius = 5.0;
            btn.layer.masksToBounds = YES;
            btn.backgroundColor = My_gray;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(hotClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:_historyData[_historyData.count - 1 - i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_historyView addSubview:btn];
        }
        
        
    }
    
    
    
    UIView *space1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 5)];
    space1.backgroundColor = My_gray;
    [_historyView addSubview:space1];
    
    UIView *bule1 = [[UIView alloc]initWithFrame:CGRectMake(10, 20, 2, 15)];
    bule1.backgroundColor = Color_system;
    [_historyView addSubview:bule1];
    
    UILabel *hotL = [[UILabel alloc]initWithFrame:CGRectMake(18, 20, 100, 15)];
    hotL.font = [UIFont systemFontOfSize:14];
    hotL.text = @"热门推荐";
    [_historyView addSubview:hotL];
    
    
    for (int i = 0; i< arr.count ; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10 + 96*i, 55, 81, 30)];
        btn.layer.cornerRadius = 5.0;
        btn.layer.masksToBounds = YES;
        btn.backgroundColor = My_gray;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(hotClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_historyView addSubview:btn];
    }
    
    [self.view addSubview:_historyView];
    
}

-(void)emptyhistory{
    
    [_historyView removeFromSuperview];
    
    [_historyData removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:_historyData forKey:@"historyData"];
}


//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    [self createHotsearch];
//    return YES;
//}
//
//-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    
//}


-(void)hotClick:(UIButton *)sender{
    
    NSLog(@" 点击了热门的： %@",sender.currentTitle);
    searchText.text = sender.currentTitle;
    [self startSearch];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    [self createHotsearch];
    self.collectionView.hidden = YES;
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [_historyView removeFromSuperview];
    _historyView = nil;
    self.collectionView.hidden = NO;
}


-(void)createHead{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 105)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui-hui"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backBtn];
    
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(40, 25, Sc_w - 90, 30)];
    searchBar.barTintColor = [UIColor whiteColor];
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.showsCancelButton = NO;
    
    
    searchBar.delegate = self;
    
    for (UIView *subView in searchBar.subviews) {
        if ([subView isKindOfClass:[UIView  class]]) {
            [[subView.subviews objectAtIndex:0] removeFromSuperview];
            if ([[subView.subviews objectAtIndex:0] isKindOfClass:[UITextField class]]) {
                searchText = [subView.subviews objectAtIndex:0];
                searchText.layer.cornerRadius = 5;
                
                searchText.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
                searchText.returnKeyType = UIReturnKeySearch;
                //设置输入框边框的颜色
                //                    textField.layer.borderColor = [UIColor blackColor].CGColor;
                //                    textField.layer.borderWidth = 1;
                
                //设置输入字体颜色
                //                    textField.textColor = [UIColor lightGrayColor];
                
                //设置默认文字颜色
//                UIColor *color = [UIColor grayColor];
//                [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"搜索感兴趣的内容"
//                                                                                    attributes:@{NSForegroundColorAttributeName:color}]];
                //修改默认的放大镜图片
//                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
//                imageView.backgroundColor = [UIColor clearColor];
//                imageView.image = [UIImage imageNamed:@"gww_search_ misplaces"];
//                textField.leftView = imageView;
            }
        }
    }
    searchBar.placeholder = @"智能屋主机";
    [searchBar becomeFirstResponder];
    [headerView addSubview:searchBar];
    
    
    UIButton *searchbtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 50, 20, 40, 40)];
    [searchbtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchbtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [searchbtn setTitleColor:Color_system forState:UIControlStateNormal];
    [searchbtn addTarget:self action:@selector(startSearch) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:searchbtn];
    
    
    UIButton *aBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 65, Sc_w/4, 40)];
    [aBtn setTitleColor:Color_system forState:UIControlStateNormal];
    [aBtn setTitle:@"综合" forState:UIControlStateNormal];
    aBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [aBtn addTarget:self action:@selector(sortBytogether:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:aBtn];
    
    CGFloat btnX = Sc_w/4;
    UIButton *bBtn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, 65, Sc_w/4, 40)];
    [bBtn setTitleColor:Color_system forState:UIControlStateNormal];
    [bBtn setTitle:@"销量" forState:UIControlStateNormal];
    bBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bBtn addTarget:self action:@selector(sortBySale:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:bBtn];
    
    btnX += Sc_w/4;
    UIButton *cBtn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, 65, Sc_w/4, 40)];
    [cBtn setTitleColor:Color_system forState:UIControlStateNormal];
    [cBtn setTitle:@"价格" forState:UIControlStateNormal];
    cBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cBtn addTarget:self action:@selector(sortByPrice:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:cBtn];
    
    btnX += Sc_w/4;
    UIButton *dBtn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, 65, Sc_w/4, 40)];
    [dBtn setTitleColor:Color_system forState:UIControlStateNormal];
    [dBtn setTitle:@"筛选" forState:UIControlStateNormal];
    dBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [dBtn addTarget:self action:@selector(sortByChoose:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:dBtn];
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
        
        
        __block SearchViewController *weakSelf = self;
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
        [achBtn addTarget:self action:@selector(startFind) forControlEvents:UIControlEventTouchUpInside];
        achBtn.tag = 100;
        [_backview addSubview:achBtn];
        
        
        
    }
    return _backview;
}


-(void)startFind{
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
    
    NSString *finPath = [searchPath stringByAppendingString:[NSString stringWithFormat:@"%@%@%@%@%@%@",self.recommend,_nowProduct,_hot,_discount,_sendfree,_time]];
    NSLog(@" path = %@",finPath);
    
    [self downLoadPict:searchText.text andPath:finPath];
    
    _nowProduct = @"&nowProduct=0";
    _recommend = @"&recommand=0";
    _hot = @"&hot=0";
    _discount = @"&discount=0";
    _time = @"&time=0";
    _sendfree = @"&sendfree=0";
    
    [self hiddenBackView];
    
    [self.collectionView reloadData];
}


//筛选按钮事件
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

//出现backview后点击其他地方的手势动作(隐藏backview并移除)
-(void)hiddenBackView{
    __weak SearchViewController *weakSelf = self;
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

//综合
- (void)sortBytogether:(UIButton *)sender {
    
    [self.showData removeAllObjects];
    
    [_showData addObjectsFromArray:_cacheData];
//    self.showData = self.cacheData;
    [self.collectionView reloadData];
    
}

//销量排序
- (void)sortBySale:(UIButton *)sender {
    NSMutableArray *arr = self.showData;
    for (int i = 0; i<arr.count; i++) {
        for (int j = i; j<arr.count; j++) {
            
            ModelData *model1 = arr[i];
            ModelData *model2 = arr[j];
            if ( [model1.salesreal integerValue] > [model2.salesreal integerValue] ) {
                [arr exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    self.showData = arr;
    [self.collectionView reloadData];
    
}

//价格排序
- (void)sortByPrice:(UIButton *)sender {
    NSMutableArray *arr = self.showData;
    
    
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
        self.showData = arr;
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
    self.showData = arr;
    [self.collectionView reloadData];
    sender.tag = 10000;
    
}

//筛选
- (void)sortByChoose:(UIButton *)sender {
    
    if (self.showData.count == 0) {
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.backview];
    __weak SearchViewController *weakSelf = self;
    self.backview.alpha = 0;
    if (!isMore) {
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.backview.alpha = 0.8;
            isMore = !isMore;
        }];
    }
}

//开始搜索
-(void)startSearch{
    NSString *searchContext = searchText.text;
    if (0 == searchContext.length) {
        searchText.text = @"智能屋主机";
    }
    NSLog(@"%@",searchText.text);
    
    int flag = 1;
    
    for (NSString *str in self.historyData) {
        if ([str isEqualToString:searchText.text]) {
            [_historyData removeObject:str];
            [_historyData addObject:str];
            flag = 0;
            break;
        }
    }
    if (flag == 1) {
        //历史记录
        [self.historyData addObject:searchText.text];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_historyData forKey:@"historyData"];
    
    
    [self downLoadPict:searchText.text andPath:searchPath];
    
    [searchText resignFirstResponder];
    
}

- (void)downLoadPict:(NSString *)searchcontext andPath:(NSString *)searchpath{
    
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    NSLog(@"path = %@",searchpath);
    [[ObjectTools sharedManager] GET:searchpath parameters:@{@"keyword":searchcontext} progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"------------------------%@------",responseObject);
        NSLog(@"已经获取图片网址");
        NSDictionary *backdata = (NSDictionary *)responseObject;
        
        NSArray *arr = backdata[@"result"];
        __block int tag = 0;
        
        [self.cacheData removeAllObjects];
        
        if ([backdata[@"status"] intValue] == 0) {
            self.collectionView.hidden = YES;
             [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            [[UIApplication sharedApplication].keyWindow makeToast:@"暂时没有找到任何商品"];
            return;
            
        }else
            self.collectionView.hidden = NO;
        
        
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
                [self.cacheData addObject:model];
                
                
            }
//            for (int ind = 0; ind<index; ind++) {
//                [self.cacheData removeObjectAtIndex:0];
//            }
            [self.showData removeAllObjects];
            [self.showData addObjectsFromArray:_cacheData];
            
            NSLog(@"商品列表下载 : %ld",_showData.count);
            dispatch_async(dispatch_get_main_queue(), ^{
                //                    [self reloadInputViews];
                [self.collectionView reloadData];
                 [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            });
        
        });
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}



-(void)controlEventValueChanged{
    [self.collectionView reloadData];
    NSLog(@"%s",__func__);
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.showData.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


//cell内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ModelData *model = self.showData[indexPath.row];
    
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
    
    ModelData *model = self.showData[indexPath.row];
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


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [searchText resignFirstResponder];
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
//    [searchText resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;
    
}

@end
