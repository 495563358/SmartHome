//
//  CustomRepeatView.h
//  P2PCamera
//
//  Created by yan luke on 13-6-24.
//
//

#import <UIKit/UIKit.h>
#import "CustomRepeatItem.h"
@class CustomRepeatView;
@protocol CustomRepeatViewDelegate <NSObject>

- (void) sendCustomRepeatViewToParentView:(CustomRepeatView*) custom andSeletedItems:(int*) seleted;

@end
@interface CustomRepeatView : UIView<CustomRepeatItemDelegate>{
    int SelectedS[7];
}
@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) UIButton* cancelBtn;
@property (nonatomic, retain) UIButton* doneBtn;
@property (nonatomic, assign) id<CustomRepeatViewDelegate> delegate;
@property (nonatomic, assign) BOOL repeatView_Show;
@property (nonatomic, retain) NSMutableArray* weeks;
- (void) showCustomRepeatView;
- (void) dismissCustomRepeatView;
@end
