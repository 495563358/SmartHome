//
//  UserSetViewController.h
//  SmartMall
//
//  Created by Smart house on 2017/8/30.
//  Copyright © 2017年 verb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSetViewController : UIViewController

@property(nonatomic,strong)UIImage *headImg;

@property(nonatomic,copy)NSString *mobile;

@property(nonatomic,copy)NSString *nonce;

@property(nonatomic,copy)NSString *sign;

@property(nonatomic,copy)NSString *token;


@property(nonatomic,copy)NSString *city;

@property(nonatomic,copy)NSString *nickname;

@property(nonatomic,copy)NSString *realname;

@property(nonatomic,copy)NSString *birthdayStr;

@property(nonatomic,copy)void(^changeHeadImgInfoBlock)(UIImage *headImg);

@property(nonatomic,copy)void(^changeMemberInfoBlock)(NSDictionary *dict);

@property(nonatomic,copy)void(^changeMobileInfoBlock)(NSString *moblie);

@end
