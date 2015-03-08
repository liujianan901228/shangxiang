//
//  DiscoverPopViewDataSource.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/15.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "DiscoverPopViewDataSource.h"
#import "TempleObject.h"
#import "DiscoverPopViewCell.h"

@implementation DiscoverPopViewDataSource

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
    
    if([object isKindOfClass:[TempleObject class]]) {
        return [DiscoverPopViewCell class];
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
    }
    
    if(self.selectIndex == indexPath.row)
    {
        cell.backgroundColor = UIColorFromRGB(0xD5D7D6);
    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    if ([cell isKindOfClass:[BaseTableViewCell class]]) {
        [(BaseTableViewCell*)cell setIndexPath:indexPath];
        [(BaseTableViewCell*)cell setObject:object];
    }
    
    return cell;
}

@end
