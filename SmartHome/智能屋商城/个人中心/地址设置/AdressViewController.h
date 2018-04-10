//
//  AdressViewController.h
//  SmartMall
//
//  Created by Smart house on 2017/9/1.
//  Copyright © 2017年 verb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol setDefaultAddrDelegate <NSObject>

@required

-(void)setDefaultAddr:(NSDictionary *)defaultAddrInfo;

@end

@interface AdressViewController : UIViewController



@property(nonatomic,strong)NSDictionary *dict;

@property(nonatomic,weak)id<setDefaultAddrDelegate>delegate;



@end
