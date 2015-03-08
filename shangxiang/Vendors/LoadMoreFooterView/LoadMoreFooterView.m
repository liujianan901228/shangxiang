//
//  LoadMoreFooterView.m
//  iKaka
//
//  Created by Eric.Wang on 13-1-1.
//
//

#import "LoadMoreFooterView.h"

#define  LoadMoreViewHight 60.0f
#define TEXT_COLOR   [UIColor darkGrayColor]
#define FLIP_ANIMATION_DURATION 0.18f

@interface LoadMoreFooterView (Private)

- (void)setState:(LoadMoreState)aState;

@end

@implementation LoadMoreFooterView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, LoadMoreViewHight - 48.0f, self.frame.size.width, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont boldSystemFontOfSize:13.0f];
        label.textColor = TEXT_COLOR;
        label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _statusLabel=label;
        [label release];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(25.0f, LoadMoreViewHight - LoadMoreViewHight, 30.0f, 55.0f);
        layer.contentsGravity = kCAGravityResizeAspect;
//        layer.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            layer.contentsScale = [[UIScreen mainScreen] scale];
        }
#endif
        
        [[self layer] addSublayer:layer];
        _arrowImage=layer;
        
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        view.frame = CGRectMake(25.0f, 10, 20.0f, 20.0f);
        [self addSubview:view];
        _activityView = view;
        [view release];
        
        
        [self setState:LoadMoreNormal];
    }
    return self;
}

- (void)setState:(LoadMoreState)aState
{
    
    switch (aState) {
        case LoadMorePulling:
            _statusLabel.text = NSLocalizedString(@"松开即可加载更多...", @"松开即可加载更多...");
            [CATransaction begin];
            [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            [CATransaction commit];
            break;
        case LoadMoreNormal:
            if (_state == LoadMorePulling) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
            }
            _statusLabel.text = NSLocalizedString(@"上拉即可加载更多...", @"上拉即可加载更多...");
            [_activityView stopAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = NO;
            _arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];
            break;
        case LoadMoreLoading:
            _statusLabel.text = NSLocalizedString(@"加载中...", @"加载中...");
            [_activityView startAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = YES;
            [CATransaction commit];
            break;
        case LoadMoreNoData:
            _statusLabel.text = NSLocalizedString(@"无更多数据...", @"无更多数据...");
            [_activityView stopAnimating];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = NO;
            _arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];
            break;
        default:
            break;
    }
    _state = aState;
}



#pragma mark -
#pragma mark ScrollView Methods

//手指屏幕上不断拖动调用此方法
- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging)
    {
        BOOL _loading = NO;
        
        if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)])
        {
            _loading = [_delegate loadMoreTableFooterDataSourceIsLoading:self];
        }
        
        if (_state == LoadMoreNormal && scrollView.contentOffset.y + (scrollView.frame.size.height) >= scrollView.contentSize.height    && scrollView.contentOffset.y > 0.0f && !_loading)
        {
            [self setState:LoadMoreLoading];
            if (_delegate && [_delegate respondsToSelector:@selector(loadMoreTableFooterDidTriggerRefresh:)])
            {
                [_delegate loadMoreTableFooterDidTriggerRefresh:self];
            }
        }
        
        if (scrollView.contentInset.bottom != 0)
        {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
        
    }
    
}



//当开发者页面页面刷新完毕调用此方法，[delegate egoRefreshScrollViewDataSourceDidFinishedLoading: scrollView];
- (void)loadMoreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    [self setState:LoadMoreNormal];
}
#pragma mark -
#pragma mark Dealloc


- (void)dealloc {
    
    _delegate=nil;
    _activityView = nil;
    _statusLabel = nil;
    _arrowImage = nil;
    //_lastUpdatedLabel = nil;
    [super dealloc];
}

@end
