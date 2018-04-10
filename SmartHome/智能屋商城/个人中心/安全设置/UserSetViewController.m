//
//  UserSetViewController.m
//  SmartMall
//
//  Created by Smart house on 2017/8/30.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "UserSetViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import<AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#import "UICustomDatePicker.h"

#import "PlacePickerView.h"

#import "ChangeMobileViewController.h"

#import "ObjectTools.h"

#import "UIView+Toast.h"

@interface UserSetViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,AYPlaceViewDelegate>

@property (nonatomic,strong)UITableView *tableview;

@property(nonatomic,strong)UIImagePickerController *imagePickerController;

@property(nonatomic,strong)UIImageView *imgView;


@property(nonatomic,strong)UITextField *mobileF;

@property(nonatomic,strong)UITextField *realName;

@property(nonatomic,strong)UITextField *nickName;

@property(nonatomic,strong)UITextField *birthday;

@property(nonatomic,strong)UITextField *currCity;



@property(nonatomic,strong)PlacePickerView *areaPicker;

@end

@implementation UserSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = My_gray;
    
    self.tableview = [[UITableView alloc]initWithFrame:Sc_bounds style:UITableViewStylePlain];
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    [self.view addSubview:_tableview];
    
    _tableview.tableFooterView = [self creatFootView];
    
    self.areaPicker = [[PlacePickerView alloc]initWithDelegate:self];
    
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

- (UIView *)creatFootView{
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, Sc_w - 20, 40)];
    [btn setTitle:@"确认修改" forState:UIControlStateNormal];
    
    btn.layer.cornerRadius = 5.0;
    btn.layer.masksToBounds = YES;
    
    [btn setBackgroundColor:Color_system];
    [btn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 60)];
    [view addSubview:btn];
    
    
    return view;
}

- (void)sureClick{
    
    if (_realName.text.length == 0 || _nickName.text.length == 0) {
        [self.view makeToast:@"请先完善您的个人信息后再提交"];
        return;
    }
    
    NSString *path = @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=member.appinfo.update";
    NSString *timestamp = [self getNowTimeTimestamp];
    
    //.updata
    
    
    NSDictionary *dict = @{@"nonce":_nonce,@"timestamp":timestamp,@"sign":_sign,@"token":_token,@"realname":_realName.text,@"birthday":_birthday.text,@"nickname":_nickName.text,@"city":_currCity.text};
    
    [[ObjectTools sharedManager] POST:path parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *ddd = (NSDictionary *)responseObject;
        NSLog(@"修改信息 = %@",[ddd[@"result"] objectForKey:@"msg"]);
        NSString *message = [ddd[@"result"] objectForKey:@"msg"];
        [[self.view superview] makeToast:message];
        
        
        self.changeMemberInfoBlock(dict);
        
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
    
    
    
}


-(UIView *)creatImg{
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 50, 50)];
    _imgView.layer.cornerRadius = 25;
    _imgView.layer.masksToBounds = YES;
    _imgView.image = self.headImg;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(90, 30, 120, 30)];
    label.text = @"更换头像";
    label.font = [UIFont systemFontOfSize:15];
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 90)];
    [view addSubview:_imgView];
    [view addSubview:label];
    
    return view;
    
}


