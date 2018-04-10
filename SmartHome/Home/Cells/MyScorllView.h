//
//  MyScorllView.h
//  LongMaoSport
//
//  Created by SunZlin on 16/4/3.
//  Copyright © 2016年 SunZlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyScorllView : UIView
@property (nonatomic,strong) NSMutableArray< UIImage*>* images;
@property  (nonatomic,strong) NSMutableArray< NSURL*>* web_images;
- (void)setupPage;
@end
