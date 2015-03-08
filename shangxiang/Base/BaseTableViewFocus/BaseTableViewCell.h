//
//  BaseTableViewCell.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

@property(nonatomic,strong) id object;


@property(nonatomic,copy) NSIndexPath* indexPath;


+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object;

- (void)baseSetup;

@end
