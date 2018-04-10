//
//  CustomRepeatView.m
//  P2PCamera
//
//  Created by yan luke on 13-6-24.
//
//

#import "CustomRepeatView.h"
#import "obj_common.h"
#define ITEMHEIGHT 40.f
#define ITEMORIGIN_Y 40.f
@interface CustomRepeatView()
@property (nonatomic, retain) UIImageView* contentView;
@end

@implementation CustomRepeatView

- (id)initWithFrame:(CGRect)frame
{
    CGRect winsize = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:winsize];
    if (self) {
        // Initialization code
        self.contentView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.contentView.image = [[UIImage imageNamed:@"custom-dialog-background"] stretchableImageWithLeftCapWidth:0.f topCapHeight:77.f];
        self.contentView.userInteractionEnabled = YES;
        [self addSubview:self.contentView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 5.f, frame.size.width, 30.f)];
        self.titleLabel.text = NSLocalizedStringFromTable(@"Repeat", @STR_LOCALIZED_FILE_NAME, nil);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
        
        self.weeks = [[NSMutableArray alloc] init];
        
        CustomRepeatItem* item = [[CustomRepeatItem alloc] initWithFrame:CGRectMake(0.f, ITEMORIGIN_Y, frame.size.width, ITEMHEIGHT) withkeyTitle:NSLocalizedStringFromTable(@"Sunday", @STR_LOCALIZED_FILE_NAME, nil)];
        item.tag = 10;
        item.delegate = self;
        [self.contentView addSubview:item];
//        [item release],item = nil;
        
        item = [[CustomRepeatItem alloc] initWithFrame:CGRectMake(0.f, ITEMORIGIN_Y + ITEMHEIGHT, frame.size.width, ITEMHEIGHT) withkeyTitle:NSLocalizedStringFromTable(@"Monday", @STR_LOCALIZED_FILE_NAME, nil)];
        item.tag = 11;
        item.delegate = self;
        [self.contentView addSubview:item];
//        [item release],item = nil;
        
        item = [[CustomRepeatItem alloc] initWithFrame:CGRectMake(0.f, ITEMORIGIN_Y + ITEMHEIGHT*2, frame.size.width, ITEMHEIGHT) withkeyTitle:NSLocalizedStringFromTable(@"Tuesday", @STR_LOCALIZED_FILE_NAME, nil)];
        item.tag = 12;
        item.delegate = self;
        [self.contentView addSubview:item];
//        [item release],item = nil;
        
        item = [[CustomRepeatItem alloc] initWithFrame:CGRectMake(0.f, ITEMORIGIN_Y + ITEMHEIGHT*3, frame.size.width, ITEMHEIGHT) withkeyTitle:NSLocalizedStringFromTable(@"Wednesday", @STR_LOCALIZED_FILE_NAME, nil)];
        item.tag = 13;
        item.delegate = self;
        [self.contentView addSubview:item];
//        [item release],item = nil;
        
        item = [[CustomRepeatItem alloc] initWithFrame:CGRectMake(0.f, ITEMORIGIN_Y + ITEMHEIGHT*4, frame.size.width, ITEMHEIGHT) withkeyTitle:NSLocalizedStringFromTable(@"Thursday", @STR_LOCALIZED_FILE_NAME, nil)];
        item.tag = 14;
        item.delegate = self;
        [self.contentView addSubview:item];
//        [item release],item = nil;
        
        item = [[CustomRepeatItem alloc] initWithFrame:CGRectMake(0.f, ITEMORIGIN_Y + ITEMHEIGHT*5, frame.size.width, ITEMHEIGHT) withkeyTitle:NSLocalizedStringFromTable(@"Friday", @STR_LOCALIZED_FILE_NAME, nil)];
        item.tag = 15;
        item.delegate = self;
        [self.contentView addSubview:item];
