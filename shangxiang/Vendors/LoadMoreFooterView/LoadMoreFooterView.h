//
//  LoadMoreFooterView.h
//  iKaka
//
//  Created by Eric.Wang on 13-1-1.
//
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

typedef enum{
    LoadMorePulling = 3,
    LoadMoreNormal = 4,
    LoadMoreLoading = 5,
    LoadMoreNoData = 6
} LoadMoreState;

typedef enum
{
    REQUESTTYPENORMAL = 0,
    REQUESTTYPELOADMORE = 1
}REQUESTTYPE;

@protocol  LoadMoreFooterViewDelegate;

@interface LoadMoreFooterView : UIView
{
    LoadMoreState _state;
    
    UILabel *_statusLabel;
    CALayer *_arrowImage;
    UIActivityIndicatorView *_activityView;
}

@property(assign, nonatomic) id<LoadMoreFooterViewDelegate> delegate;

- (void)setState:(LoadMoreState)aState;

- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView;


- (void)loadMoreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;


@end

@protocol LoadMoreFooterViewDelegate <NSObject>
  @optional
- (void)loadMoreTableFooterDidTriggerRefresh:(LoadMoreFooterView *)view;
- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreFooterView *)view;

@end
