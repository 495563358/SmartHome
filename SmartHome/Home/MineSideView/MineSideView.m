//
//  MineSideView.m
//  SmartHome
//
//  Created by Smart house on 2017/12/14.
//  Copyright © 2017年 sunzl. All rights reserved.
//

#import "MineSideView.h"

@interface MineSideView ()

@end

@implementation MineSideView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStyleGrouped];
        [self addSubview:self.tableView];
        
        self.tableView.showsHorizontalScrollIndicator = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.isOpen = NO;
    }
    return self;
}



-(void)setDelegate:(id<UITableViewDataSource,UITableViewDelegate>)delegate
{
    self.tableView.dataSource=delegate;
    self.tableView.delegate=delegate;
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemCell" bundle:nil] forCellReuseIdentifier:@"itemcell"];
//    [self.tableView registerNib:[UINib nibWithNibName:@"AddCell" bundle:nil] forCellReuseIdentifier:@"addcell"];
//    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalCell" bundle:nil] forCellReuseIdentifier:@"itemcell"];
//    [self.tableView registerNib:[UINib nibWithNibName:@"MyHeadCell" bundle:nil] forCellReuseIdentifier:@"addcell"];
    
    
//    tableView.registerNib(UINib(nibName:"PersonalCell", bundle: nil), forCellReuseIdentifier:"Percell")
//    tableView.registerNib(UINib(nibName:"MyHeadCell", bundle: nil), forCellReuseIdentifier:"MyHeadCell")
    
//    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 0.01)];
//    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 0.01)];
}

- (void)closeTap {
    NSLog(@"close");
    self.isOpen =  !self.isOpen;;
    //close
    [UIView beginAnimations:@"closeSide" context:nil];
    [UIView setAnimationDuration:0.30f];
    self.frame=CGRectMake(-self.frame.size.width, self.frame.origin.y, self.frame.size.width,  self.frame.size.height);
    mainWindowss.center = CGPointMake(Sc_w/2, Sc_h/2);
    [UIView commitAnimations];
}

- (void)openTap {
    //open
    NSLog(@"open");
    self.isOpen =  !self.isOpen;
    [UIView beginAnimations:@"openSide" context:nil];
    [UIView setAnimationDuration:0.30f];
    mainWindowss.center = CGPointMake(Sc_w/2 + self.frame.size.width, Sc_h/2);
    [UIView commitAnimations];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
