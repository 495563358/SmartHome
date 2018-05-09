//
//  MerchFilterVC.h
//  SmartHome
//
//  Created by Smart house on 2018/5/4.
//  Copyright © 2018年 Verb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchFilterVC : UIViewController

@property(nonatomic,strong)NSMutableDictionary *currentSelect;

@property(nonatomic,strong)NSMutableArray<NSArray *> *VerificationDatas;
@property(nonatomic,copy)NSString *navigationTitle;
@property(nonatomic,assign)BOOL isSearch;

@end
