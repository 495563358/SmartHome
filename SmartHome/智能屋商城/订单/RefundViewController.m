//
//  RefundViewController.m
//  SmartMall
//
//  Created by Smart house on 2017/10/20.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "RefundViewController.h"

#import "ObjectTools.h"

#import "UIView+Toast.h"
//退货申请
#define requestRefund @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=order.apprefund.submit"

@interface RefundViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UITextField *processWays;
    UITextField *refundReason;
    UITextField *refundExplain;
    UITextField *refundTotal;
    UIImageView *commentImg;
    
}


@property(nonatomic,strong)UIView *processwayView;

@property(nonatomic,strong)UIImagePickerController *imagePickerController;

@end

@implementation RefundViewController

-(UIView *)processwayView{
    if (!_processwayView) {
        _processwayView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        _processwayView.backgroundColor = [UIColor blueColor];
    }return _processwayView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = My_gray;
    //    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.title = @"退款申请";
    
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    [self createView];
    [self creatFooter];
}

-(void)createView{
    
    UIView *whiteBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 10, Sc_w, 360)];
    whiteBackground.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:whiteBackground];
    
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 40)];
    
    processWays = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, Sc_w - 20, 40)];
    processWays.userInteractionEnabled = NO;
    processWays.text = @"退款(仅退款不退货)";
    processWays.font = [UIFont systemFontOfSize:13];
    
    //    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ways)];
    //    [view1 addGestureRecognizer:tap1];
    
    UILabel *leftview1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    leftview1.font = [UIFont systemFontOfSize:13];
    leftview1.text = @"处理方式";
    processWays.leftView = leftview1;
    processWays.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, Sc_w - 20, 1)];
    line1.backgroundColor = My_gray;
    
    //    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(Sc_w - 33, 12, 8, 15)];
    //    imgView.image = [UIImage imageNamed:@"gengduo-拷贝"];
    
    //    [processWays addSubview:imgView];
    [processWays addSubview:line1];
    [view1 addSubview:processWays];
    [whiteBackground addSubview:view1];
    
    
    [whiteBackground addSubview:[self creat2]];
    [whiteBackground addSubview:[self creat3]];
    [whiteBackground addSubview:[self creat4]];
    [whiteBackground addSubview:[self creat5]];
    
}


-(UIView *)creat2{
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, Sc_w, 40)];
    
    refundReason = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, Sc_w - 20, 40)];
    refundReason.userInteractionEnabled = NO;
    //    refundReason.text = @"";
    refundReason.placeholder = @"请选择您的退款原因";
    refundReason.font = [UIFont systemFontOfSize:13];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choosereason)];
    [view1 addGestureRecognizer:tap1];
    
    UILabel *leftview1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    leftview1.font = [UIFont systemFontOfSize:13];
    leftview1.text = @"退款原因";
    refundReason.leftView = leftview1;
    refundReason.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, Sc_w - 20, 1)];
    line1.backgroundColor = My_gray;
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(Sc_w - 33, 12, 8, 15)];
    imgView.image = [UIImage imageNamed:@"gengduo-拷贝"];
    
    [refundReason addSubview:line1];
    [refundReason addSubview:imgView];
    [view1 addSubview:refundReason];
    return view1;
}


-(UIView *)creat3{
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 80, Sc_w, 40)];
    
    refundExplain = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, Sc_w - 20, 40)];
    refundExplain.userInteractionEnabled = YES;
    //    refundExplain.text = @"";
    refundExplain.placeholder = @"您可以详细描述您的退款原因(选填)";
    refundExplain.font = [UIFont systemFontOfSize:13];
    
    //    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ways)];
    //    [view1 addGestureRecognizer:tap1];
    
    UILabel *leftview1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    leftview1.font = [UIFont systemFontOfSize:13];
    leftview1.text = @"退款说明";
    refundExplain.leftView = leftview1;
    refundExplain.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, Sc_w - 20, 1)];
    line1.backgroundColor = My_gray;
    
    [refundExplain addSubview:line1];
    [view1 addSubview:refundExplain];
    return view1;
}

-(UIView *)creat4{
    
    
    NSLog(@"%@",_orderInfo);
    NSString *price = _orderInfo[@"parentorder"][@"price"];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 120, Sc_w, 40)];
    
    refundTotal = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, Sc_w - 20, 40)];
    refundTotal.userInteractionEnabled = NO;
    refundTotal.text = price;
    refundTotal.font = [UIFont systemFontOfSize:13];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choosetotalmoney)];
    [view1 addGestureRecognizer:tap1];
    
    UILabel *leftview1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    leftview1.font = [UIFont systemFontOfSize:13];
    leftview1.text = @"退款金额";
    refundTotal.leftView = leftview1;
    refundTotal.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, Sc_w - 20, 1)];
    line1.backgroundColor = My_gray;
    
    
    [refundTotal addSubview:line1];
    [view1 addSubview:refundTotal];
    return view1;
}

