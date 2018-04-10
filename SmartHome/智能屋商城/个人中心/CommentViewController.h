//
//  CommentViewController.h
//  SmartMall
//
//  Created by Smart house on 2017/10/11.
//  Copyright © 2017年 verb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController

@property (nonatomic ,strong)NSDictionary *data;

@property (nonatomic ,strong)NSMutableDictionary *userInfo;

@property (nonatomic ,assign)bool isSub;

@end
