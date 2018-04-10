//
//  CommentViewController.m
//  SmartMall
//
//  Created by Smart house on 2017/10/11.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "CommentViewController.h"


#import <AssetsLibrary/AssetsLibrary.h>
#import<AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#import "TZImagePickerController.h"


#import "ObjectTools.h"

#import "UIView+Toast.h"
//提交评论
#define submitComment @"r=order.appcomment.submit"

@interface CommentViewController()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>{
    NSArray *goodsData;
    
    UIImageView *tempImg;
    
    UITextView *lastTextView;
    
}


@property (nonatomic,strong)UITableView *tableview;


@property(nonatomic,strong)NSMutableArray *commentDatas;

@end


@implementation CommentViewController


-(NSMutableArray *)commentDatas{
    if (!_commentDatas) {
        _commentDatas = [NSMutableArray array];
        for (NSArray *arr1 in goodsData) {
            for (NSDictionary *dict in arr1) {
                NSMutableDictionary *mdict = [[NSMutableDictionary alloc]initWithDictionary:dict];
                
                [mdict setObject:_data[@"id"] forKey:@"id"];
                
                NSMutableArray *marr = [NSMutableArray array];
                [mdict setObject:marr forKey:@"images"];
                
                [mdict setObject:@"" forKey:@"content"];
                
                [_commentDatas addObject:mdict];
            }
        }
    }
    
    return _commentDatas;
}


-(bool)isSub{
    if (!_isSub) {
        _isSub = false;
    }return _isSub;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isSub == false)
        self.navigationItem.title = @"评价";
    else
        self.navigationItem.title = @"追加评价";
    self.view.backgroundColor = My_gray;
    self.navigationController.navigationBarHidden = NO;
    [self.view setBackgroundColor:My_gray];
    
    NSLog(@"评价信息 = %@",_data);
    goodsData = _data[@"goods"];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    
    
    UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 60, 40)];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitle:@"提交中" forState:UIControlStateSelected];
    [submitBtn addTarget:self action:@selector(submitCommentToWeb:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    submitBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 26, 0, 0);
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitBtn];
    
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, Sc_h - 64) style:UITableViewStyleGrouped];
    _tableview.backgroundColor = My_gray;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    _tableview.sectionHeaderHeight = 40;
    _tableview.sectionFooterHeight = 0.1;
    
    [self.view addSubview:_tableview];

    
}

