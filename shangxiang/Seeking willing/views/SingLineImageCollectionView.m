//
//  SingLineImageCollectionView.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/17.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "SingLineImageCollectionView.h"
#import "SingLineImageCellCollectionViewCell.h"

@interface SingLineImageCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout* followLayout;

@end

@implementation SingLineImageCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        _followLayout = [[UICollectionViewFlowLayout alloc] init];
        [_followLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [_followLayout setMinimumInteritemSpacing:0];
        [_followLayout setMinimumLineSpacing:10];
        [_followLayout setItemSize:CGSizeMake(72, 72)];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:_followLayout];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = NO;
        _collectionView.autoresizingMask = UIViewAutoresizingNone;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[SingLineImageCellCollectionViewCell class] forCellWithReuseIdentifier:@"SingLineImageCellCollectionViewCell"];
        
        [self addSubview:_collectionView];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andAction:(didSelectBlock)action
{
    if(self = [self initWithFrame:frame])
    {
        self.actionBlock = action;
    }
    return self;
}


-(void)setObject:(id)object
{
    _object = object;
    [self.collectionView reloadData];
}

- (void)dealloc
{
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;
}

#pragma mark - UICollectionViewDataSource -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.object.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SingLineImageCellCollectionViewCell *cell = (SingLineImageCellCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SingLineImageCellCollectionViewCell" forIndexPath:indexPath];
    [cell setObject:[self.object objectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SingLineImageCellCollectionViewCell* cell = (SingLineImageCellCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    TemplePictureObject* pic = (TemplePictureObject*)[self.object objectAtIndex:indexPath.row];
    if(self.actionBlock)
    {
        self.actionBlock (pic,cell.singImageView);
    }
}

@end
