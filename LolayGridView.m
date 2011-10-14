//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import "LolayGridView.h"
#import "LolayGridViewCell.h"

@interface LolayGridView ()

@property (nonatomic, retain) NSMutableSet* inUseGridCells; // LolayGridViewCell*
@property (nonatomic, retain) NSMutableSet* reusableGridCells; // LolayGridViewCell*
@property (nonatomic, retain) NSLock* reloadLock;
@property (nonatomic, retain) NSLock* handleCellsLock;
@property (nonatomic) BOOL loadedOnce;
@property (nonatomic) NSInteger numberOfRows;
@property (nonatomic) NSInteger numberOfColumns;
@property (nonatomic) CGFloat heightForRows;
@property (nonatomic) CGFloat widthForColumns;

@end

@implementation LolayGridView

@synthesize inUseGridCells = inUseGridCells_;
@synthesize reusableGridCells = reusableGridCells_;
@synthesize reloadLock = reloadLock_;
@synthesize handleCellsLock = handleCellsLock_;
@synthesize loadedOnce = loadedOnce_;
@synthesize numberOfRows = numberOfRows_;
@synthesize numberOfColumns = numberOfColumns_;
@synthesize heightForRows = heightForRows_;
@synthesize widthForColumns = widthForColumns_;
@synthesize dataSource = dataSource_;
@synthesize delegate = delegate_;

#pragma mark -
#pragma mark View Lifecycle

- (void) setup {
	self.inUseGridCells = [NSMutableSet set];
	self.reusableGridCells = [NSMutableSet set];
	self.reloadLock = [NSLock new];
	self.reloadLock.name = @"LolayGridView.reloadLock";
	self.handleCellsLock = [NSLock new];
	self.handleCellsLock.name = @"LolayGridView.handleCellsLock";
	self.loadedOnce = NO;
	self.numberOfRows = 0;
	self.numberOfColumns = 0;
	self.heightForRows = 0.0;
	self.widthForColumns = 0.0;
}

- (id) initWithCoder:(NSCoder*) decoder {
	NSLog(@"[LolayGridView initWithCoder] enter");
	self = [super initWithCoder:decoder];
	
	if (self) {
		[self setup];
	}
	
	return self;
}

- (id) initWithFrame:(CGRect) inRect {
	NSLog(@"[LolayGridView initWithFrame] enter");
	self = [super initWithFrame:inRect];
	
	if (self) {
		[self setup];
	}
	
	return self;
}

- (void) didReceiveMemoryWarning {
	NSLog(@"[LolayGridView didReceiveMemoryWarning] enter");
	[self.reusableGridCells removeAllObjects];
}

#pragma mark -
#pragma mark LolayGridViewDataSource Calls

- (NSInteger) dataSourceNumberOfRows {
	if ([self.dataSource respondsToSelector:@selector(numberOfRowsInGridView:)]) {
		return [self.dataSource numberOfRowsInGridView:self];
	} else {
		return 0;
	}
}

- (NSInteger) dataSourceNumberOfColumns {
	if ([self.dataSource respondsToSelector:@selector(numberOfColumnsInGridView:)]) {
		return [self.dataSource numberOfColumnsInGridView:self];
	} else {
		return 0;
	}
}

- (LolayGridViewCell*) dataSourceCellForRow:(NSInteger) gridRowIndex atColumn:(NSInteger) gridColumnIndex {
	if ([self.dataSource respondsToSelector:@selector(gridView:cellForRow:atColumn:)]) {
		LolayGridViewCell* cell = [self.dataSource gridView:self cellForRow:gridRowIndex atColumn:gridColumnIndex];
		cell.delegate = self;
		[cell setRow:gridRowIndex atColumn:gridColumnIndex];
		return cell;
	} else {
		return nil;
	}
}

- (void) dataSourceDidReuseCell:(LolayGridViewCell*) gridCell {
	if ([self.dataSource respondsToSelector:@selector(gridView:didReuseCell:)]) {
		[self.dataSource gridView:self didReuseCell:gridCell];
	}
}