//提交评论
-(void)submitCommentToWeb:(UIButton *)sender{
    
    if (sender.selected) {
        return;
    }
    
    [lastTextView endEditing:YES];
    
    if (self.isSub) {
        for (NSMutableDictionary *dict in self.commentDatas) {
            if ([dict[@"content"] isEqualToString:@""]) {
                [self.view makeToast:@"请先填写追加评论哟"];
                return;
            }
        }
    }else{
        for (NSMutableDictionary *dict in self.commentDatas) {
            if ([dict[@"content"] isEqualToString:@""]) {
                [self.view makeToast:@"请先填写评论哟"];
                return;
            }else if ([dict[@"startlevel"] intValue] == 0){
                [self.view makeToast:@"请先评分哟"];
                return;
            }
        }
    }
    
    sender.selected = YES;
    NSLog(@"_commentdata = %@",_commentDatas);
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_commentDatas options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [_userInfo setObject:str forKey:@"datas"];
    
    [_userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
    
    
    NSLog(@"评论返回 = %@",_userInfo[@"datas"]);
    
    [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:submitComment] parameters:_userInfo progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSLog(@"评论返回 = %@",dict);
        if ([dict[@"status"] intValue] == 1) {
            [mainWindowss makeToast:@"评论成功"];
        }else
            [mainWindowss makeToast:@"评论失败"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//cell内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row]];
        
        NSDictionary *dict = goodsData[indexPath.section][indexPath.row];
        
        //    商品图片
        UIImageView *shoppingImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 70, 70)];
        
        shoppingImgView.layer.borderWidth = 1;
        shoppingImgView.layer.borderColor = My_gray.CGColor;
        
        [cell.contentView addSubview:shoppingImgView];
        
        //    商品标题
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shoppingImgView.frame)+10, 10, Sc_w -CGRectGetMaxX(shoppingImgView.frame)-15, 21)];
        title.font=[UIFont systemFontOfSize:14];
        title.textColor=[UIColor blackColor];
        [cell.contentView addSubview:title];
        
        //    规格
        UILabel *typeName = [[UILabel alloc] initWithFrame:CGRectMake(title.frame.origin.x, CGRectGetMaxY(title.frame) + 10, 60, 20)];
        typeName.font=[UIFont systemFontOfSize:12];
        typeName.textColor=[UIColor blackColor];
        [cell.contentView addSubview:typeName];
        
        NSString *typenames = dict[@"optionname"];
        UIButton *colortype = [[UIButton alloc]initWithFrame:CGRectMake(title.frame.origin.x + 60, CGRectGetMaxY(title.frame) + 10, 14 * typenames.length, 20)];
        
        if (typenames.length <= 2) {
            colortype.frame = CGRectMake(title.frame.origin.x + 60, CGRectGetMaxY(title.frame) + 10, 18 * typenames.length, 20);
        }
        
        colortype.layer.cornerRadius = 3.0;
        colortype.titleLabel.font = [UIFont systemFontOfSize:12];
        colortype.backgroundColor = Color_system;
        [cell.contentView addSubview:colortype];
        
        
        UILabel *price = [[UILabel alloc]initWithFrame:CGRectMake(title.frame.origin.x, CGRectGetMaxY(typeName.frame)+12, 100, 17)];
        price.hidden =NO;
        price.font =  [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:price];
        
        
        UILabel *countLab = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 60, 60, 40, 20)];
        countLab.font = [UIFont systemFontOfSize:15];
        countLab.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:countLab];
        
        
        shoppingImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AddressPath,dict[@"thumb"]]]]];
        title.text = dict[@"title"];
        typeName.text = @"所选规格 : ";
        [colortype setTitle:typenames forState:UIControlStateNormal];
        price.text = [NSString stringWithFormat:@"￥%@",dict[@"price"]];
        countLab.text = [NSString stringWithFormat:@"x%@",dict[@"total"]];
        
        
        
        UIView *space = [[UIView alloc]initWithFrame:CGRectMake(0, 98, Sc_w, 10)];
        space.backgroundColor = My_gray;
        [cell.contentView addSubview:space];
        
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 108, Sc_w, 42)];
        [cell.contentView addSubview:view2];
        
        UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 150, Sc_w, 200)];
        [cell.contentView addSubview:view3];
        
        if (self.isSub) {
            view2.hidden = YES;
            view3.frame = CGRectMake(0, 108, Sc_w, 200);
        }
        
        //评分
        UILabel *scoreL = [[UILabel alloc]initWithFrame:CGRectMake(10, 6, 45, 30)];
        scoreL.font = [UIFont systemFontOfSize:14];
        scoreL.text = @"评分";
        [view2 addSubview:scoreL];
        
        for (int i = 0 ; i<5; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(50 + i * 16 , 14, 14, 14)];
            [btn setImage:[UIImage imageNamed:@"pingfen-moren"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"pingfen-xuanz"] forState:UIControlStateSelected];
            
            btn.tag = i+1 + indexPath.section * 1000 + indexPath.row * 100;
            
            [btn addTarget:self action:@selector(scoreAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [view2 addSubview:btn];
        }
        
        //评论内容
        
        UITextView *text = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 200)];
        text.layer.borderWidth = 1;
        text.layer.borderColor = My_gray.CGColor;
        [view3 addSubview:text];
        text.font = [UIFont systemFontOfSize:14];
        text.delegate = self;
        text.textColor = [UIColor grayColor];
        text.text = @"说点什么吧";
        text.tag = indexPath.section * 1000 + indexPath.row * 100;
        
        
        UIImageView *commentImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 200 - 16 - 72, 72, 72)];
        
        commentImg.layer.borderWidth = 1;
        commentImg.layer.borderColor = My_gray.CGColor;
        
        
        UIImageView *imgadd = [[UIImageView alloc]initWithFrame:CGRectMake(31, 24, 9, 9)];
        imgadd.image = [UIImage imageNamed:@"tianjiatup"];
        
        
        UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 36, 72, 24)];
        lab1.textColor = [UIColor grayColor];
        lab1.text = @"添加图片";
        lab1.font = [UIFont systemFontOfSize:12];
        lab1.textAlignment = NSTextAlignmentCenter;
        
        
        commentImg.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPicture:)];
        commentImg.tag = indexPath.section * 1000 + indexPath.row * 100 + 1000;
        
        [commentImg addGestureRecognizer:tap];
        
        [commentImg addSubview:imgadd];
        
        [commentImg addSubview:lab1];
        
        for (int i = 0; i < 4; i++) {
            UIImageView *commentImg1 = [[UIImageView alloc]initWithFrame:CGRectMake(10 + 82 * i, 200 - 16 - 72, 72, 72)];
            
            commentImg1.layer.borderWidth = 1;
            commentImg1.layer.borderColor = My_gray.CGColor;
            [text addSubview:commentImg1];
            commentImg1.hidden = YES;
            
            commentImg1.tag = i;
        }
        
        
        
        [text addSubview:commentImg];
        
        
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

