//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "LolayGridViewDelegate.h"
#import "LolayGridViewDataSource.h"
#import "LolayGridViewCellDelegate.h"

@interface LolayGridView : UIScrollView <LolayGridViewCellDelegate>

@property (nonatomic, assign) IBOutlet id<LolayGridViewDataSource> dataSource;
@property (nonatomic, assign) IBOutlet id<LolayGridViewDelegate> delegate;
@property (nonatomic, readonly) NSInteger numberOfRows;
@property (nonatomic, readonly) NSInteger numberOfColumns;

- (LolayGridViewCell*) dequeueReusableGridCellWithIdentifier:(NSString*) identifier;

- (LolayGridViewCell*) cellForRow:(NSInteger) gridRowIndex atColumn:(NSInteger) gridColumnIndex;

- (void) didSelectGridCell:(LolayGridViewCell*) gridCellView;

- (void) reloadData;

- (void) didReceiveMemoryWarning;

@end