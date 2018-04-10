//
//  SelectWeekCustomView.h
//  P2PCamera
//
//  Created by yan luke on 13-6-27.
//
//

#import <UIKit/UIKit.h>
@class SelectWeekCustomView;
@protocol SelectWeekCustomViewDelegate <NSObject>
- (void) SelectWeekCustomView:(SelectWeekCustomView*) selectWeekView ChangeSelectIndex:(int) Selectindex;
//- (void) SelectWeekCustomView:(SelectWeekCustomView*) selectWeekView SelectAllDay:(BOOL) selectAllDay;
//- (void) SelectWeekCustomView:(SelectWeekCustomView*) selectWeekView SelectAllWeek:(BOOL) selectALlWeek;
@end

@interface SelectWeekCustomView : UIImageView
@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) UIButton* backBtn;
@property (nonatomic, retain) UIButton* forwardBtn;
@property (nonatomic, assign) int SelectIndex;
@property (nonatomic, assign) id<SelectWeekCustomViewDelegate> delegate;
@end
