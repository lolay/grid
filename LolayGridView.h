//
//  Copyright 2012 Lolay, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
