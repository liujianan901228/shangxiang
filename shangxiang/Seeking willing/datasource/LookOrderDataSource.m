//
//  LookOrderDataSource.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/31.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "LookOrderDataSource.h"
#import "OrderInfoObject.h"

@implementation LookOrderDataSource

- (instancetype)init
{
    if(self = [super init])
    {
        BaseTableViewSectionObject* section = [[BaseTableViewSectionObject alloc] init];
        [self.sections addObject:section];
    }
    return self;
}

- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object{
    
    if([object isKindOfClass:[OrderInfoObject class]]) {
        return [LookOrderViewCell class];
    }
    return [super tableView:tableView cellClassForObject:object];
}

- (UITableViewCell*)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id object = [self tableView:tableView objectForRowAtIndexPath:indexPath];
    
    Class cellClass = [self tableView:tableView cellClassForObject:object];
    NSString *className = [cellClass className];
    
    UITableViewCell* cell =
    (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:className];
    if (cell == nil) {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:className];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    if([cell isKindOfClass:[LookOrderViewCell class]])
    {
        [(LookOrderViewCell*)cell setCellDelegate:self.cellDelegate];
    }
    
    if ([cell isKindOfClass:[BaseTableViewCell class]]) {
        [(BaseTableViewCell*)cell setIndexPath:indexPath];
        [(BaseTableViewCell*)cell setObject:object];
    }
    
    return cell;
}

@end