//添加图片
-(void)addPicture:(UITapGestureRecognizer *)tap{
    
    
    tempImg = (UIImageView *)tap.view;
    
    NSInteger section = tempImg.tag/1000 - 1;
    NSInteger row = (tempImg.tag%1000)/100;
    
    NSInteger num = section * [goodsData[section] count] + row;
    
    
    
    TZImagePickerController *imageVC = [[TZImagePickerController alloc]initWithMaxImagesCount:4 - [self.commentDatas[num][@"images"] count] delegate:self];
    
    [imageVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL flag) {
        NSLog(@"photo = %@ ass = %@ 原图 = %i",photos,assets,flag);
        
        
        
        
        for (UIImage *selectImg in photos) {
            
            //把数据转化为json数据
            NSData *data = UIImageJPEGRepresentation(selectImg, 0.1);
            //.updata
            
            NSString *jsonData = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            
            [self.commentDatas[num][@"images"] addObject:jsonData];
            
//            [self.commentDatas[num][@"images"] addObject:selectImg];
            
            for (UIImageView *view in tempImg.superview.subviews) {
                
                NSLog(@"1213");
                if (view.hidden == YES) {
                    view.image = selectImg;
                    view.hidden = NO;
                    
                    CGRect frame = tempImg.frame;
                    tempImg.frame = CGRectMake(frame.origin.x + 82, frame.origin.y, frame.size.width, frame.size.height);
                    if (view.tag == 3) {
                        tempImg.hidden = YES;
                    }
                    
                    
                    break;
                }
            }
        }
        
//        NSLog(@"_comment = %@",_commentDatas);
        
    }];
    
    [self presentViewController:imageVC animated:YES completion:nil];
    
    
}

//评论文字 代理方法 系统
#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    NSInteger section = textView.tag/1000;
    NSInteger row = (textView.tag%1000)/100;
    
    NSInteger num = section * [goodsData[section] count] + row;
    
    
    [self.commentDatas[num] setObject:textView.text forKey:@"content"];
    
    if(textView.text.length < 1){
        textView.text = @"说点什么吧";
        textView.textColor = [UIColor grayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    lastTextView = textView;
    if([textView.text isEqualToString:@"说点什么吧"]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}


//点击星星评分
-(void)scoreAction:(UIButton *)sender{
    
    NSInteger section = sender.tag/1000;
    NSInteger row = (sender.tag%1000)/100;
    
    NSInteger num = section * [goodsData[section] count] + row;
    
    NSLog(@"super = %ld",num);
    
    NSInteger startlevel = sender.tag%100;
    
    for (UIButton *btn in [sender superview].subviews) {
        if (btn.tag > 0) {
            if (btn.tag <= sender.tag) {
                
                btn.selected = YES;
            }else
                btn.selected = NO;
        }
    }
    
    [self.commentDatas[num] setObject:[NSString stringWithFormat:@"%ld",startlevel] forKey:@"startlevel"];
    
//    NSLog(@"%@",_commentDatas);
    
}




-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

//组头内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSDictionary *data = [goodsData[section] firstObject];
    
    UIView *sectionHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 40)];
    sectionHeader.backgroundColor = [UIColor whiteColor];
    
    
    //店家名字
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 9, 22, 21)];
    imgV.image = [UIImage imageNamed:@"dianpu"];
    
    UILabel *shopname = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 150, 40)];
    shopname.font = [UIFont systemFontOfSize:15];
    shopname.text = data[@"merchname"];
    
    
    [sectionHeader addSubview:imgV];
    [sectionHeader addSubview:shopname];
    
    return sectionHeader;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSub) {
        return 308;
    }
    return 350;
}

//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return goodsData.count;
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [goodsData[section] count];
}


-(void)backClick{
    
    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的评论还未提交,确定要退出吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCtr addAction:action1];
    [alertCtr addAction:action2];
    
    [self presentViewController:alertCtr animated:YES completion:nil];
}

- (NSString *)getNowTimeTimestamp{
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
    
}

@end
