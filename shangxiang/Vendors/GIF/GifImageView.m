//
//  OLImageView.m
//  OLImageViewDemo
//
//  Created by Diego Torres on 9/5/12.
//  Copyright (c) 2012 Onda Labs. All rights reserved.
//

#import "GifImageView.h"
#import "GifImage.h"
#import <QuartzCore/QuartzCore.h>

@interface GifImageView ()
{
    CADisplayLink *displayLink;
}
@property (nonatomic, strong) GifImage *animatedImage;
@property (nonatomic) NSTimeInterval previousTimeStamp;
@property (nonatomic) NSTimeInterval accumulator;
@property (nonatomic) NSUInteger currentFrameIndex;
@property (nonatomic) NSUInteger loopCountdown;

@end
@implementation GifImageView

const NSTimeInterval kMaxTimeStep = 1; // note: To avoid spiral-o-death

@synthesize runLoopMode = _runLoopMode;

- (id)init
{
    self = [super init];
    if (self) {
        self.currentFrameIndex = 0;
    }
    return self;
}

- (void)dealloc
{
    [displayLink invalidate];
}

- (NSString *)runLoopMode
{
    return _runLoopMode ?: NSDefaultRunLoopMode;
}

- (void)setRunLoopMode:(NSString *)runLoopMode
{
    if (runLoopMode != _runLoopMode) {
        _runLoopMode = runLoopMode;
        [self stopAnimating];
        [self startAnimating];
    }
}

//- (void)setHighlighted:(BOOL)highlighted
//{
//    if (!self.animatedImage) {
//        [super setHighlighted:highlighted];
//    }
//}

- (UIImage *)image
{
    return self.animatedImage ?: [super image];
}

- (void)_updateLayerContentWithImageAtIndex:(NSUInteger)index
{
    if(index < self.animatedImage.images.count)
    {
        UIImage *image = [self.animatedImage.images objectAtIndex:index];
        if([image isKindOfClass:[UIImage class]])
            self.layer.contents = (__bridge id)[image CGImage];
        else
        {
            // keep original contents
        }
    }
}

- (void)setImage:(UIImage *)image
{
    [super setImage:nil];
    
    [self stopAnimating];
    self.animatedImage = nil;
    self.currentFrameIndex = 0;
    self.previousTimeStamp = 0;
    self.loopCountdown = 0;
    self.accumulator = 0;
    if ([image isKindOfClass:[GifImage class]] && ((GifImage *)image).images)
    {
        self.animatedImage = (GifImage *)image;
        [self _updateLayerContentWithImageAtIndex:0];

        self.loopCountdown = self.animatedImage.loopCount ?: NSUIntegerMax;

        [self startAnimating];
    }
    else
    {
        self.layer.contents = nil;
        [super setImage:image];
    }
}

- (BOOL)isAnimating
{
    return [super isAnimating] || (displayLink && !displayLink.isPaused);
}

- (void)stopAnimating
{
    if (!self.animatedImage) {
        [super stopAnimating];
        return;
    }
    
    self.loopCountdown = 0;
    
    @synchronized(displayLink) {
        displayLink.paused = YES;
        [displayLink invalidate];
        displayLink = nil;
    }
}

- (void)startAnimating
{
    if (!self.animatedImage) {
        [super startAnimating];
        return;
    }
    
    if (self.isAnimating) {
        return;
    }
    
    self.loopCountdown = self.animatedImage.loopCount ?: NSUIntegerMax;
    self.previousTimeStamp = 0;
    
    @synchronized(displayLink) {
        [displayLink invalidate];

        if (self.animatedImage.images.count > 1) {
            displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeKeyframe:)];
            [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:self.runLoopMode];
        }else if(self.animatedImage.images.count == 1) {
            [self _updateLayerContentWithImageAtIndex:0];
        }
    }
}

- (void)changeKeyframe:(CADisplayLink *)caDisplayLink
{
    NSTimeInterval timestamp = caDisplayLink.timestamp;
    
    if (self.previousTimeStamp == 0) {
        self.previousTimeStamp = timestamp;
    }
    
    self.accumulator += fmin(timestamp - self.previousTimeStamp, kMaxTimeStep);

    while (self.accumulator >= [self.animatedImage frameDurationWithIndex:self.currentFrameIndex]) {
        self.accumulator -= [self.animatedImage frameDurationWithIndex:self.currentFrameIndex];
        if (++self.currentFrameIndex >= [self.animatedImage.images count]) {

            if (--self.loopCountdown == 0 || self.animatedImage == nil) {
                [self stopAnimating];
                return;
            }
            self.currentFrameIndex = 0;
        }
        [self.layer setNeedsDisplay];
    }
    self.previousTimeStamp = timestamp;
}

- (void)displayLayer:(CALayer *)layer
{
    @autoreleasepool {
        [self _updateLayerContentWithImageAtIndex:self.currentFrameIndex];
    }
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    if (self.window) {
        [self startAnimating];
    } else {
        [self stopAnimating];
    }
}

@end
