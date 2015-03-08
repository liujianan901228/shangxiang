//
//  LoadErrorView.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoadErrorViewProtocol <NSObject>

-(void)requestToReLoadData;

@end

@interface LoadErrorView : UIView
@property(nonatomic,weak)id<LoadErrorViewProtocol>delegate;
@end