-(UIView *)creatInfo:(long)index{
    
    
    UILabel *WifiLeft = [[UILabel alloc]initWithFrame:CGRectMake(20, 1, 90, 38)];
    WifiLeft.font = [UIFont systemFontOfSize:15];
    WifiLeft.textAlignment = NSTextAlignmentLeft;
    
    NSString *name;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 60)];
    
    switch (index) {
        case 1:
            name = @"    姓名: ";
            self.realName = [[UITextField alloc]initWithFrame:CGRectMake(0, 2, Sc_w, 40)];
            _realName.leftViewMode = UITextFieldViewModeAlways;
            _realName.leftView = WifiLeft;
            _realName.font = [UIFont systemFontOfSize:15];
            _realName.textColor = [UIColor grayColor];
            
            _realName.text = _realname;
            [view addSubview:_realName];
            break;
        case 2:
            name = @"    昵称: ";
            self.nickName = [[UITextField alloc]initWithFrame:CGRectMake(0, 2, Sc_w, 40)];
            _nickName.leftViewMode = UITextFieldViewModeAlways;
            _nickName.leftView = WifiLeft;
            _nickName.font = [UIFont systemFontOfSize:15];
            _nickName.textColor = [UIColor grayColor];
            
            
            _nickName.text = _nickname;
            [view addSubview:_nickName];
            break;
        case 3:
            name = @"    出生日期:";
            self.birthday = [[UITextField alloc]initWithFrame:CGRectMake(0, 2, Sc_w, 40)];
            _birthday.leftViewMode = UITextFieldViewModeAlways;
            _birthday.leftView = WifiLeft;
            _birthday.font = [UIFont systemFontOfSize:15];
            _birthday.textColor = [UIColor grayColor];
            
            _birthday.text = _birthdayStr;
            [view addSubview:_birthday];
            _birthday.userInteractionEnabled = NO;
            break;
        case 4:
            name = @"    所在城市:";
            self.currCity = [[UITextField alloc]initWithFrame:CGRectMake(0, 2, Sc_w, 40)];
            _currCity.leftViewMode = UITextFieldViewModeAlways;
            _currCity.leftView = WifiLeft;
            _currCity.textColor = [UIColor grayColor];
            
            _currCity.font = [UIFont systemFontOfSize:15];
            _currCity.text = _city;
            [view addSubview:_currCity];
            _currCity.userInteractionEnabled = NO;
            break;
            
        default:
            name = @"    手机号: ";
            self.mobileF = [[UITextField alloc]initWithFrame:CGRectMake(0, 2, Sc_w, 40)];
            _mobileF.leftViewMode = UITextFieldViewModeAlways;
            _mobileF.leftView = WifiLeft;
            _mobileF.font = [UIFont systemFontOfSize:15];
            _mobileF.textColor = [UIColor grayColor];
            
            
            _mobileF.text = _mobile;
            [view addSubview:_mobileF];
            _mobileF.userInteractionEnabled = NO;
            break;
    }
    
    
    WifiLeft.text = name;
    return view;
    
    
}


- (void)areaPickerView:(PlacePickerView *)areaPickerView didSelectArea:(NSString *)area
{
    self.currCity.text = area;
}





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 90;
    }else
        return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }
    return 0.1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 5;
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [cell.contentView addSubview:[self creatImg]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 1 && indexPath.row == 0 ){
        [cell.contentView addSubview:[self creatInfo:indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
    
    [cell.contentView addSubview:[self creatInfo:indexPath.row]];
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        [self openPhoto];
        return;
    }
    else if(indexPath.section == 1 && indexPath.row == 0){
        NSLog(@"更换绑定");
        ChangeMobileViewController *vc = [[ChangeMobileViewController alloc]init];
        vc.sign = self.sign;
        vc.userToken = self.token;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
    if (indexPath.row == 3) {
        __weak UserSetViewController *weakSelf = self;
        [UICustomDatePicker showCustomDatePickerAtView:weakSelf.view choosedDateBlock:^(NSDate *date) {//点击确认打印
            NSDateFormatter *formatter_minDate = [[NSDateFormatter alloc] init];
            [formatter_minDate setDateFormat:@"yyyy-MM-dd"];
            
            NSString *timeString = [formatter_minDate stringFromDate:date];
            self.birthday.text = timeString;
        } cancelBlock:^{//点击取消打印
            NSLog(@"点击了取消");
        }];
    }
    
    if (indexPath.row == 4) {
        _areaPicker.isHidden = NO;
    }
    
}



-(void)openPhoto{
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
    NSLog(@"dsad11");
    
    UIImage *editedImage = info[@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.imgView.image = editedImage;
            NSLog(@"dingdan");
            
            NSData *data = UIImageJPEGRepresentation(editedImage, 0.5);
            [data writeToFile:[NSString stringWithFormat:@"%@/%@.arch",App_document,self.mobile] atomically:YES];
            
            NSString *path = @"http://mall.znhomes.com/app/index.php?i=195&c=entry&m=ewei_shopv2&do=mobile&r=member.appinfo.face";
            NSString *timestamp = [self getNowTimeTimestamp];
            
            //.updata
            
            NSString *strData = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            
            NSDictionary *dict = @{@"nonce":_nonce,@"timestamp":timestamp,@"sign":_sign,@"token":_token,@"image":strData};
            
            [[ObjectTools sharedManager] POST:path parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *ddd = (NSDictionary *)responseObject;
                NSString * name = [ddd[@"result"] objectForKey:@"message"];
                
                self.changeHeadImgInfoBlock(editedImage);
                
                [self.view makeToast:name];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error");
            }];
            
            
        });
    }];
    
    
}



- (NSString *)getNowTimeTimestamp{
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
    
}


@end
