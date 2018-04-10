//
//  AddPlanViewController.h
//  Eye4
//
//  Created by 黄甜 on 16/10/20.
//
//

#import <UIKit/UIKit.h>
#import "PPPPChannelManagement.h"
@interface AddPlanViewController : UIViewController

@property (nonatomic) CPPPPChannelManagement* m_PPPPChannelMgt;
@property(nonatomic,strong) NSString *ID;
@property(nonatomic,strong) NSString *str_DID;
@property(nonatomic,assign) NSInteger rowIndex;
@property(nonatomic,assign) BOOL isEdit;
@property(nonatomic,strong) NSString *addPlanTyep; //区分添加计划的类型
@end
