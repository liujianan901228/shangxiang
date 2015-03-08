//
//  OLImage.m
//  MMT
//
//  Created by Diego Torres on 9/1/12.
//  Copyright (c) 2012 Onda. All rights reserved.
//

#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "GifImage.h"
#import "SDWebImageDecoder.h"

inline static NSTimeInterval CGImageSourceGetGifFrameDelay(CGImageSourceRef imageSource, NSUInteger index)
{
    NSTimeInterval frameDuration = 0;
    CFDictionaryRef theImageProperties;
    if ((theImageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, index, NULL))) {
        CFDictionaryRef gifProperties;
        if (CFDictionaryGetValueIfPresent(theImageProperties, kCGImagePropertyGIFDictionary, (const void **)&gifProperties)) {
            const void *frameDurationValue;
            if (CFDictionaryGetValueIfPresent(gifProperties, kCGImagePropertyGIFUnclampedDelayTime, &frameDurationValue)) {
                frameDuration = [(__bridge NSNumber *)frameDurationValue doubleValue];
                if (frameDuration <= 0) {
                    if (CFDictionaryGetValueIfPresent(gifProperties, kCGImagePropertyGIFDelayTime, &frameDurationValue)) {
                        frameDuration = [(__bridge NSNumber *)frameDurationValue doubleValue];
                    }
                }
            }
        }
        CFRelease(theImageProperties);
    }
    
#ifndef OLExactGIFRepresentation
    //Implement as Browsers do.
    //See:  http://nullsleep.tumblr.com/post/16524517190/animated-gif-minimum-frame-delay-browser-compatibility
    //Also: http://blogs.msdn.com/b/ieinternals/archive/2010/06/08/animated-gifs-slow-down-to-under-20-frames-per-second.aspx
    //设置最大最小频率
    if (frameDuration < 0.02 - FLT_EPSILON) {
        frameDuration = 0.1;
    }
    if (frameDuration > 0.3) {
        frameDuration = 0.3;
    }
#endif
    return frameDuration;
}

inline static BOOL CGImageSourceContainsAnimatedGif(CGImageSourceRef imageSource)
{
    return imageSource && UTTypeConformsTo(CGImageSourceGetType(imageSource), kUTTypeGIF);
}

inline static BOOL isRetinaFilePath(NSString *path)
{
    NSRange retinaSuffixRange = [[path lastPathComponent] rangeOfString:@"@2x" options:NSCaseInsensitiveSearch];
    return retinaSuffixRange.length && retinaSuffixRange.location != NSNotFound;
}

@interface GifImage ()

@property (nonatomic, readwrite) NSTimeInterval *frameDurations;
@property (nonatomic, readwrite) NSTimeInterval totalDuration;
@property (nonatomic, readwrite) NSUInteger loopCount;
@property (nonatomic, readwrite) NSMutableArray *images;

@end

@implementation GifImage

@synthesize images;

#pragma mark - Class Methods

+ (id)imageNamed:(NSString *)name
{
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:name];
    
    return ([[NSFileManager defaultManager] fileExistsAtPath:path]) ? [self imageWithContentsOfFile:path] : nil;
}

+ (id)imageWithContentsOfFile:(NSString *)path
{
    return [self imageWithData:[NSData dataWithContentsOfFile:path]
                         scale:isRetinaFilePath(path) ? 2.0f : 1.0f isAsync:NO asyncCompletionBlock:NULL];
}

+ (id)imageWithContentsOfFile:(NSString *)path asyncCompletionBlock:(void(^)(void))asyncCompletionBlock
{
    return [self imageWithData:[NSData dataWithContentsOfFile:path]
                         scale:isRetinaFilePath(path) ? 2.0f : 1.0f isAsync:YES asyncCompletionBlock:asyncCompletionBlock];
}

+ (id)imageWithData:(NSData *)data
{
    return [self imageWithData:data scale:1.0f isAsync:NO asyncCompletionBlock:NULL];
}

+ (id)imageWithData:(NSData *)data scale:(CGFloat)scale isAsync:(BOOL)isAsync asyncCompletionBlock:(void(^)(void))asyncCompletionBlock
{
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)(data), NULL);
    UIImage *image;
    
    if (CGImageSourceContainsAnimatedGif(imageSource)) {
        image = [[self alloc] initWithCGImageSource:imageSource scale:scale isAsync:isAsync asyncCompletionBlock:asyncCompletionBlock];
    } else {
        image = [super imageWithData:data scale:scale];
    }
    
    if (imageSource) {
        CFRelease(imageSource);
    }
    
    return image;
}

#pragma mark - Initialization methods

- (id)initWithContentsOfFile:(NSString *)path
{
    return [self initWithData:[NSData dataWithContentsOfFile:path]
                        scale:isRetinaFilePath(path) ? 2.0f : 1.0f isAsync:NO asyncCompletionBlock:NULL];
}

- (id)initWithData:(NSData *)data
{
    return [self initWithData:data scale:1.0f isAsync:NO asyncCompletionBlock:NULL];
}

