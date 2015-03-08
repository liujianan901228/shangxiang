//
//  SingLineImageCollectionView.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/17.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplePictureObject.h"

typedef void(^didSelectBlock)(TemplePictureObject* picObject,UIImageView* imageView) ;

@interface SingLineImageCollectionView : UIView

@property (nonatomic, strong) NSMutableArray* object;//里面是TemplePictureObject
@property (nonatomic, strong) didSelectBlock actionBlock;

- (instancetype)initWithFrame:(CGRect)frame andAction:(didSelectBlock)action;

@end
