//
//  ApplyEnterViewController.m
//  SmartMall
//
//  Created by Smart house on 2017/11/3.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "ApplyEnterViewController.h"
#import "ProjectdesignVC.h"
#import "PlacePickerView.h"
#import "TZImagePickerController.h"

#define Getdata @"r=merch.appregister"
#define Postdata @"r=merch.appregister.add"

#import "ObjectTools.h"
#import "UIView+Toast.h"
#import <CommonCrypto/CommonDigest.h>

@interface ApplyEnterViewController ()<UITextFieldDelegate,AYPlaceViewDelegate,TZImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    UITextField *text1;
    UITextField *text2;
    UITextField *text3;
    UITextField *text4;
    UITextField *text5;
    UITextField *text6;
    UITextField *text7;
    UITextField *text8;
    UITextField *text9;
    UITextField *text10;
    UITextField *text11;
    
    UIButton *protectBtn;
    
    UIImageView *tempImg;
    
    NSDictionary *typeData;
    
    
    UIButton *okBtn;
    UIButton *cancelBtn;
    UIPickerView *typePicker;
    
    NSMutableArray *marrs;
}

@property(nonatomic,strong)PlacePickerView *areaPicker;

@property(nonatomic,strong)NSMutableArray *imageDatas;


@property(nonatomic,strong)UIView *backView;

@property (nonatomic, assign)NSInteger selectedMain;
@property (nonatomic, assign)NSInteger selectedSub;
@end

@implementation ApplyEnterViewController

-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:Sc_bounds];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.5;
        [self.view addSubview:_backView];
    }return _backView;
}

