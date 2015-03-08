//
//  BaseTableViewDataSource.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "BaseLoadMoreTableViewCell.h"

#import "BaseTableViewLoadMoreItem.h"
#import "BaseTableViewSectionObject.h"

@class BaseTableViewDataSource;

@protocol BaseTableViewDataSource <UITableViewDataSource, UISearchDisplayDelegate>

- (id)tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath;

- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object;

- (NSIndexPath *)tableView:(UITableView *)tableView indexPathForObject:(id)object;


@end

typedef void (^loadDataCompleteBlock)(BOOL result, NSError *err);

//typedef void(^RefreshTableViewDataBlock)(BOOL hasNew);

typedef void(^RefreshTableViewDataBlock)(BOOL hasNew,id error);

@interface BaseTableViewDataSource : NSObject <BaseTableViewDataSource>{
    
}
@property(nonatomic,strong) NSMutableArray* sections;

-(void)updateTableViewCell:(UITableView*)tableView WithObject:(id)object;

@end
