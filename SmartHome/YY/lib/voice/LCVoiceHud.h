

#import <UIKit/UIKit.h>

@interface LCVoiceHud : UIView

@property(nonatomic,strong)  UIButton *btnCancel;

@property(nonatomic) float progress;

-(void) show;
-(void) hide;

@end