-(NSMutableArray *)imageDatas{
    if (!_imageDatas) {
        _imageDatas = [NSMutableArray array];
    }return _imageDatas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = My_gray;
    self.navigationItem.title = @"申请入驻";
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [self createView];
    
    self.areaPicker = [[PlacePickerView alloc]initWithDelegate:self];
    
    
    [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:Getdata] parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([dict[@"status"] intValue]==1) {
            typeData = dict[@"result"];
            
            NSArray *pids = typeData[@"pid"];
            NSArray *cids = typeData[@"cid"];
            
            marrs = [NSMutableArray array];
            
            for (NSDictionary *dic1 in pids) {
                NSMutableArray *marr1 = [NSMutableArray array];
                for (NSDictionary *dic2 in cids) {
                    if ([dic2[@"pid"] isEqualToString:dic1[@"id"]]) {
                        [marr1 addObject:dic2];
                    }
                }
                [marrs addObject:marr1];
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请确认您已经登录了智能屋商城,否则会导致资料上传失败" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

-(void)createView{
    
    UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, Sc_h - 64)];
    [self.view addSubview:scrollview];
    
    NSArray *arr1 = @[@"商户名称:",@"主营项目:",@"公司介绍:",@"营业执照:",@"联系人:",@"手机号:",@"申请区域:",@"申请级别:",@"投入设施:",@"账号:",@"密码:"];
    text1 = [UITextField new];
    text2 = [UITextField new];
    text3 = [UITextField new];
    text4 = [UITextField new];
    text5 = [UITextField new];
    text6 = [UITextField new];
    text7 = [UITextField new];
    text8 = [UITextField new];
    text9 = [UITextField new];
    text10 = [UITextField new];
    text11 = [UITextField new];
    
    NSArray *arr2 = @[text1,text2,text3,text4,text5,text6,text7,text8,text9,text10,text11];
    NSArray *arr3 = @[@"商户名字",@"例如智能家居等",@"简单介绍下商户(不超过20个字)",@"个人上传身份证,企业上传营业执照",@"您的称呼",@"手机号",@"选择省份城市",@"选择代理级别",@"选择投入设施",@"账号(用于登录多商户后台,请认真填写)",@"密码(用于登录多商户后台,请认真填写)"];
    
    for (int i = 0; i<arr1.count; i++) {
        CGFloat yy1 = 0;
        if (i<4) {
            yy1 = 0 + i * 44;
        }else if(i>3 && i<9){
            yy1 = 90 + i * 44;
        }else if(i>8){
            yy1 = 100 + i * 44;
        }
        
        UITextField *temp = arr2[i];
        temp.frame = CGRectMake(0, yy1, Sc_w, 43);
        temp.backgroundColor = [UIColor whiteColor];
        temp.font = [UIFont systemFontOfSize:14];
        temp.placeholder = arr3[i];
        temp.tag = i;
        temp.delegate = self;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, yy1, 80, 43)];
        label.font = [UIFont systemFontOfSize:14];
        label.text = [@"    " stringByAppendingString:arr1[i]];
        
        temp.leftView = label;
        temp.leftViewMode = UITextFieldViewModeAlways;
        
        [scrollview addSubview:temp];
    }
    
    
    //营业执照
    UIView *accView = [[UIView alloc]initWithFrame:CGRectMake(0, 132+43, Sc_w, 80)];
    accView.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:accView];
    
    
    UIImageView *commentImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 72, 72)];
    
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
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPicture:)];
    
    [commentImg addGestureRecognizer:tap1];
    
    [commentImg addSubview:imgadd];
    
    [commentImg addSubview:lab1];
    
    for (int i = 0; i < 3; i++) {
        UIImageView *commentImg1 = [[UIImageView alloc]initWithFrame:CGRectMake(10 + 82 * i, 0, 72, 72)];
        
        commentImg1.layer.borderWidth = 1;
        commentImg1.layer.borderColor = My_gray.CGColor;
        [accView addSubview:commentImg1];
        commentImg1.hidden = YES;
        
        commentImg1.tag = i;
    }
    
    
    
    [accView addSubview:commentImg];
    
    
    
    UIView *protocolView = [[UIView alloc]initWithFrame:CGRectMake(0, 584 + 10, Sc_w, 43)];
    protocolView.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:protocolView];
    
    protectBtn = [[UIButton alloc]initWithFrame:CGRectMake(13, 13, 17, 17)];
    [protectBtn setImage:[UIImage imageNamed:@"morensz-xuanz"] forState:UIControlStateSelected];
    [protectBtn setImage:[UIImage imageNamed:@"morensz"] forState:UIControlStateNormal];
    [protectBtn addTarget:self action:@selector(protocolClick:) forControlEvents:UIControlEventTouchUpInside];
    [protocolView addSubview:protectBtn];
    
    UILabel *labeltext = [[UILabel alloc]initWithFrame:CGRectMake(37, 0, Sc_w - 100, 43)];
    
    NSString *protStr = @"我已阅读并接受【商户服务协议】";
    NSRange range = [protStr rangeOfString:@"【商户服务协议】"];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:protStr];
    [attrStr addAttribute:NSForegroundColorAttributeName value:Color_system range:range];
    
    labeltext.font = [UIFont systemFontOfSize:14];
    labeltext.attributedText = attrStr;
    
    [protocolView addSubview:labeltext];
    
    UIView *views = [[UIView alloc]initWithFrame:CGRectMake(50, 0, Sc_w - 100, 43)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [views addGestureRecognizer:tap];
    [protocolView addSubview:views];
    
    UIButton *applyBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 584 + 54 + 25, Sc_w - 20, 41)];
    applyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    applyBtn.layer.cornerRadius = 10;
    applyBtn.backgroundColor = Color_system;
    [applyBtn setTitle:@"立即申请" forState: UIControlStateNormal];
    [applyBtn setTitle:@"资料上传中" forState: UIControlStateSelected];
    [applyBtn addTarget: self action:@selector(enterClick:) forControlEvents:UIControlEventTouchUpInside];
    [scrollview addSubview:applyBtn];
    
    scrollview.contentSize = CGSizeMake(Sc_w, 200 + 44 * 12);
}

