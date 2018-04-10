//
//  EZLivePlayViewController.h
//  EZOpenSDKDemo
//
//  Created by DeJohn Dong on 15/10/28.
//  Copyright © 2015年 hikvision. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue, alp)	[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 \
alpha:alp]

@interface EZLivePlayViewController : UIViewController

@property (nonatomic, copy) NSString *cameraId;
@property (nonatomic, copy) NSString *cameraName;

- (void)imageSavedToPhotosAlbum:(UIImage *)image
       didFinishSavingWithError:(NSError *)error
                    contextInfo:(void *)contextInfo;

@end
