//
//  LookupExpressVC.m
//  SmartMall
//
//  Created by Smart house on 2017/10/10.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "LookupExpressVC.h"

@implementation LookupExpressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"查看物流";
    self.view.backgroundColor = My_gray;
    self.navigationController.navigationBarHidden = NO;
    [self.view setBackgroundColor:My_gray];
    
    NSLog(@"物流信息 = %@",_data);
    
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    
    [self createHeaderView];
    [self createFooterView];
    
}

-(void)createHeaderView{
    
    
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 6, 87, 87)];
    imageV.layer.borderWidth = 1;
    imageV.layer.borderColor = My_gray.CGColor;
    
    UILabel *countL = [[UILabel alloc]initWithFrame:CGRectMake(10, 6 + 67, 87, 20)];
    countL.backgroundColor = [UIColor blackColor];
    countL.textColor = [UIColor whiteColor];
    countL.font = [UIFont systemFontOfSize:13];
    countL.alpha = 0.5;
    countL.textAlignment = NSTextAlignmentCenter;
    
    
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10 + 87 + 13, 19, 75, 15)];
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont systemFontOfSize:15];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10 + 87 + 13 + 75 - 3, 19, 150, 15)];
    label2.textColor = Color_system;
    label2.font = [UIFont systemFontOfSize:15];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(10 + 87 + 13, 19 + 25, 300, 15)];
    label3.textColor = [UIColor grayColor];
    label3.font = [UIFont systemFontOfSize:14];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(10 + 87 + 13, 19 + 50, 300, 15)];
    label4.textColor = [UIColor grayColor];
    label4.font = [UIFont systemFontOfSize:14];
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 102)];
    view.backgroundColor = [UIColor whiteColor];
    
    [view addSubview:imageV];
    [view addSubview:countL];
    [view addSubview:label1];
    [view addSubview:label2];
    [view addSubview:label3];
    [view addSubview:label4];
    
    //数据
    NSArray *goods = _data[@"result"][@"goods"];
    
    
    imageV.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",AddressPath,[[goods firstObject] objectForKey:@"thumb"]]]]];
    countL.text = [NSString stringWithFormat:@"%ld件商品",goods.count];
    
    
    NSDictionary *orderInfo = _data[@"result"][@"order"];
    
    label1.text = @"物流状态";
    label2.text = orderInfo[@"expressstatus"];
    label3.text = [NSString stringWithFormat:@"快递公司:  %@",orderInfo[@"expresscom"]];
    label4.text = [NSString stringWithFormat:@"快递单号:  %@",orderInfo[@"expresssn"]];
    
    [self.view addSubview:view];
}

-(void)createFooterView{
    
    
    
    NSArray *expresslist = _data[@"result"][@"expresslist"];
    
    UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 112, Sc_w, Sc_h - 112 - 64)];
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, expresslist.count * 60 + 24)];
    view.backgroundColor = [UIColor whiteColor];
    
    [scrollview addSubview:view];
    
    [self.view addSubview:scrollview];
    
    for (int i = 0;i < expresslist.count ;i++) {
        if (i==0) {
            UILabel *step = [[UILabel alloc]initWithFrame:CGRectMake(35, 8 + i * 60, Sc_w - 60, 40)];
            step.font = [UIFont systemFontOfSize:14];
            step.textColor = Color_system;
            step.text = expresslist[i][@"step"];
            step.numberOfLines = 0;
            
            UILabel *times = [[UILabel alloc]initWithFrame:CGRectMake(35, 46 + i * 60, Sc_w - 60, 14)];
            times.font = [UIFont systemFontOfSize:14];
            times.textColor = Color_system;
            times.text = expresslist[i][@"time"];
            [view addSubview:step];
            [view addSubview:times];
            
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(11, 23, 13, 13)];
            imageV.image = [UIImage imageNamed:@"wuliu-yuan-lan"];
            [view addSubview:imageV];
            
        }else{
            UILabel *step = [[UILabel alloc]initWithFrame:CGRectMake(35, 8 + i * 60, Sc_w - 60, 40)];
            step.font = [UIFont systemFontOfSize:14];
            step.textColor = [UIColor grayColor];
            step.text = expresslist[i][@"step"];
            step.numberOfLines = 0;
            
            UILabel *times = [[UILabel alloc]initWithFrame:CGRectMake(35, 46 + i * 60, Sc_w - 60, 14)];
            times.font = [UIFont systemFontOfSize:14];
            times.textColor = [UIColor grayColor];
            times.text = expresslist[i][@"time"];
            [view addSubview:step];
            [view addSubview:times];
            
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(13, 23 + i * 60, 9, 9)];
            imageV.image = [UIImage imageNamed:@"wuliu-yuan-hui"];
            [view addSubview:imageV];
            
            
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(17, 23 + i * 60 - 51, 1, 52)];
            if (i==1) {
                line.frame = CGRectMake(17, 23 + i * 60 - 51 + 2, 1, 50);
            }
            line.backgroundColor = color(204, 204, 204, 1.0);
            [view addSubview:line];
            
        }
        
//        NSLog(@"%ld",[expresslist[i][@"step"] length]);
    }
    scrollview.contentSize = CGSizeMake(Sc_w, expresslist.count * 60 + 24);
    
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
