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

#import <UIKit/UIKit.h>

typedef enum {
	LolayGridViewEdgeNone = 0,
	LolayGridViewEdgeTop = 1,
	LolayGridViewEdgeBottom = 1 << 1,
	LolayGridViewEdgeLeft = 1 << 2,
	LolayGridViewEdgeRight = 1 << 3
} LolayGridViewEdge;

@class LolayGridView;
@class LolayGridViewCell;

@protocol LolayGridViewDelegate <UIScrollViewDelegate>

- (CGFloat) heightForGridViewRows:(LolayGridView*) gridView;
- (CGFloat) widthForGridViewColumns:(LolayGridView*) gridView;

@optional

- (CGFloat) gridView:(LolayGridView*) gridView insetForRow:(NSInteger) gridRowIndex;
- (CGFloat) gridView:(LolayGridView*) gridView insetForColumn:(NSInteger) gridColumnIndex;

- (void) gridView:(LolayGridView*) gridView didScrollToEdge:(LolayGridViewEdge) edge;

- (void) gridView:(LolayGridView*) gridView didSelectCellAtRow:(NSInteger) gridRowIndex atColumn:(NSInteger) gridColumnIndex;

- (void) gridView:(LolayGridView*) gridView cellWillAppear:(LolayGridViewCell*) cell row:(NSInteger) row column:(NSInteger) column;

@end