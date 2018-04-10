//
//  MyOrderTopTabBar.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/9.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "MyOrderTopTabBar.h"
#import "TabButton.h"

#define bottomViewW 6.0

@interface MyOrderTopTabBar(){
    NSInteger selectedTag;
}

@property(nonatomic,weak) TabButton *lastBtn;//记录上一个按钮
@property(nonatomic,assign)CGFloat btnH;//记录按钮的高度

@end

@implementation MyOrderTopTabBar

+(instancetype)tabbar{
    return [[self alloc] init];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView* bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = Color_system;
        self.bottomView = bottomView;
        [self addSubview:bottomView];
    }
    return self;
}

/**
 使用字符数组初始化
 */

-(instancetype)initWithArray:(NSArray *)array{
    self = [super init];
    if (self) {
        for(NSString* name in array){
            [self AddTarBarBtn:name];
        }
    }
    return self;
}

/**
 添加顶部标题项的名字
 */
-(void)AddTarBarBtn:(NSString *)name{
    
    TabButton *btn = [TabButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:name forState:UIControlStateNormal];
    [btn setTitleColor:color(33.0,33,33.0,1.0) forState:UIControlStateNormal];
    [btn setTitleColor:Color_system forState:UIControlStateSelected];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btn addTarget:self action:@selector(TabBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:btn];
    [btn setTag:self.subviews.count-2];
    //NSLog(@"按钮tag == %ld",self.subviews.count - 2);
    if(2 == self.subviews.count){
        [self TabBtnClick:btn];
    }
    
}
/**
 计算字view的frame
 */
-(void)layoutSubviews{
    NSInteger btnCount = self.subviews.count;
    CGFloat btnW = self.frame.size.width/(btnCount - 1);
    CGFloat btnH = self.frame.size.height;
    self.btnW = btnW;
    self.btnH = btnH;
    for(int i=0;i<btnCount;i++){
        if ([self.subviews[i] isKindOfClass:[TabButton class]]) {
            TabButton *btn = self.subviews[i];
            btn.frame = CGRectMake((i-1)*btnW, 0, btnW, btnH);
        }
        else{
            UIView* view = self.subviews[i];
            view.frame = CGRectMake(selectedTag * btnW, btnH - 3.0, btnW,3.0);
        }
    }
    //NSLog(@"按钮数量 == %ld",self.subviews.count);
    
    
    NSLog(@"layout");
}

/**
 监听tabbar的点击
 */
-(void)TabBtnClick:(TabButton *)sender{
    self.bottomView.hidden = NO;
    if(_lastBtn != nil){
        _lastBtn.selected = NO;
    }
    sender.selected = YES;
    _lastBtn = sender;
    //底部指示view的动画
    
    selectedTag = sender.tag;
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomView.frame = CGRectMake(sender.tag * self.btnW, self.btnH - bottomViewW/2, _btnW, bottomViewW/2);
    }];
    if([_delegate respondsToSelector:@selector(tabBar:didSelectIndex:)]){//判断代理有没有实现这个函数了
        [_delegate tabBar:self didSelectIndex:sender.tag];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