//添加图片
-(void)addPicture:(UITapGestureRecognizer *)tap{
    
    tempImg = (UIImageView *)tap.view;
    
    TZImagePickerController *imageVC = [[TZImagePickerController alloc]initWithMaxImagesCount:3 - [self.imageDatas count] delegate:self];
    
    [imageVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL flag) {
        NSLog(@"photo = %@ ass = %@ 原图 = %i",photos,assets,flag);
        
        for (UIImage *selectImg in photos) {
            
            //把数据转化为json数据
            NSData *data = UIImageJPEGRepresentation(selectImg, 1);
            //.updata
            
            NSString *jsonData = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            
            [self.imageDatas addObject:jsonData];
            
            NSLog(@"数组 = %@",_imageDatas);
            
            for (UIImageView *view in tempImg.superview.subviews) {
                
                NSLog(@"1213");
                if (view.hidden == YES) {
                    view.image = selectImg;
                    view.hidden = NO;
                    
                    CGRect frame = tempImg.frame;
                    tempImg.frame = CGRectMake(frame.origin.x + 82, frame.origin.y, frame.size.width, frame.size.height);
                    if (view.tag == 2) {
                        tempImg.hidden = YES;
                    }
                    break;
                }
            }
        }
    }];
    [self presentViewController:imageVC animated:YES completion:nil];
}