-(UIView *)creat5{
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 160, Sc_w, 200)];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [view1 addGestureRecognizer:tap1];
    
    UILabel *leftview1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 60, 40)];
    leftview1.font = [UIFont systemFontOfSize:13];
    leftview1.text = @"上传凭证";
    
    commentImg = [[UIImageView alloc]initWithFrame:CGRectMake(80, 10, 160, 160)];
    
    commentImg.layer.borderWidth = 1;
    commentImg.layer.borderColor = My_gray.CGColor;
    
    
    UIImageView *imgadd = [[UIImageView alloc]initWithFrame:CGRectMake(75, 53, 9, 9)];
    imgadd.image = [UIImage imageNamed:@"tianjiatup"];
    
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, 160, 24)];
    lab1.textColor = [UIColor grayColor];
    lab1.text = @"添加图片";
    lab1.font = [UIFont systemFontOfSize:12];
    lab1.textAlignment = NSTextAlignmentCenter;
    
    
    commentImg.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPicture:)];
    
    
    [commentImg addGestureRecognizer:tap];
    
    [commentImg addSubview:imgadd];
    
    [commentImg addSubview:lab1];
    
    
    NSString *price = _orderInfo[@"parentorder"][@"price"];
    
    UILabel *tipL = [[UILabel alloc]initWithFrame:CGRectMake(10, 180, Sc_w - 20, 20)];
    tipL.font = [UIFont systemFontOfSize:12];
    tipL.textColor = Color_system;
    tipL.text = [NSString stringWithFormat:@"提示:您可退款的最大金额为%.2f",[price floatValue]];
    
    
    NSMutableAttributedString * attriStr=[[NSMutableAttributedString alloc]initWithString:tipL.text];
    NSRange range = [tipL.text rangeOfString:@"提示:您可退款的最大金额为"];
    [attriStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:range];
    tipL.attributedText = attriStr;
    
    
    [view1 addSubview:commentImg];
    [view1 addSubview:leftview1];
    [view1 addSubview:tipL];
    return view1;
}

-(void)creatFooter{
    UIView *selfFoot = [[UIView alloc]initWithFrame:CGRectMake(0, Sc_h - 64 - 52, Sc_w, 52)];
    selfFoot.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 90 - 60, 13.5, 70, 25)];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.layer.cornerRadius = 8.0;
    btn1.backgroundColor = My_gray;
    btn1.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn1 setTitle:@"提交申请" forState:UIControlStateNormal];
    [btn1 setTitle:@"申请中" forState:UIControlStateSelected];
    [btn1 addTarget:self action:@selector(submitRequst:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 60, 13.5, 50, 25)];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.layer.cornerRadius = 8.0;
    btn2.backgroundColor = My_gray;
    btn2.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn2 setTitle:@"取消" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    [selfFoot addSubview:btn1];
    [selfFoot addSubview:btn2];
    
    [self.view addSubview:selfFoot];
}

-(void)submitRequst:(UIButton *)sender{
    
    if (sender.selected) {
        return;
    }
    
    if(refundReason.text.length == 0){
        [self.view makeToast:@"请先选择退款原因"];
        return;
    }
    
    if ([refundTotal.text intValue] <= 0) {
        [self.view makeToast:@"退款金额不能小于或等于0"];
        return;
    }
    
    sender.selected = YES;
    //订单ID
    [self.userInfo setObject:_orderInfo[@"parentorder"][@"id"] forKey:@"id"];
    //时间
    [self.userInfo setObject:[self getNowTimeTimestamp] forKey:@"timestamp"];
    //退款金额
    [self.userInfo setObject:refundTotal.text forKey:@"price"];
    //退款原因
    [self.userInfo setObject:refundReason.text forKey:@"reason"];
    
    if (refundExplain.text) {
        //退款说明
        [self.userInfo setObject:refundExplain.text forKey:@"content"];
    }
    //退款方式
    [self.userInfo setObject:@"0" forKey:@"rtype"];
    
    
    if (commentImg.image) {
        NSData *imageData = UIImageJPEGRepresentation(commentImg.image, 0.5);
        
        NSString *imgStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        //凭证
        [self.userInfo setObject:imgStr forKey:@"images"];
        
        
    }
    
    [[ObjectTools sharedManager] POST:requestRefund parameters:_userInfo constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"申请结果%@",responseObject);
        
        UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:nil message:@"提交申请成功,点击确认返回" preferredStyle:UIAlertControllerStyleAlert];
        [alertCtr addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        
        [self presentViewController:alertCtr animated:YES completion:nil];
        
        sender.selected = NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@",error);
        sender.selected = NO;
    }];
    
    
}

