//
//  SingLineImageCellCollectionViewCell.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/17.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplePictureObject.h"

@interface SingLineImageCellCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) TemplePictureObject* object;
@property (nonatomic, strong) UIImageView* singImageView;

@end
