//
//  DiscoverTableViewDataSource.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/13.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "DiscoverTableViewDataSource.h"
#import "OrderObject.h"
#import "BaseTableViewSectionObject.h"

@implementation DiscoverTableViewDataSource

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
    
    if([object isKindOfClass:[OrderObject class]]) {
        return [DiscoverViewCell class];
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
    if (cell == nil)
    {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:className];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    if([cell isKindOfClass:[DiscoverViewCell class]])
    {
        [(DiscoverViewCell*)cell setCellDelegate:self.delegate];
    }
    
    if ([cell isKindOfClass:[DiscoverViewCell class]]) {
        [(DiscoverViewCell*)cell setIndexPath:indexPath];
        [(DiscoverViewCell*)cell setObject:object];
    }
    
    return cell;
}

@end
