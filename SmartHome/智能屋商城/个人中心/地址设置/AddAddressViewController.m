//
//  AddAddressViewController.m
//  SmartMall
//
//  Created by Smart house on 2017/9/1.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "AddAddressViewController.h"

#import "PlacePickerView.h"

#import "ObjectTools.h"

#import "UIView+Toast.h"


@interface AddAddressViewController ()<AYPlaceViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)UITextField *recipients;

@property(nonatomic,strong)UITextField *mobileF;

@property(nonatomic,strong)UITextField *currCity;

@property(nonatomic,strong)UITextField *currStreet;

@property(nonatomic,strong)PlacePickerView *areaPicker;



#define requestPath @"r=member.appinfo.addupdate"

@end

@implementation AddAddressViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"新建地址";
    self.navigationController.navigationBarHidden = NO;
    [self.view setBackgroundColor:My_gray];
    
    [self.view addSubview:[self creatUI]];
    [self.view addSubview:[self creatFootView]];
    
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
    
    self.update();
    
}

- (UIView *)creatUI{
    
    
    
    
    UILabel *textLeft1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 50)];
    textLeft1.font = [UIFont systemFontOfSize:15];
    textLeft1.textAlignment = NSTextAlignmentLeft;
    textLeft1.text = @"  收件人";
    
    self.recipients = [[UITextField alloc]initWithFrame:CGRectMake(0, 10, Sc_w, 50)];
    _recipients.placeholder = @"收件人";
    _recipients.font = [UIFont systemFontOfSize:15.0];
    _recipients.leftViewMode = UITextFieldViewModeAlways;
    _recipients.leftView = textLeft1;
    _recipients.backgroundColor = [UIColor whiteColor];
    _recipients.userInteractionEnabled = YES;
    
    
    UILabel *textLeft2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 50)];
    textLeft2.font = [UIFont systemFontOfSize:15];
    textLeft2.textAlignment = NSTextAlignmentLeft;
    textLeft2.text = @"  联系号码";
    
    self.mobileF = [[UITextField alloc]initWithFrame:CGRectMake(0, 62, Sc_w, 50)];
    _mobileF.placeholder = @"联系号码";
    _mobileF.font = [UIFont systemFontOfSize:15.0];
    _mobileF.leftViewMode = UITextFieldViewModeAlways;
    _mobileF.leftView = textLeft2;
    _mobileF.backgroundColor = [UIColor whiteColor];
    
    
    
    UILabel *textLeft3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 50)];
    textLeft3.font = [UIFont systemFontOfSize:15];
    textLeft3.textAlignment = NSTextAlignmentLeft;
    textLeft3.text = @"  所在地区";
    
    self.currCity = [[UITextField alloc]initWithFrame:CGRectMake(0, 114, Sc_w, 50)];
    _currCity.placeholder = @"所在地区";
    _currCity.font = [UIFont systemFontOfSize:15.0];
    _currCity.leftViewMode = UITextFieldViewModeAlways;
    _currCity.leftView = textLeft3;
    _currCity.backgroundColor = [UIColor whiteColor];
    
    self.currCity.delegate = self;
    
    
    UILabel *textLeft4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 50)];
    textLeft4.font = [UIFont systemFontOfSize:15];
    textLeft4.textAlignment = NSTextAlignmentLeft;
    textLeft4.text = @"  详细地址";
    
    self.currStreet = [[UITextField alloc]initWithFrame:CGRectMake(0, 166, Sc_w, 50)];
    _currStreet.placeholder = @"街道,门牌号等";
    _currStreet.font = [UIFont systemFontOfSize:15.0];
    _currStreet.leftViewMode = UITextFieldViewModeAlways;
    _currStreet.leftView = textLeft4;
    _currStreet.backgroundColor = [UIColor whiteColor];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 216)];
    
    [view addSubview:_recipients];
    [view addSubview:_mobileF];
    [view addSubview:_currCity];
    [view addSubview:_currStreet];
    
    
    return view;
}

- (UIView *)creatFootView{
    
    UIButton *addbtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 236, Sc_w - 20, 40)];
    [addbtn setTitle:@"保存地址" forState:UIControlStateNormal];
    [addbtn setTitle:@"保存中" forState:UIControlStateSelected];
    
    addbtn.layer.cornerRadius = 5.0;
    addbtn.layer.masksToBounds = YES;
    
    [addbtn setBackgroundColor:Color_system];
    [addbtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 60)];
//    [view addSubview:addbtn];
    
    
    return addbtn;
}


-(void)addClick:(UIButton *)sender{
    
    if (sender.selected) {
        return;
    }
    
    if (!((_recipients.text)&&(_mobileF.text.length == 11)&&(_currCity.text)&&(_currStreet.text))) {
        
        [self.view makeToast:@"请确认信息完整无误后再试"];
        
        return;
    }
    NSString *nonce = _dict[@"nonce"];
    NSString *timestamp = [self getNowTimeTimestamp];
    NSString *sign = _dict[@"sign"];
    NSString *token = _dict[@"token"];
    
    
    NSString *newarea = _currCity.text;
    NSString *mobile = _mobileF.text;
    NSString *address = _currStreet.text;
    NSString *realname = _recipients.text;
    
    NSDictionary *newDict = @{@"nonce":nonce,@"timestamp":timestamp,@"token":token,@"sign":sign,@"newarea":newarea,@"mobile":mobile,@"address":address,@"realname":realname};
    
    sender.selected = YES;
    
    [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:requestPath] parameters:newDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        [self.view makeToast:@"添加地址成功,稍后将为您返回"];
        [self performSelector:@selector(backClick) withObject:nil afterDelay:2.0];
        NSLog(@"地址返回信息 = %@",[dict[@"result"] objectForKey:@"message"]);
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:@"网络错误,请检查网络后重试"];
    }];
    
}

-(void)animation{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSString *)getNowTimeTimestamp{
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
    
}




- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //写你要实现的：页面跳转的相关代码
    [self.view endEditing:YES];
    _areaPicker.isHidden = NO;
    return NO;
}


- (void)areaPickerView:(PlacePickerView *)areaPickerView didSelectArea:(NSString *)area
{
    self.currCity.text = area;
}


@end
