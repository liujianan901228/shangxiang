//
//  CropImageContentView.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "CropImageContentView.h"
#import "CropImageView.h"

@interface CropImageContentView()
@property(nonatomic,strong)CropImageView* cropImageView;
@property(nonatomic,strong)UIView* toolContentView;
@property(nonatomic,strong)UIButton* cancelButton;
@property(nonatomic,strong)UIButton* confirmButton;
@end

@implementation CropImageContentView

- (id)initWithFrame:(CGRect)frame image:(UIImage*)image
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.8);
        _cropImageView = [[CropImageView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - 50)];
        
        [_cropImageView setCropSize:CGSizeMake(120, 120)];
        [_cropImageView setImage:image];
        [self addSubview:_cropImageView];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame = CGRectMake(40, _cropImageView.bottom + 5, 50, 40);
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.cancelButton];
        
        
        self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.confirmButton.frame = CGRectMake(frame.size.width - 90, _cropImageView.bottom + 5, 50, 40);
        [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.confirmButton];
    }
    return self;
}

-(void)setCropedImage:(UIImage*)image
{
    [_cropImageView setImage:image];
}

- (UIImage *)cropImage
{
    return [self.cropImageView cropImage];
}

-(void)cancelButtonClick
{
    if([self.delegate respondsToSelector:@selector(didCancelOperation)]) {
        [self.delegate didCancelOperation];
    }
}

-(void)confirmButtonClick
{
    
    if([self.delegate respondsToSelector:@selector(didConfirmOperation)]) {
        [self.delegate didConfirmOperation];
    }
}

@end
