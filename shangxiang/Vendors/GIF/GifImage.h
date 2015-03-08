//
//  OLImage.h
//  MMT
//
//  Created by Diego Torres on 9/1/12.
//  Copyright (c) 2012 Onda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

@interface GifImage : UIImage

@property (nonatomic, readonly) NSTimeInterval *frameDurations;
@property (nonatomic, readonly) NSTimeInterval totalDuration;
@property (nonatomic, readonly) NSUInteger loopCount;

- (NSTimeInterval)frameDurationWithIndex:(NSInteger)index;
+ (UIImage *)imageWithContentsOfFile:(NSString *)path;
- (UIImage *)firstImage;
- (void)changeImages:(NSArray *)images;

@end
