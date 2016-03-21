//
//  PageSliderView.h
//  FamHist
//
//  Created by Aleksey Alekseenkov on 2/11/14.
//
//

#import <UIKit/UIKit.h>

@class ImageSliderView;
@protocol ImageSliderViewDelegate <NSObject>

- (void) imageSliderView:(ImageSliderView *) imageSliderView didChangePage:(NSInteger) pageNumber;

@end

@interface ImageSliderView : UIView

- (void) prepareWithPages:(NSArray *) images imageInsets:(UIEdgeInsets) insets;
- (void) nextPage;
- (void) previousPage;
- (void) toPage:(NSInteger) page animated:(BOOL) animated;
- (NSInteger) currentPage;

@property (nonatomic) NSInteger currentPage;
@property (nonatomic, assign) id<ImageSliderViewDelegate> delegate;

@end
