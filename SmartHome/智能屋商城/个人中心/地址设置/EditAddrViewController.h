//
//  EditAddrViewController.h
//  SmartMall
//
//  Created by Smart house on 2017/9/1.
//  Copyright © 2017年 verb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAddrViewController : UIViewController

@property(nonatomic,strong)NSDictionary *dict;

@property(nonatomic,strong)NSMutableDictionary *info;

@property(nonatomic,copy)void(^editBlock)(NSMutableDictionary *changedInfo);

@end
