//
//  RecordTimeMode.m
//  P2PCamera
//
//  Created by yan luke on 13-6-20.
//
//

#import "RecordTimeMode.h"
//@interface RecordTimeMode()
//@property (nonatomic, retain) UITapGestureRecognizer* tapGes;
//@end
@implementation RecordTimeMode

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.is_Selected = NO;
        self.is_Selected_Icon = NO;
//        self.userInteractionEnabled = YES;
//        self.tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMySelf:)];
//        self.tapGes.numberOfTapsRequired = 1;
//        [self addGestureRecognizer:self.tapGes];
    }
    return self;
}

//- (void) clickMySelf:(id) sender{
//    if (_delegate != nil && [_delegate respondsToSelector:@selector(ClickRecordTimeMode:)]) {
//        [_delegate ClickRecordTimeMode:self];
//    }
//}

- (void) setIs_Selected:(BOOL)is_Selected{
    if (is_Selected) {
        self.backgroundColor = [UIColor blueColor];
    }else{
        self.backgroundColor = [UIColor clearColor];
    }
    _is_Selected = is_Selected;
}

- (void) setIs_Selected_Icon:(BOOL)is_Selected_Icon{
    if (is_Selected_Icon) {
        self.image = [UIImage imageNamed:@"Selected"];
    }else{
        self.image = [UIImage imageNamed:@"Unselected"];
    }
    _is_Selected_Icon = is_Selected_Icon;
}

- (void) setIs_Add_Icon:(BOOL)is_Add_Icon{
    if (is_Add_Icon) {
        
    }else{
        
    }
    _is_Add_Icon = is_Add_Icon;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