//主营项目
-(void)levelClick:(UIButton *)sender{
    
    okBtn.hidden = YES;
    cancelBtn.hidden = YES;
    _backView.hidden = YES;
    //确定
    if ([sender.currentTitle isEqualToString:@"确认"]) {
        NSString *name1 = [[typeData[@"pid"] objectAtIndex:_selectedMain] objectForKey:@"catename"];
        NSString *name2 = [[[marrs objectAtIndex:_selectedMain] objectAtIndex:_selectedSub] objectForKey:@"catename"];
        NSLog(@"%@  -- %@",name1,name2);
        text2.text = [NSString stringWithFormat:@"%@ %@",name1,name2];
    }
    [typePicker removeFromSuperview];
    typePicker = nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSArray *pids = typeData[@"pid"];
    if (component == 0)
    {
        return pids.count;
    }
    else if (component == 1)
    {
        return [marrs[_selectedMain] count];
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component __TVOS_PROHIBITED{
    return 150;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED{
    return 50;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED{
    
    NSArray *pids = typeData[@"pid"];
    
    if (component == 0)
    {
        return [[pids objectAtIndex:row] objectForKey:@"catename"];
    }
    else if (component == 1)
    {
        return [[marrs[_selectedMain] objectAtIndex:row] objectForKey:@"catename"];
    }
    return @"暂无数据";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        self.selectedMain = row;
        self.selectedSub = 0;
        
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    else if (component == 1)
    {
        self.selectedSub = row;
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 1 ||textField.tag == 3 || textField.tag == 6|| textField.tag == 7|| textField.tag == 8) {
        if (textField.tag == 1) {
            self.backView.hidden = NO;
            
            if (!okBtn) {
                okBtn = [[UIButton alloc]initWithFrame:CGRectMake((Sc_w - 300)/2+250, (Sc_h - 110-200)/2+160, 40, 30)];
                [okBtn setTitle:@"确认" forState:UIControlStateNormal];
                [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [okBtn addTarget:self action:@selector(levelClick:) forControlEvents:UIControlEventTouchUpInside];
                
                cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake((Sc_w - 300)/2 + 10, (Sc_h - 110-200)/2+160, 40, 30)];
                [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
                [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [cancelBtn addTarget:self action:@selector(levelClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.view addSubview:okBtn];
                [self.view addSubview:cancelBtn];
                
                okBtn.hidden = YES;
                cancelBtn.hidden = YES;
            }
            typePicker = [[UIPickerView alloc]initWithFrame:CGRectMake((Sc_w - 300)/2, (Sc_h - 110-200)/2, 300, 200)];
            typePicker.backgroundColor = [UIColor whiteColor];
            
            [self.view addSubview:typePicker];
            typePicker.delegate = self;
            typePicker.dataSource = self;
            typePicker.tag = 2;
            
            okBtn.tag = 2;
            cancelBtn.tag = 2;
            
            okBtn.hidden = NO;
            cancelBtn.hidden = NO;
            
            [self.view bringSubviewToFront:okBtn];
            [self.view bringSubviewToFront:cancelBtn];
            return NO;
        }
        
        
        if (textField.tag == 3) {
            return NO;
        }
        
        //申请区域
        if (textField.tag == 6) {
            _areaPicker.isHidden = NO;
            return NO;
        }
        
        textField.textColor = Color_system;
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        if (textField.tag == 7) {//申请级别
            
            for (NSDictionary *dic in typeData[@"level"]) {
                [alertVC addAction:[UIAlertAction actionWithTitle:dic[@"levelname"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    text8.text = action.title;
                }]];
            }
        }
        if (textField.tag == 8) {//投入设施
            for (NSDictionary *dic in typeData[@"taste"]) {
                [alertVC addAction:[UIAlertAction actionWithTitle:dic[@"catename"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    text9.text = action.title;
                }]];
            }
        }
        [self presentViewController:alertVC animated:YES completion:nil];
        return NO;
    }
    return YES;
}

-(void)areaPickerView:(AYPlaceView *)areaPickerView didSelectArea:(NSString *)area{
    text7.text = area;
}

-(void)tapClick{
    ProjectdesignVC *vc = [ProjectdesignVC new];
    vc.urlStr = @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=merch.appregister.notice";
    vc.titlename = @"商户服务协议";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)protocolClick:(UIButton *)sender{
    sender.selected = !sender.selected;
}

-(void)enterClick:(UIButton *)sender{
    
    if (sender.selected) {
        return;
    }
    
    if (!(text1.text&&text2.text&&text3.text&&text5.text&&text6.text&&text7.text&&text8.text&&text9.text&&text10.text&&text11.text&&self.imageDatas.count)) {
        [self.view makeToast:@"请完善资料后再上传"];
        return;
    }

    if (!protectBtn.selected) {
        [self.view makeToast:@"请阅读并同意商户服务协议"];
        return;
    }
    
    sender.selected = YES;
    
    NSString *pid = [typeData[@"pid"][_selectedMain] objectForKey:@"id"];
    NSString *cateid = [[[marrs objectAtIndex:_selectedMain] objectAtIndex:_selectedSub] objectForKey:@"id"];


    NSString *places = text7.text;
    NSArray *arrplaces = [places componentsSeparatedByString:@"-"];
    NSString *newplaces = [NSString stringWithFormat:@"%@-%@",arrplaces[0],arrplaces[1]];

    NSString *levelid = @"";
    for (NSDictionary *dic in typeData[@"level"]) {
        if ([dic[@"levelname"] isEqualToString:text8.text]) {
            levelid = dic[@"id"];
            break;
        }
    }

    NSString *investID = @"";
    for (NSDictionary *dic in typeData[@"taste"]) {
        if ([dic[@"catename"] isEqualToString:text9.text]) {
            investID = dic[@"id"];
            break;
        }
    }

    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userToken = [user objectForKey:@"userToken"];
    NSString *nonce = [self GetNonce];
    NSString *timestamp = [self getNowTimeTimestamp];
    NSString *signStr = [NSString stringWithFormat:@"token=%@&12345",userToken];
    NSString *sign = [self MD5:signStr];
    
    NSDictionary *datas = @{@"merchname":text1.text,@"cateid":cateid,@"pid":pid,@"comanyprofile":text3.text,@"images":_imageDatas,@"contactperson":text5.text,@"phone":text6.text,@"city":newplaces,@"levelid":levelid,@"tasteid":investID,@"account":text10.text,@"password":text11.text};
    
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:datas options:NSJSONWritingPrettyPrinted error:nil];
    
    NSLog(@"data = %@",datas);
    NSLog(@"jsondata = %@",jsonData);
    
    NSString *str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *uploading = @{@"nonce":nonce,@"timestamp":timestamp,@"token":userToken,@"sign":sign,@"data":str};
    
//    NSLog(@"datas = %@",uploading);
    
    [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:Postdata] parameters:uploading progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSLog(@"%@",responseObject);
        sender.selected = NO;
        if ([[(NSDictionary *)responseObject objectForKey:@"status"] intValue] == 1) {
            [self.view makeToast:@"已提交申请"];
        }else{
            [self.view makeToast:[[(NSDictionary *)responseObject objectForKey:@"result"] objectForKey:@"message"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
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

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