-(void)dismissKeyboard{
    [refundExplain resignFirstResponder];
}

-(void)addPicture:(UITapGestureRecognizer *)tap{
    
    
    [self selectPhotoAlbumPhotos];
}

// 选择相册照片
- (void)selectPhotoAlbumPhotos {
    // 获取支持的媒体格式
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    // 判断是否支持需要设置的sourceType
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        // 1、设置图片拾取器上的sourceType
        self.imagePickerController = [[UIImagePickerController alloc]init];
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 2、设置支持的媒体格式
        _imagePickerController.mediaTypes = @[mediaTypes[0]];
        // 3、其他设置
        _imagePickerController.allowsEditing = YES; // 如果设置为NO，当用户选择了图片之后不会进入图像编辑界面。
        // 4、推送图片拾取器控制器
        _imagePickerController.delegate = self;
        [self presentViewController:_imagePickerController animated:YES completion:nil];
        
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"11");
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *editedImage = info[@"UIImagePickerControllerEditedImage"];
    dispatch_async(dispatch_get_main_queue(), ^{
        commentImg.image = editedImage;
        for (UIView *subview in commentImg.subviews) {
            subview.hidden = YES;
        }
    });
    
    
    
    
    //    NSLog(@"dingdan");
    //
    //    NSData *data = UIImageJPEGRepresentation(editedImage, 0.5);
    //    [data writeToFile:[NSString stringWithFormat:@"%@/%@.arch",app_document,self.mobile] atomically:YES];
    //
    //    NSString *path = @"http://mall.znhomes.com/app/index.php?i=89&c=entry&m=ewei_shopv2&do=mobile&r=member.appinfo.face";
    //    NSString *timestamp = [self getNowTimeTimestamp];
    //
    //    //.updata
    //
    //    NSString *strData = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    //
    //    NSDictionary *dict = _userInfo;
    //
    //    [self.mgr POST:path parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        NSDictionary *ddd = (NSDictionary *)responseObject;
    //        NSString * name = [ddd[@"result"] objectForKey:@"message"];
    //
    //        self.changeHeadImgInfoBlock(editedImage);
    //
    //        [self.view makeToast:name];
    //
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        NSLog(@"error");
    //    }];
    
    
}



- (NSString *)getNowTimeTimestamp{
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
    
}


-(void)choosereason{
    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"退款原因" message:@"请选择您的退款原因" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"不想要了" style:0 handler:^(UIAlertAction * _Nonnull action) {
        refundReason.text = action.title;
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"卖家缺货" style:0 handler:^(UIAlertAction * _Nonnull action) {
        refundReason.text = action.title;
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"其他" style:0 handler:^(UIAlertAction * _Nonnull action) {
        refundReason.text = action.title;
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"拍错了/订单信息错误" style:0 handler:^(UIAlertAction * _Nonnull action) {
        refundReason.text = action.title;
    }];
    
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        refundReason.text = @"";
    }];
    
    [alertCtr addAction:action1];
    [alertCtr addAction:action2];
    [alertCtr addAction:action3];
    [alertCtr addAction:action4];
    [alertCtr addAction:action5];
    
    [self presentViewController:alertCtr animated:YES completion:nil];
    
}


-(void)choosetotalmoney{
    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"退款金额" message:@"请输入您的退款金额" preferredStyle:UIAlertControllerStyleAlert];
    
    __block UITextField *temp = [UITextField new];
    
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:0 handler:^(UIAlertAction * _Nonnull action) {
        
        CGFloat maxPrice = [_orderInfo[@"parentorder"][@"price"] floatValue];
        
        CGFloat currPrice = [temp.text floatValue];
        
        refundTotal.text = [NSString stringWithFormat:@"%.2f",[temp.text floatValue]];
        if (currPrice > maxPrice) {
            [self.view makeToast:@"申请金额超过最大可退款金额"];
            
            refundTotal.text = [NSString stringWithFormat:@"%.2f",maxPrice];
        }
        
    }];
    
    [alertCtr addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        temp = textField;
    }];
    
    [alertCtr addAction:action1];
    
    [self presentViewController:alertCtr animated:YES completion:nil];
}


-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

