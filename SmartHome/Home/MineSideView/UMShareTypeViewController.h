//
//  UMShareTypeViewController.h
//  UMSocialSDK
//
//  Created by wyq.Cloudayc on 11/16/16.
//  Copyright © 2016 UMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>
#import "UMSBaseViewController.h"

@interface UMShareTypeViewController : UMSBaseViewController


@property(nonatomic,copy)NSString *titleName;
@property(nonatomic,copy)NSString *typeName;
@property(nonatomic,strong)id imageUrl;
@property(nonatomic,copy)NSString *shareLink;


- (instancetype)initWithType:(UMSocialPlatformType)type;


- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType;




@end
