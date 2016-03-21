//
//  TITableDataSourceWrapper.m
//  touchin-rateme
//
//  Created by Tony Larin on 09/01/15.
//
//

#import "TITableWrapper.h"

#if __has_include("TIAnalytics.h") //Shite! FIXME: move TITableWrapper to push and rateme to break circullar dependency Trivia <-> Anatytics, or move analytics call to delegate or something
#import "TIAnalytics.h"
#endif

#import "Aspects.h"

@implementation TITableWrapper

bool (^shouldShow)(void);

- (TITableWrapper*) initWithDataSource:(id<UITableViewDataSource>) dataSource
                                   tableDelegate:(id<UITableViewDelegate>) delegate
                             tableView:(UITableView*) tableView
                                      shouldShow:(bool (^)(void))shouldShowParam {
    self = [super init];
    
    _wrappedDataSource = dataSource;
    _wrappedDelegate = delegate;
    _tableView = tableView;
    shouldShow = shouldShowParam;
    self.dialogRow = 1;
    self.dialogSection = 0;
    
    //check should we show service cell after table update
    __weak typeof(self) weakSelf = self;
    [tableView aspect_hookSelector:@selector(reloadData) withOptions:AspectPositionAfter
                                 usingBlock:^(id<AspectInfo> aspectInfo) {
        [weakSelf check];
    } error:NULL];

    return self;
}

- (NSString*) UD_SHOWN_KEY {
    return [NSStringFromClass([self class]) stringByAppendingString:@"ServiceCellShown"];
}

- (NSString*) UD_FINISHED_KEY {
    return [NSStringFromClass([self class]) stringByAppendingString:@"ServiceCellFinished"];
}

- (BOOL) isFinished {
    NSNumber* value = [[NSUserDefaults standardUserDefaults] objectForKey:self.UD_FINISHED_KEY];
    return value.boolValue;
}

- (bool) show {
    NSObject* shown = [[NSUserDefaults standardUserDefaults] objectForKey:self.UD_SHOWN_KEY];
    return (shown != nil ) && ![self isFinished]; //|| shouldShow()
}

- (bool) shown {
    NSObject* _shown = [[NSUserDefaults standardUserDefaults] objectForKey:self.UD_SHOWN_KEY];
    return ((NSNumber*)_shown).boolValue;
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
    if (self.show && (section == self.dialogSection) && (baseCount >= self.dialogRow)) {
        baseCount++;
    }
    return baseCount;
}

//Check should we show our service cell or not, swizzled after reloadData
- (void) check {
    if (shouldShow() && ![self shown]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:self.UD_SHOWN_KEY];
        if ([self.wrappedDataSource tableView:self.tableView numberOfRowsInSection:self.dialogSection] > self.dialogRow) {
            //cant insert row in empty table
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dialogRow inSection:self.dialogSection]] withRowAnimation:UITableViewRowAnimationRight];
        }
        #ifdef TIAnalytics
        [TIAnalytics.shared trackEvent:@"RATEME-CELL_SHOWN_FIRST"];
        #endif
    }
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
    if (indexPath.section == _dialogSection && indexPath.row == _dialogRow) {
        return;
    }
    if ([self.wrappedDelegate respondsToSelector:@selector(tableView: didHighlightRowAtIndexPath:)]) {
        [self.wrappedDelegate tableView:tableView didHighlightRowAtIndexPath:[self getForwardIndexPath:indexPath]];
    }
}

- (void) tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == _dialogSection && indexPath.row == _dialogRow) {
        return;
    }
    if ([self.wrappedDelegate respondsToSelector:@selector(tableView: didUnhighlightRowAtIndexPath:)]) {
        [self.wrappedDelegate tableView:tableView didUnhighlightRowAtIndexPath:[self getForwardIndexPath:indexPath]];
    }
}

#pragma mark TIRateMeDelegate
- (void) finished {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:self.UD_FINISHED_KEY];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dialogRow inSection:self.dialogSection]] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void) animateTransition {
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dialogRow inSection:self.dialogSection]] withRowAnimation:UITableViewRowAnimationLeft];
}
@end
