//
//  CollectionViewCell.h
//  CollectionView
//
//  Created by tang on 16/3/4.
//  Copyright © 2016年 tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *currentPrice;
@property (weak, nonatomic) IBOutlet UILabel *beforePrice;
@property (weak, nonatomic) IBOutlet UILabel *titleName;

@end
