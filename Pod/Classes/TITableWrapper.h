//
//  TITableDataSourceWrapper.h
//  touchin-rateme
//
//  Used to show service-cells like ask user to rate the app or to turn on push messages.
//
//

#import <Foundation/Foundation.h>
#import "TIEmailFeedback.h"
#import "TIAppearance.h"

@protocol TITableWrapperDelegate
- (void) finished;
- (void) animateTransition;
@end

@interface TITableWrapper : NSObject<UITableViewDataSource, UITableViewDelegate, TITableWrapperDelegate>

@property (weak, readonly) id<UITableViewDataSource> wrappedDataSource;
@property (weak, readonly) id<UITableViewDelegate> wrappedDelegate;

@property NSUInteger dialogRow;
@property NSUInteger dialogSection;
@property (weak) UIViewController* presentingVC;
@property (weak) UITableView* tableView;
@property (strong, nonatomic) TIAppearance *appearance;

- (TITableWrapper*) initWithDataSource:(id<UITableViewDataSource>) dataSource
                      tableDelegate:(id<UITableViewDelegate>) delegate
                         shouldShow:(bool (^)(void))shouldShow;

- (NSIndexPath *) adjustIndexPath:(NSIndexPath *) indexPath;

- (UITableViewCell*) createServiceCell;
@end
