//
//  FileManager.h
//  SmartHome
//
//  Created by Komlin on 16/4/15.
//  Copyright © 2016年 sunzl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+WebCache.h"
@interface FileManager : NSObject
- (float)folderSizeAtPath:(NSString *)path;
@end
