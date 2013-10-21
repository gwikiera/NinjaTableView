//
//  NGPulseTableViewCell.h
//  TableViewMadness
//
//  Created by Wojciech Nagrodzki on 03/10/2012.
//  Copyright (c) 2012 Trifork. All rights reserved.
//

#import "NGNinjaTableViewCellSubclass.h"

@class NGPulseTableViewCell;


@protocol NGPulseTableViewCellDataSource <NSObject>

@optional

/**
    Tells the data source to return the number of rows for pulse-table-view.
    @param pulseCell Pulse cell requesting the information.
    @returns Number of cells in pulse-table-view.
 */
- (NSInteger)pulseTableViewCellNumberOfRows:(NGPulseTableViewCell *)pulseCell;

/**
    Asks the data source for a cell to insert in a particular location of pulse-table-view
    @param pulseCell Pulse cell requesting the information
    @param pulseTableView Pulse-table-view inside pulse cell
    @param indexPath Index path of cell in pulse-table-view
    @returns An object inheriting from UITableViewCell that the table-view can use for the specified row. An assertion is raised if you return nil.
 */
- (UITableViewCell *)pulseTableViewCell:(NGPulseTableViewCell *)pulseCell pulseTableView:(UITableView *)pulseTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@protocol NGPulseTableViewCellDelegate <NSObject>

@optional

/**
    Tells the delegate pulse-table-view is about to draw a cell for a particular row.
    @param pulseCell Pulse cell informing the delegate of this impending event
    @param cell A table-view cell object that pulse-table-view is going to use when drawing the row.
    @param indexPath Index path of cell in pulse-table-view
 */
- (void)pulseTableViewCell:(NGPulseTableViewCell *)pulseCell willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

/**
    Asks the delegate for the height to use for a row in a specified location
    @param pulseCell Pulse cell requesting the information
    @param indexPath An index path that locates a row in pulse-table-view.
    @returns A floating-point value that specifies the height (in points) that row should be.
 */
- (CGFloat)pulseTableViewCell:(NGPulseTableViewCell *)pulseCell heightForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
    Tells the delegate that the specified row is now selected.
    @param pulseCell Pulse cell informing the delegate about new row selection.
    @param indexPath An index path locating the new selected row in pulse-table-view.
 */
- (void)pulseTableViewCell:(NGPulseTableViewCell *)pulseCell didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end


/**
    NGPulseTableViewCell is a cell holding UITableView. 
    It provides NGPulseTableViewCellDataSource and NGPulseTableViewCellDelegate protocols to work with inner pulse-table-view.
 */
@interface NGPulseTableViewCell : NGNinjaTableViewCell {
    @protected
    UITableView * _pulseTableView;
}

@end
