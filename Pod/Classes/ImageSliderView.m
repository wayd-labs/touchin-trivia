//
//  ImageSliderView.m
//  hitmeapp
//
//  Created by Aleksey Alekseenkov on 2/11/14.
//
//

#import "ImageSliderView.h"

@interface ImageSliderView() <UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray * images;
@property (strong, nonatomic) UIScrollView * scrollView;
@property (strong, nonatomic) NSMutableArray * imagePages;
@property (nonatomic) UIEdgeInsets insets;
@property (nonatomic) NSInteger previousPageNumber;

@end

@implementation ImageSliderView

#pragma mark - Initialization

- (void) prepareWithPages:(NSArray *) images imageInsets:(UIEdgeInsets) insets {
    
    self.images = [NSMutableArray arrayWithArray:images];
    self.insets = insets;
    _previousPageNumber = 0;
    [self doViewSetup];
}

- (void) layoutSubviews {
    CGRect frame = self.bounds;
    NSInteger numberOfPage = _images.count;
    CGSize contentSize = CGSizeMake(_scrollView.frame.size.width * numberOfPage, _scrollView.frame.size.height);
    _scrollView.contentSize = contentSize;
    NSInteger currentPage = 0;
    for (UIView * image in _imagePages) {
        CGRect imageViewFrame = CGRectMake(frame.size.width * currentPage + _insets.left, 0 + _insets.top, frame.size.width - ( _insets.left + _insets.right ), frame.size.height - ( _insets.top + _insets.bottom ) );
        image.frame = imageViewFrame;
        currentPage++;
    }
}

#pragma mark - View Setup

- (void) doViewSetup {
    for (UIView *view in self.imagePages) {
      [view removeFromSuperview];
    }
    [_scrollView removeFromSuperview];
    [self.imagePages removeAllObjects];
    CGRect frame = self.bounds;
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.autoresizingMask |= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.maximumZoomScale = 1.0;
    scrollView.minimumZoomScale = 1.0;
    scrollView.bounces = TRUE;
    scrollView.alwaysBounceHorizontal = TRUE;
    scrollView.alwaysBounceVertical = FALSE;
    scrollView.pagingEnabled = TRUE;
    scrollView.showsHorizontalScrollIndicator = FALSE;
    scrollView.delegate = self;
    self.scrollView = scrollView;
    [self addSubview:self.scrollView];
    [self sendSubviewToBack:self.scrollView];
  
    NSInteger currentPage = 0;
    for (UIView * view in _images) {
        view.clipsToBounds = TRUE;
        [self.imagePages addObject:view];
        [_scrollView addSubview:view];
        currentPage++;
    }
    [self layoutIfNeeded];
}

#pragma mark - getter / setter

- (NSMutableArray *) imagePages {
    
    if ( _imagePages == nil ) {
        _imagePages = [[NSMutableArray alloc] init];
    }
    return _imagePages;
}

#pragma mark - Interface

- (void) nextPage {
    
    [self toPage:[self currentPage] + 1 animated:TRUE];
}

- (void) previousPage {
    
    [self toPage:[self currentPage] - 1 animated:TRUE];
}

- (void) toPage:(NSInteger) page animated:(BOOL) animated {
    
    if ((page < 0) || (page >= _imagePages.count)) {
        return;
    }
    CGRect visibleFrame = [_imagePages[page] frame];
    visibleFrame.origin.x -= _insets.left;
    visibleFrame.size.width += _insets.left + _insets.right;
    [_scrollView scrollRectToVisible:visibleFrame animated:animated];
}

#pragma mark - helpers

- (NSInteger) currentPage {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor( ( self.scrollView.contentOffset.x + pageWidth / 2.0 ) / pageWidth );
    return page;
}

#pragma mark - ScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentPage = [self currentPage];
    if (currentPage != _previousPageNumber) {
        _previousPageNumber = currentPage;
        if ( [_delegate respondsToSelector:@selector(imageSliderView:didChangePage:)] ) {
            [_delegate imageSliderView:self didChangePage:currentPage];
        }
        self.currentPage = currentPage;
    }
}

@end
