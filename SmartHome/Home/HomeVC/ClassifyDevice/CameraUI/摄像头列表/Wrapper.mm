//
//  Wrapper.m
//  SmartHome
//
//  Created by sunzl on 16/4/11.
//  Copyright © 2016年 sunzl. All rights reserved.
//

#import "Wrapper.h"
#import "JK_ViewController.h"
#import "HTPlayCamerViewController.h"


@implementation Wrapper
-(void)push:(UIViewController *)view roomCode:(NSString *)roomCode
{
    JK_ViewController *jk=[JK_ViewController new];
    jk.hidesBottomBarWhenPushed = YES;
    jk.roomCode = roomCode;
    [view.navigationController pushViewController:jk animated:YES];
}
-(BOOL)kindsOfHTPlayCamerViewController:(UINavigationController *)view{
    return [view.visibleViewController isKindOfClass:HTPlayCamerViewController.class];

}
-(void)pushCamera:(UIViewController *)view dict:(NSDictionary *)dict
{
    
    HTPlayCamerViewController *playViewController = [HTPlayCamerViewController new];
   
    playViewController.cameraID = dict[@"cameraID"];
    playViewController.m_PPPPChannelMgt = nil;
    playViewController.username = dict[@"username"];
    playViewController.password = dict[@"password"];
    
    playViewController.hidesBottomBarWhenPushed = YES;
    [view.navigationController pushViewController:playViewController animated:YES];
}
@end
