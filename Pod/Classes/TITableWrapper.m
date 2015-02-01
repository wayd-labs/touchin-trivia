//
//  TITableDataSourceWrapper.m
//  touchin-rateme
//
//  Created by Tony Larin on 09/01/15.
//
//

#import "TITableWrapper.h"
#import "TIAnalytics.h"

@implementation TITableWrapper

bool (^shouldShow)(void);


- (TITableWrapper*) initWithDataSource:(id<UITableViewDataSource>) dataSource
                                   tableDelegate:(id<UITableViewDelegate>) delegate                                    
                                      shouldShow:(bool (^)(void))shouldShowParam {
    self = [super init];
    
    _wrappedDataSource = dataSource;
    _wrappedDelegate = delegate;
    shouldShow = shouldShowParam;
    self.dialogRow = 1;
    self.dialogSection = 0;
    return self;
}

- (NSString*) UD_SHOWN_KEY {
    return [NSStringFromClass([self class]) stringByAppendingString:@"SeviceCellShown"];
}

- (NSString*) UD_FINISHED_KEY {
    return [NSStringFromClass([self class]) stringByAppendingString:@"ServiceCellFinished"];
}



- (bool) show {
    NSObject* finished = [[NSUserDefaults standardUserDefaults] objectForKey:self.UD_FINISHED_KEY];
    NSObject* shown = [[NSUserDefaults standardUserDefaults] objectForKey:self.UD_SHOWN_KEY];
    return (shown != nil || shouldShow()) && finished == nil;
}

//Adjust indexPath for manipulating of table cell directrly in UITableViewController (bad decision)
- (NSIndexPath *) adjustIndexPath:(NSIndexPath *) indexPath {
   if (!self.show || indexPath.section != self.dialogSection || indexPath.row < self.dialogRow) {
       return indexPath;
   } else if (indexPath.row >= self.dialogRow) {
       return [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
   } else {
       //our rateme cell
       return nil;
   }
}

//Adjust indexPath for forward methods to delegate and datasource
- (NSIndexPath *) getForwardIndexPath:(NSIndexPath *) indexPath {
    if (!self.show || indexPath.section != self.dialogSection || indexPath.row < self.dialogRow) {
        return indexPath;
    } else if (indexPath.row >= self.dialogRow) {
        return [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
    } else {
        //our rateme cell
        return nil;
    }
}


#pragma mark UITableViewDataSource

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.wrappedDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        return [self.wrappedDelegate tableView:tableView heightForHeaderInSection:section];
    }
    return 0.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self.wrappedDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [self.wrappedDelegate tableView:tableView viewForHeaderInSection:section];
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.wrappedDataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [self.wrappedDataSource numberOfSectionsInTableView:tableView];
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger baseCount = [self.wrappedDataSource tableView:tableView numberOfRowsInSection:section];
    if (self.show && (section == self.dialogSection) && (baseCount > self.dialogRow)) {
        
        @synchronized([NSUserDefaults standardUserDefaults]) {
//            [self.tableView reloadData];
            NSObject* shown = [[NSUserDefaults standardUserDefaults] objectForKey:self.UD_SHOWN_KEY];
            NSLog(@"** Shown %@", shown);
            if (shown == nil) {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:self.UD_SHOWN_KEY];

//                [self.tableView beginUpdates];
//                NSLog(@"** Insert");
//                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dialogRow inSection:self.dialogSection]] withRowAnimation:UITableViewRowAnimationRight];
//                [self.tableView endUpdates];
                
                [TIAnalytics.shared trackEvent:@"RATEME-CELL_SHOWN_FIRST"];
            }
        }
        baseCount++;
    }
    NSLog(@"** Basecount %ld in section %ld", (long)baseCount, (long) section);
    return baseCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.show || indexPath.section != self.dialogSection || indexPath.row < self.dialogRow) {
        return [self.wrappedDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    } else if (indexPath.row > self.dialogRow) {
        return [self.wrappedDataSource tableView:tableView
                           cellForRowAtIndexPath:[self getForwardIndexPath:indexPath]];
    } else {
        return [self createServiceCell];
    }
}

- (UITableViewCell*) createServiceCell {
    return nil; //should define in subclasses
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject* shown = [[NSUserDefaults standardUserDefaults] objectForKey:self.UD_SHOWN_KEY];
    if (!shown || !self.show || indexPath.section != self.dialogSection || indexPath.row != self.dialogRow) {
        return [self.wrappedDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    } else {        
        return 95.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.show || indexPath.section != self.dialogSection || indexPath.row < self.dialogRow) {
        [self.wrappedDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else if (indexPath.row > self.dialogRow) {
        [self.tableView selectRowAtIndexPath:[self getForwardIndexPath:indexPath] animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self.wrappedDelegate tableView:tableView didSelectRowAtIndexPath:[self getForwardIndexPath:indexPath]];
    } else {
        //do nothing for rate me cell
    }
}

- (void) tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.wrappedDelegate respondsToSelector:@selector(tableView: didHighlightRowAtIndexPath:)]) {
        [self.wrappedDelegate tableView:tableView didHighlightRowAtIndexPath:[self getForwardIndexPath:indexPath]];
    }
}

- (void) tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.wrappedDelegate respondsToSelector:@selector(tableView: didUnhighlightRowAtIndexPath:)]) {
        [self.wrappedDelegate tableView:tableView didUnhighlightRowAtIndexPath:[self getForwardIndexPath:indexPath]];
    }
}

#pragma mark TIRateMeDelegate
- (void) finished {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:self.UD_FINISHED_KEY];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dialogRow inSection:self.dialogSection]] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
}

- (void) animateTransition {
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dialogRow inSection:self.dialogSection]] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
}
@end
