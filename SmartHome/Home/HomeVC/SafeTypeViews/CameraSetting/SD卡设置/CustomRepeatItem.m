//
//  CustomRepeatItem.m
//  P2PCamera
//
//  Created by yan luke on 13-6-24.
//
//

#import "CustomRepeatItem.h"
#import <QuartzCore/QuartzCore.h>
@interface CustomRepeatItem()
@property (nonatomic, retain) UITapGestureRecognizer *tapGes;
@end

@implementation CustomRepeatItem

- (id)initWithFrame:(CGRect)frame withkeyTitle:(NSString*) title
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.iconIv = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - frame.size.height + 1, 0.f, frame.size.height - 1, frame.size.height)];
        self.iconIv.image = [UIImage imageNamed:@"Unselected"];
        self.iconIv.contentMode = UIViewContentModeCenter;
        
        self.separateIv = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - frame.size.height - 1.f , 0.f, 2.f, frame.size.height)];
        self.separateIv.image = [UIImage imageNamed:@"N-list"];
        self.separateIv.contentMode = UIViewContentModeScaleAspectFit;
        
        self.keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 0.f, frame.size.width - self.iconIv.frame.size.width - self.separateIv.frame.size.width, frame.size.height)];
        self.keyLabel.backgroundColor = [UIColor clearColor];
        self.keyLabel.text = title;
        self.keyLabel.textAlignment = NSTextAlignmentLeft;
        self.keyLabel.textColor = [UIColor whiteColor];
        
        self.bottomIv = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, frame.size.height - 1.f, frame.size.width, 1.f)];
        self.bottomIv.image = [UIImage imageNamed:@"line"];
        self.bottomIv.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:self.iconIv];
        [self addSubview:self.separateIv];
        [self addSubview:self.keyLabel];
        [self addSubview:self.bottomIv];
        
        self.backgroundColor = [UIColor clearColor];//colorWithPatternImage:[UIImage imageNamed:@"W-bg"]];
//        self.layer.masksToBounds = YES;
//        self.layer.cornerRadius = 5.f;
        
        self.tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(IsSelected:)];
        self.tapGes.numberOfTapsRequired = 1;
        [self addGestureRecognizer:self.tapGes];
        
        self.is_selected = YES;
    }
    return self;
}

- (void) IsSelected:(id) sender{
    self.is_selected = !self.is_selected;
}

- (void) setIs_selected:(BOOL)is_selected{
    if (is_selected) {
        self.iconIv.image = [UIImage imageNamed:@"Selected"];
    }else{
        self.iconIv.image = [UIImage imageNamed:@"Unselected"];
    }
    _is_selected = is_selected;
    
    if (_delegate != nil) {
        [_delegate clickCustomRepeatItem:self];
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
    [self removeGestureRecognizer:_tapGes];
//    [super dealloc];
//    [_tapGes release],_tapGes = nil;
//    [_iconIv release],_iconIv = nil;
//    [_separateIv release],_separateIv = nil;
//    [_keyLabel release],_keyLabel = nil;
    _delegate = nil;
}

@end
