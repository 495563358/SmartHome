//
//  WeekButton.m
//  封装敲一遍
//
//  Created by kensla on 15/3/31.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "WeekButton.h"

@implementation WeekButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeButtonColor) name:@"changeButtonColor" object:nil];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame Title:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        self.buttonName = title;
        [self loadTabBarItem];
    }
    return self;
}

-(void) changeButtonColor{
    [self loadTabBarItem];
}

-(void) loadTabBarItem{
    
    [self setTitle:self.buttonName forState:UIControlStateNormal];

}

@end