#pragma mark -
#pragma mark LolayGridViewDelegate Calls

- (CGFloat) delegateHeightForRows {
	if ([self.delegate respondsToSelector:@selector(heightForGridViewRows:)]) {
		return [self.delegate heightForGridViewRows:self];
	} else {
		return 0.0;
	}
}

- (CGFloat) delegateWidthForColumns {
	if ([self.delegate respondsToSelector:@selector(widthForGridViewColumns:)]) {
		return [self.delegate widthForGridViewColumns:self];
	} else {
		return 0.0;
	}
}

- (CGFloat) delegateInsetForRow:(NSInteger) gridRowIndex {
	if ([self.delegate respondsToSelector:@selector(gridView:insetForRow:)]) {
		return [self.delegate gridView:self insetForRow:gridRowIndex];
	} else {
		return 0.0;
	}
}

- (CGFloat) delegateInsetForColumn:(NSInteger) gridColumnIndex {
	if ([self.delegate respondsToSelector:@selector(gridView:insetForColumn:)]) {
		return [self.delegate gridView:self insetForColumn:gridColumnIndex];
	} else {
		return 0.0;
	}
}

#pragma mark -
#pragma mark LolayGridView Methods

/*
 Find the first reusable grid cell with the same reuse identifier.
 */
- (LolayGridViewCell*) dequeueReusableGridCellWithIdentifier:(NSString*) identifier {
	LolayGridViewCell* foundCell = nil;
	
	for (LolayGridViewCell* cell in self.reusableGridCells) {
		if ([cell.reuseIdentifier isEqualToString:identifier]) {
			foundCell = cell;
			[self.reusableGridCells removeObject:cell];
			break;
		}
	}
	
	return foundCell;
}

- (LolayGridViewCell*) cellForRow:(NSInteger) gridRowIndex atColumn:(NSInteger) gridColumnIndex {
	LolayGridViewCell* foundCell = nil;
	
	for (LolayGridViewCell* cell in self.inUseGridCells) {
		if (cell.rowIndex == gridRowIndex && cell.columnIndex == gridColumnIndex) {
			foundCell = cell;
			break;
		}
	}
	
	return foundCell;
}

- (void) scrollToRow:(NSInteger) gridRowIndex atColumn:(NSInteger) gridColumnIndex animated:(BOOL) animated {
    CGRect lastVisibleRect;
    lastVisibleRect.size.height = self.heightForRows;
    lastVisibleRect.origin.y = (self.heightForRows * gridRowIndex);
    lastVisibleRect.size.width = self.widthForColumns;
    lastVisibleRect.origin.x = (self.widthForColumns * gridColumnIndex);
    [self scrollRectToVisible:lastVisibleRect animated:animated];
}


- (void) handleContentSize {
	NSLog(@"[LolayGridView handleContentSize] enter");
	NSInteger numRows = self.numberOfRows;
	NSInteger numColumns = self.numberOfColumns;
	
	if (numRows == 0 || numColumns == 0) {
		self.contentSize = CGSizeZero;
		return;
	}
	
	CGFloat maxRowInset = 0.0;
	CGFloat contentHeight = 0.0;
	CGFloat rowHeight = self.heightForRows;
	for (NSInteger i = 0; i < numRows; i++) {
		maxRowInset = MAX(maxRowInset, [self delegateInsetForRow:i]);
		contentHeight += rowHeight;
	}
	
	CGFloat maxColumnInset = 0.0;
	CGFloat contentWidth = 0.0;
	CGFloat columnWidth = self.widthForColumns;
	for (NSInteger i = 0; i < numColumns; i++) {
		maxColumnInset = MAX(maxColumnInset, [self delegateInsetForColumn:i]);
		contentWidth += columnWidth;
	}
	
	contentWidth += maxRowInset;
	contentHeight += maxColumnInset;
	
	self.contentSize = CGSizeMake(contentWidth, contentHeight);
	NSLog(@"[LolayGridView handleContentSize] exit self.content.size=(%2f,%2f)", contentWidth, contentHeight);
}

