//
//  PlanModel.h
//  Eye4
//
//  Created by 黄甜 on 16/10/20.
//
//

#import <Foundation/Foundation.h>

@interface PlanModel : NSObject

@property(nonatomic,retain) NSString *devicedID;
@property(nonatomic,retain) NSString *startTimer;
@property(nonatomic,retain) NSString *endTimer;
@property(nonatomic,retain) NSString *week;
@property(nonatomic,retain) NSString *isOn;
@property(nonatomic,assign) NSInteger ID;
@property(nonatomic,assign) NSInteger sum;

@end
