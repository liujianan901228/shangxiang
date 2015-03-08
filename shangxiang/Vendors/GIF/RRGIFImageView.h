

#import <UIKit/UIKit.h>

@interface AnimatedGifQueueObject : NSObject
{
    UIImageView *uiv;
    NSURL *url;
}

@property (nonatomic, retain) UIImageView *uiv;
@property (nonatomic, retain) NSURL *url;

@end

@interface AnimatedGifFrame : NSObject
{
	NSData *data;
	NSData *header;
	double delay;
	int disposalMethod;
	CGRect area;
}

@property (nonatomic, copy) NSData *header;
@property (nonatomic, copy) NSData *data;
@property (nonatomic) double delay;
@property (nonatomic) int disposalMethod;
@property (nonatomic) CGRect area;

@end

@interface RRGIFImageView : UIImageView {
	NSData *GIF_pointer;
	NSMutableData *GIF_buffer;
	NSMutableData *GIF_screen;
	NSMutableData *GIF_global;
	NSMutableArray *GIF_frames;
	
	int GIF_sorted;
	int GIF_colorS;
	int GIF_colorC;
	int GIF_colorF;
	int animatedGifDelay;
	
	int dataPointer;
}
@property (nonatomic, retain) NSMutableArray *GIF_frames;

- (id)initWithGIFFile:(NSString*)gifFilePath;
- (id)initWithGIFData:(NSData*)gifImageData;

- (void)loadImageData;

+ (NSMutableArray*)getGifFrames:(NSData*)gifImageData;
+ (BOOL)isGifImage:(NSData*)imageData;

- (void) decodeGIF:(NSData *)GIFData;
- (void) GIFReadExtensions;
- (void) GIFReadDescriptor;
- (bool) GIFGetBytes:(NSInteger)length;
- (bool) GIFSkipBytes: (NSInteger) length;
- (NSData*) getFrameAsDataAtIndex:(NSInteger)index;
- (UIImage*) getFrameAsImageAtIndex:(NSInteger)index;

-(void)startGifAnimating;
-(void)stopGifAnimating;

+(RRGIFImageView*)deQueueGifImageView:(NSString*)fileName;

+(NSMutableArray*)getGifImageFrameFromMem:(NSString*)fileName;
+(void)saveGifImageFrameToMem:(NSString*)fileName gif:(NSMutableArray*)gifFrames;
+(void)clearGifImageFrameMemStoreifOver:(NSInteger)maxSize;
@end