- (CGRect) loadedContentRect {
	CGFloat offsetX = self.contentOffset.x;
	CGFloat offsetY = self.contentOffset.y;
	CGFloat width = self.bounds.size.width;
	CGFloat height = self.bounds.size.height;
	
	CGFloat deltaX = 0.5 * width;
	CGFloat deltaY = 0.5 * height;
	
	return CGRectMake(offsetX - deltaX, offsetY - deltaY, width + 2 * deltaX, height + 2 * deltaY);
}

- (void) reuseCell:(LolayGridViewCell*) cell {
	
	[cell removeFromSuperview];
	[cell prepareForReuse];
	[self dataSourceDidReuseCell:cell];
	
}

- (void) handleCells {
	NSLog(@"[LolayGridView handleCells] enter");
	
	NSInteger rows = self.numberOfRows;
	NSInteger columns = self.numberOfColumns;
	
	if (rows == 0 || columns == 0) {
		return;
	}
	
	if ([self.handleCellsLock tryLock]) {
		CGRect loadedRect = [self loadedContentRect];
		NSLog(@"[LolayGridView handleCells] loadedRect=(%2f,%2f,%2f,%2f)", loadedRect.origin.x, loadedRect.origin.y, loadedRect.size.width, loadedRect.size.height);
		
		// Reclaim some cells
		NSMutableSet* reuseSet = [NSMutableSet setWithCapacity:self.inUseGridCells.count / 2];
		for (LolayGridViewCell* cell in self.inUseGridCells) {
			if (! CGRectIntersectsRect(loadedRect, cell.frame)) {
				NSLog(@"[LolayGridView handleCells] reusing cell uuid=%@, row=%i column=%i", cell.uuid, cell.rowIndex, cell.columnIndex);
				[self reuseCell:cell];
				[reuseSet addObject:cell];
			}
		}
		[self.inUseGridCells minusSet:reuseSet];
		[self.reusableGridCells unionSet:reuseSet];
		
		// Load some missing cells
		CGFloat rowHeight = self.heightForRows;
		CGFloat columnWidth = self.widthForColumns;
		
		
		NSInteger minColumn = floor(loadedRect.origin.x / columnWidth) - 1;
		NSInteger maxColumn = ceil((loadedRect.origin.x + loadedRect.size.width) / columnWidth) - 1;
		NSInteger minRow = floor(loadedRect.origin.y / rowHeight) - 1;
		NSInteger maxRow = ceil((loadedRect.origin.y + loadedRect.size.height) / rowHeight) - 1;
		
		if (minRow < 0) {
			minRow = 0;
		}
		if (minRow >= rows) {
			minRow = rows - 1;
		}
		if (maxRow < 0) {
			maxRow = 0;
		}
		if (maxRow >= rows) {
			maxRow = rows - 1;
		}
		if (minColumn < 0) {
			minColumn = 0;
		}
		if (minColumn >= columns) {
			minColumn = columns - 1;
		}
		if (maxColumn < 0) {
			maxColumn = 0;
		}
		if (maxColumn >= columns) {
			maxColumn = columns - 1;
		}
		
		NSLog(@"[LolayGridView handleCells] (minRow,minColumn:maxRow,maxColumn)=(%i,%i:%i,%i)", minRow, minColumn, maxRow, maxColumn);
		
		for (NSInteger row = minRow; row <= maxRow; row++) {
			CGFloat insetForRow = [self delegateInsetForRow:row];
			NSInteger columnOffset = round(insetForRow / columnWidth);
			
			for (NSInteger column = minColumn; column <= maxColumn; column++) {
				CGFloat insetForColumn = [self delegateInsetForColumn:row];
				NSInteger rowOffset = round(insetForColumn / rowHeight);
				
				NSInteger offsetRow = row - rowOffset;
				if (offsetRow < 0) {
					offsetRow = 0;
				}
				if (offsetRow >= rows) {
					offsetRow = rows - 1;
				}
				
				NSInteger offsetColumn = column - columnOffset;
				if (offsetColumn < 0) {
					offsetColumn = 0;
				}
				if (offsetColumn >= columns) {
					offsetColumn = columns - 1;
				}
				
				if (! [self cellForRow:offsetRow atColumn:offsetColumn]) {
					LolayGridViewCell* cell = [self dataSourceCellForRow:offsetRow atColumn:offsetColumn];
					if (cell) {
						cell.frame = CGRectMake(insetForRow + offsetColumn * columnWidth, insetForColumn + offsetRow * rowHeight, columnWidth, rowHeight);
						[self addSubview:cell];
						[self.inUseGridCells addObject:cell];
					}
				}
			}
		}
		[self.handleCellsLock unlock];
	}
}

