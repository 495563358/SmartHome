//
//  Wrapper.h
//  SmartHome
//
//  Created by sunzl on 16/4/11.
//  Copyright © 2016年 sunzl. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Wrapper : NSObject
-(void)push:(UIViewController *)view roomCode:(NSString *)roomCode;
-(BOOL)kindsOfHTPlayCamerViewController:(UINavigationController *)view;
-(void)pushCamera:(UIViewController *)view dict:(NSDictionary *)dict;
@end
