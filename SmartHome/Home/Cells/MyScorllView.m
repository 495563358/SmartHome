//
//  MyScorllView.m
//  LongMaoSport
//
//  Created by SunZlin on 16/4/3.
//  Copyright © 2016年 SunZlin. All rights reserved.
//
//使用
//_images = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"demo.jpg"],[UIImage imageNamed:@"demo.jpg"],[UIImage imageNamed:@"demo.jpg"],nil];

//调用 setupPage方法
//[self setupPage];
#import "MyScorllView.h"
#import "UIImageView+WebCache.h"

@interface MyScorllView()<UIScrollViewDelegate>
@property (strong, nonatomic)  UIScrollView *scrollView;

@property (retain, nonatomic) UIPageControl *pageControl;

@end
@implementation MyScorllView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化
        [self configView:frame];
    }
    return self;
}



-(void)configView:(CGRect)frame
{
    //设置scrollview
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height)];
     //初始化pageControl
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(80, frame.size.height - 40, frame.size.width-160,40)];
    //把scrollView与pageControl添加到当前视图中
    [self addSubview:_scrollView];
    [self addSubview:_pageControl];

}


#pragma mark 设计视图使用的方法
//改变滚动视图的方法实现
- (void)setupPage
{
    //设置委托
    _scrollView.tag=111;
    _scrollView.delegate = self;
    //是否自动裁切超出部分

    //是否自动裁切超出部分;
    self.scrollView.clipsToBounds = YES;
    //设置是否可以缩放
    self.scrollView.scrollEnabled = YES;
    //设置是否可以进行画面切换
    self.scrollView.pagingEnabled = YES;
    //设置在拖拽的时候是否锁定其在水平或者垂直的方向
    self.scrollView.directionalLockEnabled = YES;
    //隐藏滚动条设置（水平、跟垂直方向）
    self.scrollView.alwaysBounceHorizontal = NO;
    self.scrollView.alwaysBounceVertical =  NO;
    self.scrollView.showsHorizontalScrollIndicator =  NO;
    self.scrollView.showsVerticalScrollIndicator =  NO;
    //设置是否可以缩放
    //用来记录页数
    NSUInteger pages = 0;
    //用来记录scrollView的x坐标
    int originX = 0;
    for(UIImage *image in _images)
    {
        //创建一个视图
        UIImageView *pImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        //设置视图的背景色
        pImageView.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
        //设置imageView的背景图
        [pImageView sd_setImageWithURL:self.web_images[pages] placeholderImage:image];
        //给imageView设置区域
        CGRect rect = _scrollView.frame;
        rect.origin.x = originX;
        rect.origin.y = 0;
        rect.size.width = _scrollView.frame.size.width;
        rect.size.height = _scrollView.frame.size.height;
        pImageView.frame = rect;
        //设置图片内容的显示模式()
        pImageView.contentMode = UIViewContentModeScaleAspectFill;
        //把视图添加到当前的滚动视图中
        pImageView.layer.masksToBounds=YES;
        [_scrollView addSubview:pImageView];
        //下一张视图的x坐标:offset为:self.scrollView.frame.size.width.
        originX += (self.scrollView.frame.size.width+4);
        //记录scrollView内imageView的个数
        pages++;
    }
    //设置页码控制器的响应方法
//    [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchDragInside];
    //设置总页数
    _pageControl.numberOfPages = pages;
    //默认当前页为第一页
    _pageControl.currentPage = 0;
    //为页码控制器设置标签
    _pageControl.tag = 110;
    //设置滚动视图的位置
    [_scrollView setContentSize:CGSizeMake(originX, 0)];
}
//改变页码的方法实现
- (void)changePage:(id)sender
{
    NSLog(@"指示器的当前索引值为:%li",(long)_pageControl.currentPage);
    //获取当前视图的页码
    CGRect rect = _scrollView.frame;
    //设置视图的横坐标，一幅图为320*460，横坐标一次增加或减少320像素
    rect.origin.x = _pageControl.currentPage * self.scrollView.frame.size.width;
    //设置视图纵坐标为0
    rect.origin.y = 0;
    //scrollView可视区域
    [_scrollView scrollRectToVisible:rect animated:YES];
}
#pragma mark-----UIScrollViewDelegate---------
//实现协议UIScrollViewDelegate的方法，必须实现的
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //获取当前视图的宽度
    CGFloat pageWith = scrollView.frame.size.width;
    //根据scrolView的左右滑动,对pageCotrol的当前指示器进行切换(设置currentPage)
    int page = floor((scrollView.contentOffset.x - pageWith/2)/pageWith)+1;
    //切换改变页码，小圆点
    self.pageControl.currentPage = page;
}

@end