- (void) reloadData {
	NSLog(@"[LolayGridView reloadData] enter");
	self.loadedOnce = YES;
	[self.reloadLock lock];
	
	self.numberOfRows = [self dataSourceNumberOfRows];
	self.numberOfColumns = [self dataSourceNumberOfColumns];
	self.heightForRows = [self delegateHeightForRows];
	self.widthForColumns = [self delegateWidthForColumns];
    
    if([self.inUseGridCells count] > 0){
        for(LolayGridViewCell* cell in self.inUseGridCells){
            [self reuseCell:cell];
        }
        [self.reusableGridCells unionSet:self.inUseGridCells];
        self.inUseGridCells = [NSMutableSet set];
    }
	
	[self handleContentSize];
	[self handleCells];
	
	[self.reloadLock unlock];
}

- (void) checkScrolledToEdge {
	if ([self.delegate respondsToSelector:@selector(gridView:didScrollToEdge:)]) {
		LolayGridViewEdge edges = LolayGridViewEdgeNone;
		
		if (self.contentOffset.x <= 0) {
			edges |= LolayGridViewEdgeLeft;
		} else if (self.contentOffset.x >= self.contentSize.width - self.frame.size.width) {
			edges |= LolayGridViewEdgeRight;
		}
		if (self.contentOffset.y <= 0) {
			edges |= LolayGridViewEdgeTop;
		} else if (self.contentOffset.y >= self.contentSize.height - self.frame.size.height) {
			edges |= LolayGridViewEdgeBottom;
		}
		
		[self.delegate gridView:self didScrollToEdge:edges];
	}
}

- (void) clearAllCells {
    NSLog(@"[LolayGridView clearAllCells] enter");
    self.numberOfRows = 0;
	self.numberOfColumns = 0;
    self.inUseGridCells = nil;
    self.reusableGridCells = nil;
    self.inUseGridCells = [NSMutableSet set];
	self.reusableGridCells = [NSMutableSet set];
    self.loadedOnce = NO;
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
}


- (LolayGridViewCell*) cellForTag:(NSInteger)tag {
    LolayGridViewCell* foundCell = nil;
    for (LolayGridViewCell* cell in self.inUseGridCells) {
        if (cell.tag == tag) {
            foundCell = cell;
            break;
        }
    }
    
    for (LolayGridViewCell* cell in self.reusableGridCells) {
        if (cell.tag == tag) {
            foundCell = cell;
            break;
        }
    }
    
    return foundCell;
}

#pragma mark -
#pragma mark LolayGridViewCellDelegate Methods

- (void) didSelectGridCell:(LolayGridViewCell*) gridCellView {
	NSLog(@"[LolayGridView didSelectGridCell] enter");
	if ([self.delegate respondsToSelector:@selector(gridView:didSelectCellAtRow:atColumn:)]) {
		[self.delegate gridView:self didSelectCellAtRow:gridCellView.rowIndex atColumn:gridCellView.columnIndex];
	}
}

#pragma mark -
#pragma mark UIView Methods

- (void) drawRect:(CGRect) rect {
	NSLog(@"[LolayGridView drawRect] enter");
	[super drawRect:rect];
	if (! self.loadedOnce) {
		[self reloadData];
	}
}

- (void) layoutSubviews {
	[super layoutSubviews];
	[self handleCells];
	[self checkScrolledToEdge];
}

@end