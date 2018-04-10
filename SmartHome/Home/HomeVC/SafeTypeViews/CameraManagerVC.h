//
//  CameraManagerVC.h
//  SmartHome
//
//  Created by Smart house on 2018/1/4.
//  Copyright © 2018年 sunzl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NotifyEventProtocol.h"


@interface CameraManagerVC : UIViewController


@property(nonatomic,strong)NSMutableDictionary *roomDict;
@property(nonatomic,strong)NSArray *cameras;


@property (nonatomic, assign) id<NotifyEventProtocol> RecordNotifyEventDelegate;

@end
