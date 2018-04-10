//
//  CustomRepeatItem.h
//  P2PCamera
//
//  Created by yan luke on 13-6-24.
//
//

#import <UIKit/UIKit.h>
@class CustomRepeatItem;
@protocol CustomRepeatItemDelegate<NSObject>
- (void) clickCustomRepeatItem:(CustomRepeatItem*) item;
@end
@interface CustomRepeatItem : UIView
@property (nonatomic) BOOL is_selected;
@property (nonatomic, retain) UILabel* keyLabel;
@property (nonatomic, retain) UIImageView* separateIv;
@property (nonatomic, retain) UIImageView* iconIv;
@property (nonatomic, retain) UIImageView* bottomIv;
@property (nonatomic, assign) id<CustomRepeatItemDelegate> delegate;
- (id)initWithFrame:(CGRect)frame withkeyTitle:(NSString*) title;
@end
