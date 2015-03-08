//
//  CropImageContentView.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CropImageContenViewProtocol <NSObject>

-(void)didCancelOperation;
-(void)didConfirmOperation;
@end

@interface CropImageContentView : UIView
- (id)initWithFrame:(CGRect)frame image:(UIImage*)image;

@property(nonatomic,weak)id<CropImageContenViewProtocol>delegate;
-(void)setCropedImage:(UIImage*)image;

- (UIImage *)cropImage;
@end