//        [item release],item = nil;
        
        item = [[CustomRepeatItem alloc] initWithFrame:CGRectMake(0.f, ITEMORIGIN_Y + ITEMHEIGHT*6, frame.size.width, ITEMHEIGHT) withkeyTitle:NSLocalizedStringFromTable(@"Saturday", @STR_LOCALIZED_FILE_NAME, nil)];
        item.tag = 16;
        item.delegate = self;
        [self.contentView addSubview:item];
//        [item release],item = nil;
        
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelBtn.frame = CGRectMake(1.f, ITEMORIGIN_Y + ITEMHEIGHT*7 + 10.f, frame.size.width/2 - 3.f, ITEMHEIGHT);
        [self.cancelBtn addTarget:self action:@selector(dismissCustomRepeatView) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelBtn setTitle:NSLocalizedStringFromTable(@"Cancel", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];\
        [self.cancelBtn setBackgroundImage:[[UIImage imageNamed:@"custom-cancel-normal"] stretchableImageWithLeftCapWidth:8 topCapHeight:0] forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.doneBtn.frame = CGRectMake(self.cancelBtn.frame.size.width + self.cancelBtn.frame.origin.x + 2.f, self.cancelBtn.frame.origin.y, frame.size.width/2 - 3.f, ITEMHEIGHT);
        [self.doneBtn addTarget:self action:@selector(doneSeletedRepeatDay:) forControlEvents:UIControlEventTouchUpInside];
        [self.doneBtn setTitle:NSLocalizedStringFromTable(@"OK", @STR_LOCALIZED_FILE_NAME, nil) forState:UIControlStateNormal];
        [self.doneBtn setBackgroundImage:[[UIImage imageNamed:@"custom-button-normal"] stretchableImageWithLeftCapWidth:8 topCapHeight:0] forState:UIControlStateNormal];
        self.doneBtn.titleLabel.textColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.cancelBtn];
        [self.contentView addSubview:self.doneBtn];
        
        self.contentView.frame = CGRectMake(0.f, 0.f, frame.size.width, self.doneBtn.frame.size.height + self.doneBtn.frame.origin.y + 5.f);
        self.contentView.center = CGPointMake(winsize.size.width/2, (winsize.size.height - 20.f - 44.f)/2);
        
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
        self.alpha = 0.f;
        self.repeatView_Show = NO;
        
        for (int i = 0; i < 7; i++) {
            SelectedS[i] = 1;
        }
    }
    return self;
}

- (void) doneSeletedRepeatDay:(id) sender{
    [self dismissCustomRepeatView];
    if (_delegate != nil) {
        [_delegate sendCustomRepeatViewToParentView:self andSeletedItems:SelectedS];
    }
}

- (void) showCustomRepeatView{
    if (_weeks != nil && [_weeks count] != 0) {
        for (int i = 0; i < 7; i++) {
            int tmp = [[_weeks objectAtIndex:i] intValue];
            SelectedS[i] = tmp;
            
            UIView* view = [self viewWithTag:i + 10];
            if ([view isKindOfClass:[CustomRepeatItem class]]) {
                CustomRepeatItem* item = (CustomRepeatItem*) view;
                if (tmp == 0) {
                    item.is_selected = NO;
                }else{
                    item.is_selected = YES;
                }
            }
        }
    }
    [UIView animateWithDuration:0.1f animations:^{
        self.alpha = 1.f;
        self.repeatView_Show = YES;
    }];
}

- (void) dismissCustomRepeatView{
    [UIView animateWithDuration:0.1f animations:^{
        self.alpha = 0.f;
        self.repeatView_Show = NO;
    }];
}

#pragma mark -
#pragma mark CustomRepeatItemDelegate
- (void) clickCustomRepeatItem:(CustomRepeatItem*) item{
    if (item.is_selected) {
        SelectedS[item.tag - 10] = 1;
    }else{
        SelectedS[item.tag - 10] = 0;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) dealloc{
//    [super dealloc];
//    [_titleLabel release],_titleLabel = nil;
//    [_weeks release],_weeks = nil;
    _cancelBtn = nil;
    _doneBtn = nil;
    _delegate = nil;
}

@end
