//
//  DiscoverInfoViewController.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/22.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderObject.h"
#import "DiscoverViewCell.h"

@interface DiscoverInfoViewController : BaseViewController

@property (nonatomic, strong) OrderObject* orderObject;
@property (nonatomic, strong) DiscoverViewCell* orderCell;


@end