- (id)initWithData:(NSData *)data scale:(CGFloat)scale isAsync:(BOOL)isAsync asyncCompletionBlock:(void(^)(void))asyncCompletionBlock
{
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)(data), NULL);
    
    if (CGImageSourceContainsAnimatedGif(imageSource)) {
        self = [self initWithCGImageSource:imageSource scale:scale isAsync:isAsync asyncCompletionBlock:asyncCompletionBlock];
    } else {
        if (scale == 1.0f) {
            self = [super initWithData:data];
        } else {
            self = [super initWithData:data scale:scale];
        }
    }
    
    if (imageSource) {
        CFRelease(imageSource);
    }
    
    return self;
}

- (id)initWithCGImageSource:(CGImageSourceRef)imageSource scale:(CGFloat)scale isAsync:(BOOL)isAsync asyncCompletionBlock:(void(^)(void))asyncCompletionBlock
{
    self = [super init];
    if (!imageSource || !self) {
        return nil;
    }
    
    CFRetain(imageSource);
    
    NSUInteger numberOfFrames = CGImageSourceGetCount(imageSource);
    
    NSDictionary *imageProperties = CFBridgingRelease(CGImageSourceCopyProperties(imageSource, NULL));
    NSDictionary *gifProperties = [imageProperties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    _frameDurations = (NSTimeInterval *)malloc(numberOfFrames  * sizeof(NSTimeInterval));
    _loopCount = [gifProperties[(NSString *)kCGImagePropertyGIFLoopCount] unsignedIntegerValue];
    self.images = [NSMutableArray arrayWithCapacity:numberOfFrames];
    
    if(isAsync)
    {
        for (NSUInteger i = 0; i < numberOfFrames; ++i) {
            NSTimeInterval frameDuration = CGImageSourceGetGifFrameDelay(imageSource, i);
            self.frameDurations[i] = frameDuration;
            self.totalDuration += frameDuration;
        }
//        CFTimeInterval start = CFAbsoluteTimeGetCurrent();
        // Load first frame
        CGImageRef firstImage = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
        UIImage *image = [UIImage imageWithCGImage:firstImage scale:scale orientation:UIImageOrientationUp];
        UIImage *imageDecoded = [UIImage decodedImageWithImage:image];
        [self.images addObject:imageDecoded];
        CFRelease(firstImage);
        
        // Asynchronously load the remaining frames
        __weak GifImage *weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_apply(numberOfFrames - 1, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(size_t iter) {
                NSUInteger i = iter + 1;
                GifImage *strongSelf = weakSelf;
                if (!strongSelf) {
                    if (asyncCompletionBlock)
                        asyncCompletionBlock();
                    return;
                }
                
                CGImageRef frameImageRef = CGImageSourceCreateImageAtIndex(imageSource, i, NULL);
                UIImage *img = [UIImage imageWithCGImage:frameImageRef scale:scale orientation:UIImageOrientationUp];
                UIImage *imgDecoded = [UIImage decodedImageWithImage:img];
                if(imgDecoded && i < strongSelf.images.count)
                    [strongSelf.images addObject:imageDecoded];
                CFRelease(frameImageRef);
            });
//            NSLog(@"Fully decoded %d frames: %f", [self.images count], CFAbsoluteTimeGetCurrent()-start);
            
            if (asyncCompletionBlock)
                asyncCompletionBlock();
        });
    }
    else
    {
        for (NSUInteger i = 0; i < numberOfFrames; ++i) {
            NSTimeInterval frameDuration = CGImageSourceGetGifFrameDelay(imageSource, i);
            self.frameDurations[i] = frameDuration;
            self.totalDuration += frameDuration;
            
            CGImageRef frameImageRef = CGImageSourceCreateImageAtIndex(imageSource, i, NULL);
            UIImage *img = [UIImage imageWithCGImage:frameImageRef scale:scale orientation:UIImageOrientationUp];
            UIImage *imgDecoded = [UIImage decodedImageWithImage:img];
            [self.images addObject:imgDecoded];
            CFRelease(frameImageRef);
        }
    }
    CFRelease(imageSource);
    
    return self;
}

#pragma mark - Compatibility methods

- (void)changeImages:(NSArray *)newImages
{
    self.images = [NSMutableArray arrayWithArray:newImages];
}

- (CGSize)size
{
    if (self.images && self.images.count > 0) {
        return [((UIImage *)[self.images objectAtIndex:0]) size];
    }
    return [super size];
}

- (UIImage*)firstImage
{
    if (self.images && self.images.count > 0) {
        return ((UIImage *)[self.images objectAtIndex:0]);
    }
    return nil;
}

- (NSTimeInterval)duration
{
    return self.totalDuration;
}

- (void)dealloc
{
    if (_frameDurations) {
        free(_frameDurations);
    }
}

- (NSTimeInterval)frameDurationWithIndex:(NSInteger)index
{
    return self.frameDurations[index];
}

@end
