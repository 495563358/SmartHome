//
//  TechnologyViewController.m
//  SmartMall
//
//  Created by Smart house on 2017/11/2.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "TechnologyViewController.h"

#import "ObjectTools.h"
#import "UIView+Toast.h"

@interface TechnologyViewController (){
    UITextField *nameT;
    UITextField *teleT;
    UITextField *compT;
    UITextField *amountT;
    UITextField *timeT1;
}


@end

@implementation TechnologyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"技术培训";
    self.view.backgroundColor = Color_system;
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [self createview];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)createview{
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 190)];
    imageV.image = [UIImage imageNamed:@"banner"];
    [self.view addSubview:imageV];
    
    UIView *space = [[UIView alloc]initWithFrame:CGRectMake(0, 190, Sc_w, 10)];
    space.backgroundColor = My_gray;
    [self.view addSubview:space];
    
    UIView *whiteBack = [[UIView alloc]initWithFrame:CGRectMake(10, 212, Sc_w - 20, 758/2)];
    whiteBack.backgroundColor = My_gray;
    whiteBack.layer.cornerRadius = 10;
    [self.view addSubview:whiteBack];
    
    NSArray *nameArray = @[@"* 姓    名:",@"* 联系方式:",@"* 公司名称:",@"* 培训人数:",@"* 选择时间:"];
    
    nameT = [UITextField new];
    teleT = [UITextField new];
    compT = [UITextField new];
    amountT = [UITextField new];
    timeT1 = [UITextField new];
    NSArray *Tarray = @[nameT,teleT,compT,amountT,timeT1];
    NSArray *placeholders = @[@"请输入真实姓名",@"请输入你的手机号",@"请输入你的公司名称",@"最多为2人",@"例:2000-01-01"];
    
    
    for (int i = 0; i<5; i++) {
        NSMutableAttributedString *nameAttr = [[NSMutableAttributedString alloc]initWithString:nameArray[i]];
        [nameAttr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(45, 20 + i * 44, 80, 14)];
        label.font = [UIFont systemFontOfSize:14];
        label.attributedText = nameAttr;
        [whiteBack addSubview:label];
        
        UITextField *tempT = Tarray[i];
        tempT.frame = CGRectMake(125, 20 + i * 44, 200, 14);
        tempT.placeholder = placeholders[i];
        tempT.font = [UIFont systemFontOfSize:14];
        [whiteBack addSubview:tempT];
    }
    
    UIButton *submit = [[UIButton alloc]initWithFrame:CGRectMake((Sc_w - 185)/2, 248, 185, 40)];
    submit.backgroundColor = Color_system;
    submit.titleLabel.font = [UIFont systemFontOfSize:15];
    submit.layer.cornerRadius = 10;
    [submit setTitle:@"立即申请" forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    [whiteBack addSubview:submit];
}

-(void)submitClick:(UIButton *)sender{
    
    if (sender.selected) {
        return;
    }
    [sender setTitle:@"请稍后" forState:UIControlStateSelected];
    
    if (nameT.text.length < 3) {
        [mainWindowss makeToast:@"请输入完整的姓名"];
        return;
    }
    if (teleT.text.length != 7 && teleT.text.length != 11) {
        [mainWindowss makeToast:@"请输入正确的手机号"];
        return;
    }
    if (compT.text.length < 3) {
        [mainWindowss makeToast:@"请输入正确的公司名称"];
        return;
    }
    if ([amountT.text intValue]<1 || [amountT.text intValue]>2) {
        [mainWindowss makeToast:@"人数为1或者2"];
        return;
    }
    
    NSArray *arr = [timeT1.text componentsSeparatedByString:@"-"];
    if (arr.count != 3 || [arr[0] intValue] < 2016) {
        [mainWindowss makeToast:@"请输入正确的时间"];
        return;
    }
    
    sender.selected = YES;
    NSDictionary *dict = @{@"name":nameT.text,@"mobile":teleT.text,@"company":compT.text,@"nums":amountT.text,@"starttime":timeT1.text};
    NSLog(@"提交申请%@",dict);
    
    NSString *subStr = @"r=merch.applist.enroll";
    
    [[ObjectTools sharedManager] POST:[ResourceFront stringByAppendingString:subStr] parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"resu%@",responseObject);
        if ([[(NSDictionary *)responseObject objectForKey:@"status"] intValue] == 1) {
            [mainWindowss makeToast:@"申请提交成功"];
            [sender setTitle:@"已提交申请" forState:UIControlStateSelected];
        }else{
            [mainWindowss makeToast:@"申请失败,请检查您的信息后重试"];
            sender.selected = NO;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        sender.selected = NO;
    }];
    
    //nameT,teleT,compT,amountT,timeT1
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
