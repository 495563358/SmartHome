//
//  oDropController.h
//  P2PCamera
//
//  Created by mac on 12-10-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropListProtocol.h"

@interface oDropController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationBarDelegate>
{
    
    IBOutlet UITableView *tableView;
    IBOutlet UINavigationBar *navigationBar;
    
    //0:移动侦测灵敏度
    //3，6:触发电平
    //4:预置位
    //9:上传图片间隔
    
    //101:ntp服务器
    //102:时区
    int m_nIndexDrop;
    NSInteger m_sel;
    
    id <DropListProtocol> m_DropListProtocolDelegate;
}
@property (nonatomic) int m_nIndexDrop;
@property (retain, nonatomic) id <DropListProtocol> m_DropListProtocolDelegate;

@property (nonatomic, retain) UITableView *tableView;
@property (retain, nonatomic) UINavigationBar *navigationBar;
@end
