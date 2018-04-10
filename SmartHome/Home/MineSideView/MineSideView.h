//
//  MineSideView.h
//  SmartHome
//
//  Created by Smart house on 2017/12/14.
//  Copyright © 2017年 sunzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineSideView : UIView
@property (weak,nonatomic) id<UITableViewDataSource,UITableViewDelegate> delegate;
@property (nonatomic) BOOL isOpen;

@property (nonatomic,strong)UITableView *tableView;

-(void)setDelegate:(id<UITableViewDataSource,UITableViewDelegate>)delegate;

- (void)closeTap;

- (void)openTap;

@end
