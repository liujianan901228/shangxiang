//
//  BaseTableViewDataSource.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//


#import "BaseTableViewDataSource.h"

@implementation BaseTableViewDataSource

- (void)dealloc
{
    //DDLogInfo(@"source name: %@",[self className]);
}

-(instancetype)init
{
    self = [super init];
    if(self) {
        self.sections =  [NSMutableArray array];
    }
    return self;
}

-(void)updateTableViewCell:(UITableView*)tableView WithObject:(id)object
{
    NSIndexPath* path = [self tableView:tableView indexPathForObject:object];
    if(path)
    {
        [tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BaseTableViewSectionObject* sectionObj = [self.sections objectAtIndex:section];
    return sectionObj.items.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell*)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self tableView:tableView objectForRowAtIndexPath:indexPath];
    
    Class cellClass = [self tableView:tableView cellClassForObject:object];
    NSString *className = [cellClass className];
    
    UITableViewCell* cell =
    (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:className];
    if (cell == nil)
    {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:className];
    }
    
    if ([cell isKindOfClass:[BaseTableViewCell class]])
    {
        [(BaseTableViewCell*)cell setObject:object];
        [(BaseTableViewCell*)cell setIndexPath:indexPath];
    }
    
    return cell;
}


#pragma mark -
#pragma mark TTTableViewDataSource
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)tableView:(UITableView*)tableView objectForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ((_sections.count > 0) && (indexPath.section < _sections.count))
    {
        BaseTableViewSectionObject *aSectionObject = [_sections objectAtIndex:indexPath.section];
        
        if ([aSectionObject.items count] > indexPath.row)
        {
            
            return [aSectionObject.items objectAtIndex:indexPath.row];
        }
    }
    
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object
{
    if ([object isKindOfClass:[BaseTableViewLoadMoreItem class]])
    {
        return [BaseLoadMoreTableViewCell class];
    }
    
    return [BaseTableViewCell class];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSIndexPath*)tableView:(UITableView*)tableView indexPathForObject:(id)object
{
    if (_sections)
    {
        for (int i = 0; i < _sections.count; ++i)
        {
            BaseTableViewSectionObject	*aSectionObject = [_sections objectAtIndex:i];
            NSUInteger					objectIndex		= [aSectionObject.items indexOfObject:object];
            
            if (objectIndex != NSNotFound)
            {
                return [NSIndexPath indexPathForRow:objectIndex inSection:i];
            }
        }
    }
    
    return nil;
}


@end
