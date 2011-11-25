//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "LolayGridViewDelegate.h"
#import "LolayGridViewDataSource.h"
#import "LolayGridViewCellDelegate.h"

@interface LolayGridView : UIScrollView <LolayGridViewCellDelegate>

@property (nonatomic, unsafe_unretained) IBOutlet id<LolayGridViewDataSource> dataSource;
@property (nonatomic, unsafe_unretained) IBOutlet id<LolayGridViewDelegate> delegate;
@property (nonatomic, readonly) NSInteger numberOfRows;
@property (nonatomic, readonly) NSInteger numberOfColumns;

- (LolayGridViewCell*) dequeueReusableGridCellWithIdentifier:(NSString*) identifier;

- (LolayGridViewCell*) cellForRow:(NSInteger) gridRowIndex atColumn:(NSInteger) gridColumnIndex;

- (void) scrollToRow:(NSInteger) gridRowIndex atColumn:(NSInteger) gridColumnIndex animated:(BOOL) animated;

- (void) didSelectGridCell:(LolayGridViewCell*) gridCellView;

- (void) reloadData;

- (void) didReceiveMemoryWarning;

- (void) clearAllCells;

- (LolayGridViewCell*) cellForTag:(NSInteger)tag;

@end
