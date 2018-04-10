//
//  Loadmore.h
//  UI进阶项目
//
//  Created by mac on 2016/12/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoadmoreDelegate <NSObject>

- (void)moreViewPushVCWithTag:(NSInteger)tag;

@end


@interface Loadmore : UIView

+(instancetype)sharedSingleton;

@property(nonatomic ,copy)void(^btnBlock)(UIButton *);
@property(nonatomic ,weak)id<LoadmoreDelegate> delegate;

@end
